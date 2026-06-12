import 'app_permission.dart';

abstract class PermissionRepository {
  Future<void> warmup();
  bool has(AppPermission permission);
  bool hasAny(Iterable<AppPermission> permissions);
  bool hasAll(Iterable<AppPermission> permissions);
  Set<AppPermission> grantedPermissions();
  Future<void> updateFromPermissionKeys(Iterable<String> permissions);
  Future<void> clear();
}
