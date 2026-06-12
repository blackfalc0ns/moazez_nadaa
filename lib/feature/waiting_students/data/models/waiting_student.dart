import 'package:flutter/material.dart';

enum WaitingStudentStatus { called, moving, atGate, delayed }

enum WaitingStudentPriority { normal, urgent }

class WaitingStudent {
  const WaitingStudent({
    required this.id,
    required this.studentName,
    required this.guardianName,
    required this.guardianRelation,
    required this.grade,
    required this.section,
    required this.stage,
    required this.campus,
    required this.gate,
    required this.waitingZone,
    required this.calledAt,
    required this.waitingMinutes,
    required this.pickupCode,
    required this.guardianPhone,
    required this.assignedTo,
    required this.status,
    required this.priority,
    required this.note,
  });

  final String id;
  final String studentName;
  final String guardianName;
  final String guardianRelation;
  final String grade;
  final String section;
  final String stage;
  final String campus;
  final String gate;
  final String waitingZone;
  final String calledAt;
  final int waitingMinutes;
  final String pickupCode;
  final String guardianPhone;
  final String assignedTo;
  final WaitingStudentStatus status;
  final WaitingStudentPriority priority;
  final String note;

  String get classLabel => '$grade - $section';
}

extension WaitingStudentStatusLabel on WaitingStudentStatus {
  String get label {
    switch (this) {
      case WaitingStudentStatus.called:
        return 'تم الاستدعاء';
      case WaitingStudentStatus.moving:
        return 'في الطريق';
      case WaitingStudentStatus.atGate:
        return 'عند البوابة';
      case WaitingStudentStatus.delayed:
        return 'متأخر';
    }
  }

  Color get color {
    switch (this) {
      case WaitingStudentStatus.called:
        return const Color(0xFF006D82);
      case WaitingStudentStatus.moving:
        return const Color(0xFF2196F3);
      case WaitingStudentStatus.atGate:
        return const Color(0xFF10B981);
      case WaitingStudentStatus.delayed:
        return const Color(0xFFF44336);
    }
  }
}
