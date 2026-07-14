import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/permissions/app_permission.dart';
import '../../../../core/permissions/permission_repository.dart';
import '../../../../core/realtime/realtime_service.dart';
import '../../../../core/services/notifications/push_token_lifecycle.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../../data/repo/dismissal_notifications_repo.dart';

class DismissalNotificationBellButton extends StatefulWidget {
  const DismissalNotificationBellButton({
    super.key,
    this.initialCount = 0,
    this.onDark = false,
  });

  final int initialCount;
  final bool onDark;

  @override
  State<DismissalNotificationBellButton> createState() =>
      _DismissalNotificationBellButtonState();
}

class _DismissalNotificationBellButtonState
    extends State<DismissalNotificationBellButton> {
  late int _unreadCount;
  StreamSubscription<dynamic>? _realtimeSubscription;
  StreamSubscription<void>? _pushSubscription;

  bool get _allowed =>
      sl<PermissionRepository>().has(AppPermission.viewNotifications);

  @override
  void initState() {
    super.initState();
    _unreadCount = widget.initialCount;
    if (_allowed) {
      _loadSummary();
      _realtimeSubscription = sl<RealtimeService>().dismissalEvents
          .where((event) => event.affectsNotifications)
          .listen((_) => _loadSummary());
      _pushSubscription = sl<PushTokenLifecycle>().notificationHints.listen(
        (_) => _loadSummary(),
      );
    }
  }

  @override
  void didUpdateWidget(covariant DismissalNotificationBellButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_unreadCount == oldWidget.initialCount) {
      _unreadCount = widget.initialCount;
    }
  }

  Future<void> _loadSummary() async {
    final result = await sl<DismissalNotificationsRepo>().summary();
    if (!mounted) return;
    result.fold(
      (_) {},
      (summary) => setState(() => _unreadCount = summary.unreadCount),
    );
  }

  @override
  void dispose() {
    _realtimeSubscription?.cancel();
    _pushSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_allowed) return const SizedBox.shrink();
    final backgroundColor = widget.onDark
        ? Colors.white.withValues(alpha: 0.16)
        : AppColors.cardBackground;
    final iconColor = widget.onDark ? Colors.white : AppColors.primary;
    return InkWell(
      onTap: () async {
        await Navigator.of(context).pushNamed(Routes.notifications);
        await _loadSummary();
      },
      borderRadius: AppRadius.all(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: widget.onDark ? null : AppShadows.card,
              border: widget.onDark
                  ? Border.all(color: Colors.white.withValues(alpha: 0.18))
                  : null,
            ),
            child: Icon(
              Icons.notifications_rounded,
              color: iconColor,
              size: 22,
            ),
          ),
          if (_unreadCount > 0)
            PositionedDirectional(
              top: -3,
              end: -3,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  _unreadCount > 99 ? '99+' : '$_unreadCount',
                  style: AppTypography.withWeight(
                    AppTypography.withColor(
                      AppTypography.labelSmall.copyWith(fontSize: 8),
                      Colors.white,
                    ),
                    FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
