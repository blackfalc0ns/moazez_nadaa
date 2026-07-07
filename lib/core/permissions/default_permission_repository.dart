import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';
import 'app_permission.dart';
import 'permission_repository.dart';

class DefaultPermissionRepository implements PermissionRepository {
  static const _permissionCacheKey = 'granted_permissions';
  static const _accessTokenKey = 'access_token';

  DefaultPermissionRepository({
    required SharedPreferences prefs,
    required FlutterSecureStorage secureStorage,
  }) : _prefs = prefs,
       _secureStorage = secureStorage;

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;
  Set<AppPermission> _granted = <AppPermission>{};

  @override
  Future<void> warmup() async {
    final token = await _secureStorage.read(key: _accessTokenKey);
    if (token == null || token.isEmpty) {
      await clear();
      return;
    }

    final tokenPayload = _decodeJwtPayload(token);
    final tokenPermissions = _permissionKeysFrom(tokenPayload);
    if (tokenPermissions.isNotEmpty) {
      await updateFromPermissionKeys(tokenPermissions);
      return;
    }

    final rawUser = _prefs.getString(StorageKeys.userData);
    if (rawUser != null && rawUser.isNotEmpty) {
      try {
        final user = Map<String, dynamic>.from(jsonDecode(rawUser) as Map);
        final userPermissions = _permissionKeysFrom(user);
        if (userPermissions.isNotEmpty) {
          await updateFromPermissionKeys(userPermissions);
          return;
        }
      } catch (_) {}
    }

    if (_isDismissalStaff(tokenPayload)) {
      await updateFromPermissionKeys(_dismissalStaffPermissionKeys);
      return;
    }

    await clear();
  }

  @override
  bool has(AppPermission permission) => _granted.contains(permission);

  @override
  bool hasAny(Iterable<AppPermission> permissions) {
    return permissions.any(_granted.contains);
  }

  @override
  bool hasAll(Iterable<AppPermission> permissions) {
    return permissions.every(_granted.contains);
  }

  @override
  Set<AppPermission> grantedPermissions() => Set.of(_granted);

  @override
  Future<void> updateFromPermissionKeys(Iterable<String> permissions) async {
    _granted = permissions
        .map((key) => _apiToEnum[key.trim()])
        .whereType<AppPermission>()
        .toSet();
    await _prefs.setStringList(
      _permissionCacheKey,
      _granted.map((permission) => permission.key).toList(growable: false),
    );
  }

  @override
  Future<void> clear() async {
    _granted = <AppPermission>{};
    await _prefs.remove(_permissionCacheKey);
  }

  Map<String, dynamic> _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return const {};
      final raw = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final decoded = jsonDecode(raw);
      return decoded is Map
          ? Map<String, dynamic>.from(decoded)
          : const <String, dynamic>{};
    } catch (_) {
      return const {};
    }
  }

  Set<String> _permissionKeysFrom(Map<String, dynamic> source) {
    final result = <String>{};

    void collect(dynamic value) {
      if (value is String && value.contains('.')) {
        result.add(value.trim());
        return;
      }
      if (value is List) {
        for (final item in value) {
          collect(item);
        }
        return;
      }
      if (value is Map) {
        final map = Map<String, dynamic>.from(value);
        for (final key in const [
          'key',
          'code',
          'name',
          'permission',
          'value',
          'permissions',
          'activeMembership',
          'role',
          'user',
        ]) {
          if (map.containsKey(key)) collect(map[key]);
        }
      }
    }

    collect(source);
    return result;
  }

  bool _isDismissalStaff(Map<String, dynamic> payload) {
    final candidates = [
      payload['userType'],
      payload['user_type'],
      payload['type'],
      payload['role'],
      payload['roleName'],
    ];
    return candidates.any(
      (value) => value?.toString().trim().toUpperCase() == 'DISMISSAL_STAFF',
    );
  }

  static final Map<String, AppPermission> _apiToEnum = {
    for (final permission in AppPermission.values) permission.key: permission,
  };

  static final Set<String> _dismissalStaffPermissionKeys = {
    for (final permission in AppPermission.values) permission.key,
  };
}
