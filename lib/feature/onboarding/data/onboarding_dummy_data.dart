import 'package:ndaaa_chat/core/constants/app_assets.dart';

/// Onboarding Item Model
class OnboardingItem {
  final String imagePath;
  final String description;

  const OnboardingItem({required this.imagePath, required this.description});
}

class OnboardingData {
  static const pages = [
    OnboardingItem(
      imagePath: AppAssets.onboarding_1,
      description:
          'استقبل نداءات أولياء الأمور فوراً، وتابع طلب خروج الطالب من لحظة الوصول حتى التسليم بأمان.',
    ),
    OnboardingItem(
      imagePath: AppAssets.onboarding_2,
      description:
          'تواصل مع الإدارة والمعلمين وأولياء الأمور داخل محادثات واضحة وسريعة مرتبطة بسياق المدرسة.',
    ),
    OnboardingItem(
      imagePath: AppAssets.onboarding_3,
      description:
          'معزز يجمع الشات والنداء في تجربة واحدة هادئة، عملية، ومناسبة لمشرفي المدرسة والأمن.',
    ),
  ];
}
