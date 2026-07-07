import '../models/dismissal_models.dart';

class DismissalMapper {
  const DismissalMapper._();

  static DismissalQueuePageModel queuePageFromJson(Map<String, dynamic> json) {
    final pagination = mapFrom(json, 'pagination');
    return DismissalQueuePageModel(
      requests: listFrom(
        json,
        'data',
      ).map((item) => requestFromJson(mapCast(item))).toList(growable: false),
      summary: queueSummaryFromJson(mapFrom(json, 'summary')),
      page: intFrom(pagination, 'page', defaultValue: 1),
      limit: intFrom(pagination, 'limit', defaultValue: 20),
      totalPages: intFrom(pagination, 'totalPages', defaultValue: 1),
    );
  }

  static DismissalGatesPageModel gatesPageFromJson(Map<String, dynamic> json) {
    final summary = mapFrom(json, 'summary');
    final gates =
        listFrom(
            json,
            'data',
          ).map((item) => gateFromJson(mapCast(item))).toList(growable: false)
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return DismissalGatesPageModel(
      gates: gates,
      totalCount: intFrom(summary, 'totalCount', defaultValue: gates.length),
      openCount: intFrom(summary, 'openCount'),
      busyCount: intFrom(summary, 'busyCount'),
      closedCount: intFrom(summary, 'closedCount'),
      maintenanceCount: intFrom(summary, 'maintenanceCount'),
      activeCount: intFrom(summary, 'activeCount'),
    );
  }

  static DismissalRequestModel requestFromJson(Map<String, dynamic> json) {
    final child = mapFrom(json, 'child');
    final gate = mapFrom(json, 'gate');
    final requester = mapFrom(json, 'requester');
    return DismissalRequestModel(
      id: stringFrom(json, 'id'),
      status: statusFromString(stringFrom(json, 'status')),
      requestedAt: stringFrom(json, 'requestedAt'),
      updatedAt: stringFrom(json, 'updatedAt'),
      waitMinutes: intFrom(json, 'waitMinutes'),
      signals: signalsFromJson(mapFrom(json, 'signals')),
      child: childFromJson(child),
      gate: gateFromJson(gate),
      requester: DismissalRequesterModel(
        displayName: firstNonEmpty([
          stringFrom(requester, 'displayName'),
          stringFrom(requester, 'name'),
        ]),
      ),
      previousStatus: nullableStringFrom(json, 'previousStatus') == null
          ? null
          : statusFromString(stringFrom(json, 'previousStatus')),
      changed: boolNullableFrom(json, 'changed'),
    );
  }

  static DismissalChildModel childFromJson(Map<String, dynamic> json) {
    return DismissalChildModel(
      id: stringFrom(json, 'id'),
      displayName: firstNonEmpty([
        stringFrom(json, 'displayName'),
        stringFrom(json, 'name'),
      ]),
      grade: stringFrom(json, 'grade'),
      section: stringFrom(json, 'section'),
      classroom: stringFrom(json, 'classroom'),
    );
  }

  static DismissalGateModel gateFromJson(Map<String, dynamic> json) {
    final location = mapFrom(json, 'location');
    return DismissalGateModel(
      id: stringFrom(json, 'id'),
      code: stringFrom(json, 'code'),
      name: firstNonEmpty([
        stringFrom(json, 'name'),
        stringFrom(json, 'label'),
      ]),
      campus: nullableStringFrom(json, 'campus'),
      status: firstNonEmpty([stringFrom(json, 'status'), 'closed']),
      isActive: boolFrom(json, 'isActive', defaultValue: true),
      sortOrder: intFrom(json, 'sortOrder'),
      waitingZones: stringListFrom(json, 'waitingZones'),
      notes: nullableStringFrom(json, 'notes'),
      latitude: doubleNullableFrom(location, 'latitude'),
      longitude: doubleNullableFrom(location, 'longitude'),
    );
  }

  static DismissalSignalsModel signalsFromJson(Map<String, dynamic> json) {
    return DismissalSignalsModel(
      delayed: boolFrom(json, 'delayed'),
      urgent: boolFrom(json, 'urgent'),
      delayThresholdMinutes: intFrom(json, 'delayThresholdMinutes'),
      urgentThresholdMinutes: intFrom(json, 'urgentThresholdMinutes'),
    );
  }

  static DismissalQueueSummaryModel queueSummaryFromJson(
    Map<String, dynamic> json,
  ) {
    return DismissalQueueSummaryModel(
      totalCount: intFrom(json, 'totalCount'),
      requestedCount: intFrom(json, 'requestedCount'),
      queuedCount: intFrom(json, 'queuedCount'),
      calledCount: intFrom(json, 'calledCount'),
      movingCount: intFrom(json, 'movingCount'),
      atGateCount: intFrom(json, 'atGateCount'),
      readyCount: intFrom(json, 'readyCount'),
      delayedCount: intFrom(json, 'delayedCount'),
      urgentCount: intFrom(json, 'urgentCount'),
    );
  }

  static DismissalRecipientsModel recipientsFromJson(
    Map<String, dynamic> json,
  ) {
    final policy = mapFrom(json, 'policy');
    return DismissalRecipientsModel(
      request: requestFromJson(mapFrom(json, 'request')),
      recipients: listFrom(json, 'recipients')
          .map((item) => pickupRecipientFromJson(mapCast(item)))
          .toList(growable: false),
      delegatePickupAllowed: boolFrom(policy, 'delegatePickupAllowed'),
      pickupCodeRequired: boolFrom(policy, 'pickupCodeRequired'),
    );
  }

  static DismissalPickupRecipientModel pickupRecipientFromJson(
    Map<String, dynamic> json,
  ) {
    return DismissalPickupRecipientModel(
      pickupRecipientToken: stringFrom(json, 'pickupRecipientToken'),
      displayName: firstNonEmpty([
        stringFrom(json, 'displayName'),
        stringFrom(json, 'name'),
      ]),
      relation: stringFrom(json, 'relation'),
      isRequestingGuardian: boolFrom(json, 'isRequestingGuardian'),
      canPickup: boolFrom(json, 'canPickup'),
      maskedPhone: nullableStringFrom(json, 'maskedPhone'),
    );
  }

  static DismissalDeliveryModel deliveryFromJson(Map<String, dynamic> json) {
    final delivery = mapFrom(json, 'delivery').isEmpty
        ? json
        : mapFrom(json, 'delivery');
    final receiver = mapFrom(delivery, 'receiver');
    return DismissalDeliveryModel(
      id: stringFrom(delivery, 'id'),
      status: statusFromString(stringFrom(delivery, 'status')),
      previousStatus: statusFromString(stringFrom(delivery, 'previousStatus')),
      handedOverAt: stringFrom(delivery, 'handedOverAt'),
      pickupCodeVerified: boolFrom(delivery, 'pickupCodeVerified'),
      pickupRecipientVerified: boolFrom(delivery, 'pickupRecipientVerified'),
      child: childFromJson(mapFrom(delivery, 'child')),
      gate: gateFromJson(mapFrom(delivery, 'gate')),
      receiverName: stringFrom(receiver, 'name'),
      receiverRelation: stringFrom(receiver, 'relation'),
    );
  }

  static DismissalProfileModel profileFromJson(Map<String, dynamic> json) {
    final school = mapFrom(json, 'school');
    final readiness = mapFrom(json, 'readiness');
    final assignments = listFrom(json, 'assignments');
    return DismissalProfileModel(
      displayName: firstNonEmpty([
        stringFrom(json, 'displayName'),
        stringFrom(json, 'name'),
        stringFrom(mapFrom(json, 'user'), 'displayName'),
      ]),
      schoolName: firstNonEmpty([
        stringFrom(school, 'name'),
        stringFrom(json, 'schoolName'),
      ]),
      ready: boolFrom(readiness, 'ready', defaultValue: true),
      assignmentsCount: assignments.length,
      gates: assignments
          .map((item) => stringFrom(mapFrom(mapCast(item), 'gate'), 'name'))
          .where((item) => item.isNotEmpty)
          .toList(growable: false),
    );
  }

  static DismissalNotificationsPageModel notificationsPageFromJson(
    Map<String, dynamic> json,
  ) {
    final pagination = mapFrom(json, 'pagination');
    final summary = mapFrom(json, 'summary');
    final notifications = listFrom(json, 'data')
        .map((item) => notificationFromJson(mapCast(item)))
        .toList(growable: false);
    return DismissalNotificationsPageModel(
      notifications: notifications,
      totalCount: intFrom(
        summary,
        'totalCount',
        defaultValue: notifications.length,
      ),
      unreadCount: intFrom(
        summary,
        'unreadCount',
        defaultValue: notifications.where((item) => !item.isRead).length,
      ),
      criticalCount: intFrom(
        summary,
        'criticalCount',
        defaultValue: notifications.where((item) => item.isCritical).length,
      ),
      page: intFrom(pagination, 'page', defaultValue: 1),
      limit: intFrom(pagination, 'limit', defaultValue: 20),
      totalPages: intFrom(pagination, 'totalPages', defaultValue: 1),
    );
  }

  static DismissalNotificationModel notificationFromJson(
    Map<String, dynamic> json,
  ) {
    final data = mapFrom(json, 'data');
    final readAt = firstNonEmpty([
      stringFrom(json, 'readAt'),
      stringFrom(json, 'read_at'),
    ]);
    return DismissalNotificationModel(
      id: stringFrom(json, 'id'),
      title: firstNonEmpty([
        stringFrom(json, 'title'),
        stringFrom(data, 'title'),
      ]),
      body: firstNonEmpty([
        stringFrom(json, 'body'),
        stringFrom(json, 'message'),
        stringFrom(data, 'body'),
        stringFrom(data, 'message'),
      ]),
      type: firstNonEmpty([
        stringFrom(json, 'type'),
        stringFrom(data, 'type'),
        stringFrom(json, 'notificationType'),
      ]),
      priority: firstNonEmpty([
        stringFrom(json, 'priority'),
        stringFrom(data, 'priority'),
        'normal',
      ]),
      createdAt: firstNonEmpty([
        stringFrom(json, 'createdAt'),
        stringFrom(json, 'created_at'),
      ]),
      isRead:
          boolFrom(json, 'isRead') ||
          boolFrom(json, 'read') ||
          readAt.isNotEmpty ||
          stringFrom(json, 'status').toLowerCase() == 'read',
      requestId:
          nullableStringFrom(data, 'requestId') ??
          nullableStringFrom(json, 'requestId'),
      childName:
          nullableStringFrom(data, 'childName') ??
          nullableStringFrom(json, 'childName'),
      gateName:
          nullableStringFrom(data, 'gateName') ??
          nullableStringFrom(json, 'gateName'),
    );
  }

  static DismissalRequestStatus statusFromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'requested':
        return DismissalRequestStatus.requested;
      case 'queued':
        return DismissalRequestStatus.queued;
      case 'called':
        return DismissalRequestStatus.called;
      case 'moving':
        return DismissalRequestStatus.moving;
      case 'at_gate':
      case 'atgate':
        return DismissalRequestStatus.atGate;
      case 'ready':
        return DismissalRequestStatus.ready;
      case 'handed_over':
      case 'handedover':
        return DismissalRequestStatus.handedOver;
      case 'cancelled':
      case 'canceled':
        return DismissalRequestStatus.cancelled;
      case 'expired':
        return DismissalRequestStatus.expired;
      default:
        return DismissalRequestStatus.unknown;
    }
  }

  static Map<String, dynamic> extractMap(dynamic raw) {
    final map = mapCast(raw);
    if (map['data'] is Map) return mapCast(map['data']);
    return map;
  }

  static Map<String, dynamic> mapCast(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  static Map<String, dynamic> mapFrom(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  static List<dynamic> listFrom(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is List) return List<dynamic>.from(value);
    return const [];
  }

  static String stringFrom(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return '';
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      for (final key in const ['displayName', 'name', 'title', 'label', 'id']) {
        final inner = map[key];
        if (inner != null) return stringFrom(map, key);
      }
    }
    return '';
  }

  static String? nullableStringFrom(Map<String, dynamic> json, String key) {
    final value = stringFrom(json, key).trim();
    return value.isEmpty ? null : value;
  }

  static int intFrom(
    Map<String, dynamic> json,
    String key, {
    int defaultValue = 0,
  }) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? defaultValue;
  }

  static double? doubleNullableFrom(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  static bool boolFrom(
    Map<String, dynamic> json,
    String key, {
    bool defaultValue = false,
  }) {
    final value = json[key];
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }
    return defaultValue;
  }

  static bool? boolNullableFrom(Map<String, dynamic> json, String key) {
    if (!json.containsKey(key)) return null;
    return boolFrom(json, key);
  }

  static List<String> stringListFrom(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is List) {
      return value
          .map((item) => stringFrom({'value': item}, 'value'))
          .where((item) => item.trim().isNotEmpty)
          .toList(growable: false);
    }
    return const [];
  }

  static String firstNonEmpty(List<String> values) {
    for (final value in values) {
      if (value.trim().isNotEmpty) return value.trim();
    }
    return '';
  }
}

extension DismissalRequestStatusApi on DismissalRequestStatus {
  String get apiValue {
    switch (this) {
      case DismissalRequestStatus.requested:
        return 'requested';
      case DismissalRequestStatus.queued:
        return 'queued';
      case DismissalRequestStatus.called:
        return 'called';
      case DismissalRequestStatus.moving:
        return 'moving';
      case DismissalRequestStatus.atGate:
        return 'at_gate';
      case DismissalRequestStatus.ready:
        return 'ready';
      case DismissalRequestStatus.handedOver:
        return 'handed_over';
      case DismissalRequestStatus.cancelled:
        return 'cancelled';
      case DismissalRequestStatus.expired:
        return 'expired';
      case DismissalRequestStatus.unknown:
        return 'unknown';
    }
  }
}
