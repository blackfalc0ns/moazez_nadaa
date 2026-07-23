import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ndaaa_chat/core/responsive/responsive.dart';
import 'package:ndaaa_chat/core/theme/app_colors.dart';
import 'package:ndaaa_chat/core/theme/app_radius.dart';
import 'package:ndaaa_chat/core/theme/app_shadows.dart';
import 'package:ndaaa_chat/core/theme/app_spacing.dart';
import 'package:ndaaa_chat/core/theme/app_typography.dart';

class OnboardingGlassCard extends StatelessWidget {
  const OnboardingGlassCard({
    super.key,
    required this.description,
    required this.currentIndex,
    required this.totalCount,
    required this.onNext,
  });

  final String description;
  final int currentIndex;
  final int totalCount;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isLast = currentIndex == totalCount - 1;
    final horizontalPadding = responsive.isNarrowPhone
        ? AppSpacing.md
        : responsive.adaptive(compact: AppSpacing.lg, medium: AppSpacing.xl);
    final verticalPadding = responsive.isShort ? AppSpacing.md : AppSpacing.lg;
    final actionSize = responsive.isShort || responsive.isNarrowPhone
        ? 48.0
        : 54.0;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(AppRadius.radiusXXL + 2),
      topRight: Radius.circular(AppRadius.radiusXXL + 2),
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            verticalPadding,
            horizontalPadding,
            responsive.viewPadding.bottom + verticalPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
            boxShadow: AppShadows.xl,
          ),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    primary: false,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: AppTypography.heading4.copyWith(
                        color: AppColors.primaryDeep,
                        fontSize: responsive.fontSize(
                          responsive.isShort ? 17 : 20,
                        ),
                        fontWeight: FontWeight.bold,
                        height: 1.45,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: responsive.isShort ? AppSpacing.sm : AppSpacing.md,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(totalCount, (index) {
                        final isActive = index == currentIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsetsDirectional.only(end: 7),
                          width: isActive
                              ? (responsive.isNarrowPhone ? 22 : 28)
                              : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.secondary
                                : AppColors.textSecondaryLight.withValues(
                                    alpha: 0.35,
                                  ),
                            borderRadius: BorderRadius.circular(
                              AppRadius.radiusFull,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Semantics(
                    button: true,
                    child: InkWell(
                      onTap: onNext,
                      borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                      child: Container(
                        width: actionSize,
                        height: actionSize,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isLast
                              ? Icons.check_rounded
                              : Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: responsive.isShort ? 23 : 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
