import 'package:flutter/foundation.dart';

/// Application logger for logging messages at different levels
/// Provides a centralized logging system for the application
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  static AppLogger get instance => _instance;

  AppLogger._internal();

  /// Whether logging is enabled
  bool _isEnabled = true;

  /// Enable or disable logging
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Log debug message
  void debug(String message, {String? tag, dynamic data}) {
    _log('DEBUG', message, tag: tag, data: data);
  }

  /// Log info message
  void info(String message, {String? tag, dynamic data}) {
    _log('INFO', message, tag: tag, data: data);
  }

  /// Log warning message
  void warning(String message, {String? tag, dynamic data}) {
    _log('WARNING', message, tag: tag, data: data);
  }

  /// Log error message
  void error(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    _log('ERROR', message, tag: tag, data: error);
    if (stackTrace != null) {
      _logStackTrace(stackTrace);
    }
  }

  /// Log verbose message
  void verbose(String message, {String? tag, dynamic data}) {
    _log('VERBOSE', message, tag: tag, data: data);
  }

  /// Log API request
  void logApiRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (!_isEnabled) return;

    final buffer = StringBuffer();
    buffer.writeln('API Request: $method $url');
    if (headers != null) {
      buffer.writeln('Headers: $headers');
    }
    if (body != null) {
      buffer.writeln('Body: $body');
    }

    debug(buffer.toString(), tag: 'API');
  }

  /// Log API response
  void logApiResponse({
    required int statusCode,
    required String url,
    dynamic data,
    int? durationMs,
  }) {
    if (!_isEnabled) return;

    final buffer = StringBuffer();
    buffer.writeln('API Response: $statusCode from $url');
    if (durationMs != null) {
      buffer.writeln('Duration: ${durationMs}ms');
    }
    if (data != null) {
      buffer.writeln('Data: $data');
    }

    if (statusCode >= 200 && statusCode < 300) {
      info(buffer.toString(), tag: 'API');
    } else {
      warning(buffer.toString(), tag: 'API');
    }
  }

  /// Log API error
  void logApiError({
    required String method,
    required String url,
    required String error,
    int? statusCode,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('API Error: $method $url failed');
    if (statusCode != null) {
      buffer.writeln('Status: $statusCode');
    }
    buffer.writeln('Error: $error');

    this.error(buffer.toString(), tag: 'API');
  }

  /// Log navigation
  void logNavigation(String routeName, {Map<String, dynamic>? arguments}) {
    final buffer = StringBuffer();
    buffer.writeln('Navigation: $routeName');
    if (arguments != null) {
      buffer.writeln('Arguments: $arguments');
    }
    info(buffer.toString(), tag: 'NAV');
  }

  /// Log user action
  void logUserAction(String action, {Map<String, dynamic>? details}) {
    final buffer = StringBuffer();
    buffer.writeln('User Action: $action');
    if (details != null) {
      buffer.writeln('Details: $details');
    }
    info(buffer.toString(), tag: 'USER');
  }

  /// Log performance metric
  void logPerformance(String operation, int durationMs, {Map<String, dynamic>? metadata}) {
    final buffer = StringBuffer();
    buffer.writeln('Performance: $operation took ${durationMs}ms');
    if (metadata != null) {
      buffer.writeln('Metadata: $metadata');
    }
    info(buffer.toString(), tag: 'PERF');
  }

  /// Log crash/exception
  void logCrash(dynamic exception, StackTrace? stackTrace, {Map<String, dynamic>? extra}) {
    final buffer = StringBuffer();
    buffer.writeln('CRASH: $exception');
    if (stackTrace != null) {
      buffer.writeln('StackTrace: $stackTrace');
    }
    if (extra != null) {
      buffer.writeln('Extra: $extra');
    }
    _log('CRASH', buffer.toString(), tag: 'CRASH');
  }

  void _log(String level, String message, {String? tag, dynamic data}) {
    if (!_isEnabled) return;

    final timestamp = DateTime.now().toIso8601String();
    final tagString = tag != null ? '[$tag] ' : '';
    final dataString = data != null ? '\nData: $data' : '';
    final logMessage = '[$timestamp] [$level] $tagString$message$dataString';

    if (kDebugMode) {
      debugPrint(logMessage);
    }
  }

  void _logStackTrace(StackTrace stackTrace) {
    if (!_isEnabled) return;
    debugPrint('StackTrace: $stackTrace');
  }

  /// Create a logger with a specific tag
  TaggedLogger tagged(String tag) {
    return TaggedLogger(tag);
  }
}

/// Tagged logger for specific components
class TaggedLogger {
  final String tag;

  TaggedLogger(this.tag);

  void debug(String message, {dynamic data}) {
    AppLogger.instance.debug(message, tag: tag, data: data);
  }

  void info(String message, {dynamic data}) {
    AppLogger.instance.info(message, tag: tag, data: data);
  }

  void warning(String message, {dynamic data}) {
    AppLogger.instance.warning(message, tag: tag, data: data);
  }

  void error(String message, {dynamic error, StackTrace? stackTrace}) {
    AppLogger.instance.error(message, tag: tag, error: error, stackTrace: stackTrace);
  }

  void verbose(String message, {dynamic data}) {
    AppLogger.instance.verbose(message, tag: tag, data: data);
  }
}