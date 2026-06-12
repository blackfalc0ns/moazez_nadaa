import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class MessagesFiltersWidget extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final Function(int) onFilterSelected;

  const MessagesFiltersWidget({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.horizontalMd,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onFilterSelected(index),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.sm),
              padding: AppSpacing.horizontalLg,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(AppRadius.radius5),
              ),
              alignment: Alignment.center,
              child: Text(
                filters[index],
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.primary : AppColors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
