import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ndaaa_chat/core/utils/common/custom_button.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/pickup_request.dart';
import 'call_status_style.dart';

class PickupRequestCard extends StatelessWidget {
  const PickupRequestCard({super.key, required this.request});

  final PickupRequest request;

  @override
  Widget build(BuildContext context) {
    final statusColor = CallStatusStyle.statusColor(request.status);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(borderRadius: AppRadius.all(AppRadius.radius3)),
      child: ClipRRect(
        borderRadius: AppRadius.all(AppRadius.radius4),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.all(AppRadius.radius7),
              border: Border.all(
                color: request.priority == PickupPriority.urgent
                    ? AppColors.error.withValues(alpha: 0.25)
                    : AppColors.lightGrey,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _StudentAvatar(stage: request.stage),
                    AppSpacing.horizontalSpaceMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  request.studentName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.primaryDeep,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              if (request.priority == PickupPriority.urgent)
                                const _UrgentBadge(),
                            ],
                          ),
                          AppSpacing.verticalSpaceXs,
                          Text(
                            '${request.classLabel} • ${request.campus}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.verticalSpaceSm,
                Wrap(
                  runSpacing: AppSpacing.sm,
                  spacing: AppSpacing.sm,
                  children: [
                    _InfoPill(
                      icon: Iconsax.profile_2user,
                      label:
                          '${request.guardianRelation}: ${request.guardianName}',
                    ),
                    _InfoPill(icon: Iconsax.location_tick, label: request.gate),
                    _InfoPill(icon: Iconsax.clock, label: request.requestedAt),
                  ],
                ),
                if (request.note.isNotEmpty) ...[
                  AppSpacing.verticalSpaceSm,
                  Text(
                    request.note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                AppSpacing.verticalSpaceSm,
                Row(
                  children: [
                    _StatusPill(
                      label: request.status.label,
                      color: statusColor,
                    ),
                    AppSpacing.horizontalSpaceSm,
                    Text(
                      'انتظار ${request.waitingMinutes} د',
                      style: AppTypography.caption.copyWith(
                        color: request.waitingMinutes >= 15
                            ? AppColors.error
                            : AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                AppSpacing.verticalSpaceSm,
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        height: 40,
                        onPressed: () {},
                        suffix: const Icon(
                          Iconsax.tick_circle,
                          color: AppColors.backgroundLight,
                          size: 18,
                        ),
                        text: request.status.actionLabel,
                      ),
                    ),
                    AppSpacing.horizontalSpaceSm,
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton.filledTonal(
                        onPressed: () {},
                        icon: const Icon(Iconsax.message_text, size: 18),
                        tooltip: 'مراسلة',
                      ),
                    ),
                    // AppSpacing.horizontalSpaceSm,
                    // IconButton.filledTonal(
                    //   onPressed: () {},
                    //   icon: const Icon(Iconsax.call, size: 20),
                    //   tooltip: 'اتصال',
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentAvatar extends StatelessWidget {
  const _StudentAvatar({required this.stage});

  final String stage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: AppRadius.all(AppRadius.radius3),
      ),
      child: Icon(
        stage == 'حضانة' || stage == 'تمهيدي'
            ? Iconsax.profile_2user
            : Iconsax.user,
        color: AppColors.primary,
        size: 21,
      ),
    );
  }
}

class _UrgentBadge extends StatelessWidget {
  const _UrgentBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: AppRadius.all(AppRadius.radiusFull),
      ),
      child: Text(
        'عاجل',
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

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
          Icon(icon, color: AppColors.primary, size: 15),
          AppSpacing.horizontalSpaceXs,
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.all(AppRadius.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
