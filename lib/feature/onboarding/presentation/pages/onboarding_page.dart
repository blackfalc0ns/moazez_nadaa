import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../../../../generated/app_localizations.dart';
import '../../data/onboarding_dummy_data.dart';
import '../widgets/onboarding_glass_card.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  static const seenKey = 'ndaaa_chat_onboarding_seen';

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  Future<void> _finishOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(OnboardingPage.seenKey, true);
    } catch (error) {
      debugPrint('SharedPreferences unavailable on onboarding: $error');
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  Future<void> _handleNext() async {
    if (_currentIndex == OnboardingData.pages.length - 1) {
      await _finishOnboarding();
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = OnboardingData.pages;
    final descriptions = [
      l10n.onboardingDescriptionOne,
      l10n.onboardingDescriptionTwo,
      l10n.onboardingDescriptionThree,
    ];
    final responsive = context.responsive;
    final cardHeight = _cardHeight(responsive);
    final horizontalPadding = responsive.isNarrowPhone
        ? AppSpacing.sm
        : responsive.adaptive(compact: AppSpacing.lg, medium: AppSpacing.xl);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final item = pages[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(item.imagePath, fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.transparent,
                          AppColors.primaryDeep.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: responsive.isShort
                        ? AppSpacing.sm
                        : AppSpacing.md,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: _finishOnboarding,
                        borderRadius: BorderRadius.circular(
                          AppRadius.radiusFull,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.isNarrowPhone
                                ? AppSpacing.sm
                                : AppSpacing.md,
                            vertical: responsive.isNarrowPhone ? 7 : 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(
                              AppRadius.radiusFull,
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            l10n.onboardingSkip,
                            style: AppTypography.labelLarge.copyWith(
                              color: Colors.white,
                              fontSize: responsive.fontSize(14),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Flexible(child: _OnboardingLanguageSelector()),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: responsive.isExpanded ? 720 : double.infinity,
              ),
              child: SizedBox(
                width: double.infinity,
                height: cardHeight,
                child: OnboardingGlassCard(
                  description: descriptions[_currentIndex],
                  currentIndex: _currentIndex,
                  totalCount: pages.length,
                  onNext: _handleNext,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _cardHeight(ResponsiveInfo responsive) {
    final baseFactor = responsive.isLandscape
        ? 0.68
        : responsive.isShort
        ? 0.43
        : 0.34;
    final textScaleAllowance =
        (responsive.textScaleFactor - 1).clamp(0.0, 1.0) * 72;
    final desired = responsive.safeHeight * baseFactor + textScaleAllowance;
    final maxHeight =
        responsive.safeHeight * (responsive.isLandscape ? 0.78 : 0.56);
    return desired.clamp(238.0, maxHeight.clamp(238.0, 430.0));
  }
}

class _OnboardingLanguageSelector extends StatelessWidget {
  const _OnboardingLanguageSelector();

  @override
  Widget build(BuildContext context) {
    final controller = sl<AppLocaleController>();
    final responsive = context.responsive;
    return LayoutBuilder(
      builder: (context, constraints) {
        final showLabels = constraints.maxWidth >= 150;
        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final selected = controller.languageCode;
            return Container(
              padding: EdgeInsets.all(
                responsive.isNarrowPhone ? 3 : AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LanguageFlagButton(
                    label: 'عربي',
                    assetPath: 'assets/images/Ar_suadi.svg',
                    selected: selected == 'ar',
                    showLabel: showLabels,
                    onTap: () => controller.setLocale(const Locale('ar')),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  _LanguageFlagButton(
                    label: 'EN',
                    assetPath: 'assets/images/En_england.svg',
                    selected: selected == 'en',
                    showLabel: showLabels,
                    onTap: () => controller.setLocale(const Locale('en')),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _LanguageFlagButton extends StatelessWidget {
  const _LanguageFlagButton({
    required this.label,
    required this.assetPath,
    required this.selected,
    required this.showLabel,
    required this.onTap,
  });

  final String label;
  final String assetPath;
  final bool selected;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Semantics(
      label: label,
      button: true,
      selected: selected,
      child: InkWell(
        onTap: selected ? null : onTap,
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: responsive.isNarrowPhone ? 6 : AppSpacing.sm,
            vertical: responsive.isNarrowPhone ? 5 : AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.radiusFull),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                assetPath,
                width: responsive.isNarrowPhone ? 17 : 20,
                height: responsive.isNarrowPhone ? 17 : 20,
              ),
              if (showLabel) ...[
                SizedBox(width: AppSpacing.xs),
                Text(
                  label,
                  style: AppTypography.labelLarge.copyWith(
                    color: selected ? AppColors.primaryDeep : Colors.white,
                    fontSize: responsive.fontSize(
                      responsive.isNarrowPhone ? 11 : 13,
                    ),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
