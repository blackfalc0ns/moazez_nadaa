import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class WaitingStudentsEmptyState extends StatelessWidget {
  const WaitingStudentsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.allXl,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.all(AppRadius.radius5),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          const Icon(
            Iconsax.profile_2user,
            color: AppColors.hintDark,
            size: 34,
          ),
          AppSpacing.verticalSpaceMd,
          Text(
            'لا يوجد طلاب مطابقون',
            style: AppTypography.heading5.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w900,
            ),
          ),
          AppSpacing.verticalSpaceSm,
          Text(
            'جرّب تغيير المرحلة أو البوابة أو منطقة الانتظار.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
