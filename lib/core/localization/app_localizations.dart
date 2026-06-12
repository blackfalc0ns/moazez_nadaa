import 'package:flutter/material.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ar.dart';

/// Application localizations support
/// Provides translations for English and Arabic
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  /// Get current localization instance
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  /// Get localization delegate
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Supported locales
  static const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];

  /// English translations
  static const AppLocalizationsEn en = AppLocalizationsEn();

  /// Arabic translations
  static const AppLocalizationsAr ar = AppLocalizationsAr();

  /// Get text for current locale
  String get text {
    switch (locale.languageCode) {
      case 'ar':
        return 'ar';
      case 'en':
      default:
        return 'en';
    }
  }

  /// Check if current locale is RTL
  bool get isRtl => locale.languageCode == 'ar';

  /// Get text direction
  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  /// Get localized text
  String translate(String key) {
    // This would be replaced with actual localization
    switch (locale.languageCode) {
      case 'ar':
        return AppLocalizationsAr.getString(key);
      case 'en':
      default:
        return AppLocalizationsEn.getString(key);
    }
  }
}

/// Localization delegate
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Extension for easy access to localizations
extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
