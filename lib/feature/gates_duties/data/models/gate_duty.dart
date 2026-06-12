import 'package:flutter/material.dart';

enum GateOperationalStatus { open, busy, closed, maintenance }

enum ShiftType { morning, dismissal, evening }

class GateDuty {
  const GateDuty({
    required this.id,
    required this.name,
    required this.campus,
    required this.status,
    required this.activeRequests,
    required this.averageWaitMinutes,
    required this.supervisor,
    required this.securityOfficer,
    required this.radioChannel,
    required this.allowedStages,
    required this.currentShift,
    required this.nextShift,
    required this.notes,
  });

  final String id;
  final String name;
  final String campus;
  final GateOperationalStatus status;
  final int activeRequests;
  final int averageWaitMinutes;
  final String supervisor;
  final String securityOfficer;
  final String radioChannel;
  final List<String> allowedStages;
  final DutyShift currentShift;
  final DutyShift nextShift;
  final List<String> notes;
}

class DutyShift {
  const DutyShift({
    required this.title,
    required this.type,
    required this.timeRange,
    required this.leadName,
    required this.team,
    required this.zone,
    required this.tasks,
  });

  final String title;
  final ShiftType type;
  final String timeRange;
  final String leadName;
  final List<String> team;
  final String zone;
  final List<String> tasks;
}

extension GateOperationalStatusLabel on GateOperationalStatus {
  String get label {
    switch (this) {
      case GateOperationalStatus.open:
        return 'مفتوحة';
      case GateOperationalStatus.busy:
        return 'ضغط مرتفع';
      case GateOperationalStatus.closed:
        return 'مغلقة';
      case GateOperationalStatus.maintenance:
        return 'صيانة';
    }
  }

  Color get color {
    switch (this) {
      case GateOperationalStatus.open:
        return const Color(0xFF10B981);
      case GateOperationalStatus.busy:
        return const Color(0xFFF59E0B);
      case GateOperationalStatus.closed:
        return const Color(0xFF64748B);
      case GateOperationalStatus.maintenance:
        return const Color(0xFFEF4444);
    }
  }
}

extension ShiftTypeLabel on ShiftType {
  String get label {
    switch (this) {
      case ShiftType.morning:
        return 'صباحية';
      case ShiftType.dismissal:
        return 'خروج';
      case ShiftType.evening:
        return 'مسائية';
    }
  }
}
