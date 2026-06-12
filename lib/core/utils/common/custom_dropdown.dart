import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

/// Custom dropdown widget
class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final String? label;
  final String? hint;
  final String? errorText;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isExpanded;

  const CustomDropdown({
    super.key,
    this.value,
    this.items,
    this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBackgroundDark : AppColors.inputBackgroundLight,
            borderRadius: AppRadius.inputRadius,
            border: Border.all(
              color: errorText != null
                  ? AppColors.error
                  : isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<T>(
                value: value,
                items: items,
                onChanged: enabled ? onChanged : null,
                isExpanded: isExpanded,
                hint: hint != null ? Text(hint!) : null,
                icon: suffixIcon ?? const Icon(Icons.keyboard_arrow_down),
                dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                borderRadius: AppRadius.inputRadius,
                style: TextStyle(
                  color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.error,
                ),
          ),
        ],
      ],
    );
  }
}