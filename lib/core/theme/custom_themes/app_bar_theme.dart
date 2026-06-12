import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Custom AppBar theme configuration
class CustomAppBarTheme {
  CustomAppBarTheme._();

  static AppBarTheme get lightTheme => const AppBarTheme(
    backgroundColor: AppColors.surfaceLight,
    foregroundColor: AppColors.onSurfaceLight,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColors.onSurfaceLight,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: AppColors.onSurfaceLight),
    actionsIconTheme: IconThemeData(color: AppColors.onSurfaceLight),
  );

  static AppBarTheme get darkTheme => const AppBarTheme(
    backgroundColor: AppColors.surfaceDark,
    foregroundColor: AppColors.onSurfaceDark,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColors.onSurfaceDark,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: AppColors.onSurfaceDark),
    actionsIconTheme: IconThemeData(color: AppColors.onSurfaceDark),
  );

  // Helper for app bar with custom background
  static AppBar withBackground({
    required BuildContext context,
    String? title,
    Widget? leading,
    List<Widget>? actions,
    bool showBackButton = true,
    Color? backgroundColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: backgroundColor ?? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
      leading: showBackButton && leading == null
          ? IconButton(
              icon: Icon(isDark ? Icons.arrow_back : Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )
          : leading,
      title: title != null ? Text(title) : null,
      actions: actions,
      elevation: 0,
      centerTitle: true,
    );
  }
}