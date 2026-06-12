import 'package:flutter/material.dart';
import 'app_localizations.dart';
import 'locale_keys.dart';

/// Centralized string provider with localization support
/// Provides localized error messages and other strings
class AppStrings {
  /// Get localized string by key
  static String get(BuildContext context, String key) {
    return AppLocalizations.of(context).translate(key);
  }

  // Network Errors
  static String noInternet(BuildContext context) =>
      get(context, LocaleKeys.noInternet);

  static String connectionTimeout(BuildContext context) =>
      get(context, LocaleKeys.connectionTimeout);

  static String requestCancelled(BuildContext context) =>
      get(context, LocaleKeys.requestCancelled);

  static String unknownError(BuildContext context) =>
      get(context, LocaleKeys.unknownError);

  // Server Errors
  static String serverError(BuildContext context) =>
      get(context, LocaleKeys.serverError);

  static String unauthorized(BuildContext context) =>
      get(context, LocaleKeys.unauthorized);

  static String forbidden(BuildContext context) =>
      get(context, LocaleKeys.forbidden);

  static String notFound(BuildContext context) =>
      get(context, LocaleKeys.notFound);

  static String internalServerError(BuildContext context) =>
      get(context, LocaleKeys.internalServerError);

  static String serviceUnavailable(BuildContext context) =>
      get(context, LocaleKeys.serviceUnavailable);

  // Validation Errors
  static String validationError(BuildContext context) =>
      get(context, LocaleKeys.validationError);

  static String invalidInput(BuildContext context) =>
      get(context, LocaleKeys.invalidInput);

  static String requiredField(BuildContext context) =>
      get(context, LocaleKeys.requiredField);

  // Auth Errors
  static String tokenExpired(BuildContext context) =>
      get(context, LocaleKeys.tokenExpired);

  static String invalidCredentials(BuildContext context) =>
      get(context, LocaleKeys.invalidCredentials);

  static String sessionExpired(BuildContext context) =>
      get(context, LocaleKeys.sessionExpired);

  // General
  static String tryAgain(BuildContext context) =>
      get(context, LocaleKeys.tryAgain);

  static String retry(BuildContext context) =>
      get(context, LocaleKeys.retry);

  static String ok(BuildContext context) =>
      get(context, LocaleKeys.ok);

  static String cancel(BuildContext context) =>
      get(context, LocaleKeys.cancel);
}
