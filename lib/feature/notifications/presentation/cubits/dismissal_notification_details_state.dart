import '../../../../core/errors/failures/typed_failure.dart';
import '../../data/models/dismissal_notification_model.dart';

sealed class DismissalNotificationDetailsState {
  const DismissalNotificationDetailsState();
}

class DismissalNotificationDetailsLoading
    extends DismissalNotificationDetailsState {
  const DismissalNotificationDetailsLoading();
}

class DismissalNotificationDetailsLoaded
    extends DismissalNotificationDetailsState {
  const DismissalNotificationDetailsLoaded({required this.notification});

  final DismissalNotificationModel notification;
}

class DismissalNotificationDetailsError
    extends DismissalNotificationDetailsState {
  const DismissalNotificationDetailsError(this.failure);

  final TypedFailure failure;
}
