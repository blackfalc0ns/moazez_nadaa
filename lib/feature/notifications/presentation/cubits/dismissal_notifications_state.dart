import '../../../../core/errors/failures/typed_failure.dart';
import '../../../../core/pagination/paginated_list.dart';
import '../../data/models/dismissal_notification_model.dart';

class DismissalNotificationsState {
  const DismissalNotificationsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isActionLoading = false,
    this.selectedStatus = 'all',
    this.selectedType = 'all',
    this.notifications = const PaginatedList<DismissalNotificationModel>(
      items: [],
      currentPage: 1,
      totalPages: 1,
      totalItems: 0,
      itemsPerPage: 20,
    ),
    this.summary = DismissalNotificationsSummary.empty,
    this.failure,
    this.successKey,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final bool isActionLoading;
  final String selectedStatus;
  final String selectedType;
  final PaginatedList<DismissalNotificationModel> notifications;
  final DismissalNotificationsSummary summary;
  final TypedFailure? failure;
  final String? successKey;

  DismissalNotificationsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isActionLoading,
    String? selectedStatus,
    String? selectedType,
    PaginatedList<DismissalNotificationModel>? notifications,
    DismissalNotificationsSummary? summary,
    TypedFailure? failure,
    bool clearFailure = false,
    String? successKey,
    bool clearSuccess = false,
  }) {
    return DismissalNotificationsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedType: selectedType ?? this.selectedType,
      notifications: notifications ?? this.notifications,
      summary: summary ?? this.summary,
      failure: clearFailure ? null : failure ?? this.failure,
      successKey: clearSuccess ? null : successKey ?? this.successKey,
    );
  }
}
