import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import '../api/api_config.dart';

/// Retry interceptor that automatically retries failed requests
/// Uses exponential backoff strategy
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration initialDelay;

  RetryInterceptor({
    this.maxRetries = ApiConfig.maxRetryAttempts,
    this.initialDelay = ApiConfig.defaultRetryDelay,
  });

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only retry on specific error types
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    // Get current retry count
    final retryCount = err.requestOptions.extra['retry_count'] ?? 0;

    // Check if max retries exceeded
    if (retryCount >= maxRetries) {
      developer.log(
        '❌ Max retries ($maxRetries) exceeded for ${err.requestOptions.uri}',
        name: 'RetryInterceptor',
      );
      return handler.next(err);
    }

    // Calculate delay with exponential backoff
    final delay = _calculateDelay(retryCount);

    developer.log(
      '🔄 Retrying request (${retryCount + 1}/$maxRetries) after ${delay.inMilliseconds}ms: ${err.requestOptions.uri}',
      name: 'RetryInterceptor',
    );

    // Wait before retrying
    await Future.delayed(delay);

    // Update retry count
    err.requestOptions.extra['retry_count'] = retryCount + 1;

    // Retry the request
    try {
      final response = await Dio().fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  /// Check if request should be retried
  bool _shouldRetry(DioException err) {
    // Retry on network errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on specific HTTP status codes
    if (err.response != null) {
      final statusCode = err.response!.statusCode;
      // Retry on 408 (Request Timeout), 429 (Too Many Requests), 500+ (Server Errors)
      if (statusCode == 408 ||
          statusCode == 429 ||
          (statusCode != null && statusCode >= 500)) {
        return true;
      }
    }

    return false;
  }

  /// Calculate delay with exponential backoff
  Duration _calculateDelay(int retryCount) {
    // Exponential backoff: initialDelay * 2^retryCount
    final delayMs = initialDelay.inMilliseconds * (1 << retryCount);
    // Cap at 30 seconds
    return Duration(milliseconds: delayMs.clamp(0, 30000));
  }
}
