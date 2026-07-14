import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/realtime/realtime_service.dart';
import '../../../../core/services/notifications/push_token_lifecycle.dart';
import '../../data/mappers/dismissal_notification_mapper.dart';
import '../../data/repo/dismissal_notifications_repo.dart';
import 'dismissal_notifications_state.dart';

export 'dismissal_notifications_state.dart';

class DismissalNotificationsCubit extends Cubit<DismissalNotificationsState> {
  DismissalNotificationsCubit({
    required DismissalNotificationsRepo repo,
    required RealtimeService realtime,
    required PushTokenLifecycle pushTokenLifecycle,
  }) : _repo = repo,
       _realtime = realtime,
       _pushTokenLifecycle = pushTokenLifecycle,
       super(const DismissalNotificationsState()) {
    unawaited(_realtime.connect());
    _realtimeSubscription = _realtime.dismissalEvents
        .where((event) => event.affectsNotifications)
        .listen((_) => _scheduleAuthoritativeRefresh());
    _pushSubscription = _pushTokenLifecycle.notificationHints.listen(
      (_) => _scheduleAuthoritativeRefresh(),
    );
  }

  final DismissalNotificationsRepo _repo;
  final RealtimeService _realtime;
  final PushTokenLifecycle _pushTokenLifecycle;
  StreamSubscription<dynamic>? _realtimeSubscription;
  StreamSubscription<void>? _pushSubscription;
  Timer? _refreshDebounce;

  Future<void> load({bool refresh = false}) async {
    if (state.isLoading || state.isLoadingMore) return;
    emit(
      state.copyWith(isLoading: true, clearFailure: true, clearSuccess: true),
    );
    await _loadFirstPage();
  }

  Future<void> _loadFirstPage({String? successKey}) async {
    final listResult = await _repo.list(
      status: state.selectedStatus,
      type: state.selectedType,
    );
    final summaryResult = await _repo.summary();
    if (isClosed) return;

    listResult.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          isActionLoading: false,
          failure: failure,
        ),
      ),
      (notifications) => emit(
        state.copyWith(
          isLoading: false,
          isActionLoading: false,
          notifications: notifications,
          summary: summaryResult.fold(
            (_) => DismissalNotificationMapper.reconcileSummary(
              state.summary,
              notifications,
            ),
            (value) => DismissalNotificationMapper.reconcileSummary(
              value,
              notifications,
            ),
          ),
          successKey: successKey,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.notifications.canLoadMore) return;
    emit(state.copyWith(isLoadingMore: true, clearFailure: true));
    final result = await _repo.list(
      page: state.notifications.nextPage ?? 1,
      status: state.selectedStatus,
      type: state.selectedType,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false, failure: failure)),
      (page) => emit(
        state.copyWith(
          isLoadingMore: false,
          notifications: page.copyWith(
            items: [...state.notifications.items, ...page.items],
          ),
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> changeStatus(String value) async {
    if (state.selectedStatus == value) return;
    emit(state.copyWith(selectedStatus: value));
    await load(refresh: true);
  }

  Future<void> changeType(String value) async {
    if (state.selectedType == value) return;
    emit(state.copyWith(selectedType: value));
    await load(refresh: true);
  }

  Future<void> markRead(String id) async {
    if (state.isActionLoading) return;
    emit(state.copyWith(isActionLoading: true, clearFailure: true));
    final result = await _repo.markRead(id);
    if (isClosed) return;
    await result.fold(
      (failure) async =>
          emit(state.copyWith(isActionLoading: false, failure: failure)),
      (_) => _loadFirstPage(successKey: 'notifications_marked_read'),
    );
  }

  Future<void> markAllRead() async {
    if (state.isActionLoading || state.summary.unreadCount == 0) return;
    emit(state.copyWith(isActionLoading: true, clearFailure: true));
    final result = await _repo.markAllRead();
    if (isClosed) return;
    await result.fold(
      (failure) async =>
          emit(state.copyWith(isActionLoading: false, failure: failure)),
      (_) => _loadFirstPage(successKey: 'notifications_all_marked_read'),
    );
  }

  void clearFeedback() {
    emit(state.copyWith(clearFailure: true, clearSuccess: true));
  }

  void _scheduleAuthoritativeRefresh() {
    if (isClosed) return;
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!isClosed && !state.isLoading && !state.isActionLoading) {
        unawaited(_loadFirstPage());
      }
    });
  }

  @override
  Future<void> close() async {
    _refreshDebounce?.cancel();
    await _realtimeSubscription?.cancel();
    await _pushSubscription?.cancel();
    return super.close();
  }
}
