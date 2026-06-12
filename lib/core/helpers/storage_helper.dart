import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Storage helper for managing SharedPreferences and SecureStorage
class StorageHelper {
  static SharedPreferences? _prefs;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  StorageHelper._();

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageHelper not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // String operations
  static Future<bool> setString(String key, String value) async {
    return prefs.setString(key, value);
  }

  static String? getString(String key, {String? defaultValue}) {
    return prefs.getString(key) ?? defaultValue;
  }

  // Int operations
  static Future<bool> setInt(String key, int value) async {
    return prefs.setInt(key, value);
  }

  static int? getInt(String key, {int? defaultValue}) {
    return prefs.getInt(key) ?? defaultValue;
  }

  // Double operations
  static Future<bool> setDouble(String key, double value) async {
    return prefs.setDouble(key, value);
  }

  static double? getDouble(String key, {double? defaultValue}) {
    return prefs.getDouble(key) ?? defaultValue;
  }

  // Bool operations
  static Future<bool> setBool(String key, bool value) async {
    return prefs.setBool(key, value);
  }

  static bool? getBool(String key, {bool? defaultValue}) {
    return prefs.getBool(key) ?? defaultValue;
  }

  // List operations
  static Future<bool> setStringList(String key, List<String> value) async {
    return prefs.setStringList(key, value);
  }

  static List<String>? getStringList(String key, {List<String>? defaultValue}) {
    return prefs.getStringList(key) ?? defaultValue;
  }

  // JSON operations
  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return prefs.setString(key, jsonEncode(value));
  }

  static Map<String, dynamic>? getJson(String key) {
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // Remove operation
  static Future<bool> remove(String key) async {
    return prefs.remove(key);
  }

  // Check if key exists
  static bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  // Clear all
  static Future<bool> clear() async {
    return prefs.clear();
  }

  // Get all keys
  static Set<String> getKeys() {
    return prefs.getKeys();
  }

  // Secure storage operations
  static Future<bool> setSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
    return true;
  }

  static Future<String?> getSecureString(String key) async {
    return _secureStorage.read(key: key);
  }

  static Future<bool> setSecureInt(String key, int value) async {
    return setSecureString(key, value.toString());
  }

  static Future<int?> getSecureInt(String key) async {
    final value = await getSecureString(key);
    return value != null ? int.tryParse(value) : null;
  }

  static Future<bool> setSecureBool(String key, bool value) async {
    return setSecureString(key, value.toString());
  }

  static Future<bool?> getSecureBool(String key) async {
    final value = await getSecureString(key);
    return value != null ? value == 'true' : null;
  }

  static Future<bool> setSecureJson(String key, Map<String, dynamic> value) async {
    return setSecureString(key, jsonEncode(value));
  }

  static Future<Map<String, dynamic>?> getSecureJson(String key) async {
    final jsonString = await getSecureString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> removeSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  static Future<void> clearSecure() async {
    await _secureStorage.deleteAll();
  }

  static Future<bool> containsSecureKey(String key) async {
    return _secureStorage.containsKey(key: key);
  }
}