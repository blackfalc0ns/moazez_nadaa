import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';
import '../config/environment.dart';
import '../localization/app_locale_controller.dart';
import '../permissions/default_permission_repository.dart';
import '../permissions/permission_repository.dart';
import '../security/certificate_pinning.dart';

import '../api/api_client.dart';
import '../api/api_service.dart';
import '../interceptors/language_interceptor.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/refresh_token_interceptor.dart';
import '../realtime/realtime_service.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // App locale controller
  final initialLocaleCode = sharedPreferences.getString(StorageKeys.locale);
  final appLocaleController = AppLocaleController(
    prefs: sharedPreferences,
    initialLocale: Locale(initialLocaleCode ?? 'ar'),
  );
  await appLocaleController.load();
  sl.registerLazySingleton<AppLocaleController>(() => appLocaleController);

  // Permission foundation
  final permissionRepository =
      DefaultPermissionRepository(prefs: sharedPreferences);
  await permissionRepository.warmup();
  sl.registerLazySingleton<PermissionRepository>(() => permissionRepository);

  // Core - API Client & Service
  final apiClient = ApiClient();

  // Certificate pinning (enabled only when fingerprints are configured)
  final certs = CertificatePinningConfig.getCertificatesForEnvironment(
    Environment.current.name,
  );
  if (certs.isNotEmpty) {
    CertificatePinning.setupCertificatePinning(
      apiClient.dio,
      allowedSHA256Fingerprints: certs,
      allowBadCertificates: Environment.isDevelopment,
    );
  }
  
  // ✅ Add Language Interceptor (sends Accept-Language header)
  apiClient.addInterceptor(
    LanguageInterceptor(
      getCurrentLocale: () => sl<AppLocaleController>().locale,
    ),
  );
  
  // ✅ Add Pretty Dio Logger for debugging
  apiClient.addInterceptor(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
  );

  // ✅ Register FlutterSecureStorage early (needed by interceptors)
  if (!sl.isRegistered<FlutterSecureStorage>()) {
    sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );
  }

  // ✅ Add Auth Interceptor — reads token from SecureStorage on every request
  apiClient.addInterceptor(
    AuthInterceptor(sl<FlutterSecureStorage>()),
  );

  // ✅ Add Refresh Token Interceptor — handles 401 by calling /auth/refresh
  apiClient.addInterceptor(
    RefreshTokenInterceptor(
      dio: apiClient.dio,
      secureStorage: sl<FlutterSecureStorage>(),
      onRefreshFailed: () {
        // On refresh failure: clear global auth header so next requests don't 401-loop
        apiClient.clearAuthToken();
        // Disconnect socket per security checklist: if REST returns 401, disconnect socket
        RealtimeService.instance.disconnect();
      },
    ),
  );

  sl.registerLazySingleton<ApiClient>(() => apiClient);
  sl.registerLazySingleton<ApiService>(() => ApiService(apiClient.dio));
  RealtimeService.init(apiClient);
  sl.registerLazySingleton<RealtimeService>(() => RealtimeService.instance);

  // Features

}
