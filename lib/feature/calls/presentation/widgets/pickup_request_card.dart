import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ndaaa_chat/core/utils/common/custom_button.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../generated/app_localizations.dart';
import '../../../dismissal/data/models/dismissal_models.dart';
import '../../../dismissal/presentation/localization/dismissal_localizations.dart';

class PickupRequestCard extends StatelessWidget {
  const PickupRequestCard({
    super.key,
    required this.request,
    required this.isProcessing,
    required this.canManage,
    required this.canDeliver,
    required this.canEscalate,
    required this.onAdvance,
    required this.onDeliver,
    required this.onEscalate,
    required this.onDetails,
  });

  final DismissalRequestModel request;
  final bool isProcessing;
  final bool canManage;
  final bool canDeliver;
  final bool canEscalate;
  final ValueChanged<DismissalRequestStatus> onAdvance;
  final VoidCallback onDeliver;
  final VoidCallback onEscalate;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusColor = _statusColor(request.status);
    final nextAction = _nextAction(request.status, l10n);

    return GestureDetector(
      onTap: onDetails,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: AppRadius.all(AppRadius.radius7),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDeep.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppRadius.all(AppRadius.radius7),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.96),
                borderRadius: AppRadius.all(AppRadius.radius7),
                border: Border.all(
                  color: request.signals.urgent
                      ? AppColors.error.withValues(alpha: 0.28)
                      : statusColor.withValues(alpha: 0.14),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _StudentAvatar(isUrgent: request.signals.urgent),
                      AppSpacing.horizontalSpaceMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    request.child.displayName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.primaryDeep,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                if (request.signals.urgent)
                                  _UrgentBadge(label: l10n.dismissalUrgent),
                                if (!request.signals.urgent &&
                                    request.signals.delayed)
                                  _DelayedBadge(label: l10n.dismissalDelayed),
                              ],
                            ),
                            AppSpacing.verticalSpaceXs,
                            Text(
                              request.child.classLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondaryLight,
                                fontWeight: FontWeight.w700,
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
                        label: request.requester.displayName.isEmpty
                            ? l10n.dismissalFallbackGuardian
                            : request.requester.displayName,
                      ),
                      _InfoPill(
                        icon: Iconsax.location_tick,
                        label: request.gate.name.isEmpty
                            ? l10n.dismissalFallbackGate
                            : request.gate.name,
                      ),
                      _InfoPill(
                        icon: Iconsax.clock,
                        label: l10n.dismissalWaitMinutes(request.waitMinutes),
                        color: request.signals.delayed
                            ? AppColors.error
                            : AppColors.primary,
                      ),
                    ],
                  ),
                  AppSpacing.verticalSpaceSm,
                  Row(
                    children: [
                      _StatusPill(
                        label: request.status.localizedLabel(l10n),
                        color: statusColor,
                      ),
                      const Spacer(),
                      Text(
                        _updatedLabel(request, l10n),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalSpaceMd,
                  if (request.status == DismissalRequestStatus.ready &&
                      canDeliver)
                    _ActionRow(
                      isProcessing: isProcessing,
                      primaryLabel: l10n.dismissalDeliver,
                      primaryIcon: Iconsax.shield_tick,
                      onPrimary: isProcessing ? null : onDeliver,
                      secondaryLabel: l10n.dismissalEscalate,
                      secondaryIcon: Iconsax.warning_2,
                      onSecondary: isProcessing || !canEscalate
                          ? null
                          : onEscalate,
                    )
                  else if (nextAction != null && canManage)
                    _ActionRow(
                      isProcessing: isProcessing,
                      primaryLabel: nextAction.label,
                      primaryIcon: nextAction.icon,
                      onPrimary: isProcessing
                          ? null
                          : () => onAdvance(nextAction.nextStatus),
                      secondaryLabel: l10n.dismissalEscalate,
                      secondaryIcon: Iconsax.warning_2,
                      onSecondary: isProcessing || !canEscalate
                          ? null
                          : onEscalate,
                    )
                  else
                    _ClosedStateLabel(status: request.status),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _updatedLabel(DismissalRequestModel request, AppLocalizations l10n) {
    if (request.updatedAt.trim().isEmpty) {
      return l10n.dismissalLastUpdateUnknown;
    }
    return l10n.dismissalLastUpdate(request.updatedAt);
  }

  _NextPickupAction? _nextAction(
    DismissalRequestStatus status,
    AppLocalizations l10n,
  ) {
    switch (status) {
      case DismissalRequestStatus.requested:
        return _NextPickupAction(
          label: l10n.dismissalQueueAction,
          icon: Iconsax.directbox_receive,
          nextStatus: DismissalRequestStatus.queued,
        );
      case DismissalRequestStatus.queued:
        return _NextPickupAction(
          label: l10n.dismissalCallAction,
          icon: Iconsax.volume_high,
          nextStatus: DismissalRequestStatus.called,
        );
      case DismissalRequestStatus.called:
        return _NextPickupAction(
          label: l10n.dismissalMovingAction,
          icon: Iconsax.routing_2,
          nextStatus: DismissalRequestStatus.moving,
        );
      case DismissalRequestStatus.moving:
        return _NextPickupAction(
          label: l10n.dismissalAtGateAction,
          icon: Iconsax.location_tick,
          nextStatus: DismissalRequestStatus.atGate,
        );
      case DismissalRequestStatus.atGate:
        return _NextPickupAction(
          label: l10n.dismissalReadyAction,
          icon: Iconsax.tick_circle,
          nextStatus: DismissalRequestStatus.ready,
        );
      case DismissalRequestStatus.ready:
      case DismissalRequestStatus.handedOver:
      case DismissalRequestStatus.cancelled:
      case DismissalRequestStatus.expired:
      case DismissalRequestStatus.unknown:
        return null;
    }
  }

  Color _statusColor(DismissalRequestStatus status) {
    switch (status) {
      case DismissalRequestStatus.requested:
        return AppColors.primary;
      case DismissalRequestStatus.queued:
        return AppColors.info;
      case DismissalRequestStatus.called:
        return AppColors.warning;
      case DismissalRequestStatus.moving:
        return AppColors.secondary;
      case DismissalRequestStatus.atGate:
        return AppColors.primaryLight;
      case DismissalRequestStatus.ready:
        return AppColors.success;
      case DismissalRequestStatus.handedOver:
        return AppColors.green;
      case DismissalRequestStatus.cancelled:
      case DismissalRequestStatus.expired:
        return AppColors.error;
      case DismissalRequestStatus.unknown:
        return AppColors.grey;
    }
  }
}

class _NextPickupAction {
  const _NextPickupAction({
    required this.label,
    required this.icon,
    required this.nextStatus,
  });

  final String label;
  final IconData icon;
  final DismissalRequestStatus nextStatus;
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.isProcessing,
    required this.primaryLabel,
    required this.primaryIcon,
    required this.onPrimary,
    required this.secondaryLabel,
    required this.secondaryIcon,
    required this.onSecondary,
  });

  final bool isProcessing;
  final String primaryLabel;
  final IconData primaryIcon;
  final VoidCallback? onPrimary;
  final String secondaryLabel;
  final IconData secondaryIcon;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            height: 42,
            onPressed: onPrimary,
            suffix: Icon(
              primaryIcon,
              color: AppColors.backgroundLight,
              size: 18,
            ),
            text: isProcessing ? l10n.dismissalProcessing : primaryLabel,
          ),
        ),
        AppSpacing.horizontalSpaceSm,
        OutlinedButton.icon(
          onPressed: onSecondary,
          icon: Icon(secondaryIcon, size: 17),
          label: Text(secondaryLabel),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(92, 42),
            foregroundColor: AppColors.error,
            side: BorderSide(color: AppColors.error.withValues(alpha: 0.28)),
            textStyle: AppTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}

class _ClosedStateLabel extends StatelessWidget {
  const _ClosedStateLabel({required this.status});

  final DismissalRequestStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.all(AppRadius.radius4),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Text(
        AppLocalizations.of(context)!.dismissalNoActionForStatus(
          status.localizedLabel(AppLocalizations.of(context)!),
        ),
        textAlign: TextAlign.center,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.textSecondaryLight,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StudentAvatar extends StatelessWidget {
  const _StudentAvatar({required this.isUrgent});

  final bool isUrgent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isUrgent
              ? [AppColors.error, AppColors.warning]
              : [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: AppRadius.all(AppRadius.radius4),
        boxShadow: [
          BoxShadow(
            color: (isUrgent ? AppColors.error : AppColors.primary).withValues(
              alpha: 0.2,
            ),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(Iconsax.user, color: Colors.white, size: 22),
    );
  }
}

class _UrgentBadge extends StatelessWidget {
  const _UrgentBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return _SignalBadge(
      label: label,
      color: AppColors.error,
      icon: Iconsax.flash_1,
    );
  }
}

class _DelayedBadge extends StatelessWidget {
  const _DelayedBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return _SignalBadge(
      label: label,
      color: AppColors.warning,
      icon: Iconsax.timer_pause,
    );
  }
}

class _SignalBadge extends StatelessWidget {
  const _SignalBadge({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.all(AppRadius.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          AppSpacing.horizontalSpaceXs,
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
    this.color = AppColors.primary,
  });

  final IconData icon;
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
        color: color.withValues(alpha: 0.07),
        borderRadius: AppRadius.all(AppRadius.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          AppSpacing.horizontalSpaceXs,
          Text(
            label.trim().isEmpty
                ? AppLocalizations.of(context)!.dismissalUnknownValue
                : label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w800,
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
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
