import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_radius.dart';

/// Custom SnackBar theme configuration
class CustomSnackBarTheme {
  CustomSnackBarTheme._();

  static SnackBarThemeData get lightTheme => SnackBarThemeData(
    backgroundColor: AppColors.onSurfaceLight,
    contentTextStyle: const TextStyle(color: AppColors.surfaceLight),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusS)),
    ),
    elevation: 4,
    dismissDirection: DismissDirection.horizontal,
  );

  static SnackBarThemeData get darkTheme => SnackBarThemeData(
    backgroundColor: AppColors.onSurfaceDark,
    contentTextStyle: const TextStyle(color: AppColors.surfaceDark),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusS)),
    ),
    elevation: 4,
    dismissDirection: DismissDirection.horizontal,
  );

  // Predefined snackbar styles
  static SnackBar success({
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: AppColors.success,
      duration: duration,
      action: action,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusS))),
    );
  }

  static SnackBar error({
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: AppColors.error,
      duration: duration,
      action: action,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusS))),
    );
  }

  static SnackBar info({
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: AppColors.info,
      duration: duration,
      action: action,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusS))),
    );
  }

  static SnackBar warning({
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.warning_amber, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: AppColors.warning,
      duration: duration,
      action: action,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusS))),
    );
  }
}