import 'package:flutter/widgets.dart';

import '../di/injection_container.dart';
import 'app_permission.dart';
import 'permission_repository.dart';

class PermissionGate extends StatelessWidget {
  const PermissionGate({
    super.key,
    required this.child,
    this.permission,
    this.anyOf = const [],
    this.allOf = const [],
    this.replacement = const SizedBox.shrink(),
  });

  final Widget child;
  final AppPermission? permission;
  final Iterable<AppPermission> anyOf;
  final Iterable<AppPermission> allOf;
  final Widget replacement;

  @override
  Widget build(BuildContext context) {
    if (!sl.isRegistered<PermissionRepository>()) return replacement;
    final repository = sl<PermissionRepository>();
    final allowed =
        (permission == null || repository.has(permission!)) &&
        (anyOf.isEmpty || repository.hasAny(anyOf)) &&
        (allOf.isEmpty || repository.hasAll(allOf));
    return allowed ? child : replacement;
  }
}
