import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Language Interceptor
/// Automatically adds Accept-Language header based on app locale
class LanguageInterceptor extends Interceptor {
  final Locale Function() getCurrentLocale;

  LanguageInterceptor({required this.getCurrentLocale});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final locale = getCurrentLocale();
    final languageCode = locale.languageCode; // 'ar' or 'en'

    // Add Accept-Language header
    options.headers['Accept-Language'] = languageCode;

    debugPrint('[LanguageInterceptor] Added Accept-Language: $languageCode');

    super.onRequest(options, handler);
  }
}
