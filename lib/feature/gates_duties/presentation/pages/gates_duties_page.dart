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

class GatesDutiesPage extends StatefulWidget {
  const GatesDutiesPage({super.key});

  @override
  State<GatesDutiesPage> createState() => _GatesDutiesPageState();
}

class _GatesDutiesPageState extends State<GatesDutiesPage> {
  late final DismissalCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<DismissalCubit>()
      ..loadProfile()
      ..loadGates();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DismissalCubit, DismissalState>(
        listenWhen: (previous, current) => previous.failure != current.failure,
        listener: (context, state) {
          final failure = state.failure;
          if (failure != null) {
            PremiumSnackbar.error(
              context,
              message: failure.getLocalizedMessage(context),
            );
          }
        },
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          final gatesPage = state.gates;
          final gates = gatesPage?.gates ?? const <DismissalGateModel>[];
          final isInitialLoading = state.isLoadingGates && gatesPage == null;

          return Scaffold(
            appBar: CustomAppBar(title: l10n.dismissalGatesTitle , showBackButton: false,),
            body: isInitialLoading
                ? const Center(child: LogoShimmerLoader(size: 112))
                : RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => context.read<DismissalCubit>().loadGates(),
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
                        if (state.profile != null) ...[
                          _StaffAssignmentCard(profile: state.profile!),
                          AppSpacing.verticalSpaceMd,
                        ],
                        _GatesOverviewStrip(
                          totalCount: gatesPage?.totalCount ?? gates.length,
                          openCount:
                              gatesPage?.openCount ??
                              gates.where((gate) => gate.isOpen).length,
                          busyCount:
                              gatesPage?.busyCount ??
                              gates
                                  .where(
                                    (gate) =>
                                        gate.status.toLowerCase() == 'busy',
                                  )
                                  .length,
                          activeCount:
                              gatesPage?.activeCount ??
                              gates.where((gate) => gate.isActive).length,
                        ),
                        AppSpacing.verticalSpaceLg,
                        _SectionHeader(
                          title: l10n.dismissalGatesSectionTitle,
                          subtitle: l10n.dismissalGatesSectionSubtitle,
                        ),
                        AppSpacing.verticalSpaceSm,
                        if (gates.isEmpty)
                          const _EmptyGatesState()
                        else
                          for (final gate in gates)
                            _GateBackendCard(gate: gate),
                        AppSpacing.verticalSpaceMd,
                        const _OperationalNotesCard(),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _StaffAssignmentCard extends StatelessWidget {
  const _StaffAssignmentCard({required this.profile});

  final DismissalProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.all(AppRadius.radius4),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: AppRadius.all(AppRadius.radius4),
            ),
            child: const Icon(Iconsax.security_user, color: Colors.white),
          ),
          AppSpacing.horizontalSpaceMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.displayName.isEmpty
                      ? l10n.dismissalStaffRole
                      : profile.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.verticalSpaceXxs,
                Text(
                  profile.schoolName.isEmpty
                      ? l10n.dismissalUnknownValue
                      : profile.schoolName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _AssignmentBadge(count: profile.assignmentsCount),
        ],
      ),
    );
  }
}

class _AssignmentBadge extends StatelessWidget {
  const _AssignmentBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: AppRadius.all(AppRadius.radiusFull),
      ),
      child: Text(
        l10n.dismissalAssignmentsCount(count),
        style: AppTypography.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _GatesOverviewStrip extends StatelessWidget {
  const _GatesOverviewStrip({
    required this.totalCount,
    required this.openCount,
    required this.busyCount,
    required this.activeCount,
  });

  final int totalCount;
  final int openCount;
  final int busyCount;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _OverviewTile(
          icon: Iconsax.location_tick,
          label: l10n.dismissalOpen,
          value: '$openCount',
          color: AppColors.success,
        ),
        AppSpacing.horizontalSpaceSm,
        _OverviewTile(
          icon: Iconsax.flash_1,
          label: l10n.dismissalBusy,
          value: '$busyCount',
          color: AppColors.warning,
        ),
        AppSpacing.horizontalSpaceSm,
        _OverviewTile(
          icon: Iconsax.direct_notification,
          label: l10n.dismissalActive,
          value: '$activeCount/$totalCount',
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _OverviewTile extends StatelessWidget {
  const _OverviewTile({
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
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.all(AppRadius.radius5),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            AppSpacing.horizontalSpaceSm,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.heading5.copyWith(
                      color: AppColors.primaryDeep,
                      fontWeight: FontWeight.w700,
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
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.heading5.copyWith(
            color: AppColors.primaryDeep,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSpacing.verticalSpaceXxs,
        Text(
          subtitle,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _GateBackendCard extends StatelessWidget {
  const _GateBackendCard({required this.gate});

  final DismissalGateModel gate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = _statusColor(gate);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.all(AppRadius.radius6),
        border: Border.all(color: color.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDeep.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: AppRadius.all(AppRadius.radius4),
                ),
                child: Icon(Iconsax.location_tick, color: color),
              ),
              AppSpacing.horizontalSpaceMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gate.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primaryDeep,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      _gateSubtitle(gate, l10n),
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
              _GateStatusChip(label: _statusLabel(gate, l10n), color: color),
            ],
          ),
          if (gate.waitingZones.isNotEmpty) ...[
            AppSpacing.verticalSpaceMd,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: gate.waitingZones
                  .map((zone) => _ZoneChip(label: zone))
                  .toList(growable: false),
            ),
          ],
          if ((gate.notes ?? '').trim().isNotEmpty) ...[
            AppSpacing.verticalSpaceMd,
            Text(
              gate.notes!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _gateSubtitle(DismissalGateModel gate, AppLocalizations l10n) {
    final parts = [
      if ((gate.code).trim().isNotEmpty) gate.code,
      if ((gate.campus ?? '').trim().isNotEmpty) gate.campus!,
      if (gate.latitude != null && gate.longitude != null)
        l10n.dismissalLocationConfigured,
    ];
    return parts.isEmpty
        ? l10n.dismissalGateDetailsUnavailable
        : parts.join(' - ');
  }

  String _statusLabel(DismissalGateModel gate, AppLocalizations l10n) {
    if (!gate.isActive) return l10n.dismissalInactive;
    switch (gate.status.trim().toLowerCase()) {
      case 'open':
        return l10n.dismissalOpen;
      case 'busy':
        return l10n.dismissalBusy;
      case 'maintenance':
        return l10n.dismissalMaintenance;
      case 'closed':
        return l10n.dismissalClosed;
      default:
        return gate.status.isEmpty ? l10n.dismissalUnknownValue : gate.status;
    }
  }

  Color _statusColor(DismissalGateModel gate) {
    if (!gate.isActive) return AppColors.grey;
    switch (gate.status.trim().toLowerCase()) {
      case 'open':
        return AppColors.success;
      case 'busy':
        return AppColors.warning;
      case 'maintenance':
        return AppColors.info;
      case 'closed':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
}

class _GateStatusChip extends StatelessWidget {
  const _GateStatusChip({required this.label, required this.color});

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
        color: color.withValues(alpha: 0.1),
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

class _ZoneChip extends StatelessWidget {
  const _ZoneChip({required this.label});

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
          const Icon(Iconsax.map, color: AppColors.primary, size: 14),
          AppSpacing.horizontalSpaceXs,
          Text(
            label,
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

class _EmptyGatesState extends StatelessWidget {
  const _EmptyGatesState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: AppSpacing.allXl,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.all(AppRadius.radius6),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          const Icon(
            Iconsax.location_slash,
            color: AppColors.primary,
            size: 36,
          ),
          AppSpacing.verticalSpaceSm,
          Text(
            l10n.dismissalNoGatesTitle,
            style: AppTypography.heading5.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.verticalSpaceXs,
          Text(
            l10n.dismissalNoGatesBody,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationalNotesCard extends StatelessWidget {
  const _OperationalNotesCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: AppRadius.all(AppRadius.radius5),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Iconsax.info_circle, color: AppColors.primary, size: 22),
          AppSpacing.horizontalSpaceSm,
          Expanded(
            child: Text(
              l10n.dismissalOperationalAssignmentsNote,
              style: AppTypography.bodySmall.copyWith(
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
