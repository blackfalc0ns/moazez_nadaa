import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Custom Button theme configuration
class CustomButtonTheme {
  CustomButtonTheme._();

  // Primary button style
  static ButtonStyle primaryStyle({
    double height = 48,
    double horizontalPadding = 24,
    double borderRadius = 12,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.primary,
      elevation: 2,
      minimumSize: Size(0, height),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  // Secondary/outlined button style
  static ButtonStyle secondaryStyle({
    double height = 48,
    double horizontalPadding = 24,
    double borderRadius = 12,
  }) {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary, width: 1.5),
      minimumSize: Size(0, height),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  // Text button style
  static ButtonStyle textStyle({
    double height = 48,
    double horizontalPadding = 16,
  }) {
    return TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      minimumSize: Size(0, height),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  // Danger button style
  static ButtonStyle dangerStyle({
    double height = 48,
    double horizontalPadding = 24,
    double borderRadius = 12,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.error,
      foregroundColor: AppColors.onError,
      elevation: 2,
      minimumSize: Size(0, height),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  // Success button style
  static ButtonStyle successStyle({
    double height = 48,
    double horizontalPadding = 24,
    double borderRadius = 12,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.success,
      foregroundColor: Colors.white,
      elevation: 2,
      minimumSize: Size(0, height),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  // Icon button style
  static ButtonStyle iconStyle({
    double size = 48,
    double iconSize = 24,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: iconColor ?? AppColors.primary,
      elevation: 2,
      minimumSize: Size(size, size),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}
