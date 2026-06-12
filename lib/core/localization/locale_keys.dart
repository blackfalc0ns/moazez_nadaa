/// Locale keys for error messages and API responses
/// Used for localization of error messages
class LocaleKeys {
  // Network Errors
  static const String noInternet = 'error_network';
  static const String connectionTimeout = 'error_timeout';
  static const String requestCancelled = 'error_cancelled';
  static const String unknownError = 'error_unknown';

  // Server Errors
  static const String serverError = 'error_server';
  static const String unauthorized = 'error_unauthorized';
  static const String forbidden = 'error_forbidden';
  static const String notFound = 'error_not_found';
  static const String internalServerError = 'error_internal_server';
  static const String serviceUnavailable = 'error_service_unavailable';

  // Validation Errors
  static const String validationError = 'error_validation';
  static const String invalidInput = 'error_invalid_input';
  static const String requiredField = 'validation_required';

  // Auth Errors
  static const String tokenExpired = 'error_token_expired';
  static const String invalidCredentials = 'error_invalid_credentials';
  static const String sessionExpired = 'error_session_expired';

  // General
  static const String tryAgain = 'try_again';
  static const String retry = 'retry';
  static const String ok = 'ok';
  static const String cancel = 'cancel';
}
