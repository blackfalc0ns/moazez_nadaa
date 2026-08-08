enum DismissalRequestStatus {
  requested,
  queued,
  called,
  moving,
  atGate,
  ready,
  handedOver,
  cancelled,
  expired,
  unknown,
}

enum DismissalEscalationReason {
  studentNotArrived('student_not_arrived'),
  gateCongestion('gate_congestion'),
  parentWaiting('parent_waiting'),
  safetyConcern('safety_concern'),
  manualFollowUp('manual_follow_up'),
  other('other');

  const DismissalEscalationReason(this.apiValue);

  final String apiValue;
}

class DismissalChildModel {
  const DismissalChildModel({
    required this.id,
    required this.displayName,
    required this.grade,
    required this.section,
    required this.classroom,
  });

  final String id;
  final String displayName;
  final String grade;
  final String section;
  final String classroom;

  String get classLabel {
    final parts = [
      grade,
      section,
      classroom,
    ].where((item) => item.trim().isNotEmpty).toList(growable: false);
    return parts.join(' - ');
  }
}

class DismissalGateModel {
  const DismissalGateModel({
    required this.id,
    required this.code,
    required this.name,
    required this.status,
    required this.isActive,
    required this.sortOrder,
    required this.waitingZones,
    this.campus,
    this.notes,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String code;
  final String name;
  final String status;
  final bool isActive;
  final int sortOrder;
  final List<String> waitingZones;
  final String? campus;
  final String? notes;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isOpen => isActive && status.toLowerCase() == 'open';

  bool get hasValidLocation {
    final lat = latitude;
    final lng = longitude;
    if (lat == null || lng == null) return false;
    return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
  }
}

class DismissalSignalsModel {
  const DismissalSignalsModel({
    required this.delayed,
    required this.urgent,
    required this.delayThresholdMinutes,
    required this.urgentThresholdMinutes,
  });

  final bool delayed;
  final bool urgent;
  final int delayThresholdMinutes;
  final int urgentThresholdMinutes;
}

class DismissalRequesterModel {
  const DismissalRequesterModel({required this.displayName});

  final String displayName;
}

class DismissalRequestModel {
  const DismissalRequestModel({
    required this.id,
    required this.status,
    required this.requestedAt,
    required this.updatedAt,
    required this.waitMinutes,
    required this.signals,
    required this.child,
    required this.gate,
    required this.requester,
    this.previousStatus,
    this.changed,
  });

  final String id;
  final DismissalRequestStatus status;
  final String requestedAt;
  final String updatedAt;
  final int waitMinutes;
  final DismissalSignalsModel signals;
  final DismissalChildModel child;
  final DismissalGateModel gate;
  final DismissalRequesterModel requester;
  final DismissalRequestStatus? previousStatus;
  final bool? changed;

  bool get isWaiting => const {
    DismissalRequestStatus.called,
    DismissalRequestStatus.moving,
    DismissalRequestStatus.atGate,
    DismissalRequestStatus.ready,
  }.contains(status);

  bool get isReady => status == DismissalRequestStatus.ready;
}

class DismissalQueueSummaryModel {
  const DismissalQueueSummaryModel({
    required this.totalCount,
    required this.requestedCount,
    required this.queuedCount,
    required this.calledCount,
    required this.movingCount,
    required this.atGateCount,
    required this.readyCount,
    required this.delayedCount,
    required this.urgentCount,
  });

  final int totalCount;
  final int requestedCount;
  final int queuedCount;
  final int calledCount;
  final int movingCount;
  final int atGateCount;
  final int readyCount;
  final int delayedCount;
  final int urgentCount;
}

class DismissalQueuePageModel {
  const DismissalQueuePageModel({
    required this.requests,
    required this.summary,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  final List<DismissalRequestModel> requests;
  final DismissalQueueSummaryModel summary;
  final int page;
  final int limit;
  final int totalPages;
}

class DismissalGatesPageModel {
  const DismissalGatesPageModel({
    required this.gates,
    required this.totalCount,
    required this.openCount,
    required this.busyCount,
    required this.closedCount,
    required this.maintenanceCount,
    required this.activeCount,
  });

  final List<DismissalGateModel> gates;
  final int totalCount;
  final int openCount;
  final int busyCount;
  final int closedCount;
  final int maintenanceCount;
  final int activeCount;
}

class DismissalPickupRecipientModel {
  const DismissalPickupRecipientModel({
    required this.pickupRecipientToken,
    required this.displayName,
    required this.relation,
    required this.isRequestingGuardian,
    required this.canPickup,
    this.maskedPhone,
  });

  final String pickupRecipientToken;
  final String displayName;
  final String relation;
  final bool isRequestingGuardian;
  final bool canPickup;
  final String? maskedPhone;
}

class DismissalRecipientsModel {
  const DismissalRecipientsModel({
    required this.request,
    required this.recipients,
    required this.delegatePickupAllowed,
    required this.pickupCodeRequired,
  });

  final DismissalRequestModel request;
  final List<DismissalPickupRecipientModel> recipients;
  final bool delegatePickupAllowed;
  final bool pickupCodeRequired;
}

class DismissalDeliveryModel {
  const DismissalDeliveryModel({
    required this.id,
    required this.status,
    required this.previousStatus,
    required this.handedOverAt,
    required this.pickupCodeVerified,
    required this.pickupRecipientVerified,
    required this.child,
    required this.gate,
    required this.receiverName,
    required this.receiverRelation,
  });

  final String id;
  final DismissalRequestStatus status;
  final DismissalRequestStatus previousStatus;
  final String handedOverAt;
  final bool pickupCodeVerified;
  final bool pickupRecipientVerified;
  final DismissalChildModel child;
  final DismissalGateModel gate;
  final String receiverName;
  final String receiverRelation;
}

class DismissalAcademicScopeModel {
  const DismissalAcademicScopeModel({
    required this.stageName,
    required this.gradeName,
    required this.sectionName,
    required this.classroomName,
    required this.isLead,
    this.startsAt,
    this.endsAt,
  });

  final String stageName;
  final String gradeName;
  final String sectionName;
  final String classroomName;
  final bool isLead;
  final DateTime? startsAt;
  final DateTime? endsAt;

  List<String> get labels => [
    stageName,
    gradeName,
    sectionName,
    classroomName,
  ].where((value) => value.trim().isNotEmpty).toList(growable: false);
}

class DismissalProfileModel {
  const DismissalProfileModel({
    required this.displayName,
    required this.userType,
    required this.status,
    required this.schoolName,
    required this.schoolTimezone,
    required this.ready,
    required this.assignmentsCount,
    required this.leadAssignmentsCount,
    required this.activeAssignmentsCount,
    required this.gates,
    required this.academicScopes,
    required this.canViewGates,
    required this.canManageRequests,
    required this.canDeliver,
    required this.canEscalate,
  });

  final String displayName;
  final String userType;
  final String status;
  final String schoolName;
  final String schoolTimezone;
  final bool ready;
  final int assignmentsCount;
  final int leadAssignmentsCount;
  final int activeAssignmentsCount;
  final List<String> gates;
  final List<DismissalAcademicScopeModel> academicScopes;
  final bool canViewGates;
  final bool canManageRequests;
  final bool canDeliver;
  final bool canEscalate;
}

class DismissalNotificationModel {
  const DismissalNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.priority,
    required this.createdAt,
    required this.isRead,
    this.requestId,
    this.childName,
    this.gateName,
  });

  final String id;
  final String title;
  final String body;
  final String type;
  final String priority;
  final String createdAt;
  final bool isRead;
  final String? requestId;
  final String? childName;
  final String? gateName;

  bool get isCritical {
    final normalized = priority.trim().toLowerCase();
    return normalized == 'critical' || normalized == 'urgent';
  }
}

class DismissalNotificationsPageModel {
  const DismissalNotificationsPageModel({
    required this.notifications,
    required this.totalCount,
    required this.unreadCount,
    required this.criticalCount,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  final List<DismissalNotificationModel> notifications;
  final int totalCount;
  final int unreadCount;
  final int criticalCount;
  final int page;
  final int limit;
  final int totalPages;
}
