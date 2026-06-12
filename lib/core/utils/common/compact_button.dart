import 'package:flutter/material.dart';
import 'package:ndaaa_chat/core/theme/app_colors.dart';
import 'package:ndaaa_chat/core/theme/app_typography.dart';
import 'package:ndaaa_chat/core/theme/app_spacing.dart';
import 'package:ndaaa_chat/core/theme/app_radius.dart';

class CompactButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final Widget? prefix;
  final Widget? suffix;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const CompactButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.prefix,
    this.suffix,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.primary;
    final effectiveTextColor =
        textColor ?? (isOutlined ? effectiveBackgroundColor : Colors.white);
    final effectiveBorderColor = borderColor ?? effectiveBackgroundColor;

    return SizedBox(
      width: width,
      height: height ?? 36,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: effectiveBorderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.buttonRadius,
                ),
                padding: padding ?? 
                    EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
              ),
              child: _buildButtonChild(effectiveTextColor),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.buttonRadius,
                ),
                padding: padding ?? 
                    EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                elevation: 0,
              ),
              child: _buildButtonChild(effectiveTextColor),
            ),
    );
  }

  Widget _buildButtonChild(Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    final children = <Widget>[];

    if (prefix != null) {
      children.add(prefix!);
      children.add(AppSpacing.horizontalSpaceXs);
    }

    children.add(
      Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          fontSize: fontSize ?? 11,
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (suffix != null) {
      children.add(AppSpacing.horizontalSpaceXs);
      children.add(suffix!);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
