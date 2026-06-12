import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/app_notification.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final color = notification.type.color;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppColors.surfaceLight
            : color.withValues(alpha: 0.05),
        borderRadius: AppRadius.all(AppRadius.radius5),
        border: Border.all(
          color: notification.isRead
              ? AppColors.borderLight
              : color.withValues(alpha: 0.24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: AppRadius.all(AppRadius.radius3),
                ),
                child: Icon(
                  _iconForType(notification.type),
                  color: color,
                  size: 20,
                ),
              ),
              AppSpacing.horizontalSpaceMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primaryDeep,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${notification.type.label} • ${notification.time}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          AppSpacing.verticalSpaceSm,
          Text(
            notification.body,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.verticalSpaceSm,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              _InfoPill(icon: Iconsax.user, text: notification.relatedStudent),
              _InfoPill(icon: Iconsax.location_tick, text: notification.gate),
              _InfoPill(
                icon: Iconsax.warning_2,
                text: notification.priority.label,
              ),
            ],
          ),
          AppSpacing.verticalSpaceMd,
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Iconsax.arrow_left_2, size: 16),
              label: Text(notification.actionLabel),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.urgentCall:
        return Iconsax.direct_notification;
      case AppNotificationType.delayedPickup:
        return Iconsax.timer_pause;
      case AppNotificationType.delivered:
        return Iconsax.tick_circle;
      case AppNotificationType.gate:
        return Iconsax.location_tick;
      case AppNotificationType.system:
        return Iconsax.setting_2;
    }
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: AppRadius.all(AppRadius.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 14),
          AppSpacing.horizontalSpaceXs,
          Text(
            text,
            style: AppTypography.caption.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
