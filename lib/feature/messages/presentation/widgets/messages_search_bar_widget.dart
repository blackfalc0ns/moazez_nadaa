import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessagesSearchBarWidget extends StatelessWidget {
  const MessagesSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ابحث هنا',
          hintStyle: AppTypography.bodyMedium.copyWith(color: Colors.grey[400]),
          prefixIcon: Padding(
            padding: AppSpacing.allMd,
            child: SvgPicture.asset(
              'assets/icons/search-normal.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          suffixIcon: Icon(
            size: 20,
            Icons.mic_none_rounded,
            color: Colors.grey[400],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
