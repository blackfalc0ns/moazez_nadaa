import 'package:flutter/material.dart';

enum AppNotificationType { urgentCall, delayedPickup, delivered, gate, system }

enum AppNotificationPriority { normal, high, critical }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    required this.priority,
    required this.isRead,
    required this.relatedStudent,
    required this.gate,
    required this.actionLabel,
  });

  final String id;
  final String title;
  final String body;
  final String time;
  final AppNotificationType type;
  final AppNotificationPriority priority;
  final bool isRead;
  final String relatedStudent;
  final String gate;
  final String actionLabel;
}

extension AppNotificationTypeLabel on AppNotificationType {
  String get label {
    switch (this) {
      case AppNotificationType.urgentCall:
        return 'نداء عاجل';
      case AppNotificationType.delayedPickup:
        return 'تأخير';
      case AppNotificationType.delivered:
        return 'تسليم';
      case AppNotificationType.gate:
        return 'بوابة';
      case AppNotificationType.system:
        return 'نظام';
    }
  }

  Color get color {
    switch (this) {
      case AppNotificationType.urgentCall:
        return const Color(0xFFF44336);
      case AppNotificationType.delayedPickup:
        return const Color(0xFFF59E0B);
      case AppNotificationType.delivered:
        return const Color(0xFF10B981);
      case AppNotificationType.gate:
        return const Color(0xFF2196F3);
      case AppNotificationType.system:
        return const Color(0xFF006D82);
    }
  }
}

extension AppNotificationPriorityLabel on AppNotificationPriority {
  String get label {
    switch (this) {
      case AppNotificationPriority.normal:
        return 'عادي';
      case AppNotificationPriority.high:
        return 'مهم';
      case AppNotificationPriority.critical:
        return 'حرج';
    }
  }
}
