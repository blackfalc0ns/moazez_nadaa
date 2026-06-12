import 'package:flutter/material.dart';
import 'package:ndaaa_chat/core/theme/app_typography.dart';
import 'package:ndaaa_chat/core/theme/app_spacing.dart';
import 'package:ndaaa_chat/core/theme/app_radius.dart';

class CustomDialogButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isDestructive;
  final bool isLoading;

  const CustomDialogButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isDestructive = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? 
          (isDestructive ? const Color.fromARGB(255, 179, 68, 79) : Colors.grey[100]),
        foregroundColor: textColor ?? 
          (isDestructive ? Colors.white : Colors.black87),
        elevation: 0,
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.buttonRadius,
        ),
      ),
      child: isLoading 
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              text,
              style: AppTypography.labelLarge.copyWith(
                color: textColor ?? (isDestructive ? Colors.white : Colors.black87),
              ),
            ),
    );
  }
} 