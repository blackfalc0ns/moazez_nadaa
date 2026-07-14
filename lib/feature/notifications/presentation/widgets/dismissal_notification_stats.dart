import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../generated/app_localizations.dart';
import '../../data/models/dismissal_notification_model.dart';

class DismissalNotificationStats extends StatelessWidget {
  const DismissalNotificationStats({super.key, required this.summary});

  final DismissalNotificationsSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _Stat(
          value: summary.totalCount,
          label: l10n.dismissalTotal,
          color: AppColors.primary,
        ),
        const SizedBox(width: 7),
        _Stat(
          value: summary.unreadCount,
          label: l10n.dismissalUnread,
          color: AppColors.error,
        ),
        const SizedBox(width: 7),
        _Stat(
          value: summary.highPriorityCount,
          label: l10n.dismissalCritical,
          color: AppColors.warning,
        ),
        const SizedBox(width: 7),
        _Stat(
          value: summary.archivedCount,
          label: l10n.dismissalDelivered,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.color});

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: AppRadius.all(14),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: AppTypography.withWeight(
                AppTypography.withColor(
                  AppTypography.bodyMedium.copyWith(fontSize: 14),
                  color,
                ),
                FontWeight.w900,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.withColor(
                AppTypography.labelSmall.copyWith(fontSize: 8),
                AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
