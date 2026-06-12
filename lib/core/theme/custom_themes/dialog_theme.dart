import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_radius.dart';

/// Custom Dialog theme configuration
class CustomDialogTheme {
  CustomDialogTheme._();

  static DialogTheme get lightTheme => DialogTheme(
    backgroundColor: AppColors.surfaceLight,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusL)),
    ),
    titleTextStyle: const TextStyle(
      color: AppColors.onSurfaceLight,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    contentTextStyle: const TextStyle(
      color: AppColors.textSecondaryLight,
      fontSize: 16,
    ),
    actionsPadding: const EdgeInsets.all(16),
  );

  static DialogTheme get darkTheme => DialogTheme(
    backgroundColor: AppColors.surfaceDark,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusL)),
    ),
    titleTextStyle: const TextStyle(
      color: AppColors.onSurfaceDark,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    contentTextStyle: const TextStyle(
      color: AppColors.textSecondaryDark,
      fontSize: 16,
    ),
    actionsPadding: const EdgeInsets.all(16),
  );

  // Helper to show confirmation dialog
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: AppColors.error)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  // Helper to show error dialog
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}