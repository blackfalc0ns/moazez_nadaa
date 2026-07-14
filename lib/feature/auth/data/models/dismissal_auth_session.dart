class DismissalAuthSession {
  const DismissalAuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.userType,
    required this.userId,
    required this.displayName,
    required this.status,
    required this.permissions,
    this.mustChangePassword = false,
  });

  final String accessToken;
  final String refreshToken;
  final String userType;
  final String userId;
  final String displayName;
  final String status;
  final List<String> permissions;
  final bool mustChangePassword;

  bool get isDismissalStaff =>
      userType.trim().toUpperCase() == 'DISMISSAL_STAFF';

  bool get isActive =>
      status.isEmpty || status.trim().toUpperCase() == 'ACTIVE';

  DismissalAuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    String? userType,
    String? userId,
    String? displayName,
    String? status,
    List<String>? permissions,
    bool? mustChangePassword,
  }) {
    return DismissalAuthSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userType: userType ?? this.userType,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
      permissions: permissions ?? this.permissions,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
    );
  }
}
