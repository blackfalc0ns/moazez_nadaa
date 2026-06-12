import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/common/custom_button.dart';
import '../../data/models/waiting_student.dart';

class WaitingStudentCard extends StatelessWidget {
  const WaitingStudentCard({super.key, required this.student});

  final WaitingStudent student;

  @override
  Widget build(BuildContext context) {
    final statusColor = student.status.color;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.all(AppRadius.radius5),
        border: Border.all(
          color: student.priority == WaitingStudentPriority.urgent
              ? AppColors.error.withValues(alpha: 0.22)
              : AppColors.borderLight,
        ),
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
                child: Icon(Iconsax.user, color: statusColor, size: 21),
              ),
              AppSpacing.horizontalSpaceMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.studentName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primaryDeep,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${student.classLabel} • ${student.stage}',
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
              _StatusBadge(label: student.status.label, color: statusColor),
            ],
          ),
          AppSpacing.verticalSpaceMd,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _InfoPill(icon: Iconsax.clock, text: student.calledAt),
              _InfoPill(
                icon: Iconsax.timer,
                text: '${student.waitingMinutes} د',
              ),
              _InfoPill(icon: Iconsax.location_tick, text: student.gate),
              _InfoPill(icon: Iconsax.map, text: student.waitingZone),
              _InfoPill(icon: Iconsax.security_safe, text: student.pickupCode),
            ],
          ),
          AppSpacing.verticalSpaceSm,
          Text(
            '${student.guardianRelation}: ${student.guardianName} • ${student.guardianPhone}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.verticalSpaceXs,
          Text(
            'المسؤول: ${student.assignedTo}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (student.note.isNotEmpty) ...[
            AppSpacing.verticalSpaceSm,
            Text(
              student.note,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          AppSpacing.verticalSpaceMd,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  height: 38,
                  onPressed: () {},
                  suffix: const Icon(
                    Iconsax.tick_circle,
                    color: AppColors.backgroundLight,
                    size: 17,
                  ),
                  text: student.status == WaitingStudentStatus.delayed
                      ? 'تصعيد الطلب'
                      : 'تأكيد الوصول',
                ),
              ),
              AppSpacing.horizontalSpaceSm,
              SizedBox(
                width: 38,
                height: 38,
                child: IconButton.filledTonal(
                  onPressed: () {},
                  icon: const Icon(Iconsax.message_text, size: 17),
                  tooltip: 'مراسلة',
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
