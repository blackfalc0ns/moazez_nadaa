import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../../../auth/data/repositories/dismissal_auth_repo.dart';
import '../../../onboarding/presentation/pages/onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _navigateToNext();
  }

  void _initAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    var hasSeenOnboarding = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      hasSeenOnboarding = prefs.getBool(OnboardingPage.seenKey) ?? false;
    } catch (error) {
      debugPrint('SharedPreferences unavailable on splash: $error');
    }

    if (!mounted) return;

    final nextRoute = hasSeenOnboarding
        ? await _authenticatedRoute()
        : Routes.onboarding;
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, nextRoute);
  }

  Future<String> _authenticatedRoute() async {
    final session = await sl<DismissalAuthRepo>().restoreSession();
    if (session == null) return Routes.login;
    return session.mustChangePassword ? Routes.changePassword : Routes.root;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SvgPicture.asset(AppAssets.logo, width: 96, height: 96),
        ),
      ),
    );
  }
}
