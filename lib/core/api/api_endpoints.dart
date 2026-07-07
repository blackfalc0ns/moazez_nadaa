class ApiEndpoints {
  const ApiEndpoints._();

  // Authentication
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String changePassword = '/auth/change-password';

  // Shared files
  static const String uploadFile = '/files';

  // Dismissal staff
  static const String dismissalProfile = '/dismissal/profile';
  static const String dismissalGates = '/dismissal/gates';
  static const String dismissalActiveRequests = '/dismissal/requests/active';
  static const String dismissalWaitingStudents = '/dismissal/waiting-students';
  static const String dismissalRequestHistory = '/dismissal/requests/history';
  static const String dismissalNotifications = '/dismissal/notifications';
  static const String dismissalNotificationsReadAll =
      '/dismissal/notifications/read-all';
  static const String dismissalNotificationDeviceTokens =
      '/dismissal/notifications/device-tokens';
  static const String dismissalNotificationCurrentDeviceToken =
      '/dismissal/notifications/device-tokens/current';

  static String dismissalRequest(String requestId) =>
      '/dismissal/requests/$requestId';

  static String dismissalRequestStatus(String requestId) =>
      '/dismissal/requests/$requestId/status';

  static String dismissalWaitingStudentArrival(String requestId) =>
      '/dismissal/waiting-students/$requestId/arrival';

  static String dismissalPickupRecipients(String requestId) =>
      '/dismissal/requests/$requestId/pickup-recipients';

  static String dismissalDeliver(String requestId) =>
      '/dismissal/requests/$requestId/deliver';

  static String dismissalEscalate(String requestId) =>
      '/dismissal/requests/$requestId/escalate';

  static String dismissalHistoryRequest(String requestId) =>
      '/dismissal/requests/history/$requestId';

  static String dismissalNotificationRead(String notificationId) =>
      '/dismissal/notifications/$notificationId/read';
}
