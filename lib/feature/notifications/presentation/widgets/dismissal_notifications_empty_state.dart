import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../generated/app_localizations.dart';

class DismissalNotificationsEmptyState extends StatelessWidget {
  const DismissalNotificationsEmptyState({super.key, required this.filtered});

  final bool filtered;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primary,
                size: 31,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              filtered
                  ? l10n.dismissalNoHistory
                  : l10n.dismissalNoNotifications,
              textAlign: TextAlign.center,
              style: AppTypography.withWeight(
                AppTypography.bodyMedium.copyWith(fontSize: 14),
                FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              filtered
                  ? l10n.dismissalNoActiveRequestsBody
                  : l10n.dismissalNoNotificationsBody,
              textAlign: TextAlign.center,
              style: AppTypography.withColor(
                AppTypography.bodySmall.copyWith(fontSize: 11),
                AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
