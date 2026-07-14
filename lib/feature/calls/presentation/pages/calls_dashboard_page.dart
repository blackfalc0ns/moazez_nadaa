import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/permissions/app_permission.dart';
import '../../../../core/permissions/permission_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/common/custom_button.dart';
import '../../../../core/utils/feedback/premium_snackbar.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../../../../core/widgets/logo_shimmer_loader.dart';
import '../../../../generated/app_localizations.dart';
import '../../../dismissal/data/models/dismissal_models.dart';
import '../../../dismissal/presentation/cubits/dismissal_cubit.dart';
import '../../../dismissal/presentation/cubits/dismissal_state.dart';
import '../../../dismissal/presentation/localization/dismissal_localizations.dart';
import '../widgets/calls_header.dart';
import '../widgets/calls_summary_strip.dart';
import '../widgets/pickup_request_card.dart';

class CallsDashboardPage extends StatefulWidget {
  const CallsDashboardPage({super.key});

  @override
  State<CallsDashboardPage> createState() => _CallsDashboardPageState();
}

class _CallsDashboardPageState extends State<CallsDashboardPage> {
  late final DismissalCubit _cubit;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  DismissalRequestStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _cubit = sl<DismissalCubit>()..loadDashboard();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
          final queue = state.queue;
          final summary = queue?.summary;
          final requests = _filterRequests(queue?.requests ?? const []);
          final isFirstLoading = state.isLoadingQueue && queue == null;

          if (isFirstLoading) {
            return const Center(child: LogoShimmerLoader(size: 112));
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => context.read<DismissalCubit>().loadDashboard(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  sliver: SliverList.list(
                    children: [
                      CallsHeader(
                        activeCount: summary?.totalCount ?? requests.length,
                        urgentCount:
                            summary?.urgentCount ??
                            requests
                                .where((request) => request.signals.urgent)
                                .length,
                      ),
                      AppSpacing.verticalSpaceXl,
                      CallsSummaryStrip(
                        newCount: summary?.requestedCount ?? 0,
                        preparingCount:
                            (summary?.queuedCount ?? 0) +
                            (summary?.calledCount ?? 0) +
                            (summary?.movingCount ?? 0),
                        readyCount: summary?.readyCount ?? 0,
                        delayedCount: summary?.delayedCount ?? 0,
                      ),
                      AppSpacing.verticalSpaceLg,
                      _SearchAndStatusBar(
                        controller: _searchController,
                        selectedStatus: _selectedStatus,
                        onSearchChanged: (query) {
                          setState(() => _searchQuery = query);
                        },
                        onStatusChanged: (status) {
                          setState(() => _selectedStatus = status);
                          context.read<DismissalCubit>().loadQueue(
                            status: status,
                          );
                        },
                      ),
                      AppSpacing.verticalSpaceLg,
                      _QueueHeader(
                        count: requests.length,
                        isRefreshing: state.isLoadingQueue,
                      ),
                      AppSpacing.verticalSpaceMd,
                      if (requests.isEmpty)
                        const _EmptyRequestsState()
                      else
                        for (final request in requests)
                          PickupRequestCard(
                            request: request,
                            isProcessing: state.isProcessing,
                            canManage: permissions.has(
                              AppPermission.manageRequests,
                            ),
                            canDeliver: permissions.has(
                              AppPermission.deliverRequests,
                            ),
                            canEscalate: permissions.has(
                              AppPermission.escalateRequests,
                            ),
                            onAdvance: (status) {
                              context.read<DismissalCubit>().transitionRequest(
                                requestId: request.id,
                                status: status,
                              );
                            },
                            onDeliver: () => _openDeliverySheet(request),
                            onEscalate: () {
                              context.read<DismissalCubit>().escalate(
                                request.id,
                              );
                            },
                            onDetails: () => Navigator.pushNamed(
                              context,
                              Routes.requestDetails,
                              arguments: {'requestId': request.id},
                            ),
                          ),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<DismissalRequestModel> _filterRequests(
    List<DismissalRequestModel> requests,
  ) {
    final query = _searchQuery.trim();
    return requests
        .where((request) {
          final matchesSearch =
              query.isEmpty ||
              request.child.displayName.contains(query) ||
              request.requester.displayName.contains(query) ||
              request.gate.name.contains(query) ||
              request.child.classLabel.contains(query);
          final matchesStatus =
              _selectedStatus == null || request.status == _selectedStatus;
          return matchesSearch && matchesStatus;
        })
        .toList(growable: false);
  }

  Future<void> _openDeliverySheet(DismissalRequestModel request) async {
    final recipients = await _cubit.loadRecipients(request.id);
    if (!mounted || recipients == null) return;

    final allowedRecipients = recipients.recipients
        .where((recipient) => recipient.canPickup)
        .toList(growable: false);
    if (allowedRecipients.isEmpty) {
      PremiumSnackbar.warning(
        context,
        message: AppLocalizations.of(context)!.dismissalNoAuthorizedRecipient,
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: _cubit,
        child: _DeliverySheet(
          request: request,
          recipients: recipients,
          allowedRecipients: allowedRecipients,
          onDeliver:
              ({
                required String pickupRecipientToken,
                required String pickupCode,
                String? note,
              }) async {
                await _cubit.deliver(
                  requestId: request.id,
                  pickupRecipientToken: pickupRecipientToken,
                  pickupCode: pickupCode,
                  note: note,
                );
              },
        ),
      ),
    );
  }
}

class _SearchAndStatusBar extends StatelessWidget {
  const _SearchAndStatusBar({
    required this.controller,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onStatusChanged,
  });

  final TextEditingController controller;
  final DismissalRequestStatus? selectedStatus;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<DismissalRequestStatus?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const statuses = [
      null,
      DismissalRequestStatus.requested,
      DismissalRequestStatus.queued,
      DismissalRequestStatus.called,
      DismissalRequestStatus.moving,
      DismissalRequestStatus.atGate,
      DismissalRequestStatus.ready,
    ];

    return Column(
      children: [
        TextField(
          controller: controller,
          onChanged: onSearchChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.dismissalSearchHint,
            hintStyle: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            prefixIcon: const Icon(Iconsax.search_normal_1),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        AppSpacing.verticalSpaceMd,
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: statuses.length,
            separatorBuilder: (context, index) => AppSpacing.horizontalSpaceSm,
            itemBuilder: (context, index) {
              final status = statuses[index];
              final isSelected = selectedStatus == status;
              return ChoiceChip(
                selected: isSelected,
                onSelected: (_) => onStatusChanged(status),
                label: Text(status?.localizedLabel(l10n) ?? l10n.dismissalAll),
                labelStyle: AppTypography.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.primaryDeep,
                  fontWeight: FontWeight.w700,
                ),
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.borderLight,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QueueHeader extends StatelessWidget {
  const _QueueHeader({required this.count, required this.isRefreshing});

  final int count;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.dismissalQueueTitle,
            style: AppTypography.heading5.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (isRefreshing) ...[
          const SizedBox(
            width: 18,
            height: 18,
            child: LogoShimmerLoader(size: 18),
          ),
          AppSpacing.horizontalSpaceSm,
        ],
        Text(
          l10n.dismissalRequestsCount(count),
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _EmptyRequestsState extends StatelessWidget {
  const _EmptyRequestsState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: AppSpacing.allXl,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          const Icon(
            Iconsax.direct_notification,
            color: AppColors.primary,
            size: 34,
          ),
          AppSpacing.verticalSpaceSm,
          Text(
            l10n.dismissalNoActiveRequests,
            style: AppTypography.heading6.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.verticalSpaceSm,
          Text(
            l10n.dismissalNoActiveRequestsBody,
            textAlign: TextAlign.center,

            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliverySheet extends StatefulWidget {
  const _DeliverySheet({
    required this.request,
    required this.recipients,
    required this.allowedRecipients,
    required this.onDeliver,
  });

  final DismissalRequestModel request;
  final DismissalRecipientsModel recipients;
  final List<DismissalPickupRecipientModel> allowedRecipients;
  final Future<void> Function({
    required String pickupRecipientToken,
    required String pickupCode,
    String? note,
  })
  onDeliver;

  @override
  State<_DeliverySheet> createState() => _DeliverySheetState();
}

class _DeliverySheetState extends State<_DeliverySheet> {
  final TextEditingController _pickupCodeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  late DismissalPickupRecipientModel _recipient;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _recipient = widget.allowedRecipients.first;
  }

  @override
  void dispose() {
    _pickupCodeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.borderLight,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                AppSpacing.verticalSpaceLg,
                Text(
                  l10n.dismissalDeliverStudent(
                    widget.request.child.displayName,
                  ),
                  style: AppTypography.heading5.copyWith(
                    color: AppColors.primaryDeep,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.verticalSpaceXs,
                Text(
                  l10n.dismissalDeliveryInstruction,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.verticalSpaceLg,
                DropdownButtonFormField<DismissalPickupRecipientModel>(
                  initialValue: _recipient,
                  isExpanded: true,
                  decoration: _inputDecoration(
                    l10n.dismissalAuthorizedRecipient,
                  ),
                  items: widget.allowedRecipients
                      .map(
                        (recipient) => DropdownMenuItem(
                          value: recipient,
                          child: Text(
                            '${recipient.displayName} - ${recipient.relation}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _recipient = value);
                    }
                  },
                ),
                AppSpacing.verticalSpaceMd,
                if (widget.recipients.pickupCodeRequired)
                  TextField(
                    controller: _pickupCodeController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(l10n.dismissalPickupCode),
                  ),
                if (widget.recipients.pickupCodeRequired)
                  AppSpacing.verticalSpaceMd,
                TextField(
                  controller: _noteController,
                  minLines: 2,
                  maxLines: 3,
                  decoration: _inputDecoration(l10n.dismissalOptionalNote),
                ),
                AppSpacing.verticalSpaceLg,
                CustomButton(
                  height: 48,
                  text: _isSubmitting
                      ? l10n.dismissalProcessingDelivery
                      : l10n.dismissalConfirmDelivery,
                  onPressed: _isSubmitting ? null : _submit,
                  suffix: const Icon(
                    Iconsax.shield_tick,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }

  Future<void> _submit() async {
    if (widget.recipients.pickupCodeRequired &&
        _pickupCodeController.text.trim().isEmpty) {
      PremiumSnackbar.warning(
        context,
        message: AppLocalizations.of(context)!.dismissalPickupCodeRequired,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await widget.onDeliver(
      pickupRecipientToken: _recipient.pickupRecipientToken,
      pickupCode: _pickupCodeController.text,
      note: _noteController.text,
    );
    if (mounted) Navigator.of(context).pop();
  }
}
