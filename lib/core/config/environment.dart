/// Environment configuration for different app environments
enum AppEnvironment {
  /// Development environment
  development,

  /// Staging environment for testing
  staging,

  /// Production environment
  production,
}

/// Environment settings
class Environment {
  final AppEnvironment type;
  final String name;
  final String baseUrl;
  final String apiVersion;
  final bool enableLogging;
  final bool enableDebugBanner;
  final int connectionTimeout;
  final int receiveTimeout;

  const Environment({
    required this.type,
    required this.name,
    required this.baseUrl,
    required this.apiVersion,
    required this.enableLogging,
    required this.enableDebugBanner,
    required this.connectionTimeout,
    required this.receiveTimeout,
  });

  /// Development environment configuration
  static const Environment development = Environment(
    type: AppEnvironment.development,
    name: 'Development',
    baseUrl: 'https://api.moazez.sa/api/v1',
    apiVersion: 'v1',
    enableLogging: true,
    enableDebugBanner: true,
    connectionTimeout: 30000,
    receiveTimeout: 30000,
  );

  /// Staging environment configuration
  static const Environment staging = Environment(
    type: AppEnvironment.staging,
    name: 'Staging',
    baseUrl: 'https://api.moazez.sa/api/v1',
    apiVersion: 'v1',
    enableLogging: true,
    enableDebugBanner: true,
    connectionTimeout: 30000,
    receiveTimeout: 30000,
  );

  /// Production environment configuration
  static const Environment production = Environment(
    type: AppEnvironment.production,
    name: 'Production',
    baseUrl: 'https://api.moazez.sa/api/v1',
    apiVersion: 'v1',
    enableLogging: false,
    enableDebugBanner: false,
    connectionTimeout: 30000,
    receiveTimeout: 30000,
  );

  /// Get environment by type
  static Environment getByType(AppEnvironment type) {
    switch (type) {
      case AppEnvironment.development:
        return development;
      case AppEnvironment.staging:
        return staging;
      case AppEnvironment.production:
        return production;
    }
  }

  /// Realtime socket URL — docs: namespace /api/v1/realtime appended to baseUrl
  String get realtimeUrl => '$baseUrl/realtime';

  /// Get current environment (can be overridden)
  static Environment _currentEnvironment = development;

  /// Get current environment
  static Environment get current => _currentEnvironment;

  /// Set current environment
  static void setCurrent(Environment environment) {
    _currentEnvironment = environment;
  }

  /// Set environment by type
  static void setByType(AppEnvironment type) {
    _currentEnvironment = getByType(type);
  }

  /// Check if current environment is development
  static bool get isDevelopment => _currentEnvironment.type == AppEnvironment.development;

  /// Check if current environment is staging
  static bool get isStaging => _currentEnvironment.type == AppEnvironment.staging;

  /// Check if current environment is production
  static bool get isProduction => _currentEnvironment.type == AppEnvironment.production;
}