/// Application configuration
/// Centralizes all app-wide configuration settings
class AppConfig {
  /// Application name
  static const String appName = 'Teacher App';

  /// Application name in Arabic
  static const String appNameAr = 'تطبيق المعلم';

  /// Application version
  static const String version = '1.0.0';

  /// Build number
  static const int buildNumber = 1;

  /// Application identifier
  static const String appId = 'com.teacher.app';

  /// Minimum supported version
  static const String minSupportedVersion = '1.0.0';

  /// Supported locales
  static const List<String> supportedLocales = ['en', 'ar'];

  /// Default locale
  static const String defaultLocale = 'en';

  /// RTL languages list
  static const List<String> rtlLanguages = ['ar', 'he', 'fa', 'ur'];

  /// Whether debug mode is enabled
  static bool isDebugMode = false;

  /// Whether to enable analytics
  static bool enableAnalytics = true;

  /// Whether to enable crash reporting
  static bool enableCrashReporting = true;

  /// Maximum image upload size in bytes (5MB)
  static const int maxImageUploadSize = 5 * 1024 * 1024;

  /// Maximum file upload size in bytes (10MB)
  static const int maxFileUploadSize = 10 * 1024 * 1024;

  /// Image compression quality (0-100)
  static const int imageCompressionQuality = 80;

  /// Pagination default page size
  static const int defaultPageSize = 20;

  /// Session timeout in minutes
  static const int sessionTimeoutMinutes = 30;

  /// Cache duration in days
  static const int cacheDurationDays = 7;

  /// Token refresh threshold in seconds (refresh token 5 minutes before expiry)
  static const int tokenRefreshThresholdSeconds = 300;

  /// Check if locale is RTL
  static bool isRtlLanguage(String locale) => rtlLanguages.contains(locale);

  /// Check if current locale is RTL
  static bool isCurrentLocaleRtl(String currentLocale) => isRtlLanguage(currentLocale);
}

/// Environment configuration
enum Environment { development, staging, production }

/// Environment configuration manager
class EnvironmentConfig {
  static Environment _currentEnvironment = Environment.development;

  /// Get current environment
  static Environment get current => _currentEnvironment;

  /// Set environment
  static void setEnvironment(Environment environment) {
    _currentEnvironment = environment;
  }

  /// Check if current environment is development
  static bool get isDevelopment => _currentEnvironment == Environment.development;

  /// Check if current environment is staging
  static bool get isStaging => _currentEnvironment == Environment.staging;

  /// Check if current environment is production
  static bool get isProduction => _currentEnvironment == Environment.production;

  /// Get environment name
  static String get environmentName {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }
}