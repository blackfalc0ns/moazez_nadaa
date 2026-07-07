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

  bool get isOpen => isActive && status.toLowerCase() == 'open';
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

class DismissalProfileModel {
  const DismissalProfileModel({
    required this.displayName,
    required this.schoolName,
    required this.ready,
    required this.assignmentsCount,
    required this.gates,
  });

  final String displayName;
  final String schoolName;
  final bool ready;
  final int assignmentsCount;
  final List<String> gates;
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
