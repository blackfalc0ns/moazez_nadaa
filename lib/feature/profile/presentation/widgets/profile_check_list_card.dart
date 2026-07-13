import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ProfileCheckListCard extends StatelessWidget {
  const ProfileCheckListCard({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.all(AppRadius.radius5),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              AppSpacing.horizontalSpaceSm,
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primaryDeep,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSpaceSm,
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(
                      Iconsax.tick_circle,
                      color: AppColors.success,
                      size: 14,
                    ),
                  ),
                  AppSpacing.horizontalSpaceXs,
                  Expanded(
                    child: Text(
                      item,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primaryDeep,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
