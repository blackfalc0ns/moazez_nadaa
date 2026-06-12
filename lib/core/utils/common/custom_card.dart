import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';

/// Custom card widget
class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool elevated;
  final bool outlined;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.elevated = false,
    this.outlined = false,
    this.backgroundColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ?? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);

    BoxDecoration decoration;
    if (outlined) {
      decoration = BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      );
    } else if (elevated) {
      decoration = BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.lg,
      );
    } else {
      decoration = BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
      );
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.cardRadius,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}