import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';

/// Refreshes an invalid access token once for all concurrent 401 requests.
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

  static const _retryMarker = 'auth_refresh_retried';
  Future<String?>? _refreshFuture;
  Future<void>? _refreshFailureFuture;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final status = response.statusCode ?? 0;
    if (status >= 200 &&
        status < 300 &&
        response.requestOptions.path.contains('/auth/login')) {
      _refreshFailureFuture = null;
    }
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final options = err.requestOptions;
    if (_isRefreshRequest(options.path) ||
        options.extra[_retryMarker] == true) {
      await _handleRefreshFailureOnce();
      handler.next(err);
      return;
    }

    final token = await _refreshAccessTokenOnce();
    if (token == null) {
      handler.next(err);
      return;
    }

    try {
      options.headers['Authorization'] = 'Bearer $token';
      options.extra[_retryMarker] = true;
      handler.resolve(await _dio.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    } catch (error, stackTrace) {
      handler.next(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  bool _isRefreshRequest(String path) => path.contains(refreshTokenEndpoint);

  Future<String?> _refreshAccessTokenOnce() {
    final active = _refreshFuture;
    if (active != null) return active;
    late final Future<String?> refresh;
    refresh = _refreshAndPersist().whenComplete(() {
      if (identical(_refreshFuture, refresh)) _refreshFuture = null;
    });
    _refreshFuture = refresh;
    return refresh;
  }

  Future<String?> _refreshAndPersist() async {
    try {
      final refreshToken = (await _secureStorage.read(
        key: StorageKeys.refreshToken,
      ))?.trim();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _handleRefreshFailureOnce();
        return null;
      }

      final response = await _dio.post<dynamic>(
        refreshTokenEndpoint,
        data: {'refreshToken': refreshToken},
        options: Options(extra: const {'is_token_refresh': true}),
      );
      final data = _readResponseData(response.data);
      final accessToken =
          (data['accessToken'] ?? data['access_token'] ?? data['token'])
              ?.toString()
              .trim();
      if (response.statusCode != 200 ||
          accessToken == null ||
          accessToken.isEmpty) {
        await _handleRefreshFailureOnce();
        return null;
      }

      await _secureStorage.write(
        key: StorageKeys.accessToken,
        value: accessToken,
      );
      final rotated = (data['refreshToken'] ?? data['refresh_token'])
          ?.toString()
          .trim();
      if (rotated != null && rotated.isNotEmpty) {
        await _secureStorage.write(
          key: StorageKeys.refreshToken,
          value: rotated,
        );
      }
      final expiry = _readExpiry(accessToken, data);
      if (expiry != null) {
        await _secureStorage.write(
          key: StorageKeys.tokenExpiry,
          value: expiry.toIso8601String(),
        );
      }

      _refreshFailureFuture = null;
      await _notifyTokenRefreshed(accessToken);
      return accessToken;
    } catch (error, stackTrace) {
      developer.log(
        'Refresh request failed',
        name: 'RefreshTokenInterceptor',
        error: error,
        stackTrace: stackTrace,
      );
      final alreadyHandled =
          error is DioException && _isRefreshRequest(error.requestOptions.path);
      if (!alreadyHandled) await _handleRefreshFailureOnce();
      return null;
    }
  }

  Map<String, dynamic> _readResponseData(dynamic raw) {
    if (raw is! Map) return const {};
    final root = Map<String, dynamic>.from(raw);
    final nested = root['data'];
    if (nested is Map &&
        root['accessToken'] == null &&
        root['access_token'] == null &&
        root['token'] == null) {
      return Map<String, dynamic>.from(nested);
    }
    return root;
  }

  DateTime? _readExpiry(String token, Map<String, dynamic> data) {
    final jwtExpiry = _getJwtExpiry(token);
    if (jwtExpiry != null) return jwtExpiry;
    final expiresIn = int.tryParse(
      (data['expiresIn'] ?? data['expires_in'])?.toString() ?? '',
    );
    if (expiresIn == null || expiresIn <= 0) return null;
    return DateTime.now().add(Duration(seconds: expiresIn)).toUtc();
  }

  Future<void> _notifyTokenRefreshed(String token) async {
    try {
      await onTokenRefreshed?.call(token);
    } catch (error, stackTrace) {
      developer.log(
        'Post-refresh callback failed; token remains valid',
        name: 'RefreshTokenInterceptor',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _handleRefreshFailureOnce() {
    final active = _refreshFailureFuture;
    if (active != null) return active;
    final failure = _clearInvalidSession();
    _refreshFailureFuture = failure;
    return failure;
  }

  Future<void> _clearInvalidSession() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: StorageKeys.accessToken),
        _secureStorage.delete(key: StorageKeys.refreshToken),
        _secureStorage.delete(key: StorageKeys.tokenExpiry),
      ]);
    } catch (error, stackTrace) {
      developer.log(
        'Failed to clear invalid session',
        name: 'RefreshTokenInterceptor',
        error: error,
        stackTrace: stackTrace,
      );
    }
    try {
      await onRefreshFailed?.call();
    } catch (error, stackTrace) {
      developer.log(
        'Refresh failure callback failed',
        name: 'RefreshTokenInterceptor',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  DateTime? _getJwtExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload =
          jsonDecode(
                utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
              )
              as Map<String, dynamic>;
      final exp = payload['exp'];
      if (exp is! num) return null;
      return DateTime.fromMillisecondsSinceEpoch(
        exp.toInt() * 1000,
        isUtc: true,
      );
    } catch (_) {
      return null;
    }
  }
}
