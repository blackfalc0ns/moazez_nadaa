enum AppPermission { viewMessages, manageCalls, viewProfile }

extension AppPermissionKey on AppPermission {
  /// Primary API permission string that maps to this enum value.
  /// Used for caching and reverse lookup.
  String get key {
    switch (this) {
      case AppPermission.viewMessages:
        return 'communication.messages.view';
      case AppPermission.manageCalls:
        return 'pickup.calls.manage';
      case AppPermission.viewProfile:
        return 'profile.read';
    }
  }
}
