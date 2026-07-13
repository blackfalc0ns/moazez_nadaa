import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../generated/app_localizations.dart';

class SettingsHeaderCard extends StatelessWidget {
  const SettingsHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: AppRadius.all(AppRadius.radius5),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: AppRadius.all(AppRadius.radius3),
            ),
            child: const Icon(
              Iconsax.setting_2,
              color: AppColors.primary,
              size: 23,
            ),
          ),
          AppSpacing.horizontalSpaceMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsHeaderTitle,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primaryDeep,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.verticalSpaceXxs,
                Text(
                  l10n.settingsHeaderSubtitle,
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
    );
  }
}
