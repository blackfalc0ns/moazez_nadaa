import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DismissalNotificationLocalPresenter {
  DismissalNotificationLocalPresenter({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const channelId = 'moazez_dismissal_notifications';
  static const channelName = 'Moazez Dismissal Notifications';
  static const channelDescription =
      'Dismissal requests, queue updates, and handover alerts.';

  final FlutterLocalNotificationsPlugin _plugin;
  static final Set<String> _seenMessageIds = <String>{};

  Future<Map<String, dynamic>?> initialize({
    required ValueChanged<Map<String, dynamic>> onTap,
  }) async {
    if (!_supportsLocalNotifications) return null;
    await _initializePlugin(
      _plugin,
      onTap: (payload) => onTap(_decodePayload(payload)),
    );
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    final response = launchDetails?.notificationResponse;
    if (launchDetails?.didNotificationLaunchApp != true ||
        response?.payload == null ||
        response!.payload!.isEmpty) {
      return null;
    }
    return _decodePayload(response.payload!);
  }

  Future<void> show(RemoteMessage message) async {
    if (!_supportsLocalNotifications) return;
    await _show(_plugin, message);
  }

  static Future<void> showDataOnlyInBackground(RemoteMessage message) async {
    if (!_supportsLocalNotifications || message.notification != null) return;
    final plugin = FlutterLocalNotificationsPlugin();
    await _initializePlugin(plugin);
    await _show(plugin, message);
  }

  static Future<void> _initializePlugin(
    FlutterLocalNotificationsPlugin plugin, {
    ValueChanged<String>? onTap,
  }) async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_notification'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: onTap == null
          ? null
          : (response) {
              final payload = response.payload;
              if (payload != null && payload.isNotEmpty) onTap(payload);
            },
    );
    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
    );
    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _show(
    FlutterLocalNotificationsPlugin plugin,
    RemoteMessage message,
  ) async {
    final presentation = _resolvePresentation(message);
    final dedupId =
        message.messageId ??
        _read(message.data, const [
          'notificationId',
          'notification_id',
          'requestId',
          'request_id',
          'dismissalRequestId',
          'dismissal_request_id',
        ]);
    if (dedupId != null && !_seenMessageIds.add(dedupId)) return;
    if (_seenMessageIds.length > 200) _seenMessageIds.clear();
    final prefs = await SharedPreferences.getInstance();
    if (dedupId != null) {
      final seen =
          prefs.getStringList('_dismissal_push_seen_ids') ?? <String>[];
      if (seen.contains(dedupId)) return;
      seen.add(dedupId);
      if (seen.length > 100) seen.removeRange(0, seen.length - 100);
      await prefs.setStringList('_dismissal_push_seen_ids', seen);
    }

    final largeIcon = await _loadLargeIcon();
    await plugin.show(
      id: ((dedupId?.hashCode ?? message.hashCode) & 0x7fffffff),
      title: presentation.title,
      body: presentation.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: 'ic_stat_notification',
          color: const Color(0xFF007F91),
          largeIcon: largeIcon,
          visibility: NotificationVisibility.private,
          styleInformation: BigTextStyleInformation(
            presentation.body,
            contentTitle: presentation.title,
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          threadIdentifier: 'dismissal_notifications',
        ),
      ),
      payload: jsonEncode(_safeTapPayload(message.data)),
    );
  }

  static Map<String, dynamic> _safeTapPayload(Map<String, dynamic> data) {
    final payload = <String, dynamic>{};
    for (final key in const [
      'notificationId',
      'notification_id',
      'requestId',
      'request_id',
      'dismissalRequestId',
      'dismissal_request_id',
      'type',
      'notificationType',
      'sourceModule',
      'source_module',
      'sourceType',
      'source_type',
      'sourceId',
      'source_id',
      'deepLink',
      'deeplink',
      'title',
      'body',
      'message',
      'description',
    ]) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) payload[key] = value;
    }
    return payload;
  }

  static _DismissalNotificationPresentation _resolvePresentation(
    RemoteMessage message,
  ) {
    final data = message.data;
    final rawTitle =
        message.notification?.title ?? _read(data, const ['title']);
    final rawBody =
        message.notification?.body ??
        _read(data, const ['body', 'message', 'description']);
    final type = _read(data, const ['type', 'notificationType']);
    return _DismissalNotificationPresentation(
      title: _wrapForTextDirection(rawTitle ?? _titleForType(type)),
      body: _wrapForTextDirection(
        rawBody ?? 'يوجد تحديث جديد على طلبات النداء.',
      ),
    );
  }

  static String _titleForType(String? type) {
    switch (type) {
      case 'request_created':
        return 'طلب نداء جديد';
      case 'request_cancelled':
        return 'تم إلغاء طلب نداء';
      case 'request_called':
        return 'تم استدعاء الطالب';
      case 'request_ready':
        return 'الطالب جاهز للتسليم';
      case 'request_handed_over':
        return 'تم تسليم الطالب';
      case 'request_expired':
        return 'انتهت صلاحية طلب نداء';
      default:
        return 'إشعار نداء';
    }
  }

  static String? _read(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  static Map<String, dynamic> _decodePayload(String payload) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return const {};
  }

  static String _wrapForTextDirection(String value) {
    if (value.isEmpty) return value;
    final isRtl = RegExp(r'[\u0600-\u06FF]').hasMatch(value);
    return '${isRtl ? '\u2067' : '\u2066'}$value\u2069';
  }

  static Future<ByteArrayAndroidBitmap?> _loadLargeIcon() async {
    if (!Platform.isAndroid) return null;
    try {
      final data = await rootBundle.load('assets/images/logo.png');
      return ByteArrayAndroidBitmap(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    } catch (_) {
      return null;
    }
  }

  static bool get _supportsLocalNotifications {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }
}

class _DismissalNotificationPresentation {
  const _DismissalNotificationPresentation({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}
