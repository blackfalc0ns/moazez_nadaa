import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/common/custom_app_bar.dart';
import '../../generated/app_localizations.dart';

class PermissionDeniedPage extends StatelessWidget {
  const PermissionDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: l10n.permissionDeniedTitle),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.shield_cross,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              AppSpacing.verticalSpaceLg,
              Text(
                l10n.permissionDeniedTitle,
                textAlign: TextAlign.center,
                style: AppTypography.heading4.copyWith(
                  color: AppColors.primaryDeep,
                  fontWeight: FontWeight.w900,
                ),
              ),
              AppSpacing.verticalSpaceSm,
              Text(
                l10n.permissionDeniedDescription,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
