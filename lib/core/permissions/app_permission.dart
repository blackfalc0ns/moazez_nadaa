enum AppPermission {
  viewProfile,
  viewGates,
  viewRequests,
  manageRequests,
  deliverRequests,
  escalateRequests,
  viewHistory,
  viewNotifications,
  manageNotifications,
  manageDeviceTokens,
}

extension AppPermissionKey on AppPermission {
  String get key {
    switch (this) {
      case AppPermission.viewProfile:
        return 'dismissal.profile.view';
      case AppPermission.viewGates:
        return 'dismissal.gates.view';
      case AppPermission.viewRequests:
        return 'dismissal.requests.view';
      case AppPermission.manageRequests:
        return 'dismissal.requests.manage';
      case AppPermission.deliverRequests:
        return 'dismissal.requests.deliver';
      case AppPermission.escalateRequests:
        return 'dismissal.requests.escalate';
      case AppPermission.viewHistory:
        return 'dismissal.requests.history.view';
      case AppPermission.viewNotifications:
        return 'dismissal.notifications.view';
      case AppPermission.manageNotifications:
        return 'dismissal.notifications.manage';
      case AppPermission.manageDeviceTokens:
        return 'app.device_tokens.manage';
    }
  }
}
