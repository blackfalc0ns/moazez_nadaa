import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/permissions/app_permission.dart';
import '../../../../core/permissions/permission_repository.dart';
import '../../../../core/services/notifications/push_token_lifecycle.dart';
import '../../../../core/utils/helper/global_navigator.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../repo/dismissal_notifications_repo.dart';
import 'dismissal_notification_local_presenter.dart';

class DismissalNotificationPushService implements PushTokenLifecycle {
  DismissalNotificationPushService({
    required DismissalNotificationsRepo notificationsRepo,
    required FirebaseMessaging messaging,
    required PermissionRepository permissionRepository,
    required FlutterSecureStorage secureStorage,
    required FlutterLocalNotificationsPlugin localNotifications,
  }) : _repo = notificationsRepo,
       _messaging = messaging,
       _permissions = permissionRepository,
       _secureStorage = secureStorage,
       _localPresenter = DismissalNotificationLocalPresenter(
         plugin: localNotifications,
       );

  final DismissalNotificationsRepo _repo;
  final FirebaseMessaging _messaging;
  final PermissionRepository _permissions;
  final FlutterSecureStorage _secureStorage;
  final DismissalNotificationLocalPresenter _localPresenter;
  final _hints = StreamController<void>.broadcast();
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedSubscription;
  StreamSubscription<String>? _tokenSubscription;
  bool _initialized = false;
  bool _registering = false;
  Map<String, dynamic>? _pendingOpen;
  bool _pendingOpenFromLaunch = false;

  static const String _lastHandledLaunchKey =
      'dismissal_last_handled_notification_launch';

  @override
  Stream<void> get notificationHints => _hints.stream;

  @override
  Future<void> initialize() async {
    if (_initialized || !_supportsMessaging) return;
    _initialized = true;
    try {
      final localLaunchPayload = await _localPresenter.initialize(
        onTap: _handlePayload,
      );
      if (localLaunchPayload != null) {
        _pendingOpen = localLaunchPayload;
        _pendingOpenFromLaunch = true;
      }
    } catch (_) {
      // REST and realtime remain available if local notifications are disabled.
    }
    try {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: true,
        sound: true,
      );
      _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
        if (!_hints.isClosed) _hints.add(null);
        unawaited(_localPresenter.show(message));
      });
      _openedSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
        message,
      ) {
        if (!_hints.isClosed) _hints.add(null);
        _handlePayload(message.data);
      });
      _tokenSubscription = _messaging.onTokenRefresh.listen((token) {
        unawaited(_registerToken(token));
      });
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null && _pendingOpen == null) {
        _pendingOpen = initialMessage.data;
        _pendingOpenFromLaunch = true;
        if (!_hints.isClosed) _hints.add(null);
      }
    } catch (_) {
      // Firebase availability must not block authenticated dismissal work.
    }
  }

  @override
  Future<void> ensureRegistered() async {
    if (!_permissions.has(AppPermission.manageDeviceTokens)) {
      _flushPendingOpen();
      return;
    }
    if (_registering) return;
    _registering = true;
    try {
      await initialize();
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;
      final token = await _messaging.getToken();
      if (token == null || token.trim().isEmpty) return;
      await _registerToken(token);
    } catch (_) {
      // Token registration is best effort and must not block the app.
    } finally {
      _registering = false;
      _flushPendingOpen();
    }
  }

  void _handlePayload(Map<String, dynamic> payload) {
    unawaited(_handlePayloadInternal(payload));
  }

  Future<void> _handlePayloadInternal(
    Map<String, dynamic> payload, {
    bool fromLaunch = false,
  }) async {
    if (fromLaunch && await _wasLaunchPayloadHandled(payload)) return;
    if (!_permissions.has(AppPermission.viewNotifications)) {
      _pendingOpen = payload;
      _pendingOpenFromLaunch = fromLaunch;
      return;
    }
    await _markLaunchPayloadHandled(payload);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = GlobalNavigator.navigatorKey.currentState;
      if (navigator == null) {
        _pendingOpen = payload;
        _pendingOpenFromLaunch = fromLaunch;
        return;
      }
      final requestId = _requestId(payload);
      if (requestId == null || requestId.isEmpty) {
        navigator.pushNamed(Routes.notifications);
        return;
      }
      navigator.pushNamed(
        Routes.requestDetails,
        arguments: {'requestId': requestId},
      );
    });
  }

  void _flushPendingOpen() {
    final payload = _pendingOpen;
    if (payload == null) return;
    final fromLaunch = _pendingOpenFromLaunch;
    _pendingOpen = null;
    _pendingOpenFromLaunch = false;
    unawaited(_handlePayloadInternal(payload, fromLaunch: fromLaunch));
  }

  Future<bool> _wasLaunchPayloadHandled(Map<String, dynamic> payload) async {
    final key = _launchPayloadKey(payload);
    if (key == null) return false;
    final stored = await _secureStorage.read(key: _lastHandledLaunchKey);
    return stored == key;
  }

  Future<void> _markLaunchPayloadHandled(Map<String, dynamic> payload) async {
    final key = _launchPayloadKey(payload);
    if (key == null) return;
    await _secureStorage.write(key: _lastHandledLaunchKey, value: key);
  }

  String? _launchPayloadKey(Map<String, dynamic> payload) {
    final notificationId = _notificationId(payload);
    final requestId = _requestId(payload);
    final type =
        _read(payload, const ['type', 'notificationType']) ?? 'unknown';
    final parts = <String>[
      if (notificationId != null) 'notification:$notificationId',
      if (requestId != null) 'request:$requestId',
      'type:$type',
    ];
    return parts.length <= 1 ? null : parts.join('|');
  }

  String? _notificationId(Map<String, dynamic> data) {
    return _read(data, const ['notificationId', 'notification_id', 'id']);
  }

  String? _requestId(Map<String, dynamic> data) {
    final direct = _read(data, const [
      'requestId',
      'request_id',
      'dismissalRequestId',
      'dismissal_request_id',
    ]);
    if (direct != null) return direct;
    final sourceType = _read(data, const ['sourceType', 'source_type']);
    if (sourceType == 'dismissal_request') {
      return _read(data, const ['sourceId', 'source_id']);
    }
    return null;
  }

  String? _read(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  Future<void> _registerToken(String token) async {
    if (!_permissions.has(AppPermission.manageDeviceTokens)) return;
    if (token.trim().isEmpty) return;
    final accessToken = await _secureStorage.read(key: StorageKeys.accessToken);
    if (accessToken == null || accessToken.isEmpty) return;
    await _repo.registerDeviceToken(
      token: token,
      platform: _platform,
      locale: PlatformDispatcher.instance.locale.toLanguageTag(),
      timezone: DateTime.now().timeZoneName,
    );
  }

  @override
  Future<void> unregisterCurrentDevice() async {
    try {
      final token = await _messaging.getToken();
      if (token != null && token.trim().isNotEmpty) {
        await _repo.unregisterCurrentDeviceToken(token: token);
      }
      await _messaging.deleteToken();
    } catch (_) {
      // Logout must continue even when push cleanup is unavailable.
    }
  }

  String get _platform {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    return 'android';
  }

  bool get _supportsMessaging {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    await _openedSubscription?.cancel();
    await _tokenSubscription?.cancel();
    await _hints.close();
  }
}
