import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local storage wrapper for non-sensitive data
/// Uses SharedPreferences for persistent storage
class LocalStorage {
  static LocalStorage? _instance;
  static LocalStorage get instance => _instance ??= LocalStorage._();

  LocalStorage._();

  SharedPreferences? _prefs;

  /// Initialize local storage
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('LocalStorage not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    return prefs.setString(key, value);
  }

  String? getString(String key, {String? defaultValue}) {
    return prefs.getString(key) ?? defaultValue;
  }

  // Int operations
  Future<bool> setInt(String key, int value) async {
    return prefs.setInt(key, value);
  }

  int? getInt(String key, {int? defaultValue}) {
    return prefs.getInt(key) ?? defaultValue;
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    return prefs.setDouble(key, value);
  }

  double? getDouble(String key, {double? defaultValue}) {
    return prefs.getDouble(key) ?? defaultValue;
  }

  // Bool operations
  Future<bool> setBool(String key, bool value) async {
    return prefs.setBool(key, value);
  }

  bool? getBool(String key, {bool? defaultValue}) {
    return prefs.getBool(key) ?? defaultValue;
  }

  // List operations
  Future<bool> setStringList(String key, List<String> value) async {
    return prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    return prefs.getStringList(key) ?? defaultValue;
  }

  // JSON operations
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return prefs.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getJson(String key) {
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // Remove operation
  Future<bool> remove(String key) async {
    return prefs.remove(key);
  }

  // Check if key exists
  bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  // Clear all
  Future<bool> clear() async {
    return prefs.clear();
  }

  // Get all keys
  Set<String> getKeys() {
    return prefs.getKeys();
  }

  // Batch operations
  Future<void> setAll(Map<String, Object> values) async {
    for (final entry in values.entries) {
      if (entry.value is String) {
        await setString(entry.key, entry.value as String);
      } else if (entry.value is int) {
        await setInt(entry.key, entry.value as int);
      } else if (entry.value is double) {
        await setDouble(entry.key, entry.value as double);
      } else if (entry.value is bool) {
        await setBool(entry.key, entry.value as bool);
      } else if (entry.value is List) {
        await setStringList(entry.key, entry.value as List<String>);
      }
    }
  }

  // Convenience methods

  /// Save locale preference
  Future<bool> setLocale(String localeCode) async {
    return setString('app_locale', localeCode);
  }

  /// Get locale preference
  String? getLocale() {
    return getString('app_locale');
  }

  /// Save theme preference
  Future<bool> setDarkMode(bool isDark) async {
    return setBool('dark_mode', isDark);
  }

  /// Get theme preference
  bool? getDarkMode() {
    return getBool('dark_mode');
  }

  /// Save onboarding completed flag
  Future<bool> setOnboardingCompleted(bool completed) async {
    return setBool('onboarding_completed', completed);
  }

  /// Get onboarding completed flag
  bool? isOnboardingCompleted() {
    return getBool('onboarding_completed');
  }

  /// Save last sync time
  Future<bool> setLastSyncTime(DateTime time) async {
    return setString('last_sync_time', time.toIso8601String());
  }

  /// Get last sync time
  DateTime? getLastSyncTime() {
    final timeStr = getString('last_sync_time');
    if (timeStr == null) return null;
    try {
      return DateTime.parse(timeStr);
    } catch (_) {
      return null;
    }
  }
}