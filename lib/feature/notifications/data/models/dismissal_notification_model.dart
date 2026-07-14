enum DismissalNotificationDeepLinkType { dismissalRequest }

class DismissalNotificationDeepLink {
  const DismissalNotificationDeepLink({required this.type, this.requestId});

  final DismissalNotificationDeepLinkType type;
  final String? requestId;
}

class DismissalNotificationModel {
  const DismissalNotificationModel({
    required this.id,
    required this.type,
    required this.sourceModule,
    required this.title,
    required this.body,
    required this.priority,
    required this.status,
    this.sourceId,
    this.readAt,
    this.archivedAt,
    this.createdAt,
    this.deepLink,
  });

  final String id;
  final String type;
  final String sourceModule;
  final String? sourceId;
  final String title;
  final String body;
  final String priority;
  final String status;
  final DateTime? readAt;
  final DateTime? archivedAt;
  final DateTime? createdAt;
  final DismissalNotificationDeepLink? deepLink;

  factory DismissalNotificationModel.reference(String id) {
    return DismissalNotificationModel(
      id: id,
      type: 'notification',
      sourceModule: 'DISMISSAL',
      title: '',
      body: '',
      priority: 'normal',
      status: 'unread',
    );
  }

  bool get isRead => readAt != null || status.toLowerCase() == 'read';

  bool get isArchived =>
      archivedAt != null || status.toLowerCase() == 'archived';

  bool get isHighPriority {
    final value = priority.toLowerCase();
    return value == 'high' || value == 'urgent' || value == 'critical';
  }

  bool get isAnnouncement =>
      type.startsWith('request_') || sourceModule.toUpperCase() == 'DISMISSAL';

  bool get isMessage => false;

  DismissalNotificationModel markRead() {
    return DismissalNotificationModel(
      id: id,
      type: type,
      sourceModule: sourceModule,
      title: title,
      body: body,
      priority: priority,
      status: 'read',
      sourceId: sourceId,
      readAt: readAt ?? DateTime.now(),
      archivedAt: archivedAt,
      createdAt: createdAt,
      deepLink: deepLink,
    );
  }
}

class DismissalNotificationsSummary {
  const DismissalNotificationsSummary({
    required this.unreadCount,
    required this.totalCount,
    required this.archivedCount,
    required this.highPriorityCount,
  });

  final int unreadCount;
  final int totalCount;
  final int archivedCount;
  final int highPriorityCount;

  static const empty = DismissalNotificationsSummary(
    unreadCount: 0,
    totalCount: 0,
    archivedCount: 0,
    highPriorityCount: 0,
  );
}
