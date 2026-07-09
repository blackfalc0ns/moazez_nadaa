import 'package:flutter/material.dart';

class GlobalNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get currentContext => navigatorKey.currentContext;

  static void navigateToLogin() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login', // Match Routes.login
      (route) => false,
    );
  }
}
