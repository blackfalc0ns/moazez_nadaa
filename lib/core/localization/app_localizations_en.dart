
/// English localizations for the application
class AppLocalizationsEn {
  const AppLocalizationsEn();

  // General
  static const String appName = 'Teacher App';
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String done = 'Done';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String close = 'Close';
  static const String retry = 'Retry';
  static const String loading = 'Loading...';
  static const String seeAll = 'See All';

  // Auth
  static const String login = 'Login';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String rememberMe = 'Remember Me';
  static const String loginButton = 'Login';
  static const String loggingIn = 'Logging in...';
  static const String loginSuccess = 'Login successful';
  static const String loginFailed = 'Login failed';
  static const String invalidCredentials = 'Invalid email or password';
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String emailInvalid = 'Invalid email';
  static const String passwordTooShort = 'Password is too short';
  static const String teacherOnly = 'This app is for teachers only';
  static const String noActiveMembership = 'No active membership';

  // Forgot Password
  static const String forgotPasswordTitle = 'Reset Password';
  static const String forgotPasswordSubtitle = 'Enter your email or phone number and we will send you reset instructions.';
  static const String forgotPasswordFieldLabel = 'Email or Phone Number';
  static const String forgotPasswordButton = 'Send Reset Instructions';
  static const String forgotPasswordSentTitle = 'Request Sent';
  static const String forgotPasswordSentBody = 'Reset instructions have been sent. Please check your inbox.';

  // Change Password (Sprint 11)
  static const String changePasswordTitle = 'Change Password';
  static const String changePasswordSubtitle = 'You must change your temporary password before continuing.';
  static const String currentPassword = 'Current Password';
  static const String newPassword = 'New Password';
  static const String confirmPassword = 'Confirm Password';
  static const String changePasswordButton = 'Change Password';
  static const String changePasswordSuccess = 'Password changed successfully';

  
  // Login Page
  static const String loginTitle = 'Teacher Login';
  static const String loginSubtitle = 'Sign in to quickly access classes, messages, and school services in one place.';
  static const String successTitle = 'Success!';
  static const String errorTitle = 'Error!';

  // Errors
  static const String errorGeneral = 'An error occurred. Please try again.';
  static const String errorNetwork = 'No internet connection. Please check your network.';
  static const String errorServer = 'Server error. Please try again later.';
  static const String errorTimeout = 'Request timed out. Please try again.';
  static const String errorUnknown = 'An unexpected error occurred.';
  static const String errorCancelled = 'Request was cancelled.';
  static const String errorUnauthorized = 'Unauthorized. Please login again.';
  static const String errorForbidden = 'Access denied. You do not have permission.';
  static const String errorNotFound = 'Resource not found.';
  static const String errorInternalServer = 'Internal server error. Please try again later.';
  static const String errorServiceUnavailable = 'Service temporarily unavailable.';
  static const String errorValidation = 'Validation error. Please check your input.';
  static const String errorInvalidInput = 'Invalid input provided.';
  static const String errorTokenExpired = 'Your session has expired. Please login again.';
  static const String errorInvalidCredentials = 'Invalid credentials provided.';
  static const String errorSessionExpired = 'Your session has expired.';

  // Validation
  static const String validationRequired = 'This field is required';
  static const String validationEmail = 'Please enter a valid email';
  static const String validationPhone = 'Please enter a valid phone number';
  static const String validationPassword = 'Password must be at least 8 characters';
  static const String validationMinLength = 'Must be at least {0} characters';
  static const String validationMaxLength = 'Must not exceed {0} characters';
  static const String validationMatch = 'Passwords do not match';

  // Navigation
  static const String navHome = 'Home';
  static const String navClasses = 'Classes';
  static const String navSchedule = 'Schedule';
  static const String navMessages = 'Messages';
  static const String navProfile = 'Profile';
  static const String navSettings = 'Settings';

  // Home
  static const String welcomeBack = 'Welcome back';
  static const String todaySchedule = "Today's Schedule";
  static const String upcomingTasks = 'Upcoming Tasks';
  static const String recentNotifications = 'Recent Notifications';
  static const String yourClasses = 'Your Classes';

  // Classes
  static const String myClasses = 'My Classes';
  static const String classDetails = 'Class Details';
  static const String classStudents = 'Students';
  static const String classAssignments = 'Assignments';
  static const String classAttendance = 'Attendance';
  static const String addClass = 'Add Class';

  // Assignments
  static const String assignments = 'Assignments';
  static const String createAssignment = 'Create Assignment';
  static const String assignmentDetails = 'Assignment Details';
  static const String dueDate = 'Due Date';
  static const String submissions = 'Submissions';
  static const String pendingSubmissions = 'Pending Submissions';
  static const String gradedSubmissions = 'Graded Submissions';

  // Schedule
  static const String schedule = 'Schedule';
  static const String today = 'Today';
  static const String thisWeek = 'This Week';
  static const String thisMonth = 'This Month';
  static const String noClassesToday = 'No classes scheduled for today';

  // Messages
  static const String messages = 'Messages';
  static const String newMessage = 'New Message';
  static const String noMessages = 'No messages yet';
  static const String typeMessage = 'Type a message...';

  // Profile
  static const String profile = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String changePassword = 'Change Password';
  static const String logout = 'Logout';
  static const String personalInfo = 'Personal Information';
  static const String workInfo = 'Work Information';

  // Settings
  static const String settings = 'Settings';
  static const String notifications = 'Notifications';
  static const String language = 'Language';
  static const String darkMode = 'Dark Mode';
  static const String about = 'About';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsConditions = 'Terms & Conditions';
  static const String helpSupport = 'Help & Support';
  static const String contactUs = 'Contact Us';

  // Common actions
  static const String submit = 'Submit';
  static const String create = 'Create';
  static const String update = 'Update';
  static const String remove = 'Remove';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String clear = 'Clear';
  static const String apply = 'Apply';
  static const String reset = 'Reset';
  static const String tryAgain = 'Try Again';

  // States
  static const String emptyState = 'Nothing to show here';
  static const String errorState = 'Something went wrong';
  static const String noResults = 'No results found';
  static const String pullToRefresh = 'Pull to refresh';

  // Get string by key
  static String getString(String key) {
    return _strings[key] ?? key;
  }

  static const Map<String, String> _strings = {
    'app_name': appName,
    'ok': ok,
    'cancel': cancel,
    'save': save,
    'delete': delete,
    'edit': edit,
    'done': done,
    'yes': yes,
    'no': no,
    'close': close,
    'retry': retry,
    'loading': loading,
    'see_all': seeAll,
    'error_general': errorGeneral,
    'error_network': errorNetwork,
    'error_server': errorServer,
    'error_timeout': errorTimeout,
    'error_unknown': errorUnknown,
    'error_cancelled': errorCancelled,
    'error_unauthorized': errorUnauthorized,
    'error_forbidden': errorForbidden,
    'error_not_found': errorNotFound,
    'error_internal_server': errorInternalServer,
    'error_service_unavailable': errorServiceUnavailable,
    'error_validation': errorValidation,
    'error_invalid_input': errorInvalidInput,
    'error_token_expired': errorTokenExpired,
    'error_invalid_credentials': errorInvalidCredentials,
    'error_session_expired': errorSessionExpired,
    'validation_required': validationRequired,
    'validation_email': validationEmail,
    'validation_phone': validationPhone,
    'validation_password': validationPassword,
    'nav_home': navHome,
    'nav_classes': navClasses,
    'nav_schedule': navSchedule,
    'nav_messages': navMessages,
    'nav_profile': navProfile,
    'nav_settings': navSettings,
    'welcome_back': welcomeBack,
    'today_schedule': todaySchedule,
    'my_classes': myClasses,
    'try_again': tryAgain,
  };
}

/// English ARB translations (for reference)
const Map<String, dynamic> appLocalizationsEnArb = {
  "appName": "Teacher App",
  "@appName": {"description": "The application name"},
  "ok": "OK",
  "cancel": "Cancel",
  "save": "Save",
  "errorGeneral": "An error occurred. Please try again.",
  "errorNetwork": "No internet connection. Please check your network.",
  "errorServer": "Server error. Please try again later.",
  "errorTimeout": "Request timed out. Please try again.",
  "validationRequired": "This field is required",
  "validationEmail": "Please enter a valid email",
  "validationPhone": "Please enter a valid phone number",
  "validationPassword": "Password must be at least 8 characters",
  "navHome": "Home",
  "navClasses": "Classes",
  "navSchedule": "Schedule",
  "navMessages": "Messages",
  "navProfile": "Profile",
  "navSettings": "Settings",
  "welcomeBack": "Welcome back",
  "todaySchedule": "Today's Schedule",
  "myClasses": "My Classes",
  "loading": "Loading...",
  "retry": "Retry",
  "seeAll": "See All",
  "submit": "Submit",
  "create": "Create",
  "update": "Update",
  "delete": "Delete",
  "edit": "Edit",
  "search": "Search",
  "filter": "Filter",
  "logout": "Logout",
};