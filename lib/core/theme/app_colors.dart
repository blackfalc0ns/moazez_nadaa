import 'package:flutter/material.dart';

/// Application color palette
/// Centralizes all color definitions for the app
class AppColors {
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFF006D82);
  static const Color primaryLight = Color(0xFF0491AD);
  static const Color primaryDark = Color(0xFF04506E);
  static const Color primaryDeep = Color(0xFF003043);
  static const Color secondary = Color(0xFF13B3B0);
  // Secondary Colors
  static const Color third = Color(0xFFF7A201);
  static const Color primarySecondary =
      secondary; // Alias for backward compatibility

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF0491AD),
      Color(0xFF006D82),
      Color(0xFF04506E),
      Color(0xFF003043),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Secondary colors
  static const Color secondaryLight = Color(0xFF81C784);
  static const Color secondaryDark = Color(0xFF388E3C);
  static const Color onSecondary = Colors.white;
  static const Color white = Colors.white;
  static const Color green = Colors.green;
  // Background colors - Light
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Colors.white;
  static const Color onSurfaceLight = Color(0xFF212121);
  static const Color inputBackgroundLight = Color(0xFFF5F5F5);

  // Background colors - Dark
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color onSurfaceDark = Colors.white;
  static const Color inputBackgroundDark = Color(0xFF2C2C2C);
  static const Color black = Color(0xFF000000);

  // Text colors - Light
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);

  static const Color hintLight = Color(0xFF9E9E9E);

  // Text colors - Dark
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color hintDark = Color(0xFF757575);
  static const Color grey = Colors.grey;
  static const Color lightGrey = Color.fromARGB(155, 207, 207, 207);

  // Border colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);

  // Divider colors
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // Error colors
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorRed = Color(0xFFF44336);
  static const Color onError = Colors.white;

  // Success colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);

  // Warning colors
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);

  // Info colors
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);

  // Additional semantic colors
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Gradient colors
  static const List<Color> successGradient = [
    Color(0xFF4CAF50),
    Color(0xFF81C784),
  ];

  // Status colors
  static const Color online = Color(0xFF4CAF50);
  static const Color offline = Color(0xFF9E9E9E);
  static const Color busy = Color(0xFFF44336);
  static const Color away = Color(0xFFFF9800);

  // Rating colors
  static const Color starFilled = Color(0xFFFFC107);
  static const Color starEmpty = Color(0xFFE0E0E0);
}
