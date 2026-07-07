import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../generated/app_localizations.dart';
import '../../../dismissal/data/models/dismissal_models.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key, required this.profile});

  final DismissalProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.all(AppRadius.radius5),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Iconsax.task_square,
            title: l10n.dismissalProfileAssignments,
            value: '${profile.assignmentsCount}',
          ),
          const _Divider(),
          _InfoRow(
            icon: Iconsax.location_tick,
            title: l10n.dismissalProfileAssignedGates,
            value: profile.gates.isEmpty
                ? l10n.dismissalProfileNoGates
                : profile.gates.join(' - '),
          ),
          const _Divider(),
          _InfoRow(
            icon: profile.ready ? Iconsax.tick_circle : Iconsax.warning_2,
            title: l10n.dismissalProfileReadiness,
            value: profile.ready
                ? l10n.dismissalProfileReady
                : l10n.dismissalProfileNotReady,
            valueColor: profile.ready ? AppColors.success : AppColors.warning,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: AppRadius.all(AppRadius.radius3),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        AppSpacing.horizontalSpaceMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodySmall.copyWith(
                  color: valueColor ?? AppColors.primaryDeep,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Divider(height: 1, color: AppColors.borderLight),
    );
  }
}
