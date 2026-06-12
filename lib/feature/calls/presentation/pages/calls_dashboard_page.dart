import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/calls_dummy_data.dart';
import '../../data/models/pickup_request.dart';
import '../widgets/calls_header.dart';
import '../widgets/calls_summary_strip.dart';
import '../widgets/pickup_request_card.dart';

class CallsDashboardPage extends StatefulWidget {
  const CallsDashboardPage({super.key});

  @override
  State<CallsDashboardPage> createState() => _CallsDashboardPageState();
}

class _CallsDashboardPageState extends State<CallsDashboardPage> {
  final TextEditingController _searchController = TextEditingController();

  final String _selectedStage = 'الكل';
  final PickupStatus? _selectedStatus = null;
  final String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PickupRequest> get _filteredRequests {
    return CallsDummyData.requests
        .where((request) {
          final matchesStage =
              _selectedStage == 'الكل' || request.stage == _selectedStage;
          final matchesStatus =
              _selectedStatus == null || request.status == _selectedStatus;
          final query = _searchQuery.trim();
          final matchesSearch =
              query.isEmpty ||
              request.studentName.contains(query) ||
              request.guardianName.contains(query) ||
              request.pickupCode.contains(query) ||
              request.classLabel.contains(query);

          return matchesStage && matchesStatus && matchesSearch;
        })
        .toList(growable: false);
  }

  int _countByStatus(PickupStatus status) {
    return CallsDummyData.requests
        .where((request) => request.status == status)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = CallsDummyData.requests
        .where((request) => request.status != PickupStatus.delivered)
        .length;
    final urgentCount = CallsDummyData.requests
        .where((request) => request.priority == PickupPriority.urgent)
        .length;
    final filteredRequests = _filteredRequests;

    return CustomScrollView(
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
              CallsHeader(activeCount: activeCount, urgentCount: urgentCount),
              AppSpacing.verticalSpaceXl,
              CallsSummaryStrip(
                newCount: _countByStatus(PickupStatus.newRequest),
                preparingCount: _countByStatus(PickupStatus.preparing),
                readyCount: _countByStatus(PickupStatus.ready),
                delayedCount: _countByStatus(PickupStatus.delayed),
              ),
              // CallsFilterBar(
              //   searchController: _searchController,
              //   selectedStage: _selectedStage,
              //   selectedStatus: _selectedStatus,
              //   stages: CallsDummyData.stages,
              //   onStageChanged: (stage) {
              //     setState(() => _selectedStage = stage);
              //   },
              //   onStatusChanged: (status) {
              //     setState(() => _selectedStatus = status);
              //   },
              //   onSearchChanged: (query) {
              //     setState(() => _searchQuery = query);
              //   },
              // ),
              AppSpacing.verticalSpaceXl,
              _QueueHeader(count: filteredRequests.length),
              AppSpacing.verticalSpaceMd,
              if (filteredRequests.isEmpty)
                const _EmptyRequestsState()
              else
                for (final request in filteredRequests)
                  PickupRequestCard(request: request),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ],
    );
  }
}

class _QueueHeader extends StatelessWidget {
  const _QueueHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'قائمة النداءات',
            style: AppTypography.heading5.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          '$count طلب',
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
    return Container(
      padding: AppSpacing.allXl,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Text(
            'لا توجد طلبات مطابقة',
            style: AppTypography.heading5.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.verticalSpaceSm,
          Text(
            'جرّب تغيير الفلاتر أو البحث باسم آخر.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
