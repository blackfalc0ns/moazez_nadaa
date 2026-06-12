
/// Arabic localizations for the application
class AppLocalizationsAr {
  const AppLocalizationsAr();

  // General
  static const String appName = 'تطبيق المعلم';
  static const String ok = 'موافق';
  static const String cancel = 'إلغاء';
  static const String save = 'حفظ';
  static const String delete = 'حذف';
  static const String edit = 'تعديل';
  static const String done = 'تم';
  static const String yes = 'نعم';
  static const String no = 'لا';
  static const String close = 'إغلاق';
  static const String retry = 'إعادة المحاولة';
  static const String loading = 'جاري التحميل...';
  static const String seeAll = 'عرض الكل';

  // Auth
  static const String login = 'تسجيل الدخول';
  static const String email = 'البريد الإلكتروني';
  static const String password = 'كلمة المرور';
  static const String forgotPassword = 'نسيت كلمة المرور؟';
  static const String rememberMe = 'تذكرني';
  static const String loginButton = 'دخول';
  static const String loggingIn = 'جاري تسجيل الدخول...';
  static const String loginSuccess = 'تم تسجيل الدخول بنجاح';
  static const String loginFailed = 'فشل تسجيل الدخول';
  static const String invalidCredentials = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
  static const String emailRequired = 'البريد الإلكتروني مطلوب';
  static const String passwordRequired = 'كلمة المرور مطلوبة';
  static const String emailInvalid = 'البريد الإلكتروني غير صالح';
  static const String passwordTooShort = 'كلمة المرور قصيرة جداً';
  static const String teacherOnly = 'هذا التطبيق للمعلمين فقط';
  static const String noActiveMembership = 'لا يوجد عضوية نشطة';
  
  // Login Page
  static const String loginTitle = 'تسجيل دخول المعلم';
  static const String loginSubtitle = 'سجّل الدخول للوصول السريع إلى الفصول، الرسائل، وخدمات المدرسة في مكان واحد.';
  static const String successTitle = 'نجح!';
  static const String errorTitle = 'خطأ!';

  // Forgot Password
  static const String forgotPasswordTitle = 'استعادة كلمة المرور';
  static const String forgotPasswordSubtitle = 'أدخل وسيلة التواصل المرتبطة بالحساب وسنرسل لك تعليمات الاستعادة.';
  static const String forgotPasswordFieldLabel = 'البريد الإلكتروني أو رقم الجوال';
  static const String forgotPasswordButton = 'إرسال تعليمات الاستعادة';
  static const String forgotPasswordSentTitle = 'تم إرسال الطلب';
  static const String forgotPasswordSentBody = 'تم إرسال تعليمات استعادة كلمة المرور بشكل تجريبي إلى وسيلة التواصل المدخلة. عند ربط النظام سيتم إرسال الرسالة الفعلية.';

  // Change Password (Sprint 11)
  static const String changePasswordTitle = 'تغيير كلمة المرور';
  static const String changePasswordSubtitle = 'يجب تغيير كلمة المرور المؤقتة قبل المتابعة.';
  static const String currentPassword = 'كلمة المرور الحالية';
  static const String newPassword = 'كلمة المرور الجديدة';
  static const String confirmPassword = 'تأكيد كلمة المرور';
  static const String changePasswordButton = 'تغيير كلمة المرور';
  static const String changePasswordSuccess = 'تم تغيير كلمة المرور بنجاح';

  // Errors
  static const String errorGeneral = 'حدث خطأ. يرجى المحاولة مرة أخرى.';
  static const String errorNetwork = 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.';
  static const String errorServer = 'خطأ في الخادم. يرجى المحاولة لاحقاً.';
  static const String errorTimeout = 'انتهت مهلة الطلب. يرجى المحاولة.';
  static const String errorUnknown = 'حدث خطأ غير متوقع.';
  static const String errorCancelled = 'تم إلغاء الطلب.';
  static const String errorUnauthorized = 'غير مصرح. يرجى تسجيل الدخول مرة أخرى.';
  static const String errorForbidden = 'تم رفض الوصول. ليس لديك إذن.';
  static const String errorNotFound = 'المورد غير موجود.';
  static const String errorInternalServer = 'خطأ داخلي في الخادم. يرجى المحاولة لاحقاً.';
  static const String errorServiceUnavailable = 'الخدمة غير متاحة مؤقتاً.';
  static const String errorValidation = 'خطأ في التحقق. يرجى التحقق من المدخلات.';
  static const String errorInvalidInput = 'مدخلات غير صالحة.';
  static const String errorTokenExpired = 'انتهت صلاحية جلستك. يرجى تسجيل الدخول مرة أخرى.';
  static const String errorInvalidCredentials = 'البريد الإلكتروني أو كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.';
  static const String errorSessionExpired = 'انتهت صلاحية جلستك.';

  // Validation
  static const String validationRequired = 'هذا الحقل مطلوب';
  static const String validationEmail = 'يرجى إدخال بريد إلكتروني صالح';
  static const String validationPhone = 'يرجى إدخال رقم هاتف صالح';
  static const String validationPassword = 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
  static const String validationMinLength = 'يجب أن يكون على الأقل {0} أحرف';
  static const String validationMaxLength = 'يجب ألا يتجاوز {0} أحرف';
  static const String validationMatch = 'كلمات المرور غير متطابقة';

  // Navigation
  static const String navHome = 'الرئيسية';
  static const String navClasses = 'الفصول';
  static const String navSchedule = 'الجدول';
  static const String navMessages = 'الرسائل';
  static const String navProfile = 'الملف';
  static const String navSettings = 'الإعدادات';

  // Home
  static const String welcomeBack = 'مرحباً بعودتك';
  static const String todaySchedule = 'جدول اليوم';
  static const String upcomingTasks = 'المهام القادمة';
  static const String recentNotifications = 'الإشعارات الأخيرة';
  static const String yourClasses = 'فصولك';

  // Classes
  static const String myClasses = 'فصولي';
  static const String classDetails = 'تفاصيل الفصل';
  static const String classStudents = 'الطلاب';
  static const String classAssignments = 'الواجبات';
  static const String classAttendance = 'الحضور';
  static const String addClass = 'إضافة فصل';

  // Assignments
  static const String assignments = 'الواجبات';
  static const String createAssignment = 'إنشاء واجب';
  static const String assignmentDetails = 'تفاصيل الواجب';
  static const String dueDate = 'تاريخ التسليم';
  static const String submissions = 'التسليمات';
  static const String pendingSubmissions = 'تسليمات معلقة';
  static const String gradedSubmissions = 'تسليمات مصححة';

  // Schedule
  static const String schedule = 'الجدول';
  static const String today = 'اليوم';
  static const String thisWeek = 'هذا الأسبوع';
  static const String thisMonth = 'هذا الشهر';
  static const String noClassesToday = 'لا توجد فصول مجدولة لليوم';

  // Messages
  static const String messages = 'الرسائل';
  static const String newMessage = 'رسالة جديدة';
  static const String noMessages = 'لا توجد رسائل بعد';
  static const String typeMessage = 'اكتب رسالة...';

  // Profile
  static const String profile = 'الملف الشخصي';
  static const String editProfile = 'تعديل الملف';
  static const String changePassword = 'تغيير كلمة المرور';
  static const String logout = 'تسجيل الخروج';
  static const String personalInfo = 'المعلومات الشخصية';
  static const String workInfo = 'معلومات العمل';

  // Settings
  static const String settings = 'الإعدادات';
  static const String notifications = 'الإشعارات';
  static const String language = 'اللغة';
  static const String darkMode = 'الوضع الداكن';
  static const String about = 'حول';
  static const String privacyPolicy = 'سياسة الخصوصية';
  static const String termsConditions = 'الشروط والأحكام';
  static const String helpSupport = 'المساعدة والدعم';
  static const String contactUs = 'اتصل بنا';

  // Common actions
  static const String submit = 'إرسال';
  static const String create = 'إنشاء';
  static const String update = 'تحديث';
  static const String remove = 'إزالة';
  static const String search = 'بحث';
  static const String filter = 'تصفية';
  static const String sort = 'ترتيب';
  static const String clear = 'مسح';
  static const String apply = 'تطبيق';
  static const String reset = 'إعادة تعيين';
  static const String tryAgain = 'حاول مرة أخرى';

  // States
  static const String emptyState = 'لا شيء للعرض هنا';
  static const String errorState = 'حدث خطأ ما';
  static const String noResults = 'لم يتم العثور على نتائج';
  static const String pullToRefresh = 'اسحب للتحديث';

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

/// Arabic ARB translations (for reference)
const Map<String, dynamic> appLocalizationsArArb = {
  "appName": "تطبيق المعلم",
  "@appName": {"description": "اسم التطبيق", "type": "text"},
  "ok": "موافق",
  "cancel": "إلغاء",
  "save": "حفظ",
  "errorGeneral": "حدث خطأ. يرجى المحاولة مرة أخرى.",
  "errorNetwork": "لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.",
  "errorServer": "خطأ في الخادم. يرجى المحاولة لاحقاً.",
  "errorTimeout": "انتهت مهلة الطلب. يرجى المحاولة.",
  "validationRequired": "هذا الحقل مطلوب",
  "validationEmail": "يرجى إدخال بريد إلكتروني صالح",
  "validationPhone": "يرجى إدخال رقم هاتف صالح",
  "validationPassword": "يجب أن تكون كلمة المرور 8 أحرف على الأقل",
  "navHome": "الرئيسية",
  "navClasses": "الفصول",
  "navSchedule": "الجدول",
  "navMessages": "الرسائل",
  "navProfile": "الملف",
  "navSettings": "الإعدادات",
  "welcomeBack": "مرحباً بعودتك",
  "todaySchedule": "جدول اليوم",
  "myClasses": "فصولي",
  "loading": "جاري التحميل...",
  "retry": "إعادة المحاولة",
  "seeAll": "عرض الكل",
  "submit": "إرسال",
  "create": "إنشاء",
  "update": "تحديث",
  "delete": "حذف",
  "edit": "تعديل",
  "search": "بحث",
  "filter": "تصفية",
  "logout": "تسجيل الخروج",
};