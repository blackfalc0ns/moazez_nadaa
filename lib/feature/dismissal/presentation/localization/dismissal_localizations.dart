import '../../../../generated/app_localizations.dart';
import '../../data/models/dismissal_models.dart';
import '../cubits/dismissal_state.dart';

extension DismissalStatusLocalization on DismissalRequestStatus {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case DismissalRequestStatus.requested:
        return l10n.dismissalStatusRequested;
      case DismissalRequestStatus.queued:
        return l10n.dismissalStatusQueued;
      case DismissalRequestStatus.called:
        return l10n.dismissalStatusCalled;
      case DismissalRequestStatus.moving:
        return l10n.dismissalStatusMoving;
      case DismissalRequestStatus.atGate:
        return l10n.dismissalStatusAtGate;
      case DismissalRequestStatus.ready:
        return l10n.dismissalStatusReady;
      case DismissalRequestStatus.handedOver:
        return l10n.dismissalStatusHandedOver;
      case DismissalRequestStatus.cancelled:
        return l10n.dismissalStatusCancelled;
      case DismissalRequestStatus.expired:
        return l10n.dismissalStatusExpired;
      case DismissalRequestStatus.unknown:
        return l10n.dismissalStatusUnknown;
    }
  }
}

extension DismissalSuccessLocalization on DismissalSuccess {
  String localizedMessage(AppLocalizations l10n) {
    switch (this) {
      case DismissalSuccess.notificationRead:
        return l10n.dismissalSuccessNotificationRead;
      case DismissalSuccess.allNotificationsRead:
        return l10n.dismissalSuccessAllNotificationsRead;
      case DismissalSuccess.statusUpdated:
        return l10n.dismissalSuccessStatusUpdated;
      case DismissalSuccess.arrivalConfirmed:
        return l10n.dismissalSuccessArrivalConfirmed;
      case DismissalSuccess.delivered:
        return l10n.dismissalSuccessDelivered;
      case DismissalSuccess.escalated:
        return l10n.dismissalSuccessEscalated;
      case DismissalSuccess.deviceRegistered:
        return l10n.dismissalSuccessDeviceRegistered;
      case DismissalSuccess.deviceUnregistered:
        return l10n.dismissalSuccessDeviceUnregistered;
    }
  }
}
