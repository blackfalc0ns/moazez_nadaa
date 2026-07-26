import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../di/injection_container.dart';
import '../localization/app_locale_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class DrawerLanguageSelector extends StatelessWidget {
  const DrawerLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = sl<AppLocaleController>();
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final selected = controller.languageCode;
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LangButton(
                label: 'عربي',
                assetPath: 'assets/images/Ar_suadi.svg',
                isSelected: selected == 'ar',
                onTap: () => controller.setLocale(const Locale('ar')),
              ),
              const SizedBox(width: 4),
              _LangButton(
                label: 'EN',
                assetPath: 'assets/images/En_england.svg',
                isSelected: selected == 'en',
                onTap: () => controller.setLocale(const Locale('en')),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LangButton extends StatelessWidget {
  const _LangButton({
    required this.label,
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSelected ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.05 : 0.95,
              duration: const Duration(milliseconds: 250),
              child: SvgPicture.asset(
                assetPath,
                width: 16,
                height: 16,
              ),
            ),
            const SizedBox(width: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: AppTypography.labelSmall.copyWith(
                color: isSelected ? AppColors.primaryDeep : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
