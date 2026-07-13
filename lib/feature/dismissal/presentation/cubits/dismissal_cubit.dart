import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures/typed_failure.dart';
import '../../../../core/realtime/realtime_service.dart';
import '../../data/models/dismissal_models.dart';
import '../../data/repositories/dismissal_repo.dart';
import 'dismissal_state.dart';

class DismissalCubit extends Cubit<DismissalState> {
  DismissalCubit({
    required DismissalRepo repo,
    required RealtimeService realtimeService,
  }) : _repo = repo,
       _realtimeService = realtimeService,
       super(const DismissalState()) {
    _eventSubscription = _realtimeService.dismissalEvents.listen(
      _onRealtimeEvent,
    );
    _connectionSubscription = _realtimeService.connectionStream.listen((
      connected,
    ) {
      if (connected) _scheduleCanonicalRefresh();
    });
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 25),
      (_) => _refreshLoadedSurfaces(),
    );
  }

  final DismissalRepo _repo;
  final RealtimeService _realtimeService;
  StreamSubscription<DismissalRealtimeEvent>? _eventSubscription;
  StreamSubscription<bool>? _connectionSubscription;
  Timer? _refreshDebounce;
  Timer? _pollingTimer;

  Future<void> loadDashboard() async {
    await Future.wait([loadProfile(), loadGates(), loadQueue()]);
  }

  Future<void> loadProfile() async {
    final result = await _repo.getProfileSafe();
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (profile) => emit(state.copyWith(profile: profile, clearFailure: true)),
    );
  }

  Future<void> loadQueue({
    DismissalRequestStatus? status,
    String? gateId,
  }) async {
    emit(
      state.copyWith(
        isLoadingQueue: true,
        clearFailure: true,
        clearActionFailure: true,
      ),
    );
    final result = await _repo.getActiveQueueSafe(
      status: status,
      gateId: gateId,
    );
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingQueue: false, failure: failure)),
      (queue) => emit(
        state.copyWith(queue: queue, isLoadingQueue: false, clearFailure: true),
      ),
    );
  }

  Future<void> loadRequestDetails(
    String requestId, {
    bool fromHistory = false,
  }) async {
    emit(
      state.copyWith(
        isLoadingDetails: true,
        clearFailure: true,
        clearRequestDetails: true,
      ),
    );
    final result = fromHistory
        ? await _repo.getHistoryRequestSafe(requestId)
        : await _repo.getRequestSafe(requestId);
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingDetails: false, failure: failure)),
      (request) => emit(
        state.copyWith(
          requestDetails: request,
          isLoadingDetails: false,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> loadWaiting({String? gateId}) async {
    emit(
      state.copyWith(
        isLoadingWaiting: true,
        clearFailure: true,
        clearActionFailure: true,
      ),
    );
    final result = await _repo.getWaitingStudentsSafe(gateId: gateId);
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingWaiting: false, failure: failure)),
      (waiting) => emit(
        state.copyWith(
          waiting: waiting,
          isLoadingWaiting: false,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> loadGates() async {
    emit(state.copyWith(isLoadingGates: true, clearFailure: true));
    final result = await _repo.getGatesSafe();
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingGates: false, failure: failure)),
      (gates) => emit(
        state.copyWith(gates: gates, isLoadingGates: false, clearFailure: true),
      ),
    );
  }

  Future<void> loadHistory({
    DismissalRequestStatus? status,
    String? gateId,
  }) async {
    emit(
      state.copyWith(
        isLoadingHistory: true,
        clearFailure: true,
        clearActionFailure: true,
      ),
    );
    final result = await _repo.getHistorySafe(status: status, gateId: gateId);
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingHistory: false, failure: failure)),
      (history) => emit(
        state.copyWith(
          history: history,
          isLoadingHistory: false,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> loadNotifications({bool unreadOnly = false}) async {
    emit(
      state.copyWith(
        isLoadingNotifications: true,
        clearFailure: true,
        clearActionFailure: true,
      ),
    );
    final result = await _repo.getNotificationsSafe(unreadOnly: unreadOnly);
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingNotifications: false, failure: failure)),
      (notifications) => emit(
        state.copyWith(
          notifications: notifications,
          isLoadingNotifications: false,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> markNotificationRead(String notificationId) async {
    if (notificationId.isEmpty) return;
    _startAction();
    final result = await _repo.markNotificationReadSafe(notificationId);
    if (isClosed) return;
    await result.fold((failure) async => _failAction(failure), (_) async {
      _completeAction(DismissalSuccess.notificationRead);
      await loadNotifications();
    });
  }

  Future<void> markAllNotificationsRead() async {
    _startAction();
    final result = await _repo.markAllNotificationsReadSafe();
    if (isClosed) return;
    await result.fold((failure) async => _failAction(failure), (_) async {
      _completeAction(DismissalSuccess.allNotificationsRead);
      await loadNotifications();
    });
  }

  Future<void> transitionRequest({
    required String requestId,
    required DismissalRequestStatus status,
    String? note,
  }) async {
    _startAction();
    final result = await _repo.updateStatusSafe(
      requestId: requestId,
      status: status,
      note: note,
    );
    if (isClosed) return;
    await result.fold((failure) async => _failAction(failure), (_) async {
      _completeAction(DismissalSuccess.statusUpdated);
      await Future.wait([loadQueue(), loadWaiting()]);
    });
  }

  Future<void> confirmArrival(String requestId) async {
    _startAction();
    final result = await _repo.confirmArrivalSafe(requestId: requestId);
    if (isClosed) return;
    await result.fold((failure) async => _failAction(failure), (_) async {
      _completeAction(DismissalSuccess.arrivalConfirmed);
      await Future.wait([loadQueue(), loadWaiting()]);
    });
  }

  Future<DismissalRecipientsModel?> loadRecipients(String requestId) async {
    emit(
      state.copyWith(
        isProcessing: true,
        clearActionFailure: true,
        clearRecipients: true,
      ),
    );
    final result = await _repo.getRecipientsSafe(requestId);
    if (isClosed) return null;
    return result.fold(
      (failure) {
        _failAction(failure);
        return null;
      },
      (recipients) {
        emit(
          state.copyWith(
            recipients: recipients,
            isProcessing: false,
            clearActionFailure: true,
          ),
        );
        return recipients;
      },
    );
  }

  Future<void> deliver({
    required String requestId,
    required String pickupRecipientToken,
    required String pickupCode,
    String? note,
  }) async {
    _startAction();
    final result = await _repo.deliverSafe(
      requestId: requestId,
      pickupRecipientToken: pickupRecipientToken,
      pickupCode: pickupCode,
      note: note,
    );
    if (isClosed) return;
    await result.fold((failure) async => _failAction(failure), (_) async {
      emit(
        state.copyWith(
          isProcessing: false,
          success: DismissalSuccess.delivered,
          clearActionFailure: true,
          clearRecipients: true,
        ),
      );
      await Future.wait([loadQueue(), loadWaiting()]);
    });
  }

  Future<void> escalate(String requestId) async {
    _startAction();
    final result = await _repo.escalateSafe(
      requestId: requestId,
      reason: 'parent_waiting',
      message: 'Parent has waited too long',
    );
    if (isClosed) return;
    await result.fold((failure) async => _failAction(failure), (_) async {
      _completeAction(DismissalSuccess.escalated);
      await loadQueue();
    });
  }

  Future<void> registerDeviceToken({
    required String token,
    required String platform,
    String? deviceId,
    String? deviceName,
  }) async {
    final result = await _repo.registerDeviceTokenSafe(
      token: token,
      platform: platform,
      deviceId: deviceId,
      deviceName: deviceName,
    );
    if (isClosed) return;
    result.fold(
      _failAction,
      (_) => _completeAction(DismissalSuccess.deviceRegistered),
    );
  }

  Future<void> unregisterDeviceToken(String token) async {
    final result = await _repo.unregisterCurrentDeviceTokenSafe(token: token);
    if (isClosed) return;
    result.fold(
      _failAction,
      (_) => _completeAction(DismissalSuccess.deviceUnregistered),
    );
  }

  void _startAction() {
    emit(
      state.copyWith(
        isProcessing: true,
        clearActionFailure: true,
        clearSuccess: true,
      ),
    );
  }

  void _completeAction(DismissalSuccess success) {
    emit(
      state.copyWith(
        isProcessing: false,
        success: success,
        clearActionFailure: true,
      ),
    );
  }

  void _failAction(TypedFailure failure) {
    emit(state.copyWith(isProcessing: false, actionFailure: failure));
  }

  void _onRealtimeEvent(DismissalRealtimeEvent event) {
    if (event.affectsQueue || event.affectsNotifications) {
      _scheduleCanonicalRefresh();
    }
  }

  void _scheduleCanonicalRefresh() {
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(
      const Duration(milliseconds: 450),
      _refreshLoadedSurfaces,
    );
  }

  Future<void> _refreshLoadedSurfaces() async {
    if (isClosed) return;
    final operations = <Future<void>>[
      if (state.queue != null) loadQueue(),
      if (state.waiting != null) loadWaiting(),
      if (state.gates != null) loadGates(),
      if (state.history != null) loadHistory(),
      if (state.notifications != null) loadNotifications(),
    ];
    if (operations.isNotEmpty) await Future.wait(operations);
  }

  @override
  Future<void> close() async {
    _refreshDebounce?.cancel();
    _pollingTimer?.cancel();
    await _eventSubscription?.cancel();
    await _connectionSubscription?.cancel();
    return super.close();
  }
}
