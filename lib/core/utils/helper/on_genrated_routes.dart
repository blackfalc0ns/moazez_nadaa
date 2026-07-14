import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../feature/auth/presentation/pages/dismissal_login_page.dart';
import '../../../feature/auth/presentation/pages/dismissal_change_password_page.dart';
import '../../../feature/calls/presentation/pages/calls_history_page.dart';
import '../../../feature/calls/presentation/pages/dismissal_request_details_page.dart';
import '../../../feature/gates_duties/presentation/pages/gates_duties_page.dart';
import '../../../feature/main/presentation/pages/main_navigation_page.dart';
import '../../../feature/notifications/presentation/pages/dismissal_notifications_screen.dart';
import '../../../feature/onboarding/presentation/pages/onboarding_page.dart';
import '../../../feature/profile/presentation/pages/profile_page.dart';
import '../../../feature/settings/presentation/pages/settings_page.dart';
import '../../../feature/splash/presentation/pages/splash_screen.dart';
import '../../../feature/waiting_students/presentation/pages/waiting_students_page.dart';
import '../../di/injection_container.dart';
import '../../permissions/app_permission.dart';
import '../../permissions/permission_denied_page.dart';
import '../../permissions/permission_repository.dart';

class Routes {
  static const String root = '/';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String changePassword = '/change-password';
  static const String callsHistory = '/calls-history';
  static const String requestDetails = '/request-details';
  static const String gatesDuties = '/gates-duties';
  static const String waitingStudents = '/waiting-students';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
}

class OnGeneratedRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (_shouldForcePasswordChange(settings.name)) {
      return MaterialPageRoute<void>(
        builder: (_) => const DismissalChangePasswordPage(mandatory: true),
        settings: settings,
      );
    }

    switch (settings.name) {
      case Routes.root:
        return MaterialPageRoute<void>(
          builder: (_) => const MainNavigationPage(),
          settings: settings,
        );
      case Routes.splash:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case Routes.onboarding:
        return MaterialPageRoute<void>(
          builder: (_) => const OnboardingPage(),
          settings: settings,
        );
      case Routes.login:
        return MaterialPageRoute<void>(
          builder: (_) => const DismissalLoginPage(),
          settings: settings,
        );
      case Routes.changePassword:
        final arguments = settings.arguments;
        final data = arguments is Map
            ? Map<String, dynamic>.from(arguments)
            : const <String, dynamic>{};
        return MaterialPageRoute<void>(
          builder: (_) => DismissalChangePasswordPage(
            mandatory: data['mandatory'] == true || _mustChangePassword(),
          ),
          settings: settings,
        );
      case Routes.callsHistory:
        return _protectedRoute(
          settings,
          AppPermission.viewHistory,
          const CallsHistoryPage(),
        );
      case Routes.requestDetails:
        final arguments = settings.arguments;
        final data = arguments is Map
            ? Map<String, dynamic>.from(arguments)
            : const <String, dynamic>{};
        final requestId = data['requestId']?.toString() ?? '';
        final fromHistory = data['fromHistory'] == true;
        return _protectedRoute(
          settings,
          fromHistory ? AppPermission.viewHistory : AppPermission.viewRequests,
          DismissalRequestDetailsPage(
            requestId: requestId,
            fromHistory: fromHistory,
          ),
        );
      case Routes.gatesDuties:
        return _protectedRoute(
          settings,
          AppPermission.viewGates,
          const GatesDutiesPage(),
        );
      case Routes.waitingStudents:
        return _protectedRoute(
          settings,
          AppPermission.viewRequests,
          const WaitingStudentsPage(),
        );
      case Routes.profile:
        return _protectedRoute(
          settings,
          AppPermission.viewProfile,
          const ProfilePage(),
        );
      case Routes.notifications:
        return _protectedRoute(
          settings,
          AppPermission.viewNotifications,
          const DismissalNotificationsScreen(),
        );
      case Routes.settings:
        return MaterialPageRoute<void>(
          builder: (_) => const SettingsPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: SizedBox.shrink()),
          settings: settings,
        );
    }
  }

  static Route<void> _protectedRoute(
    RouteSettings settings,
    AppPermission permission,
    Widget page,
  ) {
    final allowed =
        sl.isRegistered<PermissionRepository>() &&
        sl<PermissionRepository>().has(permission);
    return MaterialPageRoute<void>(
      builder: (_) => allowed ? page : const PermissionDeniedPage(),
      settings: settings,
    );
  }

  static bool _shouldForcePasswordChange(String? routeName) {
    if (!_mustChangePassword()) return false;
    return switch (routeName) {
      Routes.splash ||
      Routes.onboarding ||
      Routes.login ||
      Routes.changePassword => false,
      _ => true,
    };
  }

  static bool _mustChangePassword() {
    if (!sl.isRegistered<SharedPreferences>()) return false;
    final raw = sl<SharedPreferences>().getString(StorageKeys.userData);
    if (raw == null || raw.isEmpty) return false;
    try {
      final json = jsonDecode(raw);
      if (json is! Map) return false;
      return json['mustChangePassword'] == true ||
          json['must_change_password'] == true;
    } catch (_) {
      return false;
    }
  }
}
