import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/error_widgets/api_error_widget.dart';
import '../../../../core/permissions/app_permission.dart';
import '../../../../core/permissions/permission_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/logo_shimmer_loader.dart';
import '../../../../generated/app_localizations.dart';
import '../../data/models/dismissal_notification_model.dart';
import '../cubits/dismissal_notification_details_cubit.dart';

class DismissalNotificationDetailsScreen extends StatelessWidget {
  const DismissalNotificationDetailsScreen({
    super.key,
    required this.initialNotification,
  });

  final DismissalNotificationModel initialNotification;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DismissalNotificationDetailsCubit>()
        ..load(
          initial: initialNotification,
          canMarkRead: sl<PermissionRepository>().has(
            AppPermission.manageNotifications,
          ),
        ),
      child: const _DetailsView(),
    );
  }
}

class _DetailsView extends StatelessWidget {
  const _DetailsView();

  @override
  Widget build(BuildContext context) {
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
                )!.dismissalFallbackNotification,
                icon: Icons.notifications_none_rounded,
                showBackButton: true,
              ),
            ),
            Expanded(
              child:
                  BlocBuilder<
                    DismissalNotificationDetailsCubit,
                    DismissalNotificationDetailsState
                  >(
                    builder: (context, state) {
                      if (state is DismissalNotificationDetailsLoading) {
                        return const Center(
                          child: LogoShimmerLoader(size: 120),
                        );
                      }
                      if (state is DismissalNotificationDetailsError) {
                        return ApiErrorWidget.fromTypedFailure(
                          state.failure,
                          onRetry: () => Navigator.of(context).pop(),
                        );
                      }
                      if (state is! DismissalNotificationDetailsLoaded) {
                        return const SizedBox.shrink();
                      }
                      return _DetailContent(notification: state.notification);
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.notification});

  final DismissalNotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = notification.isHighPriority
        ? AppColors.warning
        : notification.isAnnouncement
        ? AppColors.info
        : AppColors.primary;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        36,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: AppRadius.all(22),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: AppRadius.all(14),
                    ),
                    child: Icon(
                      notification.isAnnouncement
                          ? Icons.campaign_outlined
                          : notification.isMessage
                          ? Icons.chat_bubble_outline_rounded
                          : Icons.notifications_none_rounded,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      notification.title,
                      style: AppTypography.withWeight(
                        AppTypography.heading5.copyWith(
                          fontSize: 18,
                          height: 1.4,
                        ),
                        FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                notification.body,
                style: AppTypography.withColor(
                  AppTypography.bodyMedium.copyWith(fontSize: 13, height: 1.8),
                  AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: AppRadius.all(18),
          ),
          child: Column(
            children: [
              _MetaRow(
                label: l10n.dismissalOperationDetails,
                value: notification.sourceModule,
                icon: Icons.hub_outlined,
              ),
              _MetaRow(
                label: l10n.dismissalRequestedAt,
                value: _date(context, notification.createdAt),
                icon: Icons.schedule_outlined,
              ),
              if (notification.readAt != null)
                _MetaRow(
                  label: l10n.dismissalUpdatedAt,
                  value: _date(context, notification.readAt),
                  icon: Icons.done_all_rounded,
                ),
            ],
          ),
        ),
        if (notification.deepLink != null &&
            _canOpenSource(notification.deepLink!)) ...[
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () => _openSource(context, notification.deepLink!),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: Text(l10n.dismissalRequestDetailsTitle),
          ),
        ],
      ],
    );
  }

  String _date(BuildContext context, DateTime? value) {
    if (value == null) {
      return AppLocalizations.of(context)!.dismissalUnknownValue;
    }
    return DateFormat(
      'd MMM y, h:mm a',
      Localizations.localeOf(context).languageCode,
    ).format(value.toLocal());
  }

  Future<void> _openSource(
    BuildContext context,
    DismissalNotificationDeepLink deepLink,
  ) async {
    switch (deepLink.type) {
      case DismissalNotificationDeepLinkType.dismissalRequest:
        final requestId = deepLink.requestId;
        if (requestId == null || requestId.isEmpty) return;
        await Navigator.of(
          context,
        ).pushNamed(Routes.requestDetails, arguments: {'requestId': requestId});
        return;
    }
  }

  bool _canOpenSource(DismissalNotificationDeepLink deepLink) {
    final permissions = sl<PermissionRepository>();
    switch (deepLink.type) {
      case DismissalNotificationDeepLinkType.dismissalRequest:
        return permissions.has(AppPermission.viewRequests);
    }
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 7),
          Text(
            '$label: ',
            style: AppTypography.withColor(
              AppTypography.labelSmall.copyWith(fontSize: 10),
              AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.withWeight(
                AppTypography.bodySmall.copyWith(fontSize: 11),
                FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
