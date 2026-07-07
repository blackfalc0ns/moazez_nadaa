import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import '../api/api_client.dart';
import '../config/environment.dart';

class DismissalRealtimeEvent {
  const DismissalRealtimeEvent({required this.name, required this.payload});

  final String name;
  final dynamic payload;

  bool get affectsNotifications => name.startsWith('dismissal.notification');
  bool get affectsQueue =>
      name.startsWith('dismissal.request') ||
      name == 'dismissal.queue.changed' ||
      name == 'parent.smart_pickup.request.changed';
}

/// Best-effort dismissal signals. REST remains the source of truth.
class RealtimeService with WidgetsBindingObserver {
  RealtimeService._({required ApiClient apiClient}) : _apiClient = apiClient;

  static RealtimeService? _instance;
  static RealtimeService get instance => _instance!;

  static void init(ApiClient apiClient) {
    _instance = RealtimeService._(apiClient: apiClient);
    WidgetsBinding.instance.addObserver(_instance!);
  }

  static const _dismissalEvents = [
    'dismissal.request.created',
    'dismissal.request.cancelled',
    'dismissal.request.status_changed',
    'dismissal.request.arrival_confirmed',
    'dismissal.request.delivered',
    'dismissal.queue.changed',
    'parent.smart_pickup.request.changed',
    'dismissal.notification.created',
    'dismissal.notification.read',
    'dismissal.notifications.read_all',
  ];

  final ApiClient _apiClient;
  final _connectionController = StreamController<bool>.broadcast();
  final _dismissalController =
      StreamController<DismissalRealtimeEvent>.broadcast();

  socket_io.Socket? _socket;
  bool _isConnecting = false;

  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<DismissalRealtimeEvent> get dismissalEvents =>
      _dismissalController.stream;
  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect() async {
    if (isConnected || _isConnecting) return;
    final token = _apiClient.getAuthToken();
    if (token == null || token.isEmpty) return;

    _isConnecting = true;
    try {
      _socket = socket_io.io(
        Environment.current.realtimeUrl,
        socket_io.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': token})
            .enableReconnection()
            .setReconnectionDelay(2000)
            .setReconnectionDelayMax(10000)
            .setRandomizationFactor(0.5)
            .enableForceNewConnection()
            .build(),
      );

      _socket!.onConnect((_) {
        _isConnecting = false;
        _connectionController.add(true);
      });
      _socket!.onDisconnect((_) {
        _isConnecting = false;
        _connectionController.add(false);
      });
      _socket!.onConnectError((error) {
        _isConnecting = false;
        debugPrint('[DismissalRealtime] connect error: $error');
      });
      _socket!.onError(
        (error) => debugPrint('[DismissalRealtime] socket error: $error'),
      );
      _socket!.onReconnect((_) => _connectionController.add(true));

      for (final event in _dismissalEvents) {
        _socket!.on(event, (payload) {
          if (!_dismissalController.isClosed) {
            _dismissalController.add(
              DismissalRealtimeEvent(name: event, payload: payload),
            );
          }
        });
      }
    } catch (error, stackTrace) {
      _isConnecting = false;
      debugPrint('[DismissalRealtime] connect exception: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> forceReconnect() async {
    disconnect();
    await connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnecting = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      forceReconnect();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnect();
    _connectionController.close();
    _dismissalController.close();
  }
}
