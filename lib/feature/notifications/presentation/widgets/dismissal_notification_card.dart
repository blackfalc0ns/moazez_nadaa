import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../generated/app_localizations.dart';
import '../../data/models/dismissal_notification_model.dart';

class DismissalNotificationCard extends StatelessWidget {
  const DismissalNotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMarkRead,
    required this.onArchive,
  });

  final DismissalNotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback? onMarkRead;
  final VoidCallback? onArchive;

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Dismissible(
      key: ValueKey('dismissal-notification-${notification.id}'),
      direction: onArchive == null
          ? DismissDirection.none
          : DismissDirection.horizontal,
      confirmDismiss: (_) async {
        onArchive?.call();
        return false;
      },
      background: _ArchiveBackground(alignment: Alignment.centerLeft),
      secondaryBackground: _ArchiveBackground(alignment: Alignment.centerRight),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.all(18),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: notification.isRead
                ? AppColors.cardBackground
                : color.withValues(alpha: 0.035),
            borderRadius: AppRadius.all(18),
            border: Border.all(
              color: notification.isRead
                  ? AppColors.surfaceVariant
                  : color.withValues(alpha: 0.28),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: AppRadius.all(14),
                    ),
                    child: Icon(_icon, color: color, size: 21),
                  ),
                  if (!notification.isRead)
                    PositionedDirectional(
                      top: -2,
                      end: -2,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.cardBackground,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.withWeight(
                              AppTypography.bodyMedium.copyWith(fontSize: 14),
                              notification.isRead
                                  ? FontWeight.w700
                                  : FontWeight.w900,
                            ),
                          ),
                        ),
                        if (notification.isHighPriority)
                          _PriorityPill(color: color),
                      ],
                    ),
                    if (notification.body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.withColor(
                          AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            height: 1.5,
                          ),
                          AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        Text(
                          _typeLabel(context),
                          style: AppTypography.withWeight(
                            AppTypography.withColor(
                              AppTypography.labelSmall.copyWith(fontSize: 9),
                              color,
                            ),
                            FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _date(context),
                          style: AppTypography.withColor(
                            AppTypography.labelSmall.copyWith(fontSize: 9),
                            AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (onMarkRead != null || onArchive != null) ...[
                      const SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (onMarkRead != null)
                            _Action(
                              label: AppLocalizations.of(
                                context,
                              )!.dismissalMarkRead,
                              onTap: onMarkRead!,
                            ),
                          if (onMarkRead != null && onArchive != null)
                            const SizedBox(width: 12),
                          if (onArchive != null)
                            _Action(
                              label: AppLocalizations.of(
                                context,
                              )!.dismissalCancelled,
                              onTap: onArchive!,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color get _color {
    if (notification.isHighPriority) return AppColors.warning;
    if (notification.isMessage) return AppColors.primary;
    if (notification.isAnnouncement) return AppColors.info;
    return AppColors.secondary;
  }

  IconData get _icon {
    switch (notification.type) {
      case 'request_created':
        return Icons.add_alert_outlined;
      case 'request_called':
        return Icons.record_voice_over_outlined;
      case 'request_ready':
        return Icons.how_to_reg_outlined;
      case 'request_handed_over':
        return Icons.verified_outlined;
      case 'request_cancelled':
        return Icons.cancel_outlined;
      case 'request_expired':
        return Icons.timer_off_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  String _typeLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (notification.type) {
      case 'request_created':
        return l10n.dismissalStatusRequested;
      case 'request_called':
        return l10n.dismissalStatusCalled;
      case 'request_ready':
        return l10n.dismissalStatusReady;
      case 'request_handed_over':
        return l10n.dismissalStatusHandedOver;
      case 'request_cancelled':
        return l10n.dismissalStatusCancelled;
      case 'request_expired':
        return l10n.dismissalStatusExpired;
      default:
        return l10n.dismissalFallbackNotification;
    }
  }

  String _date(BuildContext context) {
    final value = notification.createdAt;
    if (value == null) return '';
    return DateFormat(
      'd MMM, h:mm a',
      Localizations.localeOf(context).languageCode,
    ).format(value.toLocal());
  }
}

class _PriorityPill extends StatelessWidget {
  const _PriorityPill({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        AppLocalizations.of(context)!.dismissalPriorityImportant,
        style: AppTypography.withWeight(
          AppTypography.withColor(
            AppTypography.labelSmall.copyWith(fontSize: 8),
            color,
          ),
          FontWeight.w800,
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: AppTypography.withWeight(
          AppTypography.withColor(
            AppTypography.labelSmall.copyWith(fontSize: 9),
            AppColors.primary,
          ),
          FontWeight.w800,
        ),
      ),
    );
  }
}

class _ArchiveBackground extends StatelessWidget {
  const _ArchiveBackground({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.09),
        borderRadius: AppRadius.all(18),
      ),
      alignment: alignment,
      child: const Icon(Icons.archive_outlined, color: AppColors.primary),
    );
  }
}
