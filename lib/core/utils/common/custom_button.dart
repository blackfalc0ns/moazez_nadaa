import 'package:flutter/material.dart';
import 'package:ndaaa_chat/core/theme/app_colors.dart';
import 'package:ndaaa_chat/core/theme/app_typography.dart';
import 'package:ndaaa_chat/core/widgets/logo_shimmer_loader.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final Widget? prefix;
  final Widget? suffix;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            (backgroundColor ?? AppColors.primary).withValues(alpha: 0.9),
            backgroundColor ?? AppColors.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: _buildButtonChild(),
      ),
    );
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return const LogoShimmerLoader(size: 28);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefix != null) ...[prefix!, const SizedBox(width: 4)],
        Text(
          text,
          style: AppTypography.button.copyWith(
            color: textColor ?? Colors.white,
          ),
        ),
        if (suffix != null) ...[const SizedBox(width: 4), suffix!],
      ],
    );
  }
}
