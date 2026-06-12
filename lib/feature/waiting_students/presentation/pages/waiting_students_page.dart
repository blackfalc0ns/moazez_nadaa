import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/common/custom_app_bar.dart';
import '../../data/models/waiting_student.dart';
import '../../data/waiting_students_dummy_data.dart';
import '../widgets/waiting_student_card.dart';
import '../widgets/waiting_students_empty_state.dart';
import '../widgets/waiting_students_filters.dart';
import '../widgets/waiting_students_summary.dart';

class WaitingStudentsPage extends StatefulWidget {
  const WaitingStudentsPage({super.key});

  @override
  State<WaitingStudentsPage> createState() => _WaitingStudentsPageState();
}

class _WaitingStudentsPageState extends State<WaitingStudentsPage> {
  String _stage = 'الكل';
  String _gate = 'الكل';
  String _zone = 'الكل';
  WaitingStudentStatus? _status;

  List<WaitingStudent> get _filteredStudents {
    return WaitingStudentsDummyData.students.where(_matchesFilters).toList();
  }

  @override
  Widget build(BuildContext context) {
    final students = _filteredStudents;
    final delayedCount = _countByStatus(students, WaitingStudentStatus.delayed);
    final atGateCount = _countByStatus(students, WaitingStudentStatus.atGate);

    return Scaffold(
      appBar: const CustomAppBar(title: 'الطلاب المنتظرون'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          WaitingStudentsSummary(
            totalCount: students.length,
            delayedCount: delayedCount,
            atGateCount: atGateCount,
          ),
          AppSpacing.verticalSpaceMd,
          WaitingStudentsFilters(
            stage: _stage,
            gate: _gate,
            zone: _zone,
            status: _status,
            onStageChanged: (value) => setState(() => _stage = value),
            onGateChanged: (value) => setState(() => _gate = value),
            onZoneChanged: (value) => setState(() => _zone = value),
            onStatusChanged: (value) => setState(() => _status = value),
            onReset: _resetFilters,
          ),
          AppSpacing.verticalSpaceLg,
          _ResultsHeader(count: students.length),
          AppSpacing.verticalSpaceMd,
          if (students.isEmpty)
            const WaitingStudentsEmptyState()
          else
            for (final student in students)
              WaitingStudentCard(student: student),
        ],
      ),
    );
  }

  bool _matchesFilters(WaitingStudent student) {
    final matchesStage = _stage == 'الكل' || student.stage == _stage;
    final matchesGate = _gate == 'الكل' || student.gate == _gate;
    final matchesZone = _zone == 'الكل' || student.waitingZone == _zone;
    final matchesStatus = _status == null || student.status == _status;

    return matchesStage && matchesGate && matchesZone && matchesStatus;
  }

  int _countByStatus(
    List<WaitingStudent> students,
    WaitingStudentStatus status,
  ) {
    return students.where((student) => student.status == status).length;
  }

  void _resetFilters() {
    setState(() {
      _stage = 'الكل';
      _gate = 'الكل';
      _zone = 'الكل';
      _status = null;
    });
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'قائمة الانتظار',
            style: AppTypography.heading5.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          '$count طالب',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
