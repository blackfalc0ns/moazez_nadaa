import 'package:dio/dio.dart';
import '../api/api_config.dart';

/// API client wrapper for Dio - Manages Dio instance and interceptors only
/// Does NOT handle HTTP methods - that's the responsibility of ApiService
class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(ApiConfig.createBaseOptions());
  }

  /// Get the underlying Dio instance
  Dio get dio => _dio;

  /// Add an interceptor to the client
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// Remove an interceptor from the client
  void removeInterceptor(Interceptor interceptor) {
    _dio.interceptors.remove(interceptor);
  }

  /// Clear all interceptors
  void clearInterceptors() {
    _dio.interceptors.clear();
  }

  /// Set authorization token for all requests
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = ApiConfig.authorizationHeader(token);
  }

  /// Get the current authorization token (without Bearer prefix)
  String? getAuthToken() {
    final header = _dio.options.headers['Authorization']?.toString();
    if (header == null || !header.startsWith('Bearer ')) return null;
    return header.substring(7);
  }

  /// Remove authorization token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Set language header for all requests
  void setLanguage(String languageCode) {
    _dio.options.headers['Accept-Language'] = languageCode;
    _dio.options.headers['X-Language'] = languageCode;
  }

  /// Update base URL
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// Update connection timeout
  void updateConnectionTimeout(int timeout) {
    _dio.options.connectTimeout = Duration(milliseconds: timeout);
  }

  /// Update receive timeout
  void updateReceiveTimeout(int timeout) {
    _dio.options.receiveTimeout = Duration(milliseconds: timeout);
  }

  /// Update send timeout
  void updateSendTimeout(int timeout) {
    _dio.options.sendTimeout = Duration(milliseconds: timeout);
  }

  /// Reset client to initial state
  void reset() {
    _dio.close(force: true);
    _dio = Dio(ApiConfig.createBaseOptions());
  }

  /// Clone the client with new configuration
  ApiClient clone() {
    final client = ApiClient();
    client._dio.options = _dio.options.copyWith();
    // Copy interceptors
    for (final interceptor in _dio.interceptors) {
      client._dio.interceptors.add(interceptor);
    }
    return client;
  }

  /// Close the client and release resources
  void close({bool force = false}) {
    _dio.close(force: force);
  }
}