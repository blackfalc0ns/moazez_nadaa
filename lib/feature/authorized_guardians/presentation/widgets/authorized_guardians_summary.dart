import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class AuthorizedGuardiansSummary extends StatelessWidget {
  const AuthorizedGuardiansSummary({
    super.key,
    required this.totalCount,
    required this.verifiedCount,
    required this.reviewCount,
  });

  final int totalCount;
  final int verifiedCount;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SummaryTile(
          icon: Iconsax.profile_2user,
          label: 'إجمالي',
          value: '$totalCount',
          color: AppColors.primary,
        ),
        AppSpacing.horizontalSpaceSm,
        _SummaryTile(
          icon: Iconsax.shield_tick,
          label: 'معتمد',
          value: '$verifiedCount',
          color: AppColors.success,
        ),
        AppSpacing.horizontalSpaceSm,
        _SummaryTile(
          icon: Iconsax.warning_2,
          label: 'مراجعة',
          value: '$reviewCount',
          color: AppColors.warning,
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
