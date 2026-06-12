import 'package:flutter/material.dart';

enum GuardianTrustStatus { verified, temporary, reviewNeeded, suspended }

class AuthorizedGuardian {
  const AuthorizedGuardian({
    required this.id,
    required this.name,
    required this.relation,
    required this.nationalIdMasked,
    required this.phone,
    required this.allowedGate,
    required this.allowedStudents,
    required this.status,
    required this.lastVerifiedAt,
    required this.expiryLabel,
    required this.notes,
  });

  final String id;
  final String name;
  final String relation;
  final String nationalIdMasked;
  final String phone;
  final String allowedGate;
  final List<String> allowedStudents;
  final GuardianTrustStatus status;
  final String lastVerifiedAt;
  final String expiryLabel;
  final String notes;
}

extension GuardianTrustStatusLabel on GuardianTrustStatus {
  String get label {
    switch (this) {
      case GuardianTrustStatus.verified:
        return 'معتمد';
      case GuardianTrustStatus.temporary:
        return 'تصريح مؤقت';
      case GuardianTrustStatus.reviewNeeded:
        return 'يحتاج مراجعة';
      case GuardianTrustStatus.suspended:
        return 'موقوف';
    }
  }

  Color get color {
    switch (this) {
      case GuardianTrustStatus.verified:
        return const Color(0xFF10B981);
      case GuardianTrustStatus.temporary:
        return const Color(0xFF2196F3);
      case GuardianTrustStatus.reviewNeeded:
        return const Color(0xFFF59E0B);
      case GuardianTrustStatus.suspended:
        return const Color(0xFFF44336);
    }
  }
}
