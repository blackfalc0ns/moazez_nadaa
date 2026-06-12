import 'package:flutter/material.dart';

import '../../../feature/authorized_guardians/presentation/pages/authorized_guardians_page.dart';
import '../../../feature/calls/presentation/pages/calls_history_page.dart';
import '../../../feature/gates_duties/presentation/pages/gates_duties_page.dart';
import '../../../feature/main/presentation/pages/main_navigation_page.dart';
import '../../../feature/messages/presentation/pages/chat_details_screen.dart';
import '../../../feature/notifications/presentation/pages/notifications_page.dart';
import '../../../feature/onboarding/presentation/pages/onboarding_page.dart';
import '../../../feature/profile/presentation/pages/profile_page.dart';
import '../../../feature/settings/presentation/pages/settings_page.dart';
import '../../../feature/splash/presentation/pages/splash_screen.dart';
import '../../../feature/waiting_students/presentation/pages/waiting_students_page.dart';

class Routes {
  static const String root = '/';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String chatDetails = '/chat-details';
  static const String callsHistory = '/calls-history';
  static const String gatesDuties = '/gates-duties';
  static const String waitingStudents = '/waiting-students';
  static const String profile = '/profile';
  static const String authorizedGuardians = '/authorized-guardians';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
}

class OnGeneratedRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
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
      case Routes.chatDetails:
        final args = settings.arguments;
        final chatArgs = args is Map ? args : const <String, Object?>{};
        return MaterialPageRoute<void>(
          builder: (_) => ChatDetailsScreen(
            peerName: chatArgs['peerName'] as String? ?? 'محادثة',
            peerAvatarUrl: chatArgs['peerAvatarUrl'] as String?,
          ),
          settings: settings,
        );
      case Routes.callsHistory:
        return MaterialPageRoute<void>(
          builder: (_) => const CallsHistoryPage(),
          settings: settings,
        );
      case Routes.gatesDuties:
        return MaterialPageRoute<void>(
          builder: (_) => const GatesDutiesPage(),
          settings: settings,
        );
      case Routes.waitingStudents:
        return MaterialPageRoute<void>(
          builder: (_) => const WaitingStudentsPage(),
          settings: settings,
        );
      case Routes.profile:
        return MaterialPageRoute<void>(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );
      case Routes.authorizedGuardians:
        return MaterialPageRoute<void>(
          builder: (_) => const AuthorizedGuardiansPage(),
          settings: settings,
        );
      case Routes.notifications:
        return MaterialPageRoute<void>(
          builder: (_) => const NotificationsPage(),
          settings: settings,
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
}
