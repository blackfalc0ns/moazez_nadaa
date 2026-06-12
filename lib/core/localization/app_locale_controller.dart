import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

class AppLocaleController extends ChangeNotifier {
  final SharedPreferences _prefs;

  Locale _locale;

  AppLocaleController({required SharedPreferences prefs, Locale? initialLocale})
      : _prefs = prefs,
        _locale = initialLocale ?? const Locale('ar');

  Locale get locale => _locale;

  String get languageCode => _locale.languageCode;

  Future<void> load() async {
    final savedCode = _prefs.getString(StorageKeys.locale);
    if (savedCode == null || savedCode.isEmpty) {
      _locale = const Locale('ar');
      return;
    }

    _locale = _normalize(savedCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    final normalized = _normalize(locale.languageCode);
    if (normalized == _locale) return;

    _locale = normalized;
    await _prefs.setString(StorageKeys.locale, normalized.languageCode);
    notifyListeners();
  }

  Locale _normalize(String languageCode) {
    if (languageCode.toLowerCase().startsWith('en')) {
      return const Locale('en');
    }
    return const Locale('ar');
  }
}
