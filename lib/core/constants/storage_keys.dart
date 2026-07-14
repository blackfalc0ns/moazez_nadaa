/// Storage keys for persistent storage
/// Centralizes all SharedPreferences and SecureStorage keys
class StorageKeys {
  StorageKeys._();

  // Auth keys
  static const String authToken = 'auth_token';
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String tokenExpiry = 'token_expiry';
  static const String userId = 'user_id';
  static const String rememberLogin = 'remember_login';
  static const String rememberedEmail = 'remembered_email';
  static const String rememberedPassword = 'remembered_password';

  // User data keys
  static const String userData = 'user_data';
  static const String userProfile = 'user_profile';

  // Settings keys
  static const String locale = 'app_locale';
  static const String theme = 'app_theme';
  static const String darkMode = 'dark_mode';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String soundEnabled = 'sound_enabled';
  static const String vibrationEnabled = 'vibration_enabled';

  // App state keys
  static const String onboardingCompleted = 'onboarding_completed';
  static const String appLaunched = 'app_launched';
  static const String lastActiveTime = 'last_active_time';
  static const String appVersion = 'app_version';

  // Cache keys
  static const String cacheVersion = 'cache_version';
  static const String lastCacheUpdate = 'last_cache_update';
  static const String cachedSchedule = 'cached_schedule';

  // Notification keys
  static const String fcmToken = 'fcm_token';
  static const String notificationSettings = 'notification_settings';
  static const String lastNotificationTime = 'last_notification_time';

  // Filter and sort keys
  static const String classroomFilters = 'classroom_filters';
  static const String messageFilters = 'message_filters';
  static const String sortPreference = 'sort_preference';

  // Recent items
  static const String recentSearches = 'recent_searches';
  static const String recentClasses = 'recent_classes';

  // Device info
  static const String deviceId = 'device_id';
  static const String deviceToken = 'device_token';

  // Analytics
  static const String analyticsEnabled = 'analytics_enabled';
  static const String crashReportingEnabled = 'crash_reporting_enabled';
}
