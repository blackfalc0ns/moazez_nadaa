import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class CallsHistorySummary extends StatelessWidget {
  const CallsHistorySummary({
    super.key,
    required this.totalCount,
    required this.deliveredCount,
    required this.delayedCount,
  });

  final int totalCount;
  final int deliveredCount;
  final int delayedCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SummaryCard(
          icon: Iconsax.receipt_search,
          label: 'إجمالي',
          value: '$totalCount',
          color: AppColors.primary,
        ),
        AppSpacing.horizontalSpaceSm,
        _SummaryCard(
          icon: Iconsax.tick_circle,
          label: 'تم التسليم',
          value: '$deliveredCount',
          color: AppColors.success,
        ),
        AppSpacing.horizontalSpaceSm,
        _SummaryCard(
          icon: Iconsax.timer_pause,
          label: 'متأخر',
          value: '$delayedCount',
          color: AppColors.warning,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
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
          border: Border.all(color: AppColors.lightGrey),
          color: AppColors.white,
          borderRadius: AppRadius.all(AppRadius.radius5),
          boxShadow: AppShadows.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            AppSpacing.verticalSpaceSm,
            Text(
              value,
              style: AppTypography.heading5.copyWith(
                color: AppColors.primaryDeep,
                fontWeight: FontWeight.w700,
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
    );
  }
}
