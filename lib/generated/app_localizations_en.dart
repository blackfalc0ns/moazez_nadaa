// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get exit_dialog_title => 'Exit Application';

  @override
  String get exit_dialog_description =>
      'Are you sure you want to close the application?';

  @override
  String get exit_dialog_cancel => 'Cancel';

  @override
  String get exit_dialog_confirm => 'Exit';

  @override
  String get error_no_internet_connection => 'No internet connection';

  @override
  String get error_no_internet_connection_desc =>
      'Please check your internet connection and try again';

  @override
  String get error_connection_timeout => 'Connection timeout';

  @override
  String get error_connection_timeout_desc =>
      'The connection took too long to establish. Please try again';

  @override
  String get error_receive_timeout => 'Receive timeout';

  @override
  String get error_receive_timeout_desc =>
      'The server took too long to respond. Please try again';

  @override
  String get error_send_timeout => 'Send timeout';

  @override
  String get error_send_timeout_desc =>
      'Failed to send data to the server. Please try again';

  @override
  String get error_server_error => 'Server error';

  @override
  String get error_server_error_desc =>
      'Something went wrong on the server. Please try again later';

  @override
  String get error_internal_server_error => 'Internal server error';

  @override
  String get error_internal_server_error_desc =>
      'The server encountered an internal error. Please try again later';

  @override
  String get error_bad_gateway => 'Bad gateway';

  @override
  String get error_bad_gateway_desc =>
      'The server received an invalid response. Please try again later';

  @override
  String get error_service_unavailable => 'Service unavailable';

  @override
  String get error_service_unavailable_desc =>
      'The service is temporarily unavailable. Please try again later';

  @override
  String get error_gateway_timeout => 'Gateway timeout';

  @override
  String get error_gateway_timeout_desc =>
      'The gateway timed out. Please try again later';

  @override
  String get error_bad_request => 'Bad request';

  @override
  String get properties_empty_message_favourite =>
      'You have not added any properties to your favorites.';

  @override
  String get error_bad_request_desc =>
      'The request contains invalid data. Please check your input';

  @override
  String get error_unauthorized => 'Unauthorized';

  @override
  String get error_unauthorized_desc =>
      'You are not authorized to access this resource. Please login again';

  @override
  String get error_forbidden => 'Access denied';

  @override
  String get error_forbidden_desc =>
      'You don\'t have permission to access this resource';

  @override
  String get error_not_found => 'Not found';

  @override
  String get error_not_found_desc => 'The requested resource was not found';

  @override
  String get error_method_not_allowed => 'Method not allowed';

  @override
  String get error_method_not_allowed_desc =>
      'This method is not allowed for this resource';

  @override
  String get error_not_acceptable => 'Not acceptable';

  @override
  String get error_not_acceptable_desc => 'The request is not acceptable';

  @override
  String get error_request_timeout => 'Request timeout';

  @override
  String get error_request_timeout_desc =>
      'The request timed out. Please try again';

  @override
  String get error_conflict => 'Conflict';

  @override
  String get error_conflict_desc =>
      'There is a conflict with the current state of the resource';

  @override
  String get error_gone => 'Resource gone';

  @override
  String get error_gone_desc => 'The requested resource is no longer available';

  @override
  String get error_length_required => 'Length required';

  @override
  String get error_length_required_desc =>
      'The request must specify the content length';

  @override
  String get error_precondition_failed => 'Precondition failed';

  @override
  String get error_precondition_failed_desc =>
      'One or more preconditions failed';

  @override
  String get error_payload_too_large => 'Payload too large';

  @override
  String get error_payload_too_large_desc => 'The request payload is too large';

  @override
  String get error_uri_too_long => 'URI too long';

  @override
  String get error_uri_too_long_desc => 'The request URI is too long';

  @override
  String get lead_send_error =>
      'An error occurred while sending the contact request';

  @override
  String get lead_info_collected => 'Lead information collected successfully';

  @override
  String get lead_offline_mode => 'Contact information saved offline';

  @override
  String get error_unsupported_media_type => 'Unsupported media type';

  @override
  String get error_unsupported_media_type_desc =>
      'The media type is not supported';

  @override
  String get error_range_not_satisfiable => 'Range not satisfiable';

  @override
  String get error_range_not_satisfiable_desc =>
      'The requested range cannot be satisfied';

  @override
  String get error_expectation_failed => 'Expectation failed';

  @override
  String get error_expectation_failed_desc =>
      'The expectation given in the request header field could not be met';

  @override
  String get error_too_many_requests => 'Too many requests';

  @override
  String get error_too_many_requests_desc =>
      'You have sent too many requests. Please try again later';

  @override
  String get error_unknown => 'Unknown error';

  @override
  String get error_unknown_desc =>
      'An unknown error occurred. Please try again';

  @override
  String get error_cancelled => 'Request cancelled';

  @override
  String get error_cancelled_desc => 'The request was cancelled';

  @override
  String get error_other => 'Error occurred';

  @override
  String get error_other_desc => 'An error occurred. Please try again';

  @override
  String get retry => 'Retry';

  @override
  String get contact_support => 'Contact Support';

  @override
  String get go_back => 'Go Back';

  @override
  String get refresh => 'Refresh';

  @override
  String get check_connection => 'Check Connection';

  @override
  String get home => 'Home';

  @override
  String get tablets => 'Table';

  @override
  String get my_classes => 'My Classes';

  @override
  String get homeworks => 'Homeworks';

  @override
  String get messages => 'Messages';

  @override
  String get calls => 'Calls';

  @override
  String get appTitle => 'Moazez Dismissal';

  @override
  String get authLoginTitle => 'Dismissal staff sign in';

  @override
  String get authLoginSubtitle =>
      'Use your school-approved staff account to manage dismissal and handover requests.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailInvalid => 'Enter a valid email address';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordInvalid => 'Password must be at least 6 characters';

  @override
  String get authLoginButton => 'Sign in';

  @override
  String get authStaffOnlyHint =>
      'This portal is only for authorized dismissal staff accounts.';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingDescriptionOne =>
      'Receive guardian calls instantly and track dismissal requests from arrival through safe handover.';

  @override
  String get onboardingDescriptionTwo =>
      'Monitor the waiting queue, each request status, and your assigned gate from one clear operations screen.';

  @override
  String get onboardingDescriptionThree =>
      'Verify the authorized recipient and pickup code, then complete handover with a reliable operational record.';

  @override
  String get settingsHeaderTitle => 'Operations settings';

  @override
  String get settingsHeaderSubtitle =>
      'Control alerts, duty preferences, and student data privacy.';

  @override
  String get settingsNotificationsSound => 'Notifications and sound';

  @override
  String get settingsDismissalNotifications => 'Dismissal notifications';

  @override
  String get settingsDismissalNotificationsSubtitle =>
      'Receive urgent requests and delay alerts';

  @override
  String get settingsUrgentSound => 'Urgent request sound';

  @override
  String get settingsUrgentSoundSubtitle =>
      'Play a distinct sound for critical calls';

  @override
  String get settingsVibration => 'Device vibration';

  @override
  String get settingsVibrationSubtitle => 'Quick alerts during duty';

  @override
  String get settingsOperationsShift => 'Operations and duty';

  @override
  String get settingsShiftMode => 'Duty mode';

  @override
  String get settingsShiftDismissal => 'Dismissal duty';

  @override
  String get settingsShiftMorning => 'Morning duty';

  @override
  String get settingsShiftEvening => 'Evening duty';

  @override
  String get settingsAutoOpenUrgent => 'Open urgent requests automatically';

  @override
  String get settingsAutoOpenUrgentSubtitle =>
      'Navigate directly to a newly received urgent request';

  @override
  String get settingsSyncGates => 'Sync gate data';

  @override
  String get settingsSyncGatesSubtitle =>
      'Reconnect and refresh operational signals';

  @override
  String get settingsSyncSuccess => 'Realtime updates reconnected';

  @override
  String get settingsLanguagePrivacy => 'Language and privacy';

  @override
  String get settingsAppLanguage => 'Application language';

  @override
  String get settingsLanguageArabic => 'Arabic';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsWifiOnly => 'Sync over Wi-Fi only';

  @override
  String get settingsWifiOnlySubtitle => 'Reduce mobile data usage during duty';

  @override
  String get settingsHideSensitive => 'Hide sensitive data';

  @override
  String get settingsHideSensitiveSubtitle =>
      'Partially mask identities and contact details';

  @override
  String get navWaiting => 'Waiting';

  @override
  String get navGates => 'Gates';

  @override
  String get permissionDeniedTitle => 'Access unavailable';

  @override
  String get permissionDeniedDescription =>
      'Your account does not have permission to view this section. Contact the school administration if this is unexpected.';

  @override
  String get drawerDailyWork => 'Daily operations';

  @override
  String get drawerCallsBoard => 'Dismissal board';

  @override
  String get drawerCallsBoardSubtitle => 'Active pickup requests';

  @override
  String get drawerCallsHistory => 'Calls history';

  @override
  String get drawerCallsHistorySubtitle => 'Completed and closed requests';

  @override
  String get drawerGates => 'Gates and duties';

  @override
  String get drawerGatesSubtitle => 'Assigned handover points';

  @override
  String get drawerWaiting => 'Waiting students';

  @override
  String get drawerWaitingSubtitle => 'Students not handed over yet';

  @override
  String get drawerAccountSafety => 'Account and safety';

  @override
  String get drawerProfile => 'Profile';

  @override
  String get drawerProfileSubtitle => 'Staff identity and permissions';

  @override
  String get drawerNotifications => 'Notifications';

  @override
  String get drawerNotificationsSubtitle => 'Urgent requests and delays';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerSettingsSubtitle => 'Sound, language, and notifications';

  @override
  String get drawerSupportLegal => 'Support and legal';

  @override
  String get drawerHelp => 'Help and support';

  @override
  String get drawerHelpSubtitle => 'Contact Moazez support';

  @override
  String get drawerTerms => 'Terms and conditions';

  @override
  String get drawerTermsSubtitle => 'Application usage rules';

  @override
  String get drawerPrivacy => 'Privacy policy';

  @override
  String get drawerPrivacySubtitle => 'Protection of student data';

  @override
  String get drawerLogout => 'Log out';

  @override
  String get dismissalStatusRequested => 'New request';

  @override
  String get dismissalStatusQueued => 'In queue';

  @override
  String get dismissalStatusCalled => 'Called';

  @override
  String get dismissalStatusMoving => 'Moving to gate';

  @override
  String get dismissalStatusAtGate => 'At gate';

  @override
  String get dismissalStatusReady => 'Ready for handover';

  @override
  String get dismissalStatusHandedOver => 'Handed over';

  @override
  String get dismissalStatusCancelled => 'Cancelled';

  @override
  String get dismissalStatusExpired => 'Expired';

  @override
  String get dismissalStatusUnknown => 'Unknown';

  @override
  String get dismissalSuccessNotificationRead => 'Notification marked as read';

  @override
  String get dismissalSuccessAllNotificationsRead =>
      'All notifications marked as read';

  @override
  String get dismissalSuccessStatusUpdated => 'Request status updated';

  @override
  String get dismissalSuccessArrivalConfirmed =>
      'Student arrival at the gate confirmed';

  @override
  String get dismissalSuccessDelivered => 'Student handed over successfully';

  @override
  String get dismissalSuccessEscalated => 'Request escalated to the supervisor';

  @override
  String get dismissalSuccessDeviceRegistered =>
      'Device registered for notifications';

  @override
  String get dismissalSuccessDeviceUnregistered =>
      'Device removed from notifications';

  @override
  String get dismissalFallbackGuardian => 'Guardian';

  @override
  String get dismissalFallbackStudent => 'Student';

  @override
  String get dismissalFallbackGate => 'Gate';

  @override
  String get dismissalFallbackNotification => 'Dismissal notification';

  @override
  String get dismissalUnknownValue => 'Not specified';

  @override
  String get dismissalAll => 'All';

  @override
  String get dismissalAllGates => 'All gates';

  @override
  String get dismissalSearchHint => 'Search by student, guardian, or gate';

  @override
  String get dismissalHistorySearchHint =>
      'Search by student, guardian, or request number';

  @override
  String get dismissalResults => 'Results';

  @override
  String get dismissalWaitingTitle => 'Waiting students';

  @override
  String get dismissalCallsHistoryTitle => 'Calls history';

  @override
  String get dismissalGatesTitle => 'Gates and duties';

  @override
  String get dismissalNotificationsTitle => 'Notifications';

  @override
  String get dismissalProfileTitle => 'Profile';

  @override
  String get dismissalStaffRole => 'Dismissal staff';

  @override
  String get dismissalProfileAssignments => 'Active assignments';

  @override
  String get dismissalProfileAssignedGates => 'Assigned gates';

  @override
  String get dismissalProfileReadiness => 'Operational readiness';

  @override
  String get dismissalProfileReady => 'Ready to operate';

  @override
  String get dismissalProfileNotReady => 'Assignment setup is incomplete';

  @override
  String get dismissalProfilePermissions => 'Granted permissions';

  @override
  String get dismissalProfileNoGates => 'No gate assignments';

  @override
  String get permissionProfileView => 'View staff profile';

  @override
  String get permissionGatesView => 'View assigned gates';

  @override
  String get permissionRequestsView => 'View pickup requests';

  @override
  String get permissionRequestsManage => 'Manage request status';

  @override
  String get permissionRequestsDeliver => 'Verify and hand over students';

  @override
  String get permissionRequestsEscalate => 'Escalate delayed requests';

  @override
  String get permissionHistoryView => 'View calls history';

  @override
  String get permissionNotificationsView => 'View notifications';

  @override
  String get permissionNotificationsManage => 'Manage notification read state';

  @override
  String get permissionDeviceTokensManage => 'Receive device notifications';

  @override
  String get dismissalSettingsTitle => 'Settings';

  @override
  String get dismissalMarkAllRead => 'Mark all as read';

  @override
  String get dismissalMarkRead => 'Mark as read';

  @override
  String get dismissalEscalate => 'Escalate';

  @override
  String get dismissalConfirmArrival => 'Confirm arrival';

  @override
  String get dismissalArrivalConfirmed => 'Arrival confirmed';

  @override
  String get dismissalWaitingList => 'Waiting list';

  @override
  String get dismissalGateField => 'Gate';

  @override
  String get dismissalDeliver => 'Verify and hand over';

  @override
  String get dismissalQueueAction => 'Add to queue';

  @override
  String get dismissalCallAction => 'Call student';

  @override
  String get dismissalMovingAction => 'Start moving';

  @override
  String get dismissalAtGateAction => 'Reached gate';

  @override
  String get dismissalReadyAction => 'Ready for handover';

  @override
  String get dismissalUrgent => 'Urgent';

  @override
  String get dismissalDelayed => 'Delayed';

  @override
  String dismissalWaitMinutes(num minutes) {
    return 'Waiting $minutes min';
  }

  @override
  String get dismissalActive => 'Active';

  @override
  String get dismissalOpen => 'Open';

  @override
  String get dismissalBusy => 'Busy';

  @override
  String get dismissalClosed => 'Closed';

  @override
  String get dismissalMaintenance => 'Maintenance';

  @override
  String get dismissalTotal => 'Total';

  @override
  String get dismissalUnread => 'Unread';

  @override
  String get dismissalCritical => 'Critical';

  @override
  String get dismissalDelivered => 'Delivered';

  @override
  String get dismissalCancelled => 'Cancelled';

  @override
  String get dismissalExpired => 'Expired';

  @override
  String get dismissalNoActiveRequests => 'No active pickup requests';

  @override
  String get dismissalNoWaitingStudents =>
      'No students are waiting at the moment';

  @override
  String get dismissalNoHistory => 'No requests match the selected filters';

  @override
  String get dismissalNoNotifications => 'No notifications are available';

  @override
  String get dismissalNoNotificationsBody =>
      'New operational notifications will appear here when received.';

  @override
  String get dismissalNoWaitingStudentsBody =>
      'Waiting requests will appear here once they move into the calling stage.';

  @override
  String get dismissalCallsSubtitle => 'Active dismissal requests now';

  @override
  String dismissalLiveCount(int count) {
    return '$count live';
  }

  @override
  String get dismissalWaiting => 'Waiting';

  @override
  String get dismissalProcessing => 'Processing...';

  @override
  String get dismissalQueueTitle => 'Dismissal queue';

  @override
  String get dismissalNoActiveRequestsBody =>
      'New guardian pickup requests will appear here immediately for operational follow-up.';

  @override
  String dismissalDeliverStudent(String name) {
    return 'Hand over $name';
  }

  @override
  String get dismissalDeliveryInstruction =>
      'Verify the recipient and pickup code before completing handover.';

  @override
  String get dismissalAuthorizedRecipient => 'Authorized recipient';

  @override
  String get dismissalPickupCode => 'Pickup code';

  @override
  String get dismissalOptionalNote => 'Optional note';

  @override
  String get dismissalProcessingDelivery => 'Completing handover...';

  @override
  String get dismissalConfirmDelivery => 'Confirm handover';

  @override
  String get dismissalRequestDetailsTitle => 'Dismissal request details';

  @override
  String get dismissalStudentDetails => 'Student details';

  @override
  String get dismissalStudentName => 'Student name';

  @override
  String get dismissalClass => 'Grade and class';

  @override
  String get dismissalPickupDetails => 'Pickup details';

  @override
  String get dismissalGuardianName => 'Guardian';

  @override
  String get dismissalWaitLabel => 'Waiting time';

  @override
  String get dismissalOperationDetails => 'Operation details';

  @override
  String get dismissalRequestNumber => 'Request number';

  @override
  String get dismissalRequestedAt => 'Request time';

  @override
  String get dismissalUpdatedAt => 'Last update';

  @override
  String get dismissalUnreadOnly => 'Show unread notifications only';

  @override
  String get dismissalNotificationsList => 'Notifications list';

  @override
  String dismissalNotificationsCount(num count) {
    return '$count notifications';
  }

  @override
  String get dismissalPriorityImportant => 'Important';

  @override
  String get dismissalPriorityNormal => 'Normal';

  @override
  String get dismissalNoGates => 'No gates are assigned to this account';

  @override
  String get dismissalGatesSectionTitle => 'Gate status now';

  @override
  String get dismissalGatesSectionSubtitle =>
      'Monitor assigned handover points and available waiting zones.';

  @override
  String dismissalAssignmentsCount(int count) {
    return '$count assignments';
  }

  @override
  String get dismissalNoGatesTitle => 'No gates available';

  @override
  String get dismissalNoGatesBody =>
      'Gates will appear here once enabled by administration.';

  @override
  String get dismissalOperationalAssignmentsNote =>
      'Duties are shown from the staff profile assignments and the recorded operational gate status.';

  @override
  String get dismissalInactive => 'Inactive';

  @override
  String get dismissalLocationConfigured => 'Location configured';

  @override
  String get dismissalGateDetailsUnavailable => 'Gate details unavailable';

  @override
  String get dismissalRetry => 'Try again';

  @override
  String get dismissalNoAuthorizedRecipient =>
      'No authorized recipient is available for this request yet.';

  @override
  String get dismissalPickupCodeRequired =>
      'Enter the pickup code before handover.';

  @override
  String dismissalNoActionForStatus(String status) {
    return 'No action is available for this status: $status';
  }

  @override
  String dismissalRequestsCount(num count) {
    return '$count requests';
  }

  @override
  String dismissalStudentsCount(num count) {
    return '$count students';
  }

  @override
  String dismissalOperationsCount(num count) {
    return '$count operations';
  }

  @override
  String get dismissalLastUpdateUnknown => 'Last update unavailable';

  @override
  String dismissalLastUpdate(String value) {
    return 'Last update $value';
  }

  @override
  String get snackbarSuccessTitle => 'Success';

  @override
  String get snackbarErrorTitle => 'Error';

  @override
  String get snackbarWarningTitle => 'Warning';

  @override
  String get snackbarInfoTitle => 'Information';

  @override
  String get errorNetwork => 'No internet connection';

  @override
  String get errorNetworkAction => 'Check your internet connection';

  @override
  String get errorTimeout => 'Request timeout';

  @override
  String get errorServer => 'Server error. Please try again later';

  @override
  String get errorServerActionRetry => 'Try again later';

  @override
  String get errorServerActionContact => 'Contact support';

  @override
  String get errorInvalidCredentials => 'Invalid email or password';

  @override
  String get errorUnauthorizedAction => 'Please check your email and password';

  @override
  String get errorForbidden => 'Access denied';

  @override
  String get errorForbiddenAction => 'You don\'t have permission';

  @override
  String get errorNotFound => 'Resource not found';

  @override
  String get errorNotFoundAction => 'Resource not found';

  @override
  String get errorValidation => 'Validation error';

  @override
  String get errorValidationAction => 'Check your inputs';

  @override
  String get errorTokenExpired => 'Your session has expired';

  @override
  String get errorTokenExpiredAction => 'Refreshing session...';

  @override
  String get errorUnknown => 'An unexpected error occurred';

  @override
  String get tryAgain => 'Try again';

  @override
  String get auth_change_password_mismatch => 'Passwords do not match';

  @override
  String get auth_change_password_same_as_old =>
      'New password must be different from the current password';

  @override
  String get auth_change_password_success => 'Password changed successfully';

  @override
  String get auth_change_password_title => 'Change password';

  @override
  String get auth_change_password_mandatory_subtitle =>
      'You must change your temporary password before continuing.';

  @override
  String get auth_change_password_optional_subtitle =>
      'Update your password to keep your account secure.';

  @override
  String get auth_change_password_current => 'Current password';

  @override
  String get auth_change_password_new => 'New password';

  @override
  String get auth_change_password_rules =>
      'Use at least 8 characters with uppercase, lowercase, number, and symbol.';

  @override
  String get auth_change_password_hint =>
      'Use a strong password that differs from the temporary one.';

  @override
  String get auth_change_password_confirm => 'Confirm password';

  @override
  String get auth_change_password_save => 'Save password';

  @override
  String get auth_login_success => 'Signed in successfully';

  @override
  String get auth_logout_success => 'Signed out successfully';

  @override
  String get auth_remember_me => 'Remember me';
}
