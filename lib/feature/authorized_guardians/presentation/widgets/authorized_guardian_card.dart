import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/common/custom_button.dart';
import '../../data/models/authorized_guardian.dart';

class AuthorizedGuardianCard extends StatelessWidget {
  const AuthorizedGuardianCard({super.key, required this.guardian});

  final AuthorizedGuardian guardian;

  @override
  Widget build(BuildContext context) {
    final color = guardian.status.color;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.all(AppRadius.radius5),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: AppRadius.all(AppRadius.radius3),
                ),
                child: Icon(Iconsax.user_octagon, color: color, size: 21),
              ),
              AppSpacing.horizontalSpaceMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guardian.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primaryDeep,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${guardian.relation} • ${guardian.phone}',
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
              _StatusBadge(label: guardian.status.label, color: color),
            ],
          ),
          AppSpacing.verticalSpaceMd,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _InfoPill(icon: Iconsax.card, text: guardian.nationalIdMasked),
              _InfoPill(
                icon: Iconsax.location_tick,
                text: guardian.allowedGate,
              ),
              _InfoPill(icon: Iconsax.clock, text: guardian.lastVerifiedAt),
              _InfoPill(icon: Iconsax.calendar, text: guardian.expiryLabel),
            ],
          ),
          AppSpacing.verticalSpaceSm,
          Text(
            'الطلاب: ${guardian.allowedStudents.join('، ')}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.verticalSpaceXs,
          Text(
            guardian.notes,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.verticalSpaceMd,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  height: 38,
                  onPressed: () {},
                  suffix: const Icon(
                    Iconsax.scan_barcode,
                    color: AppColors.backgroundLight,
                    size: 17,
                  ),
                  text: 'تحقق الآن',
                ),
              ),
              AppSpacing.horizontalSpaceSm,
              SizedBox(
                width: 38,
                height: 38,
                child: IconButton.filledTonal(
                  onPressed: () {},
                  icon: const Icon(Iconsax.call, size: 17),
                  tooltip: 'اتصال',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.all(AppRadius.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: AppRadius.all(AppRadius.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 14),
          AppSpacing.horizontalSpaceXs,
          Text(
            text,
            style: AppTypography.caption.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
