import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

/// SnackBar service for showing snackbars
class SnackBarService {
  static final SnackBarService _instance = SnackBarService._();
  static SnackBarService get instance => _instance;

  SnackBarService._();

  /// Show success snackbar
  static void showSuccess(String message, {Duration? duration}) {
    _show(
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle,
    );
  }

  /// Show error snackbar
  static void showError(String message, {Duration? duration}) {
    _show(
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  /// Show info snackbar
  static void showInfo(String message, {Duration? duration}) {
    _show(
      message: message,
      backgroundColor: AppColors.info,
      icon: Icons.info_outline,
    );
  }

  /// Show warning snackbar
  static void showWarning(String message, {Duration? duration}) {
    _show(
      message: message,
      backgroundColor: AppColors.warning,
      icon: Icons.warning_amber,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  static void _show({
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final context = _getContext();
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusS))),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static BuildContext? _getContext() {
    // This would be handled by getting the context from a key or using a global key
    return null;
  }
}

/// Extension for showing snackbars on BuildContext
extension SnackBarExtension on BuildContext {
  void showSnackBarSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusS))),
      ),
    );
  }

  void showSnackBarError(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusS))),
      ),
    );
  }
}