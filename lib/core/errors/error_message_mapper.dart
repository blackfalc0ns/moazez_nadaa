import 'package:flutter/widgets.dart';
import '../../generated/app_localizations.dart';

/// Converts known backend error messages to the active application locale.
class ErrorMessageMapper {
  const ErrorMessageMapper._();

  static String toLocalized(
    BuildContext context,
    String? raw, {
    required String defaultMessage,
  }) {
    if (raw == null || raw.trim().isEmpty) return defaultMessage;
    final message = raw.trim();
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(message)) return message;
    final l10n = AppLocalizations.of(context)!;
    final normalized = message.toLowerCase();
    if (_containsAny(normalized, const [
      'no internet connection',
      'connection error',
      'socketexception',
      'network is unreachable',
    ])) {
      return l10n.error_no_internet_connection;
    }
    if (_containsAny(normalized, const [
      'connection timed out',
      'request timeout',
      'timeout',
      'timed out',
    ])) {
      return l10n.error_connection_timeout;
    }
    if (_containsAny(normalized, const [
      'request was cancelled',
      'cancelled',
    ])) {
      return l10n.error_cancelled;
    }
    if (_containsAny(normalized, const [
      'service unavailable',
      'maintenance',
      'temporarily unavailable',
    ])) {
      return l10n.error_service_unavailable;
    }
    if (_containsAny(normalized, const [
      'active scope is required',
      'scope is required',
      'auth.scope.missing',
      'access denied',
      'read-only participants',
      'communication.message.send_forbidden',
    ])) {
      return l10n.error_forbidden;
    }
    if (_containsAny(normalized, const [
      'invalid email or password',
      'unauthorized',
      'session expired',
      'token expired',
    ])) {
      return l10n.error_unauthorized;
    }
    if (_containsAny(normalized, const [
      'validation error',
      'validation failed',
      'property should not exist',
      'invalid input',
    ])) {
      return l10n.error_bad_request;
    }
    if (_containsAny(normalized, const [
      'not found',
      'message not found',
      'conversation not found',
    ])) {
      return l10n.error_not_found;
    }
    if (_containsAny(normalized, const [
      'server error',
      'internal error',
      'null response',
    ])) {
      return l10n.error_server_error;
    }
    if (_containsAny(normalized, const [
      'unexpected error',
      'something went wrong',
      'failed to send message',
      'failed to load messages',
    ])) {
      return l10n.error_unknown;
    }
    return defaultMessage;
  }

  static bool _containsAny(String message, List<String> patterns) =>
      patterns.any(message.contains);
}
