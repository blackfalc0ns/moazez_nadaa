import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:developer' as developer;

/// Request deduplication interceptor
/// Prevents duplicate requests from being sent simultaneously
/// Returns the same Future for identical requests
/// 
/// Enterprise-level pattern used by: GitHub, Notion, Trello
class DeduplicationInterceptor extends Interceptor {
  // Map to store pending requests
  final Map<String, Completer<Response>> _pendingRequests = {};

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Generate unique key for this request
    final requestKey = _generateRequestKey(options);

    // Check if this request is already pending
    if (_pendingRequests.containsKey(requestKey)) {
      developer.log(
        '🔄 Duplicate request detected, reusing pending request: ${options.uri}',
        name: 'DeduplicationInterceptor',
      );

      try {
        // Wait for the pending request to complete
        final response = await _pendingRequests[requestKey]!.future;
        return handler.resolve(response);
      } catch (e) {
        return handler.reject(e as DioException);
      }
    }

    // Create a new completer for this request
    final completer = Completer<Response>();
    _pendingRequests[requestKey] = completer;

    developer.log(
      '✅ New request registered: ${options.uri}',
      name: 'DeduplicationInterceptor',
    );

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final requestKey = _generateRequestKey(response.requestOptions);

    // Complete the pending request
    if (_pendingRequests.containsKey(requestKey)) {
      _pendingRequests[requestKey]!.complete(response);
      _pendingRequests.remove(requestKey);

      developer.log(
        '✅ Request completed and removed: ${response.requestOptions.uri}',
        name: 'DeduplicationInterceptor',
      );
    }

    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final requestKey = _generateRequestKey(err.requestOptions);

    // Complete the pending request with error
    if (_pendingRequests.containsKey(requestKey)) {
      _pendingRequests[requestKey]!.completeError(err);
      _pendingRequests.remove(requestKey);

      developer.log(
        '❌ Request failed and removed: ${err.requestOptions.uri}',
        name: 'DeduplicationInterceptor',
      );
    }

    handler.next(err);
  }

  /// Generate unique key for request
  String _generateRequestKey(RequestOptions options) {
    // Combine method, path, and query parameters
    final method = options.method;
    final path = options.path;
    final queryParams = options.queryParameters.toString();
    final data = options.data?.toString() ?? '';

    return '$method:$path:$queryParams:$data';
  }

  /// Clear all pending requests (useful for testing)
  void clear() {
    _pendingRequests.clear();
  }

  /// Get number of pending requests
  int get pendingCount => _pendingRequests.length;
}
