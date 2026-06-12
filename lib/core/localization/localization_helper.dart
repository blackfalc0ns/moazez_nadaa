import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

/// Localization helper class for managing app localization
class LocalizationHelper {
  static final LocalizationHelper _instance = LocalizationHelper._internal();
  static LocalizationHelper get instance => _instance;

  LocalizationHelper._internal();

  /// Current locale
  Locale _currentLocale = const Locale('en');

  /// Get current locale
  Locale get currentLocale => _currentLocale;

  /// Check if current locale is RTL
  bool get isRtl => _currentLocale.languageCode == 'ar';

  /// Get text direction
  TextDirection get textDirection => isRtl ? TextDirection.rtl : TextDirection.ltr;

  /// Set locale
  void setLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      _currentLocale = locale;
    }
  }

  /// Set locale by language code
  void setLocaleByCode(String languageCode) {
    setLocale(Locale(languageCode));
  }

  /// Get supported locales
  List<Locale> get supportedLocales => const [
        Locale('en'),
        Locale('ar'),
      ];

  /// Get localized delegates for MaterialApp
  List<LocalizationsDelegate<dynamic>> get localizationsDelegates => const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  /// Get localized supported locales for MaterialApp
  List<Locale> get supportedLocalesForApp => const [
        Locale('en'),
        Locale('ar'),
      ];

  /// Get locale resolution callback
  LocaleResolutionCallback get localeResolutionCallback => (locale, supportedLocales) {
        if (locale == null) {
          return const Locale('en');
        }

        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }

        return const Locale('en');
      };

  /// Get RTL alignment based on locale
  static bool isRtlLocale(Locale locale) {
    return locale.languageCode == 'ar' ||
        locale.languageCode == 'he' ||
        locale.languageCode == 'fa' ||
        locale.languageCode == 'ur';
  }

  /// Check if current system locale is RTL
  static bool isSystemRtl(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  /// Get current locale from context
  static Locale getCurrentLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }

  /// Get text direction from locale
  static TextDirection getTextDirection(Locale locale) {
    return isRtlLocale(locale) ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Get localized day name
  static String getDayName(int weekday, String localeCode) {
    if (localeCode == 'ar') {
      const arDays = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
      return arDays[weekday - 1];
    }
    const enDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return enDays[weekday - 1];
  }

  /// Get localized month name
  static String getMonthName(int month, String localeCode) {
    if (localeCode == 'ar') {
      const arMonths = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      return arMonths[month - 1];
    }
    const enMonths = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return enMonths[month - 1];
  }

  /// Format number according to locale
  static String formatNumber(num number, String localeCode) {
    if (localeCode == 'ar') {
      // Convert western numbers to Arabic numerals
      return number.toString().replaceAllMapped(
        RegExp(r'[0-9]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 1632),
      );
    }
    return number.toString();
  }
}