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
import '../../../../core/utils/common/custom_button.dart';
import '../../../../core/utils/feedback/premium_snackbar.dart';
import '../../../../core/widgets/logo_shimmer_loader.dart';
import '../../../../generated/app_localizations.dart';
import '../../../dismissal/data/models/dismissal_models.dart';
import '../../../dismissal/presentation/cubits/dismissal_cubit.dart';
import '../../../dismissal/presentation/cubits/dismissal_state.dart';
import '../../../dismissal/presentation/localization/dismissal_localizations.dart';
import '../widgets/waiting_students_empty_state.dart';
import '../widgets/waiting_students_summary.dart';

class WaitingStudentsPage extends StatefulWidget {
  const WaitingStudentsPage({super.key});

  @override
  State<WaitingStudentsPage> createState() => _WaitingStudentsPageState();
}

class _WaitingStudentsPageState extends State<WaitingStudentsPage> {
  late final DismissalCubit _cubit;
  String? _selectedGateId;
  DismissalRequestStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _cubit = sl<DismissalCubit>()
      ..loadGates()
      ..loadWaiting();
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
          final waiting = state.waiting;
          final summary = waiting?.summary;
          final students = _filter(waiting?.requests ?? const []);
          final isInitialLoading = state.isLoadingWaiting && waiting == null;

          return Scaffold(
            appBar: CustomAppBar(title: l10n.dismissalWaitingTitle),
            body: isInitialLoading
                ? const Center(child: LogoShimmerLoader(size: 112))
                : RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => context.read<DismissalCubit>().loadWaiting(
                      gateId: _selectedGateId,
                    ),
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
                        WaitingStudentsSummary(
                          totalCount: summary?.totalCount ?? students.length,
                          delayedCount:
                              summary?.delayedCount ??
                              students
                                  .where((student) => student.signals.delayed)
                                  .length,
                          atGateCount:
                              summary?.atGateCount ??
                              students
                                  .where(
                                    (student) =>
                                        student.status ==
                                            DismissalRequestStatus.atGate ||
                                        student.status ==
                                            DismissalRequestStatus.ready,
                                  )
                                  .length,
                        ),
                        AppSpacing.verticalSpaceMd,
                        _WaitingFilters(
                          gates: state.gates?.gates ?? const [],
                          selectedGateId: _selectedGateId,
                          selectedStatus: _selectedStatus,
                          onGateChanged: (gateId) {
                            setState(() => _selectedGateId = gateId);
                            context.read<DismissalCubit>().loadWaiting(
                              gateId: gateId,
                            );
                          },
                          onStatusChanged: (status) {
                            setState(() => _selectedStatus = status);
                          },
                        ),
                        AppSpacing.verticalSpaceLg,
                        _ResultsHeader(
                          count: students.length,
                          isRefreshing: state.isLoadingWaiting,
                        ),
                        AppSpacing.verticalSpaceMd,
                        if (students.isEmpty)
                          const WaitingStudentsEmptyState()
                        else
                          for (final student in students)
                            _WaitingStudentBackendCard(
                              student: student,
                              isProcessing: state.isProcessing,
                              canManage: permissions.has(
                                AppPermission.manageRequests,
                              ),
                              canEscalate: permissions.has(
                                AppPermission.escalateRequests,
                              ),
                              onConfirmArrival: () => context
                                  .read<DismissalCubit>()
                                  .confirmArrival(student.id),
                              onEscalate: () => context
                                  .read<DismissalCubit>()
                                  .escalate(student.id),
                            ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  List<DismissalRequestModel> _filter(List<DismissalRequestModel> students) {
    return students
        .where((student) {
          return _selectedStatus == null || student.status == _selectedStatus;
        })
        .toList(growable: false);
  }
}

class _WaitingFilters extends StatelessWidget {
  const _WaitingFilters({
    required this.gates,
    required this.selectedGateId,
    required this.selectedStatus,
    required this.onGateChanged,
    required this.onStatusChanged,
  });

  final List<DismissalGateModel> gates;
  final String? selectedGateId;
  final DismissalRequestStatus? selectedStatus;
  final ValueChanged<String?> onGateChanged;
  final ValueChanged<DismissalRequestStatus?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const statuses = [
      null,
      DismissalRequestStatus.called,
      DismissalRequestStatus.moving,
      DismissalRequestStatus.atGate,
      DismissalRequestStatus.ready,
    ];

    return Container(
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.all(AppRadius.radius6),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String?>(
            initialValue: selectedGateId,
            isExpanded: true,
            decoration: _decoration(l10n.dismissalGateField),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(l10n.dismissalAllGates),
              ),
              ...gates.map(
                (gate) => DropdownMenuItem<String?>(
                  value: gate.id,
                  child: Text(gate.name),
                ),
              ),
            ],
            onChanged: onGateChanged,
          ),
          AppSpacing.verticalSpaceMd,
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: statuses.length,
              separatorBuilder: (context, index) =>
                  AppSpacing.horizontalSpaceSm,
              itemBuilder: (context, index) {
                final status = statuses[index];
                final isSelected = selectedStatus == status;
                return ChoiceChip(
                  selected: isSelected,
                  onSelected: (_) => onStatusChanged(status),
                  label: Text(
                    status?.localizedLabel(l10n) ?? l10n.dismissalAll,
                  ),
                  labelStyle: AppTypography.labelMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.primaryDeep,
                    fontWeight: FontWeight.w900,
                  ),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceLight,
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.borderLight,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
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
            l10n.dismissalWaitingList,
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
          l10n.dismissalStudentsCount(count),
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _WaitingStudentBackendCard extends StatelessWidget {
  const _WaitingStudentBackendCard({
    required this.student,
    required this.isProcessing,
    required this.canManage,
    required this.canEscalate,
    required this.onConfirmArrival,
    required this.onEscalate,
  });

  final DismissalRequestModel student;
  final bool isProcessing;
  final bool canManage;
  final bool canEscalate;
  final VoidCallback onConfirmArrival;
  final VoidCallback onEscalate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canConfirm =
        student.status == DismissalRequestStatus.called ||
        student.status == DismissalRequestStatus.moving;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.all(AppRadius.radius6),
        border: Border.all(
          color: student.signals.delayed
              ? AppColors.warning.withValues(alpha: 0.3)
              : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDeep.withValues(alpha: 0.05),
            blurRadius: 16,
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.09),
                  borderRadius: AppRadius.all(AppRadius.radius4),
                ),
                child: const Icon(Iconsax.user, color: AppColors.primary),
              ),
              AppSpacing.horizontalSpaceMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.child.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primaryDeep,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      student.child.classLabel,
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
              _StatusChip(status: student.status),
            ],
          ),
          AppSpacing.verticalSpaceMd,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _InfoChip(icon: Iconsax.location_tick, text: student.gate.name),
              _InfoChip(
                icon: Iconsax.clock,
                text: l10n.dismissalWaitMinutes(student.waitMinutes),
                color: student.signals.delayed
                    ? AppColors.error
                    : AppColors.primary,
              ),
              _InfoChip(
                icon: Iconsax.profile_2user,
                text: student.requester.displayName,
              ),
            ],
          ),
          AppSpacing.verticalSpaceMd,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  height: 40,
                  text: canConfirm
                      ? l10n.dismissalConfirmArrival
                      : l10n.dismissalArrivalConfirmed,
                  onPressed: canConfirm && canManage && !isProcessing
                      ? onConfirmArrival
                      : null,
                  suffix: Icon(
                    canConfirm ? Iconsax.location_tick : Iconsax.tick_circle,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              AppSpacing.horizontalSpaceSm,
              OutlinedButton.icon(
                onPressed: isProcessing || !canEscalate ? null : onEscalate,
                icon: const Icon(Iconsax.warning_2, size: 17),
                label: Text(l10n.dismissalEscalate),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(88, 40),
                  foregroundColor: AppColors.error,
                  side: BorderSide(
                    color: AppColors.error.withValues(alpha: 0.26),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final DismissalRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = switch (status) {
      DismissalRequestStatus.ready => AppColors.success,
      DismissalRequestStatus.atGate => AppColors.primaryLight,
      DismissalRequestStatus.moving => AppColors.secondary,
      DismissalRequestStatus.called => AppColors.warning,
      _ => AppColors.primary,
    };

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
        status.localizedLabel(l10n),
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.text,
    this.color = AppColors.primary,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            text.trim().isEmpty ? l10n.dismissalUnknownValue : text,
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
