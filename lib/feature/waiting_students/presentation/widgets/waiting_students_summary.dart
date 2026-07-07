import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../generated/app_localizations.dart';

class WaitingStudentsSummary extends StatelessWidget {
  const WaitingStudentsSummary({
    super.key,
    required this.totalCount,
    required this.delayedCount,
    required this.atGateCount,
  });

  final int totalCount;
  final int delayedCount;
  final int atGateCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _SummaryTile(
          icon: Iconsax.profile_2user,
          label: l10n.dismissalWaiting,
          value: '$totalCount',
          color: AppColors.primary,
        ),
        AppSpacing.horizontalSpaceSm,
        _SummaryTile(
          icon: Iconsax.timer_pause,
          label: l10n.dismissalDelayed,
          value: '$delayedCount',
          color: AppColors.error,
        ),
        AppSpacing.horizontalSpaceSm,
        _SummaryTile(
          icon: Iconsax.location_tick,
          label: l10n.dismissalStatusAtGate,
          value: '$atGateCount',
          color: AppColors.success,
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.all(AppRadius.radius5),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            AppSpacing.horizontalSpaceSm,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: AppTypography.heading5.copyWith(
                      color: AppColors.primaryDeep,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
