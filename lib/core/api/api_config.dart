import 'package:dio/dio.dart';
import '../config/environment.dart';

/// API configuration class that holds base URL, timeouts, and headers
class ApiConfig {
  /// Base URL for the API - configured per environment
  static String get baseUrl => Environment.current.baseUrl;

  /// Connection timeout in milliseconds
  static int get connectionTimeout => Environment.current.connectionTimeout;

  /// Receive timeout in milliseconds
  static int get receiveTimeout => Environment.current.receiveTimeout;

  /// Send timeout in milliseconds
  static const int sendTimeout = 30000;

  /// Maximum retry attempts for failed requests
  static const int maxRetryAttempts = 3;

  /// Retry delay in milliseconds (exponential backoff)
  static const int retryDelay = 1000;

  /// Whether to enable request/response logging
  static bool get enableLogging => Environment.current.enableLogging;

  /// Maximum log length for request/response bodies
  static const int maxLogLength = 2000;

  /// Default headers for all API requests
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      };

  /// Authorization header template
  static String authorizationHeader(String token) => 'Bearer $token';

  /// API version path
  static String get apiVersionPath => '/${Environment.current.apiVersion}';

  /// Default request retry delay in seconds
  static const Duration defaultRetryDelay = Duration(seconds: 1);

  /// Maximum redirect count for requests
  static const int maxRedirects = 5;

  /// Whether to follow redirects
  static const bool followRedirects = true;

  /// Validate status code range - Only 2xx are considered success.
  /// 4xx/5xx are treated as errors so Dio throws DioException,
  /// which allows onError interceptors (e.g. RefreshTokenInterceptor) to run.
  static bool validateStatus(int? status) => status != null && status >= 200 && status < 300;

  /// Create base options for Dio requests
  static BaseOptions createBaseOptions() {
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: connectionTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      sendTimeout: const Duration(milliseconds: sendTimeout),
      headers: defaultHeaders,
      validateStatus: validateStatus,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
    );
  }
}