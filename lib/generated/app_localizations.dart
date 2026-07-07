import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @error_no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get error_no_internet_connection;

  /// No description provided for @error_no_internet_connection_desc.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again'**
  String get error_no_internet_connection_desc;

  /// No description provided for @error_connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get error_connection_timeout;

  /// No description provided for @error_connection_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The connection took too long to establish. Please try again'**
  String get error_connection_timeout_desc;

  /// No description provided for @error_receive_timeout.
  ///
  /// In en, this message translates to:
  /// **'Receive timeout'**
  String get error_receive_timeout;

  /// No description provided for @error_receive_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Please try again'**
  String get error_receive_timeout_desc;

  /// No description provided for @error_send_timeout.
  ///
  /// In en, this message translates to:
  /// **'Send timeout'**
  String get error_send_timeout;

  /// No description provided for @error_send_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'Failed to send data to the server. Please try again'**
  String get error_send_timeout_desc;

  /// No description provided for @error_server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get error_server_error;

  /// No description provided for @error_server_error_desc.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on the server. Please try again later'**
  String get error_server_error_desc;

  /// No description provided for @error_internal_server_error.
  ///
  /// In en, this message translates to:
  /// **'Internal server error'**
  String get error_internal_server_error;

  /// No description provided for @error_internal_server_error_desc.
  ///
  /// In en, this message translates to:
  /// **'The server encountered an internal error. Please try again later'**
  String get error_internal_server_error_desc;

  /// No description provided for @error_bad_gateway.
  ///
  /// In en, this message translates to:
  /// **'Bad gateway'**
  String get error_bad_gateway;

  /// No description provided for @error_bad_gateway_desc.
  ///
  /// In en, this message translates to:
  /// **'The server received an invalid response. Please try again later'**
  String get error_bad_gateway_desc;

  /// No description provided for @error_service_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get error_service_unavailable;

  /// No description provided for @error_service_unavailable_desc.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable. Please try again later'**
  String get error_service_unavailable_desc;

  /// No description provided for @error_gateway_timeout.
  ///
  /// In en, this message translates to:
  /// **'Gateway timeout'**
  String get error_gateway_timeout;

  /// No description provided for @error_gateway_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The gateway timed out. Please try again later'**
  String get error_gateway_timeout_desc;

  /// No description provided for @error_bad_request.
  ///
  /// In en, this message translates to:
  /// **'Bad request'**
  String get error_bad_request;

  /// No description provided for @properties_empty_message_favourite.
  ///
  /// In en, this message translates to:
  /// **'You have not added any properties to your favorites.'**
  String get properties_empty_message_favourite;

  /// No description provided for @error_bad_request_desc.
  ///
  /// In en, this message translates to:
  /// **'The request contains invalid data. Please check your input'**
  String get error_bad_request_desc;

  /// No description provided for @error_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get error_unauthorized;

  /// No description provided for @error_unauthorized_desc.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to access this resource. Please login again'**
  String get error_unauthorized_desc;

  /// No description provided for @error_forbidden.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get error_forbidden;

  /// No description provided for @error_forbidden_desc.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to access this resource'**
  String get error_forbidden_desc;

  /// No description provided for @error_not_found.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get error_not_found;

  /// No description provided for @error_not_found_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found'**
  String get error_not_found_desc;

  /// No description provided for @error_method_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Method not allowed'**
  String get error_method_not_allowed;

  /// No description provided for @error_method_not_allowed_desc.
  ///
  /// In en, this message translates to:
  /// **'This method is not allowed for this resource'**
  String get error_method_not_allowed_desc;

  /// No description provided for @error_not_acceptable.
  ///
  /// In en, this message translates to:
  /// **'Not acceptable'**
  String get error_not_acceptable;

  /// No description provided for @error_not_acceptable_desc.
  ///
  /// In en, this message translates to:
  /// **'The request is not acceptable'**
  String get error_not_acceptable_desc;

  /// No description provided for @error_request_timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get error_request_timeout;

  /// No description provided for @error_request_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Please try again'**
  String get error_request_timeout_desc;

  /// No description provided for @error_conflict.
  ///
  /// In en, this message translates to:
  /// **'Conflict'**
  String get error_conflict;

  /// No description provided for @error_conflict_desc.
  ///
  /// In en, this message translates to:
  /// **'There is a conflict with the current state of the resource'**
  String get error_conflict_desc;

  /// No description provided for @error_gone.
  ///
  /// In en, this message translates to:
  /// **'Resource gone'**
  String get error_gone;

  /// No description provided for @error_gone_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested resource is no longer available'**
  String get error_gone_desc;

  /// No description provided for @error_length_required.
  ///
  /// In en, this message translates to:
  /// **'Length required'**
  String get error_length_required;

  /// No description provided for @error_length_required_desc.
  ///
  /// In en, this message translates to:
  /// **'The request must specify the content length'**
  String get error_length_required_desc;

  /// No description provided for @error_precondition_failed.
  ///
  /// In en, this message translates to:
  /// **'Precondition failed'**
  String get error_precondition_failed;

  /// No description provided for @error_precondition_failed_desc.
  ///
  /// In en, this message translates to:
  /// **'One or more preconditions failed'**
  String get error_precondition_failed_desc;

  /// No description provided for @error_payload_too_large.
  ///
  /// In en, this message translates to:
  /// **'Payload too large'**
  String get error_payload_too_large;

  /// No description provided for @error_payload_too_large_desc.
  ///
  /// In en, this message translates to:
  /// **'The request payload is too large'**
  String get error_payload_too_large_desc;

  /// No description provided for @error_uri_too_long.
  ///
  /// In en, this message translates to:
  /// **'URI too long'**
  String get error_uri_too_long;

  /// No description provided for @error_uri_too_long_desc.
  ///
  /// In en, this message translates to:
  /// **'The request URI is too long'**
  String get error_uri_too_long_desc;

  /// No description provided for @lead_send_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while sending the contact request'**
  String get lead_send_error;

  /// No description provided for @lead_info_collected.
  ///
  /// In en, this message translates to:
  /// **'Lead information collected successfully'**
  String get lead_info_collected;

  /// No description provided for @lead_offline_mode.
  ///
  /// In en, this message translates to:
  /// **'Contact information saved offline'**
  String get lead_offline_mode;

  /// No description provided for @error_unsupported_media_type.
  ///
  /// In en, this message translates to:
  /// **'Unsupported media type'**
  String get error_unsupported_media_type;

  /// No description provided for @error_unsupported_media_type_desc.
  ///
  /// In en, this message translates to:
  /// **'The media type is not supported'**
  String get error_unsupported_media_type_desc;

  /// No description provided for @error_range_not_satisfiable.
  ///
  /// In en, this message translates to:
  /// **'Range not satisfiable'**
  String get error_range_not_satisfiable;

  /// No description provided for @error_range_not_satisfiable_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested range cannot be satisfied'**
  String get error_range_not_satisfiable_desc;

  /// No description provided for @error_expectation_failed.
  ///
  /// In en, this message translates to:
  /// **'Expectation failed'**
  String get error_expectation_failed;

  /// No description provided for @error_expectation_failed_desc.
  ///
  /// In en, this message translates to:
  /// **'The expectation given in the request header field could not be met'**
  String get error_expectation_failed_desc;

  /// No description provided for @error_too_many_requests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests'**
  String get error_too_many_requests;

  /// No description provided for @error_too_many_requests_desc.
  ///
  /// In en, this message translates to:
  /// **'You have sent too many requests. Please try again later'**
  String get error_too_many_requests_desc;

  /// No description provided for @error_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get error_unknown;

  /// No description provided for @error_unknown_desc.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred. Please try again'**
  String get error_unknown_desc;

  /// No description provided for @error_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get error_cancelled;

  /// No description provided for @error_cancelled_desc.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled'**
  String get error_cancelled_desc;

  /// No description provided for @error_other.
  ///
  /// In en, this message translates to:
  /// **'Error occurred'**
  String get error_other;

  /// No description provided for @error_other_desc.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again'**
  String get error_other_desc;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contact_support;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get go_back;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @check_connection.
  ///
  /// In en, this message translates to:
  /// **'Check Connection'**
  String get check_connection;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @tablets.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get tablets;

  /// No description provided for @my_classes.
  ///
  /// In en, this message translates to:
  /// **'My Classes'**
  String get my_classes;

  /// No description provided for @homeworks.
  ///
  /// In en, this message translates to:
  /// **'Homeworks'**
  String get homeworks;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @calls.
  ///
  /// In en, this message translates to:
  /// **'Calls'**
  String get calls;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Moazez Dismissal'**
  String get appTitle;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Dismissal staff sign in'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your school-approved staff account to manage dismissal and handover requests.'**
  String get authLoginSubtitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authPasswordInvalid;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginButton;

  /// No description provided for @authStaffOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'This portal is only for authorized dismissal staff accounts.'**
  String get authStaffOnlyHint;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingDescriptionOne.
  ///
  /// In en, this message translates to:
  /// **'Receive guardian calls instantly and track dismissal requests from arrival through safe handover.'**
  String get onboardingDescriptionOne;

  /// No description provided for @onboardingDescriptionTwo.
  ///
  /// In en, this message translates to:
  /// **'Monitor the waiting queue, each request status, and your assigned gate from one clear operations screen.'**
  String get onboardingDescriptionTwo;

  /// No description provided for @onboardingDescriptionThree.
  ///
  /// In en, this message translates to:
  /// **'Verify the authorized recipient and pickup code, then complete handover with a reliable operational record.'**
  String get onboardingDescriptionThree;

  /// No description provided for @settingsHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Operations settings'**
  String get settingsHeaderTitle;

  /// No description provided for @settingsHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control alerts, duty preferences, and student data privacy.'**
  String get settingsHeaderSubtitle;

  /// No description provided for @settingsNotificationsSound.
  ///
  /// In en, this message translates to:
  /// **'Notifications and sound'**
  String get settingsNotificationsSound;

  /// No description provided for @settingsDismissalNotifications.
  ///
  /// In en, this message translates to:
  /// **'Dismissal notifications'**
  String get settingsDismissalNotifications;

  /// No description provided for @settingsDismissalNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive urgent requests and delay alerts'**
  String get settingsDismissalNotificationsSubtitle;

  /// No description provided for @settingsUrgentSound.
  ///
  /// In en, this message translates to:
  /// **'Urgent request sound'**
  String get settingsUrgentSound;

  /// No description provided for @settingsUrgentSoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play a distinct sound for critical calls'**
  String get settingsUrgentSoundSubtitle;

  /// No description provided for @settingsVibration.
  ///
  /// In en, this message translates to:
  /// **'Device vibration'**
  String get settingsVibration;

  /// No description provided for @settingsVibrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick alerts during duty'**
  String get settingsVibrationSubtitle;

  /// No description provided for @settingsOperationsShift.
  ///
  /// In en, this message translates to:
  /// **'Operations and duty'**
  String get settingsOperationsShift;

  /// No description provided for @settingsShiftMode.
  ///
  /// In en, this message translates to:
  /// **'Duty mode'**
  String get settingsShiftMode;

  /// No description provided for @settingsShiftDismissal.
  ///
  /// In en, this message translates to:
  /// **'Dismissal duty'**
  String get settingsShiftDismissal;

  /// No description provided for @settingsShiftMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning duty'**
  String get settingsShiftMorning;

  /// No description provided for @settingsShiftEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening duty'**
  String get settingsShiftEvening;

  /// No description provided for @settingsAutoOpenUrgent.
  ///
  /// In en, this message translates to:
  /// **'Open urgent requests automatically'**
  String get settingsAutoOpenUrgent;

  /// No description provided for @settingsAutoOpenUrgentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Navigate directly to a newly received urgent request'**
  String get settingsAutoOpenUrgentSubtitle;

  /// No description provided for @settingsSyncGates.
  ///
  /// In en, this message translates to:
  /// **'Sync gate data'**
  String get settingsSyncGates;

  /// No description provided for @settingsSyncGatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reconnect and refresh operational signals'**
  String get settingsSyncGatesSubtitle;

  /// No description provided for @settingsSyncSuccess.
  ///
  /// In en, this message translates to:
  /// **'Realtime updates reconnected'**
  String get settingsSyncSuccess;

  /// No description provided for @settingsLanguagePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Language and privacy'**
  String get settingsLanguagePrivacy;

  /// No description provided for @settingsAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'Application language'**
  String get settingsAppLanguage;

  /// No description provided for @settingsLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get settingsLanguageArabic;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsWifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Sync over Wi-Fi only'**
  String get settingsWifiOnly;

  /// No description provided for @settingsWifiOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reduce mobile data usage during duty'**
  String get settingsWifiOnlySubtitle;

  /// No description provided for @settingsHideSensitive.
  ///
  /// In en, this message translates to:
  /// **'Hide sensitive data'**
  String get settingsHideSensitive;

  /// No description provided for @settingsHideSensitiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Partially mask identities and contact details'**
  String get settingsHideSensitiveSubtitle;

  /// No description provided for @navWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get navWaiting;

  /// No description provided for @navGates.
  ///
  /// In en, this message translates to:
  /// **'Gates'**
  String get navGates;

  /// No description provided for @permissionDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access unavailable'**
  String get permissionDeniedTitle;

  /// No description provided for @permissionDeniedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your account does not have permission to view this section. Contact the school administration if this is unexpected.'**
  String get permissionDeniedDescription;

  /// No description provided for @drawerDailyWork.
  ///
  /// In en, this message translates to:
  /// **'Daily operations'**
  String get drawerDailyWork;

  /// No description provided for @drawerCallsBoard.
  ///
  /// In en, this message translates to:
  /// **'Dismissal board'**
  String get drawerCallsBoard;

  /// No description provided for @drawerCallsBoardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active pickup requests'**
  String get drawerCallsBoardSubtitle;

  /// No description provided for @drawerCallsHistory.
  ///
  /// In en, this message translates to:
  /// **'Calls history'**
  String get drawerCallsHistory;

  /// No description provided for @drawerCallsHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Completed and closed requests'**
  String get drawerCallsHistorySubtitle;

  /// No description provided for @drawerGates.
  ///
  /// In en, this message translates to:
  /// **'Gates and duties'**
  String get drawerGates;

  /// No description provided for @drawerGatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Assigned handover points'**
  String get drawerGatesSubtitle;

  /// No description provided for @drawerWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting students'**
  String get drawerWaiting;

  /// No description provided for @drawerWaitingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Students not handed over yet'**
  String get drawerWaitingSubtitle;

  /// No description provided for @drawerAccountSafety.
  ///
  /// In en, this message translates to:
  /// **'Account and safety'**
  String get drawerAccountSafety;

  /// No description provided for @drawerProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get drawerProfile;

  /// No description provided for @drawerProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Staff identity and permissions'**
  String get drawerProfileSubtitle;

  /// No description provided for @drawerNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get drawerNotifications;

  /// No description provided for @drawerNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Urgent requests and delays'**
  String get drawerNotificationsSubtitle;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @drawerSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sound, language, and notifications'**
  String get drawerSettingsSubtitle;

  /// No description provided for @drawerSupportLegal.
  ///
  /// In en, this message translates to:
  /// **'Support and legal'**
  String get drawerSupportLegal;

  /// No description provided for @drawerHelp.
  ///
  /// In en, this message translates to:
  /// **'Help and support'**
  String get drawerHelp;

  /// No description provided for @drawerHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Moazez support'**
  String get drawerHelpSubtitle;

  /// No description provided for @drawerTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get drawerTerms;

  /// No description provided for @drawerTermsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Application usage rules'**
  String get drawerTermsSubtitle;

  /// No description provided for @drawerPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get drawerPrivacy;

  /// No description provided for @drawerPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Protection of student data'**
  String get drawerPrivacySubtitle;

  /// No description provided for @drawerLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get drawerLogout;

  /// No description provided for @dismissalStatusRequested.
  ///
  /// In en, this message translates to:
  /// **'New request'**
  String get dismissalStatusRequested;

  /// No description provided for @dismissalStatusQueued.
  ///
  /// In en, this message translates to:
  /// **'In queue'**
  String get dismissalStatusQueued;

  /// No description provided for @dismissalStatusCalled.
  ///
  /// In en, this message translates to:
  /// **'Called'**
  String get dismissalStatusCalled;

  /// No description provided for @dismissalStatusMoving.
  ///
  /// In en, this message translates to:
  /// **'Moving to gate'**
  String get dismissalStatusMoving;

  /// No description provided for @dismissalStatusAtGate.
  ///
  /// In en, this message translates to:
  /// **'At gate'**
  String get dismissalStatusAtGate;

  /// No description provided for @dismissalStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready for handover'**
  String get dismissalStatusReady;

  /// No description provided for @dismissalStatusHandedOver.
  ///
  /// In en, this message translates to:
  /// **'Handed over'**
  String get dismissalStatusHandedOver;

  /// No description provided for @dismissalStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get dismissalStatusCancelled;

  /// No description provided for @dismissalStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get dismissalStatusExpired;

  /// No description provided for @dismissalStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get dismissalStatusUnknown;

  /// No description provided for @dismissalSuccessNotificationRead.
  ///
  /// In en, this message translates to:
  /// **'Notification marked as read'**
  String get dismissalSuccessNotificationRead;

  /// No description provided for @dismissalSuccessAllNotificationsRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get dismissalSuccessAllNotificationsRead;

  /// No description provided for @dismissalSuccessStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Request status updated'**
  String get dismissalSuccessStatusUpdated;

  /// No description provided for @dismissalSuccessArrivalConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Student arrival at the gate confirmed'**
  String get dismissalSuccessArrivalConfirmed;

  /// No description provided for @dismissalSuccessDelivered.
  ///
  /// In en, this message translates to:
  /// **'Student handed over successfully'**
  String get dismissalSuccessDelivered;

  /// No description provided for @dismissalSuccessEscalated.
  ///
  /// In en, this message translates to:
  /// **'Request escalated to the supervisor'**
  String get dismissalSuccessEscalated;

  /// No description provided for @dismissalSuccessDeviceRegistered.
  ///
  /// In en, this message translates to:
  /// **'Device registered for notifications'**
  String get dismissalSuccessDeviceRegistered;

  /// No description provided for @dismissalSuccessDeviceUnregistered.
  ///
  /// In en, this message translates to:
  /// **'Device removed from notifications'**
  String get dismissalSuccessDeviceUnregistered;

  /// No description provided for @dismissalFallbackGuardian.
  ///
  /// In en, this message translates to:
  /// **'Guardian'**
  String get dismissalFallbackGuardian;

  /// No description provided for @dismissalFallbackStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get dismissalFallbackStudent;

  /// No description provided for @dismissalFallbackGate.
  ///
  /// In en, this message translates to:
  /// **'Gate'**
  String get dismissalFallbackGate;

  /// No description provided for @dismissalFallbackNotification.
  ///
  /// In en, this message translates to:
  /// **'Dismissal notification'**
  String get dismissalFallbackNotification;

  /// No description provided for @dismissalUnknownValue.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get dismissalUnknownValue;

  /// No description provided for @dismissalAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get dismissalAll;

  /// No description provided for @dismissalAllGates.
  ///
  /// In en, this message translates to:
  /// **'All gates'**
  String get dismissalAllGates;

  /// No description provided for @dismissalSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by student, guardian, or gate'**
  String get dismissalSearchHint;

  /// No description provided for @dismissalHistorySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by student, guardian, or request number'**
  String get dismissalHistorySearchHint;

  /// No description provided for @dismissalResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get dismissalResults;

  /// No description provided for @dismissalWaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting students'**
  String get dismissalWaitingTitle;

  /// No description provided for @dismissalCallsHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Calls history'**
  String get dismissalCallsHistoryTitle;

  /// No description provided for @dismissalGatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Gates and duties'**
  String get dismissalGatesTitle;

  /// No description provided for @dismissalNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get dismissalNotificationsTitle;

  /// No description provided for @dismissalProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get dismissalProfileTitle;

  /// No description provided for @dismissalStaffRole.
  ///
  /// In en, this message translates to:
  /// **'Dismissal staff'**
  String get dismissalStaffRole;

  /// No description provided for @dismissalProfileAssignments.
  ///
  /// In en, this message translates to:
  /// **'Active assignments'**
  String get dismissalProfileAssignments;

  /// No description provided for @dismissalProfileAssignedGates.
  ///
  /// In en, this message translates to:
  /// **'Assigned gates'**
  String get dismissalProfileAssignedGates;

  /// No description provided for @dismissalProfileReadiness.
  ///
  /// In en, this message translates to:
  /// **'Operational readiness'**
  String get dismissalProfileReadiness;

  /// No description provided for @dismissalProfileReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to operate'**
  String get dismissalProfileReady;

  /// No description provided for @dismissalProfileNotReady.
  ///
  /// In en, this message translates to:
  /// **'Assignment setup is incomplete'**
  String get dismissalProfileNotReady;

  /// No description provided for @dismissalProfilePermissions.
  ///
  /// In en, this message translates to:
  /// **'Granted permissions'**
  String get dismissalProfilePermissions;

  /// No description provided for @dismissalProfileNoGates.
  ///
  /// In en, this message translates to:
  /// **'No gate assignments'**
  String get dismissalProfileNoGates;

  /// No description provided for @permissionProfileView.
  ///
  /// In en, this message translates to:
  /// **'View staff profile'**
  String get permissionProfileView;

  /// No description provided for @permissionGatesView.
  ///
  /// In en, this message translates to:
  /// **'View assigned gates'**
  String get permissionGatesView;

  /// No description provided for @permissionRequestsView.
  ///
  /// In en, this message translates to:
  /// **'View pickup requests'**
  String get permissionRequestsView;

  /// No description provided for @permissionRequestsManage.
  ///
  /// In en, this message translates to:
  /// **'Manage request status'**
  String get permissionRequestsManage;

  /// No description provided for @permissionRequestsDeliver.
  ///
  /// In en, this message translates to:
  /// **'Verify and hand over students'**
  String get permissionRequestsDeliver;

  /// No description provided for @permissionRequestsEscalate.
  ///
  /// In en, this message translates to:
  /// **'Escalate delayed requests'**
  String get permissionRequestsEscalate;

  /// No description provided for @permissionHistoryView.
  ///
  /// In en, this message translates to:
  /// **'View calls history'**
  String get permissionHistoryView;

  /// No description provided for @permissionNotificationsView.
  ///
  /// In en, this message translates to:
  /// **'View notifications'**
  String get permissionNotificationsView;

  /// No description provided for @permissionNotificationsManage.
  ///
  /// In en, this message translates to:
  /// **'Manage notification read state'**
  String get permissionNotificationsManage;

  /// No description provided for @permissionDeviceTokensManage.
  ///
  /// In en, this message translates to:
  /// **'Receive device notifications'**
  String get permissionDeviceTokensManage;

  /// No description provided for @dismissalSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get dismissalSettingsTitle;

  /// No description provided for @dismissalMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get dismissalMarkAllRead;

  /// No description provided for @dismissalMarkRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get dismissalMarkRead;

  /// No description provided for @dismissalEscalate.
  ///
  /// In en, this message translates to:
  /// **'Escalate'**
  String get dismissalEscalate;

  /// No description provided for @dismissalConfirmArrival.
  ///
  /// In en, this message translates to:
  /// **'Confirm arrival'**
  String get dismissalConfirmArrival;

  /// No description provided for @dismissalArrivalConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Arrival confirmed'**
  String get dismissalArrivalConfirmed;

  /// No description provided for @dismissalWaitingList.
  ///
  /// In en, this message translates to:
  /// **'Waiting list'**
  String get dismissalWaitingList;

  /// No description provided for @dismissalGateField.
  ///
  /// In en, this message translates to:
  /// **'Gate'**
  String get dismissalGateField;

  /// No description provided for @dismissalDeliver.
  ///
  /// In en, this message translates to:
  /// **'Verify and hand over'**
  String get dismissalDeliver;

  /// No description provided for @dismissalQueueAction.
  ///
  /// In en, this message translates to:
  /// **'Add to queue'**
  String get dismissalQueueAction;

  /// No description provided for @dismissalCallAction.
  ///
  /// In en, this message translates to:
  /// **'Call student'**
  String get dismissalCallAction;

  /// No description provided for @dismissalMovingAction.
  ///
  /// In en, this message translates to:
  /// **'Start moving'**
  String get dismissalMovingAction;

  /// No description provided for @dismissalAtGateAction.
  ///
  /// In en, this message translates to:
  /// **'Reached gate'**
  String get dismissalAtGateAction;

  /// No description provided for @dismissalReadyAction.
  ///
  /// In en, this message translates to:
  /// **'Ready for handover'**
  String get dismissalReadyAction;

  /// No description provided for @dismissalUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get dismissalUrgent;

  /// No description provided for @dismissalDelayed.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get dismissalDelayed;

  /// No description provided for @dismissalWaitMinutes.
  ///
  /// In en, this message translates to:
  /// **'Waiting {minutes} min'**
  String dismissalWaitMinutes(num minutes);

  /// No description provided for @dismissalActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get dismissalActive;

  /// No description provided for @dismissalOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get dismissalOpen;

  /// No description provided for @dismissalBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get dismissalBusy;

  /// No description provided for @dismissalClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get dismissalClosed;

  /// No description provided for @dismissalMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get dismissalMaintenance;

  /// No description provided for @dismissalTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get dismissalTotal;

  /// No description provided for @dismissalUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get dismissalUnread;

  /// No description provided for @dismissalCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get dismissalCritical;

  /// No description provided for @dismissalDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get dismissalDelivered;

  /// No description provided for @dismissalCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get dismissalCancelled;

  /// No description provided for @dismissalExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get dismissalExpired;

  /// No description provided for @dismissalNoActiveRequests.
  ///
  /// In en, this message translates to:
  /// **'No active pickup requests'**
  String get dismissalNoActiveRequests;

  /// No description provided for @dismissalNoWaitingStudents.
  ///
  /// In en, this message translates to:
  /// **'No students are waiting at the moment'**
  String get dismissalNoWaitingStudents;

  /// No description provided for @dismissalNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No requests match the selected filters'**
  String get dismissalNoHistory;

  /// No description provided for @dismissalNoNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications are available'**
  String get dismissalNoNotifications;

  /// No description provided for @dismissalNoNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'New operational notifications will appear here when received.'**
  String get dismissalNoNotificationsBody;

  /// No description provided for @dismissalNoWaitingStudentsBody.
  ///
  /// In en, this message translates to:
  /// **'Waiting requests will appear here once they move into the calling stage.'**
  String get dismissalNoWaitingStudentsBody;

  /// No description provided for @dismissalCallsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active dismissal requests now'**
  String get dismissalCallsSubtitle;

  /// No description provided for @dismissalLiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} live'**
  String dismissalLiveCount(int count);

  /// No description provided for @dismissalWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get dismissalWaiting;

  /// No description provided for @dismissalProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get dismissalProcessing;

  /// No description provided for @dismissalQueueTitle.
  ///
  /// In en, this message translates to:
  /// **'Dismissal queue'**
  String get dismissalQueueTitle;

  /// No description provided for @dismissalNoActiveRequestsBody.
  ///
  /// In en, this message translates to:
  /// **'New guardian pickup requests will appear here immediately for operational follow-up.'**
  String get dismissalNoActiveRequestsBody;

  /// No description provided for @dismissalDeliverStudent.
  ///
  /// In en, this message translates to:
  /// **'Hand over {name}'**
  String dismissalDeliverStudent(String name);

  /// No description provided for @dismissalDeliveryInstruction.
  ///
  /// In en, this message translates to:
  /// **'Verify the recipient and pickup code before completing handover.'**
  String get dismissalDeliveryInstruction;

  /// No description provided for @dismissalAuthorizedRecipient.
  ///
  /// In en, this message translates to:
  /// **'Authorized recipient'**
  String get dismissalAuthorizedRecipient;

  /// No description provided for @dismissalPickupCode.
  ///
  /// In en, this message translates to:
  /// **'Pickup code'**
  String get dismissalPickupCode;

  /// No description provided for @dismissalOptionalNote.
  ///
  /// In en, this message translates to:
  /// **'Optional note'**
  String get dismissalOptionalNote;

  /// No description provided for @dismissalProcessingDelivery.
  ///
  /// In en, this message translates to:
  /// **'Completing handover...'**
  String get dismissalProcessingDelivery;

  /// No description provided for @dismissalConfirmDelivery.
  ///
  /// In en, this message translates to:
  /// **'Confirm handover'**
  String get dismissalConfirmDelivery;

  /// No description provided for @dismissalRequestDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Dismissal request details'**
  String get dismissalRequestDetailsTitle;

  /// No description provided for @dismissalStudentDetails.
  ///
  /// In en, this message translates to:
  /// **'Student details'**
  String get dismissalStudentDetails;

  /// No description provided for @dismissalStudentName.
  ///
  /// In en, this message translates to:
  /// **'Student name'**
  String get dismissalStudentName;

  /// No description provided for @dismissalClass.
  ///
  /// In en, this message translates to:
  /// **'Grade and class'**
  String get dismissalClass;

  /// No description provided for @dismissalPickupDetails.
  ///
  /// In en, this message translates to:
  /// **'Pickup details'**
  String get dismissalPickupDetails;

  /// No description provided for @dismissalGuardianName.
  ///
  /// In en, this message translates to:
  /// **'Guardian'**
  String get dismissalGuardianName;

  /// No description provided for @dismissalWaitLabel.
  ///
  /// In en, this message translates to:
  /// **'Waiting time'**
  String get dismissalWaitLabel;

  /// No description provided for @dismissalOperationDetails.
  ///
  /// In en, this message translates to:
  /// **'Operation details'**
  String get dismissalOperationDetails;

  /// No description provided for @dismissalRequestNumber.
  ///
  /// In en, this message translates to:
  /// **'Request number'**
  String get dismissalRequestNumber;

  /// No description provided for @dismissalRequestedAt.
  ///
  /// In en, this message translates to:
  /// **'Request time'**
  String get dismissalRequestedAt;

  /// No description provided for @dismissalUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Last update'**
  String get dismissalUpdatedAt;

  /// No description provided for @dismissalUnreadOnly.
  ///
  /// In en, this message translates to:
  /// **'Show unread notifications only'**
  String get dismissalUnreadOnly;

  /// No description provided for @dismissalNotificationsList.
  ///
  /// In en, this message translates to:
  /// **'Notifications list'**
  String get dismissalNotificationsList;

  /// No description provided for @dismissalNotificationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} notifications'**
  String dismissalNotificationsCount(num count);

  /// No description provided for @dismissalPriorityImportant.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get dismissalPriorityImportant;

  /// No description provided for @dismissalPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get dismissalPriorityNormal;

  /// No description provided for @dismissalNoGates.
  ///
  /// In en, this message translates to:
  /// **'No gates are assigned to this account'**
  String get dismissalNoGates;

  /// No description provided for @dismissalGatesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Gate status now'**
  String get dismissalGatesSectionTitle;

  /// No description provided for @dismissalGatesSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor assigned handover points and available waiting zones.'**
  String get dismissalGatesSectionSubtitle;

  /// No description provided for @dismissalAssignmentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} assignments'**
  String dismissalAssignmentsCount(int count);

  /// No description provided for @dismissalNoGatesTitle.
  ///
  /// In en, this message translates to:
  /// **'No gates available'**
  String get dismissalNoGatesTitle;

  /// No description provided for @dismissalNoGatesBody.
  ///
  /// In en, this message translates to:
  /// **'Gates will appear here once enabled by administration.'**
  String get dismissalNoGatesBody;

  /// No description provided for @dismissalOperationalAssignmentsNote.
  ///
  /// In en, this message translates to:
  /// **'Duties are shown from the staff profile assignments and the recorded operational gate status.'**
  String get dismissalOperationalAssignmentsNote;

  /// No description provided for @dismissalInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get dismissalInactive;

  /// No description provided for @dismissalLocationConfigured.
  ///
  /// In en, this message translates to:
  /// **'Location configured'**
  String get dismissalLocationConfigured;

  /// No description provided for @dismissalGateDetailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Gate details unavailable'**
  String get dismissalGateDetailsUnavailable;

  /// No description provided for @dismissalRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get dismissalRetry;

  /// No description provided for @dismissalNoAuthorizedRecipient.
  ///
  /// In en, this message translates to:
  /// **'No authorized recipient is available for this request yet.'**
  String get dismissalNoAuthorizedRecipient;

  /// No description provided for @dismissalPickupCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the pickup code before handover.'**
  String get dismissalPickupCodeRequired;

  /// No description provided for @dismissalNoActionForStatus.
  ///
  /// In en, this message translates to:
  /// **'No action is available for this status: {status}'**
  String dismissalNoActionForStatus(String status);

  /// No description provided for @dismissalRequestsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} requests'**
  String dismissalRequestsCount(num count);

  /// No description provided for @dismissalStudentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} students'**
  String dismissalStudentsCount(num count);

  /// No description provided for @dismissalOperationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} operations'**
  String dismissalOperationsCount(num count);

  /// No description provided for @dismissalLastUpdateUnknown.
  ///
  /// In en, this message translates to:
  /// **'Last update unavailable'**
  String get dismissalLastUpdateUnknown;

  /// No description provided for @dismissalLastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last update {value}'**
  String dismissalLastUpdate(String value);

  /// No description provided for @snackbarSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get snackbarSuccessTitle;

  /// No description provided for @snackbarErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get snackbarErrorTitle;

  /// No description provided for @snackbarWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get snackbarWarningTitle;

  /// No description provided for @snackbarInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get snackbarInfoTitle;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorNetwork;

  /// No description provided for @errorNetworkAction.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection'**
  String get errorNetworkAction;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later'**
  String get errorServer;

  /// No description provided for @errorServerActionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again later'**
  String get errorServerActionRetry;

  /// No description provided for @errorServerActionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get errorServerActionContact;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get errorInvalidCredentials;

  /// No description provided for @errorUnauthorizedAction.
  ///
  /// In en, this message translates to:
  /// **'Please check your email and password'**
  String get errorUnauthorizedAction;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get errorForbidden;

  /// No description provided for @errorForbiddenAction.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission'**
  String get errorForbiddenAction;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found'**
  String get errorNotFound;

  /// No description provided for @errorNotFoundAction.
  ///
  /// In en, this message translates to:
  /// **'Resource not found'**
  String get errorNotFoundAction;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Validation error'**
  String get errorValidation;

  /// No description provided for @errorValidationAction.
  ///
  /// In en, this message translates to:
  /// **'Check your inputs'**
  String get errorValidationAction;

  /// No description provided for @errorTokenExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired'**
  String get errorTokenExpired;

  /// No description provided for @errorTokenExpiredAction.
  ///
  /// In en, this message translates to:
  /// **'Refreshing session...'**
  String get errorTokenExpiredAction;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get errorUnknown;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
