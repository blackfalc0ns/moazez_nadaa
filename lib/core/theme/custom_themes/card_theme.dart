import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_radius.dart';
import '../app_shadows.dart';

/// Custom Card theme configuration
class CustomCardTheme {
  CustomCardTheme._();

  static CardThemeData get lightTheme => CardThemeData(
    color: AppColors.surfaceLight,
    elevation: 2,
    shadowColor: Colors.black.withValues(alpha:0.1),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.cardRadius,
    ),
    margin: EdgeInsets.zero,
  );

  static CardThemeData get darkTheme => CardThemeData(
    color: AppColors.surfaceDark,
    elevation: 2,
    shadowColor: Colors.black.withValues(alpha:0.2),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.cardRadius,
    ),
    margin: EdgeInsets.zero,
  );

  // Elevated card variant
  static CardThemeData elevated({bool isDark = false}) => CardThemeData(
    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
    elevation: 4,
    shadowColor: Colors.black.withValues(alpha:isDark ? 0.3 : 0.15),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.cardRadius,
    ),
  );

  // Outlined card variant
  static CardThemeData outlined({bool isDark = false}) => CardThemeData(
    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.cardRadius,
      side: BorderSide(
        color: isDark ? AppColors.borderDark : AppColors.borderLight,
        width: 1,
      ),
    ),
  );

  // Decoration helpers
  static BoxDecoration decoration({
    bool isDark = false,
    bool elevated = false,
    bool outlined = false,
    EdgeInsets? padding,
  }) {
    if (outlined) {
      return BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      );
    }

    return BoxDecoration(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      borderRadius: AppRadius.cardRadius,
      boxShadow: elevated ? AppShadows.lg : AppShadows.card,
    );
  }
}