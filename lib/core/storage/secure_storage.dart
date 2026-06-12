import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

/// Secure storage wrapper for sensitive data
/// Uses FlutterSecureStorage for encrypted storage
class SecureStorage {
  static SecureStorage? _instance;
  static SecureStorage get instance => _instance ??= SecureStorage._();

  SecureStorage._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      storageNamespace: 'TeacherAppSecureStorage',
      preferencesKeyPrefix: 'ndaaa_chat_',
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      accountName: 'TeacherApp',
    ),
  );

  /// Write value to secure storage
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      debugPrint('SecureStorage write error: $e');
      rethrow;
    }
  }

  /// Read value from secure storage
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      debugPrint('SecureStorage read error: $e');
      return null;
    }
  }

  /// Delete value from secure storage
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      debugPrint('SecureStorage delete error: $e');
      rethrow;
    }
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      debugPrint('SecureStorage containsKey error: $e');
      return false;
    }
  }

  /// Clear all secure storage
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('SecureStorage deleteAll error: $e');
      rethrow;
    }
  }

  /// Write multiple key-value pairs
  Future<void> writeAll(Map<String, String> values) async {
    try {
      for (final entry in values.entries) {
        await _storage.write(key: entry.key, value: entry.value);
      }
    } catch (e) {
      debugPrint('SecureStorage writeAll error: $e');
      rethrow;
    }
  }

  /// Read all keys and values
  Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      debugPrint('SecureStorage readAll error: $e');
      return {};
    }
  }

  // Convenience methods for specific data types

  /// Write auth token
  Future<void> writeAuthToken(String token) async {
    await write('auth_token', token);
  }

  /// Read auth token
  Future<String?> readAuthToken() async {
    return read('auth_token');
  }

  /// Write refresh token
  Future<void> writeRefreshToken(String token) async {
    await write('refresh_token', token);
  }

  /// Read refresh token
  Future<String?> readRefreshToken() async {
    return read('refresh_token');
  }

  /// Clear auth data
  Future<void> clearAuthData() async {
    await delete('auth_token');
    await delete('refresh_token');
    await delete('token_expiry');
  }
}
