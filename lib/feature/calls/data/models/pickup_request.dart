enum PickupStatus { newRequest, preparing, ready, delivered, delayed }

enum PickupPriority { normal, urgent }

class PickupRequest {
  const PickupRequest({
    required this.id,
    required this.studentName,
    required this.guardianName,
    required this.guardianRelation,
    required this.grade,
    required this.section,
    required this.stage,
    required this.campus,
    required this.gate,
    required this.requestedAt,
    required this.status,
    required this.priority,
    required this.waitingMinutes,
    required this.guardianPhone,
    required this.pickupCode,
    required this.note,
    required this.assignedTo,
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
  final String requestedAt;
  final PickupStatus status;
  final PickupPriority priority;
  final int waitingMinutes;
  final String guardianPhone;
  final String pickupCode;
  final String note;
  final String assignedTo;

  String get classLabel => '$grade - $section';
}

extension PickupStatusLabel on PickupStatus {
  String get label {
    switch (this) {
      case PickupStatus.newRequest:
        return 'جديد';
      case PickupStatus.preparing:
        return 'قيد التجهيز';
      case PickupStatus.ready:
        return 'جاهز للتسليم';
      case PickupStatus.delivered:
        return 'تم التسليم';
      case PickupStatus.delayed:
        return 'متأخر';
    }
  }

  String get actionLabel {
    switch (this) {
      case PickupStatus.newRequest:
        return 'استدعاء الطالب';
      case PickupStatus.preparing:
        return 'تأكيد الوصول';
      case PickupStatus.ready:
        return 'تأكيد التسليم';
      case PickupStatus.delivered:
        return 'عرض التفاصيل';
      case PickupStatus.delayed:
        return 'تصعيد للمشرف';
    }
  }
}
