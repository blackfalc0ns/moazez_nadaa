import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/gate_duty.dart';

class DutyShiftCard extends StatelessWidget {
  const DutyShiftCard({
    super.key,
    required this.gateName,
    required this.shift,
    this.compact = false,
  });

  final String gateName;
  final DutyShift shift;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
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
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.all(AppRadius.radius3),
                ),
                child: const Icon(
                  Iconsax.calendar_tick,
                  color: AppColors.primary,
                  size: 19,
                ),
              ),
              AppSpacing.horizontalSpaceSm,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shift.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primaryDeep,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '$gateName • ${shift.timeRange}',
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
              _ShiftTypeBadge(type: shift.type),
            ],
          ),
          AppSpacing.verticalSpaceSm,
          _ShiftInfo(icon: Iconsax.user, text: 'القائد: ${shift.leadName}'),
          AppSpacing.verticalSpaceXs,
          _ShiftInfo(icon: Iconsax.location, text: 'النطاق: ${shift.zone}'),
          if (!compact) ...[
            AppSpacing.verticalSpaceSm,
            Text(
              'الفريق',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w800,
              ),
            ),
            AppSpacing.verticalSpaceXs,
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final member in shift.team) _TeamChip(label: member),
              ],
            ),
          ],
          AppSpacing.verticalSpaceSm,
          for (final task in shift.tasks.take(compact ? 1 : 3))
            _TaskLine(text: task),
        ],
      ),
    );
  }
}

class _ShiftTypeBadge extends StatelessWidget {
  const _ShiftTypeBadge({required this.type});

  final ShiftType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.all(AppRadius.radiusFull),
      ),
      child: Text(
        type.label,
        style: AppTypography.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ShiftInfo extends StatelessWidget {
  const _ShiftInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 15),
        AppSpacing.horizontalSpaceXs,
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _TaskLine extends StatelessWidget {
  const _TaskLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              text,
              style: AppTypography.caption.copyWith(
                color: AppColors.primaryDeep,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamChip extends StatelessWidget {
  const _TeamChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.all(AppRadius.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: AppColors.primaryDeep,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
