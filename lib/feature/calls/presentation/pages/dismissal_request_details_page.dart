import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/di/injection_container.dart';
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

class DismissalRequestDetailsPage extends StatefulWidget {
  const DismissalRequestDetailsPage({
    super.key,
    required this.requestId,
    this.fromHistory = false,
  });

  final String requestId;
  final bool fromHistory;

  @override
  State<DismissalRequestDetailsPage> createState() =>
      _DismissalRequestDetailsPageState();
}

class _DismissalRequestDetailsPageState
    extends State<DismissalRequestDetailsPage> {
  late final DismissalCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<DismissalCubit>()
      ..loadRequestDetails(widget.requestId, fromHistory: widget.fromHistory);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _refresh() {
    return _cubit.loadRequestDetails(
      widget.requestId,
      fromHistory: widget.fromHistory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DismissalCubit, DismissalState>(
        listenWhen: (previous, current) => previous.failure != current.failure,
        listener: (context, state) {
          if (state.failure != null) {
            PremiumSnackbar.error(
              context,
              message: state.failure!.getLocalizedMessage(context),
            );
          }
        },
        builder: (context, state) {
          final request = state.requestDetails;
          return Scaffold(
            appBar: CustomAppBar(title: l10n.dismissalRequestDetailsTitle),
            body: request == null
                ? const Center(child: LogoShimmerLoader(size: 112))
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      children: [
                        _RequestHero(request: request),
                        AppSpacing.verticalSpaceMd,
                        _DetailsCard(
                          title: l10n.dismissalStudentDetails,
                          icon: Iconsax.user_octagon,
                          rows: [
                            _DetailRow(
                              l10n.dismissalStudentName,
                              request.child.displayName,
                            ),
                            _DetailRow(
                              l10n.dismissalClass,
                              request.child.classLabel,
                            ),
                          ],
                        ),
                        AppSpacing.verticalSpaceMd,
                        _DetailsCard(
                          title: l10n.dismissalPickupDetails,
                          icon: Iconsax.car,
                          rows: [
                            _DetailRow(
                              l10n.dismissalGuardianName,
                              request.requester.displayName,
                            ),
                            _DetailRow(
                              l10n.dismissalGateField,
                              request.gate.name,
                            ),
                            _DetailRow(
                              l10n.dismissalWaitLabel,
                              l10n.dismissalWaitMinutes(request.waitMinutes),
                            ),
                          ],
                        ),
                        AppSpacing.verticalSpaceMd,
                        _DetailsCard(
                          title: l10n.dismissalOperationDetails,
                          icon: Iconsax.receipt_text,
                          rows: [
                            _DetailRow(l10n.dismissalRequestNumber, request.id),
                            _DetailRow(
                              l10n.dismissalRequestedAt,
                              request.requestedAt,
                            ),
                            _DetailRow(
                              l10n.dismissalUpdatedAt,
                              request.updatedAt,
                            ),
                          ],
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

class _RequestHero extends StatelessWidget {
  const _RequestHero({required this.request});

  final DismissalRequestModel request;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final signalColor = request.signals.urgent
        ? AppColors.error
        : request.signals.delayed
        ? AppColors.warning
        : AppColors.success;
    return Container(
      padding: AppSpacing.allLg,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.all(AppRadius.radius7),
      ),
      child: Row(
        children: [
          const Icon(
            Iconsax.direct_notification,
            color: Colors.white,
            size: 34,
          ),
          AppSpacing.horizontalSpaceMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.child.displayName,
                  style: AppTypography.heading5.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  request.status.localizedLabel(l10n),
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: signalColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    required this.title,
    required this.icon,
    required this.rows,
  });

  final String title;
  final IconData icon;
  final List<_DetailRow> rows;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: AppSpacing.allLg,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.all(AppRadius.radius6),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 21),
              AppSpacing.horizontalSpaceSm,
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primaryDeep,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSpaceMd,
          for (var index = 0; index < rows.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    rows[index].label,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    rows[index].value.trim().isEmpty
                        ? l10n.dismissalUnknownValue
                        : rows[index].value,
                    textAlign: TextAlign.end,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primaryDeep,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            if (index != rows.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Divider(height: 1, color: AppColors.borderLight),
              ),
          ],
        ],
      ),
    );
  }
}
