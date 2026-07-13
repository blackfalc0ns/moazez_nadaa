import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/staff_profile.dart';

class ProfileStatsGrid extends StatelessWidget {
  const ProfileStatsGrid({super.key, required this.stats});

  final ProfileStats stats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - AppSpacing.sm) / 2;

        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _StatTile(
              width: itemWidth,
              icon: Iconsax.direct_notification,
              label: 'نداءات تعامل معها',
              value: '${stats.handledCalls}',
              color: AppColors.primary,
            ),
            _StatTile(
              width: itemWidth,
              icon: Iconsax.user_tick,
              label: 'طلاب تم تسليمهم',
              value: '${stats.deliveredStudents}',
              color: AppColors.success,
            ),
            _StatTile(
              width: itemWidth,
              icon: Iconsax.warning_2,
              label: 'تصعيدات',
              value: '${stats.escalatedCalls}',
              color: AppColors.warning,
            ),
            _StatTile(
              width: itemWidth,
              icon: Iconsax.timer,
              label: 'متوسط الانتظار',
              value: '${stats.averageWaitMinutes} د',
              color: AppColors.info,
            ),
          ],
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.width,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final double width;
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
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
          ],
        ),
      ),
    );
  }
}
