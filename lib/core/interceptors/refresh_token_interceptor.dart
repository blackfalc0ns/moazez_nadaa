import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as developer;

/// Refresh token interceptor that automatically refreshes expired tokens
/// Uses the same FlutterSecureStorage instance and keys as AuthRepoImpl.
class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final String refreshTokenEndpoint;
  final void Function()? onRefreshFailed;

  // Same keys used by AuthRepoImpl
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';

  // Lock to prevent multiple simultaneous refresh requests
  bool _isRefreshing = false;
  final List<_RequestRetry> _requestsQueue = [];

  RefreshTokenInterceptor({
    required Dio dio,
    required FlutterSecureStorage secureStorage,
    this.refreshTokenEndpoint = '/auth/refresh',
    this.onRefreshFailed,
  })  : _dio = dio,
        _secureStorage = secureStorage;

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    developer.log(
      '🚨 onError fired: ${err.response?.statusCode} ${err.requestOptions.path}',
      name: 'RefreshTokenInterceptor',
    );

    // Only handle 401 Unauthorized errors
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Skip refresh for refresh token endpoint itself
    if (err.requestOptions.path.contains(refreshTokenEndpoint)) {
      developer.log(
        '❌ Refresh token request failed',
        name: 'RefreshTokenInterceptor',
      );
      _handleRefreshFailure();
      return handler.next(err);
    }

    developer.log(
      '🔐 Token expired, attempting refresh...',
      name: 'RefreshTokenInterceptor',
    );

    // If already refreshing, queue this request
    if (_isRefreshing) {
      _requestsQueue.add(_RequestRetry(err.requestOptions, handler));
      return;
    }

    _isRefreshing = true;

    try {
      // Attempt to refresh token
      final newToken = await _refreshToken();

      if (newToken != null) {
        // Save new token (same key as AuthRepoImpl)
        await _secureStorage.write(key: _kAccessToken, value: newToken);

        // Update authorization header
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

        // Retry original request
        final response = await _dio.fetch(err.requestOptions);

        // Retry all queued requests
        await _retryQueuedRequests(newToken);

        _isRefreshing = false;
        return handler.resolve(response);
      } else {
        // Refresh failed
        await _handleRefreshFailure();
        _isRefreshing = false;
        return handler.next(err);
      }
    } catch (e) {
      developer.log(
        '❌ Token refresh error: $e',
        name: 'RefreshTokenInterceptor',
      );
      await _handleRefreshFailure();
      _isRefreshing = false;
      return handler.next(err);
    }
  }

  /// Refresh the access token using refresh token
  Future<String?> _refreshToken() async {
    try {
      // Get refresh token from storage (same key as AuthRepoImpl)
      final refreshToken = await _secureStorage.read(key: _kRefreshToken);

      if (refreshToken == null || refreshToken.isEmpty) {
        developer.log(
          '❌ No refresh token found',
          name: 'RefreshTokenInterceptor',
        );
        return null;
      }

      // Create a new Dio instance without interceptors to avoid infinite loop
      final refreshDio = Dio(_dio.options);
      // Remove any stale Authorization header — refresh endpoint is public
      refreshDio.options.headers.remove('Authorization');

      // Make refresh request (same body format as AuthRepoImpl)
      final response = await refreshDio.post(
        refreshTokenEndpoint,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        // Backend returns camelCase keys (accessToken / refreshToken)
        final newAccessToken = data['accessToken'] ?? data['access_token'] ?? data['token'];
        final newRefreshToken = data['refreshToken'] ?? data['refresh_token'];

        // Update refresh token if provided (same key as AuthRepoImpl)
        if (newRefreshToken != null) {
          await _secureStorage.write(key: _kRefreshToken, value: newRefreshToken);
        }

        developer.log(
          '✅ Token refreshed successfully',
          name: 'RefreshTokenInterceptor',
        );

        return newAccessToken;
      }

      developer.log(
        '⚠️ Refresh response invalid: status=${response.statusCode} data=${response.data}',
        name: 'RefreshTokenInterceptor',
      );
      return null;
    } catch (e) {
      developer.log(
        '❌ Refresh token request failed: $e',
        name: 'RefreshTokenInterceptor',
      );
      return null;
    }
  }

  /// Retry all queued requests with new token
  Future<void> _retryQueuedRequests(String newToken) async {
    for (final retry in _requestsQueue) {
      try {
        retry.options.headers['Authorization'] = 'Bearer $newToken';
        final response = await _dio.fetch(retry.options);
        retry.handler.resolve(response);
      } catch (e) {
        retry.handler.next(
          DioException(
            requestOptions: retry.options,
            error: e,
          ),
        );
      }
    }
    _requestsQueue.clear();
  }

  /// Handle refresh failure - clear tokens and notify
  Future<void> _handleRefreshFailure() async {
    // Clear all tokens (same keys as AuthRepoImpl)
    await _secureStorage.delete(key: _kAccessToken);
    await _secureStorage.delete(key: _kRefreshToken);

    // Clear queued requests
    _requestsQueue.clear();

    // Notify callback (usually to navigate to login)
    onRefreshFailed?.call();
  }
}

/// Helper class to queue requests during token refresh
class _RequestRetry {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _RequestRetry(this.options, this.handler);
}
