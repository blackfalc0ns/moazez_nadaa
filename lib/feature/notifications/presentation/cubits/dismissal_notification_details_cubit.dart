import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/dismissal_notification_model.dart';
import '../../data/repo/dismissal_notifications_repo.dart';
import 'dismissal_notification_details_state.dart';

export 'dismissal_notification_details_state.dart';

class DismissalNotificationDetailsCubit
    extends Cubit<DismissalNotificationDetailsState> {
  DismissalNotificationDetailsCubit({required DismissalNotificationsRepo repo})
    : _repo = repo,
      super(const DismissalNotificationDetailsLoading());

  final DismissalNotificationsRepo _repo;

  Future<void> load({
    required DismissalNotificationModel initial,
    required bool canMarkRead,
  }) async {
    final detailResult = await _repo.detail(initial);
    if (isClosed) return;
    await detailResult.fold(
      (failure) async => emit(DismissalNotificationDetailsError(failure)),
      (detail) async {
        if (canMarkRead && !detail.isRead) {
          final readResult = await _repo.markRead(detail.id);
          if (isClosed) return;
          readResult.fold(
            (_) => emit(
              DismissalNotificationDetailsLoaded(
                notification: detail.markRead(),
              ),
            ),
            (updated) =>
                emit(DismissalNotificationDetailsLoaded(notification: updated)),
          );
          return;
        }
        emit(DismissalNotificationDetailsLoaded(notification: detail));
      },
    );
  }
}
