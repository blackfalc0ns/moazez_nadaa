import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import '../api/api_client.dart';
import '../config/environment.dart';

/// Production-ready realtime service for Socket.io integration.
///
/// Contract based on Moazez frontend integration docs:
/// - Namespace: /api/v1/realtime
/// - Auth via auth.token
/// - Client commands: conversation.join/leave, typing.start/stop
/// - Server events: message.created/updated/deleted/read, typing, presence
class RealtimeService with WidgetsBindingObserver {
  RealtimeService._({required ApiClient apiClient}) : _apiClient = apiClient;

  static RealtimeService? _instance;
  static RealtimeService get instance => _instance!;

  static void init(ApiClient apiClient) {
    _instance = RealtimeService._(apiClient: apiClient);
    WidgetsBinding.instance.addObserver(_instance!);
  }

  final ApiClient _apiClient;
  socket_io.Socket? _socket;
  bool _isConnecting = false;

  final _eventControllers = <String, StreamController<dynamic>>{};
  final _connectionController = StreamController<bool>.broadcast();
  final _localEventController =
      StreamController<Map<String, dynamic>>.broadcast();

  /// Exposed connection state stream
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Local event stream for cross-cubit signaling (not from socket).
  /// Used by ChatDetailsCubit to notify ConversationsCubit of
  /// mark-read and message-sent events without a full REST reload.
  Stream<Map<String, dynamic>> get localEventStream =>
      _localEventController.stream;

  /// Emit a local event that other cubits can listen to.
  void emitLocalEvent(Map<String, dynamic> data) {
    if (!_localEventController.isClosed) {
      _localEventController.add(data);
    }
  }

  /// Whether socket is currently connected
  bool get isConnected => _socket?.connected ?? false;

  socket_io.Socket? get socket => _socket;

  // ─── Connection ────────────────────────────────────────────────────────────

  Future<void> connect() async {
    if (_socket?.connected == true || _isConnecting) return;
    _isConnecting = true;

    try {
      final token = _apiClient.getAuthToken();
      if (token == null || token.isEmpty) {
        debugPrint(
          '[RealtimeService] No access token found in ApiClient. Skipping connect.',
        );
        _isConnecting = false;
        return;
      }
      debugPrint(
        '[RealtimeService] Got token, connecting to ${Environment.current.realtimeUrl}',
      );

      final realtimeUrl = Environment.current.realtimeUrl;

      _socket = socket_io.io(
        realtimeUrl,
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
        debugPrint('[RealtimeService] Connected');
        _isConnecting = false;
        _connectionController.add(true);
      });

      _socket!.onDisconnect((_) {
        debugPrint('[RealtimeService] Disconnected');
        _connectionController.add(false);
      });

      _socket!.onConnectError((error) {
        debugPrint('[RealtimeService] Connect error: $error');
        _isConnecting = false;
      });

      _socket!.onError((error) {
        debugPrint('[RealtimeService] Socket error: $error');
      });

      _socket!.onReconnect((_) {
        debugPrint('[RealtimeService] Reconnected');
        _connectionController.add(true);
      });

      // Bind server events to internal broadcast streams
      _bindServerEvents();
    } catch (e, stack) {
      debugPrint('[RealtimeService] Connect exception: $e');
      debugPrintStack(stackTrace: stack);
      _isConnecting = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('[RealtimeService] AppLifecycleState changed to: $state');
    if (state == AppLifecycleState.resumed) {
      _handleAppResumed();
    }
  }

  Future<void> _handleAppResumed() async {
    debugPrint('[RealtimeService] App resumed. Verifying socket connection...');
    // To prevent zombie sockets on emulators, if we were initialized, let's force a clean reconnect.
    // This guarantees the connection is fresh and triggers all Bloc/Cubit listeners to heal.
    if (_socket != null) {
      debugPrint(
        '[RealtimeService] Socket exists. Forcing a clean reconnect to heal any zombie connection.',
      );
      await forceReconnect();
    } else {
      debugPrint(
        '[RealtimeService] Socket was null. Attempting fresh connection.',
      );
      await connect();
    }
  }

  Future<void> forceReconnect() async {
    debugPrint('[RealtimeService] Forcing socket reconnect...');
    disconnect();
    await connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnecting = false;
    debugPrint('[RealtimeService] Disconnected manually');
  }

  // ─── Client Commands ─────────────────────────────────────────────────────

  void joinConversation(
    String conversationId, {
    void Function(dynamic ack)? onAck,
  }) {
    _emitWithAck('communication.chat.conversation.join', {
      'conversationId': conversationId,
    }, ack: onAck);
  }

  void leaveConversation(String conversationId) {
    _emit('communication.chat.conversation.leave', {
      'conversationId': conversationId,
    });
  }

  void startTyping(String conversationId) {
    _emit('communication.typing.start', {'conversationId': conversationId});
  }

  void stopTyping(String conversationId) {
    _emit('communication.typing.stop', {'conversationId': conversationId});
  }

  // ─── Event Streams ─────────────────────────────────────────────────────────

  Stream<dynamic> onMessageCreated() =>
      _eventStream('communication.chat.message.created');
  Stream<dynamic> onMessageUpdated() =>
      _eventStream('communication.chat.message.updated');
  Stream<dynamic> onMessageDeleted() =>
      _eventStream('communication.chat.message.deleted');
  Stream<dynamic> onMessageRead() =>
      _eventStream('communication.chat.message.read');
  Stream<dynamic> onReactionUpserted() =>
      _eventStream('communication.chat.reaction.upserted');
  Stream<dynamic> onReactionDeleted() =>
      _eventStream('communication.chat.reaction.deleted');
  Stream<dynamic> onAttachmentLinked() =>
      _eventStream('communication.chat.attachment.linked');
  Stream<dynamic> onAttachmentDeleted() =>
      _eventStream('communication.chat.attachment.deleted');
  Stream<dynamic> onTypingStarted() =>
      _eventStream('communication.typing.started');
  Stream<dynamic> onTypingStopped() =>
      _eventStream('communication.typing.stopped');
  Stream<dynamic> onPresenceUpdated() =>
      _eventStream('communication.presence.user.updated');

  // ─── Internal Helpers ──────────────────────────────────────────────────────

  void _emit(String event, dynamic data) {
    if (_socket == null || !_socket!.connected) {
      debugPrint('[RealtimeService] Cannot emit $event: socket not connected');
      return;
    }
    _socket!.emit(event, data);
  }

  void _emitWithAck(
    String event,
    dynamic data, {
    void Function(dynamic ack)? ack,
  }) {
    if (_socket == null || !_socket!.connected) {
      debugPrint(
        '[RealtimeService] Cannot emitWithAck $event: socket not connected',
      );
      ack?.call({'ok': false, 'error': 'not_connected'});
      return;
    }
    _socket!.emitWithAck(event, data, ack: ack ?? (_) {});
  }

  Stream<dynamic> _eventStream(String event) {
    if (!_eventControllers.containsKey(event)) {
      _eventControllers[event] = StreamController<dynamic>.broadcast();
    }
    return _eventControllers[event]!.stream;
  }

  void _bindServerEvents() {
    final events = [
      'communication.chat.message.created',
      'communication.chat.message.updated',
      'communication.chat.message.deleted',
      'communication.chat.message.read',
      'communication.chat.reaction.upserted',
      'communication.chat.reaction.deleted',
      'communication.chat.attachment.linked',
      'communication.chat.attachment.deleted',
      'communication.typing.started',
      'communication.typing.stopped',
      'communication.presence.user.updated',
    ];

    for (final event in events) {
      _socket?.on(event, (data) {
        if (_eventControllers.containsKey(event) &&
            !_eventControllers[event]!.isClosed) {
          _eventControllers[event]!.add(data);
        }
      });
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnect();
    for (final controller in _eventControllers.values) {
      controller.close();
    }
    _eventControllers.clear();
    _connectionController.close();
    _localEventController.close();
  }
}
