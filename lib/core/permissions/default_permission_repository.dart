import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';
import 'app_permission.dart';
import 'permission_repository.dart';

class DefaultPermissionRepository implements PermissionRepository {
  static const _kPermissionCache = 'granted_permissions';

  final SharedPreferences _prefs;
  Set<AppPermission> _granted = AppPermission.values.toSet();

  DefaultPermissionRepository({required SharedPreferences prefs})
    : _prefs = prefs;

  @override
  Future<void> warmup() async {
    final cached = _prefs.getStringList(_kPermissionCache);
    if (cached != null && cached.isNotEmpty) {
      _granted = cached
          .map(_parsePermission)
          .whereType<AppPermission>()
          .toSet();
      return;
    }

    final rawUser = _prefs.getString(StorageKeys.userData);
    if (rawUser == null || rawUser.isEmpty) return;

    try {
      final json = jsonDecode(rawUser) as Map<String, dynamic>;
      final permissions = json['permissions'];
      if (permissions is List) {
        await updateFromPermissionKeys(permissions.whereType<String>());
      }
    } catch (_) {
      // Keep the permissive default until auth and user models are wired.
    }
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
  Set<AppPermission> grantedPermissions() => Set<AppPermission>.from(_granted);

  @override
  Future<void> updateFromPermissionKeys(Iterable<String> permissions) async {
    final resolved = permissions
        .map(_parsePermission)
        .whereType<AppPermission>()
        .toSet();
    _granted = resolved.isEmpty ? AppPermission.values.toSet() : resolved;
    await _prefs.setStringList(
      _kPermissionCache,
      _granted.map((permission) => permission.key).toList(growable: false),
    );
  }

  @override
  Future<void> clear() async {
    _granted = AppPermission.values.toSet();
    await _prefs.remove(_kPermissionCache);
  }

  AppPermission? _parsePermission(String key) => _apiToEnum[key];

  static final Map<String, AppPermission> _apiToEnum = {
    for (final permission in AppPermission.values) permission.key: permission,
  };
}
