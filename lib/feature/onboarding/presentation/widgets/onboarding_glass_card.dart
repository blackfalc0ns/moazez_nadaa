import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ndaaa_chat/core/theme/app_colors.dart';
import 'package:ndaaa_chat/core/theme/app_radius.dart';
import 'package:ndaaa_chat/core/theme/app_shadows.dart';
import 'package:ndaaa_chat/core/theme/app_spacing.dart';
import 'package:ndaaa_chat/core/theme/app_typography.dart';

/// Onboarding Glass Card with Core Design System
/// 
/// Features:
/// - ✅ AppTypography for text
/// - ✅ AppSpacing for spacing
/// - ✅ AppRadius for border radius
/// - ✅ AppShadows for shadows
/// - ✅ AppColors for colors
/// - ✅ Animated page indicators
/// - ✅ Glassmorphism effect
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
    final isLast = currentIndex == totalCount - 1;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppRadius.radiusXXL + 2), // 34
        topRight: Radius.circular(AppRadius.radiusXXL + 2), // 34
      ),
      child: Stack(
        children: [
          // Main Container
          Container(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              MediaQuery.of(context).padding.bottom + AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.radiusXXL + 2),
                topRight: Radius.circular(AppRadius.radiusXXL + 2),
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
              boxShadow: AppShadows.xl,
            ),
            child: Column(
              children: [
                AppSpacing.verticalSpaceLg,
                
                // Description Text
                Expanded(
                  child: Center(
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: AppTypography.heading4.copyWith(
                        color: AppColors.primaryDeep,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Bottom Row (Indicators + Next Button)
                Row(
                  children: [
                    // Page Indicators
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(totalCount, (index) {
                          final isActive = index == currentIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.secondary
                                  : AppColors.textSecondaryLight.withValues(
                                      alpha: 0.35,
                                    ),
                              borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                            ),
                          );
                        }),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Next/Finish Button
                    InkWell(
                      onTap: onNext,
                      borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isLast
                              ? Icons.check_rounded
                              : Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Glassmorphism Effect at Top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.radiusXXL + 2),
                topRight: Radius.circular(AppRadius.radiusXXL + 2),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.05),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
