import '../../../../core/errors/failures/typed_failure.dart';
import '../../data/models/dismissal_models.dart';

enum DismissalSuccess {
  notificationRead,
  allNotificationsRead,
  statusUpdated,
  arrivalConfirmed,
  delivered,
  escalated,
  deviceRegistered,
  deviceUnregistered,
}

class DismissalState {
  const DismissalState({
    this.isLoadingQueue = false,
    this.isLoadingGates = false,
    this.isLoadingWaiting = false,
    this.isLoadingHistory = false,
    this.isLoadingNotifications = false,
    this.isLoadingDetails = false,
    this.isProcessing = false,
    this.queue,
    this.gates,
    this.waiting,
    this.history,
    this.notifications,
    this.profile,
    this.requestDetails,
    this.recipients,
    this.failure,
    this.actionFailure,
    this.success,
  });

  final bool isLoadingQueue;
  final bool isLoadingGates;
  final bool isLoadingWaiting;
  final bool isLoadingHistory;
  final bool isLoadingNotifications;
  final bool isLoadingDetails;
  final bool isProcessing;
  final DismissalQueuePageModel? queue;
  final DismissalGatesPageModel? gates;
  final DismissalQueuePageModel? waiting;
  final DismissalQueuePageModel? history;
  final DismissalNotificationsPageModel? notifications;
  final DismissalProfileModel? profile;
  final DismissalRequestModel? requestDetails;
  final DismissalRecipientsModel? recipients;
  final TypedFailure? failure;
  final TypedFailure? actionFailure;
  final DismissalSuccess? success;

  DismissalState copyWith({
    bool? isLoadingQueue,
    bool? isLoadingGates,
    bool? isLoadingWaiting,
    bool? isLoadingHistory,
    bool? isLoadingNotifications,
    bool? isLoadingDetails,
    bool? isProcessing,
    DismissalQueuePageModel? queue,
    DismissalGatesPageModel? gates,
    DismissalQueuePageModel? waiting,
    DismissalQueuePageModel? history,
    DismissalNotificationsPageModel? notifications,
    DismissalProfileModel? profile,
    DismissalRequestModel? requestDetails,
    DismissalRecipientsModel? recipients,
    TypedFailure? failure,
    TypedFailure? actionFailure,
    DismissalSuccess? success,
    bool clearFailure = false,
    bool clearActionFailure = false,
    bool clearSuccess = false,
    bool clearRequestDetails = false,
    bool clearRecipients = false,
  }) {
    return DismissalState(
      isLoadingQueue: isLoadingQueue ?? this.isLoadingQueue,
      isLoadingGates: isLoadingGates ?? this.isLoadingGates,
      isLoadingWaiting: isLoadingWaiting ?? this.isLoadingWaiting,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      isLoadingNotifications:
          isLoadingNotifications ?? this.isLoadingNotifications,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      isProcessing: isProcessing ?? this.isProcessing,
      queue: queue ?? this.queue,
      gates: gates ?? this.gates,
      waiting: waiting ?? this.waiting,
      history: history ?? this.history,
      notifications: notifications ?? this.notifications,
      profile: profile ?? this.profile,
      requestDetails: clearRequestDetails
          ? null
          : requestDetails ?? this.requestDetails,
      recipients: clearRecipients ? null : recipients ?? this.recipients,
      failure: clearFailure ? null : failure ?? this.failure,
      actionFailure: clearActionFailure
          ? null
          : actionFailure ?? this.actionFailure,
      success: clearSuccess ? null : success ?? this.success,
    );
  }
}
