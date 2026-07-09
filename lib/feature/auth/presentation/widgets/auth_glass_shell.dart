import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Auth Glass Shell with Core Design System
///
/// Features:
/// - ✅ AppTypography for all text
/// - ✅ AppSpacing for all spacing
/// - ✅ AppRadius for all border radius
/// - ✅ AppShadows for shadows
/// - ✅ AppColors for all colors
class AuthGlassShell extends StatelessWidget {
  const AuthGlassShell({
    super.key,
    required this.backgroundImagePath,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBackButton = false,
    this.centerContent = false,
  });

  final String backgroundImagePath;
  final String title;
  final String subtitle;
  final Widget child;
  final bool showBackButton;
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(backgroundImagePath, fit: BoxFit.cover),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.20),
                    AppColors.primaryDeep.withValues(alpha: 0.20),
                    Colors.black.withValues(alpha: 0.10),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Stack(
              children: [
                // Back Button
                if (showBackButton)
                  Positioned(
                    top: AppSpacing.md,
                    right: AppSpacing.lg,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const _TopActionShell(
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                // Main Content
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      centerContent
                          ? AppSpacing.lg
                          : mediaQuery.size.height * 0.28,
                      AppSpacing.lg,
                      mediaQuery.padding.bottom + AppSpacing.lg,
                    ),
                    child: Align(
                      alignment: centerContent
                          ? Alignment.center
                          : Alignment.bottomCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 560,
                          minHeight: centerContent
                              ? 0
                              : mediaQuery.size.height * 0.50,
                        ),
                        child: _AuthGlassCard(
                          title: title,
                          subtitle: subtitle,
                          centerContent: centerContent,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Auth Glass Card with glassmorphism effect
class _AuthGlassCard extends StatelessWidget {
  const _AuthGlassCard({
    required this.title,
    required this.subtitle,
    required this.child,
    required this.centerContent,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.radiusXXL + 4), // 36
      child: Stack(
        children: [
          // Blur Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: const SizedBox.expand(),
            ),
          ),

          // Glass Background
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.50),
                border: Border.all(color: Colors.white.withValues(alpha: 0.68)),
                borderRadius: BorderRadius.circular(
                  AppRadius.radiusXXL + 4,
                ), // 36
                boxShadow: AppShadows.xl,
              ),
            ),
          ),

          // Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg + AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
                AppSpacing.verticalSpaceMd,

                // Divider
                Divider(
                  color: AppColors.grey.withValues(alpha: 0.2),
                  thickness: 1,
                ),
                AppSpacing.verticalSpaceLg,

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.heading3.copyWith(
                    color: AppColors.primaryDeep,
                  ),
                ),
                AppSpacing.verticalSpaceXs,

                // Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: centerContent ? AppSpacing.md : 0,
                  ),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
                AppSpacing.verticalSpaceLg,

                // Child Content
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Top Action Button Shell (Back Button)
class _TopActionShell extends StatelessWidget {
  const _TopActionShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.radiusL),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(AppRadius.radiusL),
            border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
