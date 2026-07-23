import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Authentication interceptor that automatically adds auth token to requests.
/// Uses the same FlutterSecureStorage instance and keys as AuthRepoImpl.
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  // Same key used by AuthRepoImpl
  static const _kAccessToken = 'access_token';

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      options.headers.remove('Authorization');
      return handler.next(options);
    }

    // Get token from secure storage (same key as AuthRepoImpl)
    final token = await _secureStorage.read(key: _kAccessToken);

    if (token != null && token.isNotEmpty) {
      // Add Bearer token to Authorization header
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  /// Check if endpoint is public (doesn't require authentication)
  bool _isPublicEndpoint(String path) {
    final publicEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/forgot-password',
      '/auth/reset-password',
      '/auth/verify-email',
      '/auth/refresh',
      '/health',
      '/version',
    ];

    return publicEndpoints.any((endpoint) => path.contains(endpoint));
  }
}
