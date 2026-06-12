import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class CallsSummaryStrip extends StatelessWidget {
  const CallsSummaryStrip({
    super.key,
    required this.newCount,
    required this.preparingCount,
    required this.readyCount,
    required this.delayedCount,
  });

  final int newCount;
  final int preparingCount;
  final int readyCount;
  final int delayedCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _SummaryCard(
            label: 'جديد',
            value: '$newCount',
            icon: Iconsax.notification,
            color: AppColors.info,
          ),
          _SummaryCard(
            label: 'قيد التجهيز',
            value: '$preparingCount',
            icon: Iconsax.timer_start,
            color: AppColors.warning,
          ),
          _SummaryCard(
            label: 'جاهز للتسليم',
            value: '$readyCount',
            icon: Iconsax.shield_tick,
            color: AppColors.success,
          ),
          _SummaryCard(
            label: 'متأخر',
            value: '$delayedCount',
            icon: Iconsax.clock,
            color: AppColors.error,
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      margin: const EdgeInsetsDirectional.only(end: AppSpacing.md),
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.all(AppRadius.radius5),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const Spacer(),
          Text(
            value,
            style: AppTypography.heading4.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
