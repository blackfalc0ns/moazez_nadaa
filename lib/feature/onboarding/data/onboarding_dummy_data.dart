import 'package:ndaaa_chat/core/constants/app_assets.dart';

/// Onboarding Item Model
class OnboardingItem {
  final String imagePath;

  const OnboardingItem({required this.imagePath});
}

class OnboardingData {
  static const pages = [
    OnboardingItem(imagePath: AppAssets.onboarding_1),
    OnboardingItem(imagePath: AppAssets.onboarding_2),
    OnboardingItem(imagePath: AppAssets.onboarding_3),
  ];
}
