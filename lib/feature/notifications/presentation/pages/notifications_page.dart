import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/common/custom_app_bar.dart';
import '../../data/models/app_notification.dart';
import '../../data/notifications_dummy_data.dart';
import '../widgets/notification_card.dart';
import '../widgets/notifications_empty_state.dart';
import '../widgets/notifications_filters.dart';
import '../widgets/notifications_summary.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  AppNotificationType? _type;
  bool _showUnreadOnly = false;

  List<AppNotification> get _filteredNotifications {
    return NotificationsDummyData.notifications
        .where((notification) {
          final matchesType = _type == null || notification.type == _type;
          final matchesRead = !_showUnreadOnly || !notification.isRead;

          return matchesType && matchesRead;
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _filteredNotifications;
    final unreadCount = notifications
        .where((notification) => !notification.isRead)
        .length;
    final criticalCount = notifications
        .where(
          (notification) =>
              notification.priority == AppNotificationPriority.critical,
        )
        .length;

    return Scaffold(
      appBar: const CustomAppBar(title: 'التنبيهات'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          NotificationsSummary(
            totalCount: notifications.length,
            unreadCount: unreadCount,
            criticalCount: criticalCount,
          ),
          AppSpacing.verticalSpaceMd,
          NotificationsFilters(
            type: _type,
            showUnreadOnly: _showUnreadOnly,
            onTypeChanged: (value) => setState(() => _type = value),
            onUnreadChanged: (value) => setState(() => _showUnreadOnly = value),
          ),
          AppSpacing.verticalSpaceLg,
          _ResultsHeader(count: notifications.length),
          AppSpacing.verticalSpaceMd,
          if (notifications.isEmpty)
            const NotificationsEmptyState()
          else
            for (final notification in notifications)
              NotificationCard(notification: notification),
        ],
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'قائمة التنبيهات',
            style: AppTypography.heading5.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          '$count تنبيه',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
