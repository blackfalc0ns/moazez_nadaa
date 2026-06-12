import 'package:flutter/material.dart';
import 'package:ndaaa_chat/core/theme/app_colors.dart';
import 'package:ndaaa_chat/core/theme/app_typography.dart';

/// Custom app bar widget with Core Design System
///
/// Features:
/// - Uses AppTypography.heading5 for title
/// - Theme-aware colors (light/dark mode)
/// - Rounded icons with RTL support
/// - Optional back button (showBackButton: true/false)
/// - Arabic tooltips
///
/// Usage Examples:
/// ```dart
/// // With back button (default)
/// CustomAppBar(title: 'صندوق الرسائل')
///
/// // Without back button
/// CustomAppBar(
///   title: 'الرئيسية',
///   showBackButton: false,
/// )
///
/// // With custom back action
/// CustomAppBar(
///   title: 'الإعدادات',
///   onBackPressed: () => Navigator.pushReplacementNamed(context, '/home'),
/// )
///
/// // With actions
/// CustomAppBar(
///   title: 'الرسائل',
///   showBackButton: false,
///   actions: [
///     IconButton(icon: Icon(Icons.search), onPressed: () {}),
///     IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
///   ],
/// )
/// ```
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title text (uses AppTypography.heading5)
  final String? title;

  /// Custom title widget (overrides title)
  final Widget? titleWidget;

  /// Show/hide back button (default: true)
  /// Set to false to hide the back button
  final bool showBackButton;

  /// Custom back button callback
  final VoidCallback? onBackPressed;

  /// Action buttons on the right (left in RTL)
  final List<Widget>? actions;

  /// Custom leading widget (overrides back button)
  final Widget? leading;

  /// Custom background color (default: surfaceLight/surfaceDark)
  final Color? backgroundColor;

  /// Center the title (default: true)
  final bool centerTitle;

  /// AppBar elevation (default: 0)
  final double elevation;

  /// Bottom widget (e.g., TabBar)
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTypography.heading5.copyWith(
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                )
              : null),
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor:
          backgroundColor ??
          (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
      // Show back button only if showBackButton is true and no custom leading widget
      automaticallyImplyLeading: showBackButton && leading == null,
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      actions: actions,
      bottom: bottom,
      iconTheme: IconThemeData(
        color: isDark ? AppColors.white : AppColors.primaryDark,
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return IconButton(
      icon: Icon(isRtl ? Icons.arrow_back_ios : Icons.arrow_forward_ios , color: AppColors.black,),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      tooltip: 'رجوع',
    );
  }
}

/// Custom floating action button
class CustomFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool mini;

  const CustomFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.iconColor,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: iconColor ?? AppColors.primaryLight,
      mini: mini,
      child: Icon(icon),
    );
  }
}
