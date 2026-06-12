import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/common/custom_app_bar.dart';
import '../../data/calls_history_dummy_data.dart';
import '../../data/models/calls_history_record.dart';
import '../../data/models/pickup_request.dart';
import '../widgets/calls_history_empty_state.dart';
import '../widgets/calls_history_filters_panel.dart';
import '../widgets/calls_history_record_card.dart';
import '../widgets/calls_history_search_box.dart';
import '../widgets/calls_history_summary.dart';

class CallsHistoryPage extends StatefulWidget {
  const CallsHistoryPage({super.key});

  @override
  State<CallsHistoryPage> createState() => _CallsHistoryPageState();
}

class _CallsHistoryPageState extends State<CallsHistoryPage> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  DateTime? _selectedDate = CallsHistoryDummyData.today;
  String _stageFilter = 'الكل';
  String _gradeFilter = 'الكل';
  String _sectionFilter = 'الكل';
  String _gateFilter = 'الكل';
  PickupStatus? _statusFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CallsHistoryRecord> get _filteredRecords {
    return CallsHistoryDummyData.records.where(_matchesFilters).toList();
  }

  @override
  Widget build(BuildContext context) {
    final records = _filteredRecords;
    final deliveredCount = _countByStatus(records, PickupStatus.delivered);
    final delayedCount = _countByStatus(records, PickupStatus.delayed);

    return Scaffold(
      appBar: const CustomAppBar(title: 'سجل النداءات'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          CallsHistorySummary(
            totalCount: records.length,
            deliveredCount: deliveredCount,
            delayedCount: delayedCount,
          ),
          AppSpacing.verticalSpaceMd,
          CallsHistorySearchBox(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
          ),
          AppSpacing.verticalSpaceMd,
          CallsHistoryFiltersPanel(
            selectedDate: _selectedDate,
            stageFilter: _stageFilter,
            gradeFilter: _gradeFilter,
            sectionFilter: _sectionFilter,
            gateFilter: _gateFilter,
            statusFilter: _statusFilter,
            onDateChanged: (value) => setState(() => _selectedDate = value),
            onStageChanged: (value) => setState(() => _stageFilter = value),
            onGradeChanged: (value) => setState(() => _gradeFilter = value),
            onSectionChanged: (value) => setState(() => _sectionFilter = value),
            onGateChanged: (value) => setState(() => _gateFilter = value),
            onStatusChanged: (value) => setState(() => _statusFilter = value),
            onReset: _resetFilters,
          ),
          AppSpacing.verticalSpaceLg,
          _RecordsHeader(count: records.length),
          AppSpacing.verticalSpaceMd,
          if (records.isEmpty)
            const CallsHistoryEmptyState()
          else
            for (final record in records)
              CallsHistoryRecordCard(record: record),
        ],
      ),
    );
  }

  bool _matchesFilters(CallsHistoryRecord record) {
    final request = record.request;
    final normalizedQuery = _query.trim();
    final matchesSearch =
        normalizedQuery.isEmpty ||
        request.studentName.contains(normalizedQuery) ||
        request.guardianName.contains(normalizedQuery) ||
        request.pickupCode.contains(normalizedQuery) ||
        request.id.contains(normalizedQuery);
    final matchesDate =
        _selectedDate == null || isSameHistoryDay(record.date, _selectedDate!);
    final matchesStage =
        _stageFilter == 'الكل' || request.stage == _stageFilter;
    final matchesGrade =
        _gradeFilter == 'الكل' || request.grade == _gradeFilter;
    final matchesSection =
        _sectionFilter == 'الكل' || request.section == _sectionFilter;
    final matchesGate = _gateFilter == 'الكل' || request.gate == _gateFilter;
    final matchesStatus =
        _statusFilter == null || request.status == _statusFilter;

    return matchesSearch &&
        matchesDate &&
        matchesStage &&
        matchesGrade &&
        matchesSection &&
        matchesGate &&
        matchesStatus;
  }

  int _countByStatus(List<CallsHistoryRecord> records, PickupStatus status) {
    return records.where((record) => record.request.status == status).length;
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _query = '';
      _selectedDate = CallsHistoryDummyData.today;
      _stageFilter = 'الكل';
      _gradeFilter = 'الكل';
      _sectionFilter = 'الكل';
      _gateFilter = 'الكل';
      _statusFilter = null;
    });
  }
}

class _RecordsHeader extends StatelessWidget {
  const _RecordsHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'النتائج',
            style: AppTypography.heading5.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          '$count عملية',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
