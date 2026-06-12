class StaffProfile {
  const StaffProfile({
    required this.name,
    required this.role,
    required this.employeeId,
    required this.schoolName,
    required this.primaryGate,
    required this.currentShift,
    required this.phone,
    required this.email,
    required this.permissions,
    required this.todayStats,
    required this.safetyChecks,
  });

  final String name;
  final String role;
  final String employeeId;
  final String schoolName;
  final String primaryGate;
  final String currentShift;
  final String phone;
  final String email;
  final List<String> permissions;
  final ProfileStats todayStats;
  final List<String> safetyChecks;
}

class ProfileStats {
  const ProfileStats({
    required this.handledCalls,
    required this.deliveredStudents,
    required this.escalatedCalls,
    required this.averageWaitMinutes,
  });

  final int handledCalls;
  final int deliveredStudents;
  final int escalatedCalls;
  final int averageWaitMinutes;
}
