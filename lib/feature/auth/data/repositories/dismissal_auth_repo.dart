import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/errors/failures/typed_failure.dart';
import '../../../../core/permissions/permission_repository.dart';
import '../../../../core/realtime/realtime_service.dart';
import '../../../../core/services/notifications/push_token_lifecycle.dart';
import '../mappers/dismissal_auth_mapper.dart';
import '../models/dismissal_auth_session.dart';

class DismissalAuthRepo {
  DismissalAuthRepo({
    ApiService? apiService,
    ApiClient? apiClient,
    FlutterSecureStorage? secureStorage,
    SharedPreferences? preferences,
    PermissionRepository? permissionRepository,
  }) : _apiService = apiService ?? sl<ApiService>(),
       _apiClient = apiClient ?? sl<ApiClient>(),
       _secureStorage = secureStorage ?? sl<FlutterSecureStorage>(),
       _preferences = preferences ?? sl<SharedPreferences>(),
       _permissions = permissionRepository ?? sl<PermissionRepository>();

  final ApiService _apiService;
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _preferences;
  final PermissionRepository _permissions;

  Future<Either<TypedFailure, DismissalAuthSession>> login({
    required String email,
    required String password,
  }) async {
    try {
      await clearLocalSession(cleanupPushToken: false);
      final response = await _apiService.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: DismissalAuthMapper.loginPayload(
          email: email,
          password: password,
        ),
        parser: DismissalAuthMapper.extractMap,
      );
      if (!response.isSuccess || response.data == null) {
        return Left(response.failure ?? const UnknownFailure());
      }

      final session = DismissalAuthMapper.sessionFromJson(response.data!);
      final validationFailure = _validateSession(session);
      if (validationFailure != null) return Left(validationFailure);

      await _persistSession(session);
      return Right(session);
    } catch (error) {
      return Left(_failureFromError(error));
    }
  }

  Future<DismissalAuthSession?> restoreSession() async {
    final accessToken = await _secureStorage.read(key: StorageKeys.accessToken);
    if (accessToken == null || accessToken.isEmpty) return null;

    final cached = _cachedSession()?.copyWith(accessToken: accessToken);
    _apiClient.setAuthToken(accessToken);

    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        ApiEndpoints.me,
        parser: DismissalAuthMapper.extractMap,
      );
      if (!response.isSuccess || response.data == null) {
        if (_isSessionFailure(response.failure)) {
          await clearLocalSession(cleanupPushToken: false);
          return null;
        }
        if (cached != null && _validateSession(cached) == null) {
          await _permissions.warmup();
          return cached;
        }
        await clearLocalSession(cleanupPushToken: false);
        return null;
      }

      final remote = DismissalAuthMapper.sessionFromJson(response.data!);
      final session = remote.copyWith(
        accessToken: accessToken,
        refreshToken:
            cached?.refreshToken ??
            await _secureStorage.read(key: StorageKeys.refreshToken) ??
            '',
        permissions: remote.permissions.isEmpty
            ? cached?.permissions ?? const []
            : remote.permissions,
        mustChangePassword:
            remote.mustChangePassword || (cached?.mustChangePassword ?? false),
      );
      if (_validateSession(session) != null) {
        await clearLocalSession(cleanupPushToken: false);
        return null;
      }
      await _persistSession(session);
      return session;
    } catch (_) {
      if (cached != null && _validateSession(cached) == null) {
        await _permissions.warmup();
        return cached;
      }
      return null;
    }
  }

  Future<Either<TypedFailure, Unit>> logout() async {
    try {
      await _apiService.post<Map<String, dynamic>>(
        ApiEndpoints.logout,
        parser: DismissalAuthMapper.extractMap,
      );
    } catch (_) {
      // Local session must always be cleared.
    }
    await clearLocalSession();
    return const Right(unit);
  }

  Future<Either<TypedFailure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        ApiEndpoints.changePassword,
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
        parser: DismissalAuthMapper.extractMap,
      );
      if (!response.isSuccess) {
        return Left(response.failure ?? const UnknownFailure());
      }

      final cached = _cachedSession();
      if (cached != null) {
        await _persistSession(cached.copyWith(mustChangePassword: false));
      }
      return const Right(unit);
    } catch (error) {
      return Left(_failureFromError(error));
    }
  }

  Future<void> clearLocalSession({bool cleanupPushToken = true}) async {
    if (cleanupPushToken && sl.isRegistered<PushTokenLifecycle>()) {
      try {
        await sl<PushTokenLifecycle>().unregisterCurrentDevice().timeout(
          const Duration(seconds: 3),
        );
      } catch (_) {
        // Local logout/session reset must not be blocked by FCM cleanup.
      }
    }
    _apiClient.clearAuthToken();
    if (sl.isRegistered<RealtimeService>()) {
      sl<RealtimeService>().disconnect();
    }
    await _secureStorage.delete(key: StorageKeys.accessToken);
    await _secureStorage.delete(key: StorageKeys.refreshToken);
    await _preferences.remove(StorageKeys.userData);
    await _permissions.clear();
  }

  Future<void> _persistSession(DismissalAuthSession session) async {
    await _secureStorage.write(
      key: StorageKeys.accessToken,
      value: session.accessToken,
    );
    if (session.refreshToken.isNotEmpty) {
      await _secureStorage.write(
        key: StorageKeys.refreshToken,
        value: session.refreshToken,
      );
    }
    await _preferences.setString(
      StorageKeys.userData,
      jsonEncode(DismissalAuthMapper.sessionToJson(session)),
    );
    _apiClient.setAuthToken(session.accessToken);
    if (session.permissions.isEmpty) {
      await _permissions.warmup();
    } else {
      await _permissions.updateFromPermissionKeys(session.permissions);
    }
    if (sl.isRegistered<RealtimeService>()) {
      await sl<RealtimeService>().connect();
    }
    if (sl.isRegistered<PushTokenLifecycle>()) {
      unawaited(sl<PushTokenLifecycle>().ensureRegistered());
    }
  }

  DismissalAuthSession? _cachedSession() {
    final raw = _preferences.getString(StorageKeys.userData);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      return DismissalAuthMapper.sessionFromJson(json);
    } catch (_) {
      return null;
    }
  }

  TypedFailure? _validateSession(DismissalAuthSession session) {
    if (session.accessToken.isEmpty) {
      return const UnauthorizedFailure(message: 'Missing access token');
    }
    if (!session.isDismissalStaff) {
      return const ForbiddenFailure(
        message: 'This account is not a dismissal staff account',
      );
    }
    if (!session.isActive) {
      return const UnauthorizedFailure(message: 'Account is inactive');
    }
    return null;
  }

  bool _isSessionFailure(TypedFailure? failure) {
    return failure?.type == FailureType.unauthorized ||
        failure?.type == FailureType.tokenExpired ||
        failure?.type == FailureType.sessionExpired;
  }

  TypedFailure _failureFromError(Object error) {
    if (error is TypedFailure) return error;
    return TypedFailureFactory.fromException(
      error is Exception ? error : Exception(error.toString()),
    );
  }
}
