import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/calls_history_record.dart';
import '../../data/models/pickup_request.dart';
import 'call_status_style.dart';

class CallsHistoryRecordCard extends StatelessWidget {
  const CallsHistoryRecordCard({super.key, required this.record});

  final CallsHistoryRecord record;

  @override
  Widget build(BuildContext context) {
    final request = record.request;
    final statusColor = CallStatusStyle.statusColor(request.status);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.all(AppRadius.radius3),
                ),
                child: Icon(Iconsax.user_tick, color: statusColor, size: 21),
              ),
              AppSpacing.horizontalSpaceMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.studentName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primaryDeep,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${request.grade} - ${request.section} • ${request.stage}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(label: request.status.label, color: statusColor),
            ],
          ),
          AppSpacing.verticalSpaceMd,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _MiniInfo(
                icon: Iconsax.calendar_1,
                text: formatHistoryDate(record.date),
              ),
              _MiniInfo(icon: Iconsax.clock, text: request.requestedAt),
              _MiniInfo(icon: Iconsax.location_tick, text: request.gate),
              _MiniInfo(
                icon: Iconsax.profile_2user,
                text: '${request.guardianRelation}: ${request.guardianName}',
              ),
              _MiniInfo(icon: Iconsax.security_safe, text: request.pickupCode),
            ],
          ),
          AppSpacing.verticalSpaceSm,
          Row(
            children: [
              Expanded(
                child: Text(
                  'المسؤول: ${request.assignedTo}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                record.durationLabel,
                style: AppTypography.caption.copyWith(
                  color: request.status == PickupStatus.delayed
                      ? AppColors.error
                      : AppColors.success,
                  fontWeight: FontWeight.w700,
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
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  const _MiniInfo({required this.icon, required this.text});

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
