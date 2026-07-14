import 'package:flutter/material.dart';

import '../di/injection_container.dart';
import 'app_permission.dart';
import 'permission_denied_page.dart';
import 'permission_repository.dart';

class PermissionGuard extends StatelessWidget {
  const PermissionGuard({
    super.key,
    required this.permission,
    required this.child,
    this.title,
  });

  final AppPermission permission;
  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final allowed =
        sl.isRegistered<PermissionRepository>() &&
        sl<PermissionRepository>().has(permission);
    return allowed ? child : const PermissionDeniedPage();
  }
}
