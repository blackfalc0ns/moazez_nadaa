import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';

/// Refreshes expired access tokens and queues concurrent 401 requests.
class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor({
    required Dio dio,
    required FlutterSecureStorage secureStorage,
    this.refreshTokenEndpoint = '/auth/refresh',
    this.onRefreshFailed,
    this.onTokenRefreshed,
  }) : _dio = dio,
       _secureStorage = secureStorage;

  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final String refreshTokenEndpoint;
  final FutureOr<void> Function()? onRefreshFailed;
  final FutureOr<void> Function(String token)? onTokenRefreshed;

  static const _refreshRetryAttemptedKey = 'refresh_retry_attempted';

  bool _isRefreshing = false;
  final List<_RequestRetry> _requestsQueue = [];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    developer.log(
      'onError fired: ${err.response?.statusCode} ${err.requestOptions.path}',
      name: 'RefreshTokenInterceptor',
    );

    if (!_shouldRefresh(err)) return handler.next(err);

    if (err.requestOptions.path.contains(refreshTokenEndpoint)) {
      await _handleRefreshFailure();
      return handler.next(err);
    }

    if (_isRefreshing) {
      _requestsQueue.add(_RequestRetry(err, handler));
      return;
    }

    _isRefreshing = true;
    try {
      final newToken = await _refreshToken();
      if (newToken == null) {
        await _handleRefreshFailure();
        return handler.next(err);
      }

      await _secureStorage.write(key: StorageKeys.accessToken, value: newToken);
      await onTokenRefreshed?.call(newToken);

      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      err.requestOptions.extra[_refreshRetryAttemptedKey] = true;
      final response = await _dio.fetch(err.requestOptions);
      await _retryQueuedRequests(newToken);
      return handler.resolve(response);
    } catch (error) {
      developer.log(
        'Token refresh failed: $error',
        name: 'RefreshTokenInterceptor',
      );
      await _handleRefreshFailure();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  bool _shouldRefresh(DioException err) {
    if (err.requestOptions.extra[_refreshRetryAttemptedKey] == true) {
      return false;
    }

    if (_isCredentialFailure(err.response?.data)) {
      return false;
    }

    final statusCode = err.response?.statusCode;
    if (statusCode == 401) return true;

    final data = err.response?.data;
    if (data is Map) {
      final error = data['error'];
      final code = error is Map ? error['code'] : data['code'];
      final normalized = code?.toString().trim().toLowerCase();
      return normalized == 'auth.token.expired' ||
          normalized == 'token.expired' ||
          normalized == 'jwt.expired';
    }

    return false;
  }

  bool _isCredentialFailure(dynamic responseData) {
    if (responseData is! Map) return false;

    final rawError = responseData['error'];
    final error = rawError is Map ? rawError : responseData;
    final code = error['code']?.toString().toLowerCase() ?? '';

    return code.startsWith('iam.credentials.') ||
        code.contains('invalid_credentials') ||
        code.contains('current_password_invalid');
  }

  Future<String?> _refreshToken() async {
    final refreshToken = await _secureStorage.read(
      key: StorageKeys.refreshToken,
    );
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final headers = Map<String, dynamic>.from(_dio.options.headers)
        ..remove('Authorization');
      final refreshDio = Dio(_dio.options.copyWith(headers: headers));

      Response<dynamic> response;
      try {
        response = await refreshDio.post<dynamic>(
          refreshTokenEndpoint,
          data: {'refreshToken': refreshToken},
        );
      } on DioException catch (error) {
        final statusCode = error.response?.statusCode ?? 500;
        final shouldRetrySnakeCase = statusCode >= 400 && statusCode <= 422;
        if (!shouldRetrySnakeCase) rethrow;
        response = await refreshDio.post<dynamic>(
          refreshTokenEndpoint,
          data: {'refresh_token': refreshToken},
        );
      }

      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300 || response.data is! Map) {
        return null;
      }

      final raw = Map<String, dynamic>.from(response.data as Map);
      final responseData = raw['data'] is Map
          ? Map<String, dynamic>.from(raw['data'] as Map)
          : raw;
      final data = _tokenMapFrom(responseData);
      final accessToken =
          (data['accessToken'] ?? data['access_token'] ?? data['token'])
              ?.toString()
              .trim();
      if (accessToken == null || accessToken.isEmpty) return null;

      final rotatedRefresh = data['refreshToken'] ?? data['refresh_token'];
      if (rotatedRefresh != null && rotatedRefresh.toString().isNotEmpty) {
        await _secureStorage.write(
          key: StorageKeys.refreshToken,
          value: rotatedRefresh.toString(),
        );
      }

      final expiresIn = int.tryParse(data['expiresIn']?.toString() ?? '');
      if (expiresIn != null && expiresIn > 0) {
        await _secureStorage.write(
          key: StorageKeys.tokenExpiry,
          value: DateTime.now()
              .add(Duration(seconds: expiresIn))
              .toUtc()
              .toIso8601String(),
        );
      }

      developer.log(
        'Token refreshed successfully',
        name: 'RefreshTokenInterceptor',
      );
      return accessToken;
    } catch (error) {
      developer.log(
        'Refresh token request failed: $error',
        name: 'RefreshTokenInterceptor',
      );
      return null;
    }
  }

  Map<String, dynamic> _tokenMapFrom(Map<String, dynamic> json) {
    for (final key in const ['tokens', 'auth', 'session']) {
      final value = json[key];
      if (value is Map) return Map<String, dynamic>.from(value);
    }
    return json;
  }

  Future<void> _retryQueuedRequests(String token) async {
    final queued = List<_RequestRetry>.from(_requestsQueue);
    _requestsQueue.clear();
    for (final retry in queued) {
      try {
        retry.options.headers['Authorization'] = 'Bearer $token';
        retry.options.extra[_refreshRetryAttemptedKey] = true;
        retry.handler.resolve(await _dio.fetch(retry.options));
      } catch (_) {
        retry.handler.next(retry.error);
      }
    }
  }

  Future<void> _handleRefreshFailure() async {
    await _secureStorage.delete(key: StorageKeys.accessToken);
    await _secureStorage.delete(key: StorageKeys.refreshToken);
    await _secureStorage.delete(key: StorageKeys.tokenExpiry);
    for (final retry in _requestsQueue) {
      retry.handler.next(retry.error);
    }
    _requestsQueue.clear();
    await onRefreshFailed?.call();
  }
}

class _RequestRetry {
  const _RequestRetry(this.error, this.handler);

  final DioException error;
  final ErrorInterceptorHandler handler;
  RequestOptions get options => error.requestOptions;
}
