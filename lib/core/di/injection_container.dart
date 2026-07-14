import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature/dismissal/data/di/dismissal_di.dart';
import '../../feature/auth/data/di/dismissal_auth_di.dart';
import '../../feature/notifications/data/di/dismissal_notifications_di.dart';
import '../api/api_client.dart';
import '../api/api_service.dart';
import '../config/environment.dart';
import '../constants/storage_keys.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/language_interceptor.dart';
import '../interceptors/refresh_token_interceptor.dart';
import '../localization/app_locale_controller.dart';
import '../utils/helper/global_navigator.dart';
import '../permissions/default_permission_repository.dart';
import '../permissions/permission_repository.dart';
import '../realtime/realtime_service.dart';
import '../security/certificate_pinning.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  final initialLocaleCode = sharedPreferences.getString(StorageKeys.locale);
  final localeController = AppLocaleController(
    prefs: sharedPreferences,
    initialLocale: Locale(initialLocaleCode ?? 'ar'),
  );
  await localeController.load();
  sl.registerLazySingleton<AppLocaleController>(() => localeController);

  final permissionRepository = DefaultPermissionRepository(
    prefs: sharedPreferences,
    secureStorage: secureStorage,
  );
  await permissionRepository.warmup();
  sl.registerLazySingleton<PermissionRepository>(() => permissionRepository);

  final apiClient = ApiClient();
  final certificates = CertificatePinningConfig.getCertificatesForEnvironment(
    Environment.current.name,
  );
  if (certificates.isNotEmpty) {
    CertificatePinning.setupCertificatePinning(
      apiClient.dio,
      allowedSHA256Fingerprints: certificates,
      allowBadCertificates: Environment.isDevelopment,
    );
  }

  apiClient.addInterceptor(
    LanguageInterceptor(getCurrentLocale: () => localeController.locale),
  );
  apiClient.addInterceptor(AuthInterceptor(secureStorage));
  apiClient.addInterceptor(
    RefreshTokenInterceptor(
      dio: apiClient.dio,
      secureStorage: secureStorage,
      onTokenRefreshed: (newToken) async {
        apiClient.setAuthToken(newToken);
        try {
          final rawSession = sharedPreferences.getString(StorageKeys.userData);
          if (rawSession != null && rawSession.isNotEmpty) {
            final sessionMap = Map<String, dynamic>.from(
              jsonDecode(rawSession) as Map,
            );
            sessionMap['accessToken'] = newToken;

            final rotatedRefresh = await secureStorage.read(
              key: StorageKeys.refreshToken,
            );
            if (rotatedRefresh != null && rotatedRefresh.isNotEmpty) {
              sessionMap['refreshToken'] = rotatedRefresh;
            }

            await sharedPreferences.setString(
              StorageKeys.userData,
              jsonEncode(sessionMap),
            );
          }
        } catch (error) {
          developer.log(
            'Error updating dismissal session after token refresh: $error',
            name: 'DismissalAuth',
          );
        }
        await RealtimeService.instance.forceReconnect();
      },
      onRefreshFailed: () async {
        apiClient.clearAuthToken();
        await sharedPreferences.remove(StorageKeys.userData);
        await permissionRepository.clear();
        RealtimeService.instance.disconnect();
        GlobalNavigator.navigateToLogin();
      },
    ),
  );
  if (Environment.current.enableLogging) {
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
  }

  sl.registerLazySingleton<ApiClient>(() => apiClient);
  sl.registerLazySingleton<ApiService>(() => ApiService(apiClient.dio));
  RealtimeService.init(apiClient);
  sl.registerLazySingleton<RealtimeService>(() => RealtimeService.instance);

  DismissalDI.init(sl);
  DismissalNotificationsDI.init(sl);
  DismissalAuthDI.init(sl);
}
