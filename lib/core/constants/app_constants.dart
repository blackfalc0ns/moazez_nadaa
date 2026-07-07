/// Application-wide constants
/// Centralizes all application constants to avoid hardcoding values
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Moazez Dismissal';
  static const String appNameAr = 'نداء معزز';
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;

  // API
  static const String apiBaseUrl = 'https://api.moazez.sa/api/v1';
  static const int apiTimeout = 30000;
  static const int maxRetries = 3;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String localeKey = 'app_locale';
  static const String themeKey = 'app_theme';
  static const String onboardingKey = 'onboarding_completed';
  static const String settingsKey = 'app_settings';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;

  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 16.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);

  // Image
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int imageQuality = 85;
  static const int thumbnailWidth = 200;
  static const int thumbnailHeight = 200;

  // Cache
  static const Duration cacheDuration = Duration(days: 7);
  static const int maxCacheItems = 100;

  // Session
  static const Duration sessionTimeout = Duration(minutes: 30);
  static const Duration tokenRefreshInterval = Duration(minutes: 25);

  // Notifications
  static const String notificationChannelId = 'ndaaa_chat_notifications';
  static const String notificationChannelName = 'Moazez Dismissal';
  static const String notificationChannelDescription =
      'Dismissal requests and operational alerts';
}
