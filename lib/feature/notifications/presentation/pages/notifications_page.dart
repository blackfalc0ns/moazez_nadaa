import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/permissions/app_permission.dart';
import '../../../../core/permissions/permission_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/common/custom_app_bar.dart';
import '../../../../core/utils/feedback/premium_snackbar.dart';
import '../../../../core/widgets/logo_shimmer_loader.dart';
import '../../../../generated/app_localizations.dart';
import '../../../dismissal/data/models/dismissal_models.dart';
import '../../../dismissal/presentation/cubits/dismissal_cubit.dart';
import '../../../dismissal/presentation/cubits/dismissal_state.dart';
import '../../../dismissal/presentation/localization/dismissal_localizations.dart';
import '../widgets/notifications_empty_state.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final DismissalCubit _cubit;
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    _cubit = sl<DismissalCubit>()..loadNotifications();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final permissions = sl<PermissionRepository>();
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DismissalCubit, DismissalState>(
        listenWhen: (previous, current) {
          return previous.failure != current.failure ||
              previous.actionFailure != current.actionFailure ||
              previous.success != current.success;
        },
        listener: (context, state) {
          final failure = state.actionFailure ?? state.failure;
          if (failure != null) {
            PremiumSnackbar.error(
              context,
              message: failure.getLocalizedMessage(context),
            );
          }
          final success = state.success;
          if (success != null) {
            PremiumSnackbar.success(
              context,
              message: success.localizedMessage(l10n),
            );
          }
        },
        builder: (context, state) {
          final notificationsPage = state.notifications;
          final notifications =
              notificationsPage?.notifications ??
              const <DismissalNotificationModel>[];
          final isInitialLoading =
              state.isLoadingNotifications && notificationsPage == null;

          return Scaffold(
            appBar: CustomAppBar(
              title: l10n.dismissalNotificationsTitle,
              actions: [
                if (permissions.has(AppPermission.manageNotifications))
                  IconButton(
                    onPressed: state.isProcessing
                        ? null
                        : () => context
                              .read<DismissalCubit>()
                              .markAllNotificationsRead(),
                    icon: const Icon(Iconsax.tick_circle),
                    tooltip: l10n.dismissalMarkAllRead,
                  ),
              ],
            ),
            body: isInitialLoading
                ? const Center(child: LogoShimmerLoader(size: 112))
                : RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => context
                        .read<DismissalCubit>()
                        .loadNotifications(unreadOnly: _showUnreadOnly),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.xl,
                      ),
                      children: [
                        _NotificationsSummary(
                          totalCount:
                              notificationsPage?.totalCount ??
                              notifications.length,
                          unreadCount:
                              notificationsPage?.unreadCount ??
                              notifications
                                  .where((item) => !item.isRead)
                                  .length,
                          criticalCount:
                              notificationsPage?.criticalCount ??
                              notifications
                                  .where((item) => item.isCritical)
                                  .length,
                        ),
                        AppSpacing.verticalSpaceMd,
                        _NotificationsFilterCard(
                          showUnreadOnly: _showUnreadOnly,
                          onUnreadChanged: (value) {
                            setState(() => _showUnreadOnly = value);
                            context.read<DismissalCubit>().loadNotifications(
                              unreadOnly: value,
                            );
                          },
                        ),
                        AppSpacing.verticalSpaceLg,
                        _ResultsHeader(
                          count: notifications.length,
                          isRefreshing: state.isLoadingNotifications,
                        ),
                        AppSpacing.verticalSpaceMd,
                        if (notifications.isEmpty)
                          const NotificationsEmptyState()
                        else
                          for (final notification in notifications)
                            _DismissalNotificationCard(
                              notification: notification,
                              isProcessing: state.isProcessing,
                              onMarkRead:
                                  notification.isRead ||
                                      !permissions.has(
                                        AppPermission.manageNotifications,
                                      )
                                  ? null
                                  : () => context
                                        .read<DismissalCubit>()
                                        .markNotificationRead(notification.id),
                            ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _NotificationsSummary extends StatelessWidget {
  const _NotificationsSummary({
    required this.totalCount,
    required this.unreadCount,
    required this.criticalCount,
  });

  final int totalCount;
  final int unreadCount;
  final int criticalCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _SummaryTile(
          icon: Iconsax.notification_status,
          label: l10n.dismissalTotal,
          value: '$totalCount',
          color: AppColors.primary,
        ),
        AppSpacing.horizontalSpaceSm,
        _SummaryTile(
          icon: Iconsax.sms_notification,
          label: l10n.dismissalUnread,
          value: '$unreadCount',
          color: AppColors.info,
        ),
        AppSpacing.horizontalSpaceSm,
        _SummaryTile(
          icon: Iconsax.warning_2,
          label: l10n.dismissalCritical,
          value: '$criticalCount',
          color: AppColors.error,
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.all(AppRadius.radius5),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            AppSpacing.verticalSpaceSm,
            Text(
              value,
              style: AppTypography.heading5.copyWith(
                color: AppColors.primaryDeep,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
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
    );
  }
}

class _NotificationsFilterCard extends StatelessWidget {
  const _NotificationsFilterCard({
    required this.showUnreadOnly,
    required this.onUnreadChanged,
  });

  final bool showUnreadOnly;
  final ValueChanged<bool> onUnreadChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.all(AppRadius.radius6),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.filter_search, color: AppColors.primary),
          AppSpacing.horizontalSpaceSm,
          Expanded(
            child: Text(
              l10n.dismissalUnreadOnly,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primaryDeep,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Switch.adaptive(
            value: showUnreadOnly,
            activeThumbColor: AppColors.primary,
            onChanged: onUnreadChanged,
          ),
        ],
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.count, required this.isRefreshing});

  final int count;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.dismissalNotificationsList,
            style: AppTypography.heading5.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (isRefreshing) ...[
          const LogoShimmerLoader(size: 18),
          AppSpacing.horizontalSpaceSm,
        ],
        Text(
          l10n.dismissalNotificationsCount(count),
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _DismissalNotificationCard extends StatelessWidget {
  const _DismissalNotificationCard({
    required this.notification,
    required this.isProcessing,
    required this.onMarkRead,
  });

  final DismissalNotificationModel notification;
  final bool isProcessing;
  final VoidCallback? onMarkRead;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = _notificationColor(notification);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white
            : color.withValues(alpha: 0.05),
        borderRadius: AppRadius.all(AppRadius.radius6),
        border: Border.all(
          color: notification.isRead
              ? AppColors.borderLight
              : color.withValues(alpha: 0.24),
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
                  color: color.withValues(alpha: 0.1),
                  borderRadius: AppRadius.all(AppRadius.radius4),
                ),
                child: Icon(_notificationIcon(notification), color: color),
              ),
              AppSpacing.horizontalSpaceMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primaryDeep,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      _subtitle(notification, l10n),
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
              if (!notification.isRead)
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          if (notification.body.trim().isNotEmpty) ...[
            AppSpacing.verticalSpaceSm,
            Text(
              notification.body,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          AppSpacing.verticalSpaceSm,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              if ((notification.childName ?? '').trim().isNotEmpty)
                _InfoPill(icon: Iconsax.user, text: notification.childName!),
              if ((notification.gateName ?? '').trim().isNotEmpty)
                _InfoPill(
                  icon: Iconsax.location_tick,
                  text: notification.gateName!,
                ),
              _InfoPill(
                icon: Iconsax.warning_2,
                text: _priorityLabel(notification, l10n),
              ),
            ],
          ),
          if (onMarkRead != null) ...[
            AppSpacing.verticalSpaceMd,
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: isProcessing ? null : onMarkRead,
                icon: const Icon(Iconsax.tick_circle, size: 16),
                label: Text(l10n.dismissalMarkRead),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _subtitle(
    DismissalNotificationModel notification,
    AppLocalizations l10n,
  ) {
    final type = notification.type.trim().isEmpty
        ? l10n.dismissalFallbackNotification
        : notification.type;
    if (notification.createdAt.trim().isEmpty) return type;
    return '$type • ${notification.createdAt}';
  }

  String _priorityLabel(
    DismissalNotificationModel notification,
    AppLocalizations l10n,
  ) {
    switch (notification.priority.trim().toLowerCase()) {
      case 'critical':
      case 'urgent':
        return l10n.dismissalCritical;
      case 'high':
        return l10n.dismissalPriorityImportant;
      default:
        return l10n.dismissalPriorityNormal;
    }
  }

  Color _notificationColor(DismissalNotificationModel notification) {
    if (notification.isCritical) return AppColors.error;
    switch (notification.type.trim().toLowerCase()) {
      case 'pickup_delivered':
      case 'delivered':
        return AppColors.success;
      case 'gate':
      case 'gate_changed':
        return AppColors.info;
      case 'delay':
      case 'delayed':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  IconData _notificationIcon(DismissalNotificationModel notification) {
    switch (notification.type.trim().toLowerCase()) {
      case 'pickup_delivered':
      case 'delivered':
        return Iconsax.tick_circle;
      case 'gate':
      case 'gate_changed':
        return Iconsax.location_tick;
      case 'delay':
      case 'delayed':
        return Iconsax.timer_pause;
      default:
        return Iconsax.direct_notification;
    }
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
