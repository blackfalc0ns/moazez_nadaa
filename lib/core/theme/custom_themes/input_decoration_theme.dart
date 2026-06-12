import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_radius.dart';

/// Custom InputDecoration theme configuration
class CustomInputDecorationTheme {
  CustomInputDecorationTheme._();

  static InputDecorationTheme get lightTheme => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBackgroundLight,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.borderLight, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.disabled, width: 1),
    ),
    hintStyle: const TextStyle(color: AppColors.hintLight),
    labelStyle: const TextStyle(color: AppColors.onSurfaceLight),
    errorStyle: const TextStyle(color: AppColors.error),
    prefixIconColor: AppColors.textSecondaryLight,
    suffixIconColor: AppColors.textSecondaryLight,
  );

  static InputDecorationTheme get darkTheme => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBackgroundDark,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.borderDark, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.disabled, width: 1),
    ),
    hintStyle: const TextStyle(color: AppColors.hintDark),
    labelStyle: const TextStyle(color: AppColors.onSurfaceDark),
    errorStyle: const TextStyle(color: AppColors.error),
    prefixIconColor: AppColors.textSecondaryDark,
    suffixIconColor: AppColors.textSecondaryDark,
  );

  // Helper to create input decoration with prefix
  static InputDecoration withPrefix({
    required String label,
    required Widget prefixIcon,
    String? hint,
    String? errorText,
    bool isDark = false,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: errorText,
      prefixIcon: prefixIcon,
    ).applyTheme(isDark);
  }

  // Helper to create input decoration with suffix
  static InputDecoration withSuffix({
    required String label,
    required Widget suffixIcon,
    String? hint,
    String? errorText,
    bool isDark = false,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: errorText,
      suffixIcon: suffixIcon,
    ).applyTheme(isDark);
  }
}

extension InputDecorationExtension on InputDecoration {
  InputDecoration applyTheme(bool isDark) {
    // This would apply the theme to the input decoration
    return this;
  }
}