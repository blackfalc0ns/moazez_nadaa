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
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../../../../core/widgets/logo_shimmer_loader.dart';
import '../../../../generated/app_localizations.dart';
import '../../../dismissal/data/models/dismissal_models.dart';
import '../../../dismissal/presentation/cubits/dismissal_cubit.dart';
import '../../../dismissal/presentation/cubits/dismissal_state.dart';
import '../../../dismissal/presentation/localization/dismissal_localizations.dart';
import '../widgets/calls_history_empty_state.dart';

class CallsHistoryPage extends StatefulWidget {
  const CallsHistoryPage({super.key});

  @override
  State<CallsHistoryPage> createState() => _CallsHistoryPageState();
}

class _CallsHistoryPageState extends State<CallsHistoryPage> {
  late final DismissalCubit _cubit;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _selectedGateId;
  DismissalRequestStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _cubit = sl<DismissalCubit>()
      ..loadGates()
      ..loadHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
          final history = state.history;
          final records = _filter(history?.requests ?? const []);
          final isInitialLoading = state.isLoadingHistory && history == null;

          return Scaffold(
            appBar: CustomAppBar(title: l10n.dismissalCallsHistoryTitle),
            body: isInitialLoading
                ? const Center(child: LogoShimmerLoader(size: 112))
                : RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => context.read<DismissalCubit>().loadHistory(
                      status: _selectedStatus,
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
                        _HistorySummary(records: records),
                        AppSpacing.verticalSpaceMd,
                        _HistorySearchAndFilters(
                          controller: _searchController,
                          gates: state.gates?.gates ?? const [],
                          selectedGateId: _selectedGateId,
                          selectedStatus: _selectedStatus,
                          onSearchChanged: (value) {
                            setState(() => _query = value);
                          },
                          onGateChanged: (gateId) {
                            setState(() => _selectedGateId = gateId);
                            context.read<DismissalCubit>().loadHistory(
                              status: _selectedStatus,
                              gateId: gateId,
                            );
                          },
                          onStatusChanged: (status) {
                            setState(() => _selectedStatus = status);
                            context.read<DismissalCubit>().loadHistory(
                              status: status,
                              gateId: _selectedGateId,
                            );
                          },
                        ),
                        AppSpacing.verticalSpaceLg,
                        _RecordsHeader(
                          count: records.length,
                          isRefreshing: state.isLoadingHistory,
                        ),
                        AppSpacing.verticalSpaceMd,
                        if (records.isEmpty)
                          const CallsHistoryEmptyState()
                        else
                          for (final record in records)
                            _HistoryRecordCard(
                              record: record,
                              onTap: () => Navigator.pushNamed(
                                context,
                                Routes.requestDetails,
                                arguments: {
                                  'requestId': record.id,
                                  'fromHistory': true,
                                },
                              ),
                            ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  List<DismissalRequestModel> _filter(List<DismissalRequestModel> records) {
    final query = _query.trim();
    return records
        .where((record) {
          final matchesSearch =
              query.isEmpty ||
              record.child.displayName.contains(query) ||
              record.requester.displayName.contains(query) ||
              record.gate.name.contains(query) ||
              record.child.classLabel.contains(query) ||
              record.id.contains(query);
          final matchesStatus =
              _selectedStatus == null || record.status == _selectedStatus;
          return matchesSearch && matchesStatus;
        })
        .toList(growable: false);
  }
}

class _HistorySummary extends StatelessWidget {
  const _HistorySummary({required this.records});

  final List<DismissalRequestModel> records;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final delivered = records
        .where((record) => record.status == DismissalRequestStatus.handedOver)
        .length;
    final cancelled = records
        .where((record) => record.status == DismissalRequestStatus.cancelled)
        .length;
    final expired = records
        .where((record) => record.status == DismissalRequestStatus.expired)
        .length;

    return Row(
      children: [
        _SummaryTile(
          icon: Iconsax.shield_tick,
          label: l10n.dismissalDelivered,
          value: '$delivered',
          color: AppColors.success,
        ),
        AppSpacing.horizontalSpaceSm,
        _SummaryTile(
          icon: Iconsax.close_circle,
          label: l10n.dismissalCancelled,
          value: '$cancelled',
          color: AppColors.error,
        ),
        AppSpacing.horizontalSpaceSm,
        _SummaryTile(
          icon: Iconsax.timer_pause,
          label: l10n.dismissalExpired,
          value: '$expired',
          color: AppColors.warning,
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
          ],
        ),
      ),
    );
  }
}

class _HistorySearchAndFilters extends StatelessWidget {
  const _HistorySearchAndFilters({
    required this.controller,
    required this.gates,
    required this.selectedGateId,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onGateChanged,
    required this.onStatusChanged,
  });

  final TextEditingController controller;
  final List<DismissalGateModel> gates;
  final String? selectedGateId;
  final DismissalRequestStatus? selectedStatus;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onGateChanged;
  final ValueChanged<DismissalRequestStatus?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const statuses = [
      null,
      DismissalRequestStatus.handedOver,
      DismissalRequestStatus.cancelled,
      DismissalRequestStatus.expired,
    ];

    return Container(
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.all(AppRadius.radius6),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: l10n.dismissalHistorySearchHint,
              prefixIcon: const Icon(Iconsax.search_normal_1),
              filled: true,
              fillColor: AppColors.surfaceLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          AppSpacing.verticalSpaceMd,
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

class _RecordsHeader extends StatelessWidget {
  const _RecordsHeader({required this.count, required this.isRefreshing});

  final int count;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.dismissalResults,
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
          l10n.dismissalOperationsCount(count),
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _HistoryRecordCard extends StatelessWidget {
  const _HistoryRecordCard({required this.record, required this.onTap});

  final DismissalRequestModel record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusColor = _statusColor(record.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: AppSpacing.allMd,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.all(AppRadius.radius6),
          border: Border.all(color: AppColors.borderLight),
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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: AppRadius.all(AppRadius.radius4),
                  ),
                  child: Icon(Iconsax.receipt_search, color: statusColor),
                ),
                AppSpacing.horizontalSpaceMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.child.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primaryDeep,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        record.child.classLabel,
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
                _StatusBadge(
                  label: record.status.localizedLabel(l10n),
                  color: statusColor,
                ),
              ],
            ),
            AppSpacing.verticalSpaceMd,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _InfoChip(icon: Iconsax.location_tick, text: record.gate.name),
                _InfoChip(
                  icon: Iconsax.profile_2user,
                  text: record.requester.displayName,
                ),
                _InfoChip(
                  icon: Iconsax.clock,
                  text: l10n.dismissalWaitMinutes(record.waitMinutes),
                  color: record.signals.delayed
                      ? AppColors.error
                      : AppColors.primary,
                ),
                _InfoChip(icon: Iconsax.hashtag, text: record.id),
              ],
            ),
            if (record.updatedAt.trim().isNotEmpty) ...[
              AppSpacing.verticalSpaceMd,
              Text(
                l10n.dismissalLastUpdate(record.updatedAt),
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _statusColor(DismissalRequestStatus status) {
    switch (status) {
      case DismissalRequestStatus.handedOver:
        return AppColors.success;
      case DismissalRequestStatus.cancelled:
        return AppColors.error;
      case DismissalRequestStatus.expired:
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
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
