import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/error_widgets/api_error_widget.dart';
import '../../../../core/permissions/app_permission.dart';
import '../../../../core/permissions/permission_guard.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/feedback/premium_snackbar.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/logo_shimmer_loader.dart';
import '../../../../generated/app_localizations.dart';
import '../../data/models/dismissal_notification_model.dart';
import '../cubits/dismissal_notifications_cubit.dart';
import '../widgets/dismissal_notification_card.dart';
import '../widgets/dismissal_notification_filters.dart';
import '../widgets/dismissal_notification_stats.dart';
import '../widgets/dismissal_notifications_empty_state.dart';
import 'dismissal_notification_details_screen.dart';

class DismissalNotificationsScreen extends StatelessWidget {
  const DismissalNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionGuard(
      permission: AppPermission.viewNotifications,
      title: AppLocalizations.of(context)!.dismissalNotificationsTitle,
      child: BlocProvider(
        create: (_) => sl<DismissalNotificationsCubit>()..load(),
        child: const _DismissalNotificationsView(),
      ),
    );
  }
}

class _DismissalNotificationsView extends StatefulWidget {
  const _DismissalNotificationsView();

  @override
  State<_DismissalNotificationsView> createState() =>
      _DismissalNotificationsViewState();
}

class _DismissalNotificationsViewState
    extends State<_DismissalNotificationsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 220) {
      context.read<DismissalNotificationsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      DismissalNotificationsCubit,
      DismissalNotificationsState
    >(
      listener: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        if (state.failure != null) {
          PremiumSnackbar.error(
            context,
            message: state.failure!.getLocalizedMessage(context),
          );
          context.read<DismissalNotificationsCubit>().clearFeedback();
        } else if (state.successKey != null) {
          PremiumSnackbar.success(
            context,
            message: _successMessage(l10n, state.successKey!),
          );
          context.read<DismissalNotificationsCubit>().clearFeedback();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: AppPageHeader.compact(
                    title: AppLocalizations.of(
                      context,
                    )!.dismissalNotificationsTitle,
                    icon: Icons.notifications_none_rounded,
                    showBackButton: true,
                    trailing: _HeaderActions(
                      unreadCount: state.summary.unreadCount,
                      onMarkAllRead: context
                          .read<DismissalNotificationsCubit>()
                          .markAllRead,
                    ),
                  ),
                ),
                if (state.isActionLoading)
                  const LinearProgressIndicator(
                    minHeight: 2,
                    color: AppColors.primary,
                  ),
                Expanded(child: _buildBody(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DismissalNotificationsState state) {
    if (state.isLoading && state.notifications.items.isEmpty) {
      return const Center(child: LogoShimmerLoader(size: 120));
    }
    if (state.failure != null && state.notifications.items.isEmpty) {
      return ApiErrorWidget.fromTypedFailure(
        state.failure!,
        onRetry: context.read<DismissalNotificationsCubit>().load,
      );
    }
    final items = state.notifications.items;
    final filtered =
        state.selectedStatus != 'all' || state.selectedType != 'all';
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () =>
          context.read<DismissalNotificationsCubit>().load(refresh: true),
      child: ListView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          36,
        ),
        children: [
          DismissalNotificationStats(summary: state.summary),
          const SizedBox(height: AppSpacing.md),
          DismissalNotificationFilters(
            selectedStatus: state.selectedStatus,
            selectedType: state.selectedType,
            onStatusChanged: context
                .read<DismissalNotificationsCubit>()
                .changeStatus,
            onTypeChanged: context
                .read<DismissalNotificationsCubit>()
                .changeType,
          ),
          const SizedBox(height: AppSpacing.md),
          if (items.isEmpty)
            SizedBox(
              height: 330,
              child: DismissalNotificationsEmptyState(filtered: filtered),
            )
          else
            ...items.map(
              (notification) => DismissalNotificationCard(
                notification: notification,
                onTap: () => _openDetails(notification),
                onMarkRead: notification.isRead
                    ? null
                    : () => context
                          .read<DismissalNotificationsCubit>()
                          .markRead(notification.id),
                onArchive: null,
              ),
            ),
          if (state.isLoadingMore)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: LogoShimmerLoader(size: 120)),
            ),
        ],
      ),
    );
  }

  Future<void> _openDetails(DismissalNotificationModel notification) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DismissalNotificationDetailsScreen(
          initialNotification: notification,
        ),
      ),
    );
    if (mounted) {
      await context.read<DismissalNotificationsCubit>().load(refresh: true);
    }
  }

  String _successMessage(AppLocalizations l10n, String key) {
    switch (key) {
      case 'notifications_marked_read':
        return l10n.dismissalSuccessNotificationRead;
      case 'notifications_all_marked_read':
        return l10n.dismissalSuccessAllNotificationsRead;
      default:
        return l10n.dismissalSuccessStatusUpdated;
    }
  }
}

class _HeaderActions extends StatelessWidget {
  const _HeaderActions({
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  final int unreadCount;
  final VoidCallback onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (unreadCount > 0)
          IconButton(
            tooltip: AppLocalizations.of(context)!.dismissalMarkAllRead,
            visualDensity: VisualDensity.compact,
            onPressed: onMarkAllRead,
            icon: const Icon(Icons.done_all_rounded, size: 20),
          ),
      ],
    );
  }
}
