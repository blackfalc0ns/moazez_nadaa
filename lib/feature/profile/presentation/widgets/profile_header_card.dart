import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../generated/app_localizations.dart';
import '../../../dismissal/data/models/dismissal_models.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key, required this.profile});

  final DismissalProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.all(AppRadius.radius6),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: AppRadius.all(AppRadius.radius5),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.24),
              ),
            ),
            child: const Icon(
              Iconsax.security_user,
              color: Colors.white,
              size: 30,
            ),
          ),
          AppSpacing.horizontalSpaceMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.displayName.isEmpty
                      ? l10n.dismissalStaffRole
                      : profile.displayName,
                  style: AppTypography.heading5.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  l10n.dismissalStaffRole,
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.76),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.verticalSpaceSm,
                Row(
                  children: [
                    const Icon(
                      Iconsax.building_4,
                      color: Colors.white,
                      size: 15,
                    ),
                    AppSpacing.horizontalSpaceXs,
                    Expanded(
                      child: Text(
                        profile.schoolName.isEmpty
                            ? l10n.dismissalUnknownValue
                            : profile.schoolName,
                        style: AppTypography.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.86),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
