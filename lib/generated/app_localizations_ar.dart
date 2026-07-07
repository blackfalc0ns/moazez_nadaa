// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get error_no_internet_connection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get error_no_internet_connection_desc =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى';

  @override
  String get error_connection_timeout => 'انتهت مهلة الاتصال';

  @override
  String get error_connection_timeout_desc =>
      'استغرق الاتصال وقتاً طويلاً. يرجى المحاولة مرة أخرى';

  @override
  String get error_receive_timeout => 'انتهت مهلة الاستقبال';

  @override
  String get error_receive_timeout_desc =>
      'استغرق الخادم وقتاً طويلاً للرد. يرجى المحاولة مرة أخرى';

  @override
  String get error_send_timeout => 'انتهت مهلة الإرسال';

  @override
  String get error_send_timeout_desc =>
      'فشل في إرسال البيانات إلى الخادم. يرجى المحاولة مرة أخرى';

  @override
  String get error_server_error => 'خطأ في الخادم';

  @override
  String get error_server_error_desc =>
      'حدث خطأ في الخادم. يرجى المحاولة لاحقاً';

  @override
  String get error_internal_server_error => 'خطأ داخلي في الخادم';

  @override
  String get error_internal_server_error_desc =>
      'واجه الخادم خطأ داخلي. يرجى المحاولة لاحقاً';

  @override
  String get error_bad_gateway => 'بوابة سيئة';

  @override
  String get error_bad_gateway_desc =>
      'تلقى الخادم استجابة غير صالحة. يرجى المحاولة لاحقاً';

  @override
  String get error_service_unavailable => 'الخدمة غير متاحة';

  @override
  String get error_service_unavailable_desc =>
      'الخدمة غير متاحة مؤقتاً. يرجى المحاولة لاحقاً';

  @override
  String get error_gateway_timeout => 'انتهت مهلة البوابة';

  @override
  String get error_gateway_timeout_desc =>
      'انتهت مهلة البوابة. يرجى المحاولة لاحقاً';

  @override
  String get error_bad_request => 'طلب خاطئ';

  @override
  String get properties_empty_message_favourite =>
      'لم تقم بإضافة أي عناصر إلى المفضلة.';

  @override
  String get error_bad_request_desc =>
      'يحتوي الطلب على بيانات غير صالحة. يرجى التحقق من المدخلات';

  @override
  String get error_unauthorized => 'غير مصرح للوصول';

  @override
  String get error_unauthorized_desc =>
      'أنت غير مصرح للوصول إلى هذا المورد. يرجى تسجيل الدخول مرة أخرى';

  @override
  String get error_forbidden => 'الوصول مرفوض';

  @override
  String get error_forbidden_desc => 'ليس لديك إذن للوصول إلى هذا المورد';

  @override
  String get error_not_found => 'غير موجود';

  @override
  String get error_not_found_desc => 'المورد المطلوب غير موجود';

  @override
  String get error_method_not_allowed => 'الطريقة غير مسموحة';

  @override
  String get error_method_not_allowed_desc =>
      'هذه الطريقة غير مسموحة لهذا المورد';

  @override
  String get error_not_acceptable => 'غير مقبول';

  @override
  String get error_not_acceptable_desc => 'الطلب غير مقبول';

  @override
  String get error_request_timeout => 'انتهت مهلة الطلب';

  @override
  String get error_request_timeout_desc =>
      'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى';

  @override
  String get error_conflict => 'تعارض';

  @override
  String get error_conflict_desc => 'يوجد تعارض مع الحالة الحالية للمورد';

  @override
  String get error_gone => 'المورد غير متاح';

  @override
  String get error_gone_desc => 'المورد المطلوب لم يعد متاحاً';

  @override
  String get error_length_required => 'الطول مطلوب';

  @override
  String get error_length_required_desc => 'يجب أن يحدد الطلب طول المحتوى';

  @override
  String get error_precondition_failed => 'فشل الشرط المسبق';

  @override
  String get error_precondition_failed_desc => 'فشل شرط مسبق واحد أو أكثر';

  @override
  String get error_payload_too_large => 'الحمولة كبيرة جداً';

  @override
  String get error_payload_too_large_desc => 'حمولة الطلب كبيرة جداً';

  @override
  String get error_uri_too_long => 'الرابط طويل جداً';

  @override
  String get error_uri_too_long_desc => 'رابط الطلب طويل جداً';

  @override
  String get lead_send_error => 'حدث خطأ أثناء إرسال طلب التواصل';

  @override
  String get lead_info_collected => 'تم جمع معلومات العميل المحتمل بنجاح';

  @override
  String get lead_offline_mode => 'تم حفظ معلومات التواصل محلياً';

  @override
  String get error_unsupported_media_type => 'نوع الوسائط غير مدعوم';

  @override
  String get error_unsupported_media_type_desc => 'نوع الوسائط غير مدعوم';

  @override
  String get error_range_not_satisfiable => 'النطاق غير قابل للتحقيق';

  @override
  String get error_range_not_satisfiable_desc => 'لا يمكن تحقيق النطاق المطلوب';

  @override
  String get error_expectation_failed => 'فشل التوقع';

  @override
  String get error_expectation_failed_desc =>
      'لا يمكن تلبية التوقع المحدد في حقل رأس الطلب';

  @override
  String get error_too_many_requests => 'طلبات كثيرة جداً';

  @override
  String get error_too_many_requests_desc =>
      'لقد أرسلت طلبات كثيرة جداً. يرجى المحاولة لاحقاً';

  @override
  String get error_unknown => 'خطأ غير معروف';

  @override
  String get error_unknown_desc => 'حدث خطأ غير معروف. يرجى المحاولة مرة أخرى';

  @override
  String get error_cancelled => 'تم إلغاء الطلب';

  @override
  String get error_cancelled_desc => 'تم إلغاء الطلب';

  @override
  String get error_other => 'حدث خطأ';

  @override
  String get error_other_desc => 'حدث خطأ. يرجى المحاولة مرة أخرى';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get contact_support => 'تواصل مع الدعم';

  @override
  String get go_back => 'العودة';

  @override
  String get refresh => 'تحديث';

  @override
  String get check_connection => 'فحص الاتصال';

  @override
  String get home => 'الرئيسية';

  @override
  String get tablets => 'الجدول';

  @override
  String get my_classes => 'فصولى';

  @override
  String get homeworks => 'الواجبات';

  @override
  String get messages => 'الرسائل';

  @override
  String get calls => 'النداء';

  @override
  String get appTitle => 'نداء معزز';

  @override
  String get authLoginTitle => 'تسجيل دخول فريق النداء';

  @override
  String get authLoginSubtitle =>
      'ادخل بحساب المشرف المعتمد من المدرسة لمتابعة طلبات الانصراف والتسليم.';

  @override
  String get authEmailLabel => 'البريد الإلكتروني';

  @override
  String get authEmailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get authPasswordLabel => 'كلمة المرور';

  @override
  String get authPasswordInvalid => 'كلمة المرور يجب ألا تقل عن 6 أحرف';

  @override
  String get authLoginButton => 'تسجيل الدخول';

  @override
  String get authStaffOnlyHint =>
      'هذه البوابة مخصصة لحسابات مشرفي النداء المعتمدين فقط.';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingDescriptionOne =>
      'استقبل نداءات أولياء الأمور فورًا، وتابع طلب الانصراف من لحظة الوصول حتى التسليم الآمن.';

  @override
  String get onboardingDescriptionTwo =>
      'تابع قائمة الانتظار وحالة كل طلب والبوابة المكلف بها من شاشة تشغيل واحدة واضحة.';

  @override
  String get onboardingDescriptionThree =>
      'تحقق من المستلم المعتمد وكود الاستلام، ثم أكمل التسليم بسجل تشغيلي موثوق.';

  @override
  String get settingsHeaderTitle => 'إعدادات التشغيل';

  @override
  String get settingsHeaderSubtitle =>
      'تحكم في التنبيهات والمناوبة وخصوصية بيانات الطلاب.';

  @override
  String get settingsNotificationsSound => 'التنبيهات والصوت';

  @override
  String get settingsDismissalNotifications => 'تنبيهات النداء';

  @override
  String get settingsDismissalNotificationsSubtitle =>
      'استقبال الطلبات العاجلة والتأخيرات';

  @override
  String get settingsUrgentSound => 'صوت الطلب العاجل';

  @override
  String get settingsUrgentSoundSubtitle =>
      'تشغيل صوت مميز عند النداءات الحرجة';

  @override
  String get settingsVibration => 'اهتزاز الجهاز';

  @override
  String get settingsVibrationSubtitle => 'تنبيه سريع أثناء المناوبة';

  @override
  String get settingsOperationsShift => 'التشغيل والمناوبة';

  @override
  String get settingsShiftMode => 'وضع المناوبة';

  @override
  String get settingsShiftDismissal => 'مناوبة الانصراف';

  @override
  String get settingsShiftMorning => 'مناوبة صباحية';

  @override
  String get settingsShiftEvening => 'مناوبة مسائية';

  @override
  String get settingsAutoOpenUrgent => 'فتح الطلب العاجل تلقائيًا';

  @override
  String get settingsAutoOpenUrgentSubtitle =>
      'ينقلك مباشرة إلى الطلب عند وصوله';

  @override
  String get settingsSyncGates => 'مزامنة بيانات البوابات';

  @override
  String get settingsSyncGatesSubtitle =>
      'إعادة الاتصال وتحديث الإشارات التشغيلية';

  @override
  String get settingsSyncSuccess => 'تمت إعادة الاتصال بخدمة التحديثات';

  @override
  String get settingsLanguagePrivacy => 'اللغة والخصوصية';

  @override
  String get settingsAppLanguage => 'لغة التطبيق';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsWifiOnly => 'المزامنة عبر Wi-Fi فقط';

  @override
  String get settingsWifiOnlySubtitle =>
      'تقليل استهلاك البيانات أثناء المناوبة';

  @override
  String get settingsHideSensitive => 'إخفاء البيانات الحساسة';

  @override
  String get settingsHideSensitiveSubtitle =>
      'إخفاء جزئي للهويات وأرقام التواصل';

  @override
  String get navWaiting => 'المنتظرون';

  @override
  String get navGates => 'البوابات';

  @override
  String get permissionDeniedTitle => 'الوصول غير متاح';

  @override
  String get permissionDeniedDescription =>
      'لا يملك حسابك صلاحية عرض هذا القسم. تواصل مع إدارة المدرسة إذا كنت ترى أن ذلك غير متوقع.';

  @override
  String get drawerDailyWork => 'العمل اليومي';

  @override
  String get drawerCallsBoard => 'لوحة النداء';

  @override
  String get drawerCallsBoardSubtitle => 'طلبات الاستلام النشطة';

  @override
  String get drawerCallsHistory => 'سجل النداءات';

  @override
  String get drawerCallsHistorySubtitle => 'الطلبات المكتملة والمغلقة';

  @override
  String get drawerGates => 'البوابات والمناوبات';

  @override
  String get drawerGatesSubtitle => 'نقاط التسليم المكلف بها';

  @override
  String get drawerWaiting => 'الطلاب المنتظرون';

  @override
  String get drawerWaitingSubtitle => 'لم يتم تسليمهم بعد';

  @override
  String get drawerAccountSafety => 'الحساب والسلامة';

  @override
  String get drawerProfile => 'الملف الشخصي';

  @override
  String get drawerProfileSubtitle => 'بيانات المشرف والصلاحيات';

  @override
  String get drawerNotifications => 'التنبيهات';

  @override
  String get drawerNotificationsSubtitle => 'طلبات عاجلة وتأخيرات';

  @override
  String get drawerSettings => 'الإعدادات';

  @override
  String get drawerSettingsSubtitle => 'الصوت واللغة والإشعارات';

  @override
  String get drawerSupportLegal => 'الدعم والقوانين';

  @override
  String get drawerHelp => 'المساعدة والدعم';

  @override
  String get drawerHelpSubtitle => 'تواصل مع دعم معزز';

  @override
  String get drawerTerms => 'الشروط والأحكام';

  @override
  String get drawerTermsSubtitle => 'قواعد استخدام التطبيق';

  @override
  String get drawerPrivacy => 'سياسة الخصوصية';

  @override
  String get drawerPrivacySubtitle => 'حماية بيانات الطلاب';

  @override
  String get drawerLogout => 'تسجيل الخروج';

  @override
  String get dismissalStatusRequested => 'طلب جديد';

  @override
  String get dismissalStatusQueued => 'في قائمة الانتظار';

  @override
  String get dismissalStatusCalled => 'تم النداء';

  @override
  String get dismissalStatusMoving => 'يتحرك للبوابة';

  @override
  String get dismissalStatusAtGate => 'عند البوابة';

  @override
  String get dismissalStatusReady => 'جاهز للتسليم';

  @override
  String get dismissalStatusHandedOver => 'تم التسليم';

  @override
  String get dismissalStatusCancelled => 'ملغي';

  @override
  String get dismissalStatusExpired => 'منتهي';

  @override
  String get dismissalStatusUnknown => 'غير محدد';

  @override
  String get dismissalSuccessNotificationRead => 'تم تعليم التنبيه كمقروء';

  @override
  String get dismissalSuccessAllNotificationsRead =>
      'تم تعليم كل التنبيهات كمقروءة';

  @override
  String get dismissalSuccessStatusUpdated => 'تم تحديث حالة الطلب';

  @override
  String get dismissalSuccessArrivalConfirmed => 'تم تأكيد وصول الطالب للبوابة';

  @override
  String get dismissalSuccessDelivered => 'تم تسليم الطالب بنجاح';

  @override
  String get dismissalSuccessEscalated => 'تم تصعيد الطلب للمسؤول';

  @override
  String get dismissalSuccessDeviceRegistered =>
      'تم تسجيل الجهاز لاستقبال التنبيهات';

  @override
  String get dismissalSuccessDeviceUnregistered =>
      'تم إلغاء ربط الجهاز بالتنبيهات';

  @override
  String get dismissalFallbackGuardian => 'ولي الأمر';

  @override
  String get dismissalFallbackStudent => 'طالب';

  @override
  String get dismissalFallbackGate => 'بوابة';

  @override
  String get dismissalFallbackNotification => 'تنبيه نداء';

  @override
  String get dismissalUnknownValue => 'غير محدد';

  @override
  String get dismissalAll => 'الكل';

  @override
  String get dismissalAllGates => 'كل البوابات';

  @override
  String get dismissalSearchHint => 'ابحث باسم الطالب أو ولي الأمر أو البوابة';

  @override
  String get dismissalHistorySearchHint =>
      'ابحث باسم الطالب أو ولي الأمر أو رقم الطلب';

  @override
  String get dismissalResults => 'النتائج';

  @override
  String get dismissalWaitingTitle => 'الطلاب المنتظرون';

  @override
  String get dismissalCallsHistoryTitle => 'سجل النداءات';

  @override
  String get dismissalGatesTitle => 'البوابات والمناوبات';

  @override
  String get dismissalNotificationsTitle => 'التنبيهات';

  @override
  String get dismissalProfileTitle => 'الملف الشخصي';

  @override
  String get dismissalStaffRole => 'مشرف النداء';

  @override
  String get dismissalProfileAssignments => 'التكليفات النشطة';

  @override
  String get dismissalProfileAssignedGates => 'البوابات المسندة';

  @override
  String get dismissalProfileReadiness => 'جاهزية التشغيل';

  @override
  String get dismissalProfileReady => 'جاهز للتشغيل';

  @override
  String get dismissalProfileNotReady => 'إعداد التكليف غير مكتمل';

  @override
  String get dismissalProfilePermissions => 'الصلاحيات الممنوحة';

  @override
  String get dismissalProfileNoGates => 'لا توجد بوابات مسندة';

  @override
  String get permissionProfileView => 'عرض ملف المشرف';

  @override
  String get permissionGatesView => 'عرض البوابات المسندة';

  @override
  String get permissionRequestsView => 'عرض طلبات الاستلام';

  @override
  String get permissionRequestsManage => 'إدارة حالات الطلبات';

  @override
  String get permissionRequestsDeliver => 'التحقق من المستلم وتسليم الطلاب';

  @override
  String get permissionRequestsEscalate => 'تصعيد الطلبات المتأخرة';

  @override
  String get permissionHistoryView => 'عرض سجل النداءات';

  @override
  String get permissionNotificationsView => 'عرض التنبيهات';

  @override
  String get permissionNotificationsManage => 'إدارة حالة قراءة التنبيهات';

  @override
  String get permissionDeviceTokensManage => 'استقبال تنبيهات الجهاز';

  @override
  String get dismissalSettingsTitle => 'الإعدادات';

  @override
  String get dismissalMarkAllRead => 'تعليم الكل كمقروء';

  @override
  String get dismissalMarkRead => 'تعليم كمقروء';

  @override
  String get dismissalEscalate => 'تصعيد';

  @override
  String get dismissalConfirmArrival => 'تأكيد الوصول';

  @override
  String get dismissalArrivalConfirmed => 'الوصول مؤكد';

  @override
  String get dismissalWaitingList => 'قائمة الانتظار';

  @override
  String get dismissalGateField => 'البوابة';

  @override
  String get dismissalDeliver => 'التحقق والتسليم';

  @override
  String get dismissalQueueAction => 'إدخال للانتظار';

  @override
  String get dismissalCallAction => 'نداء الطالب';

  @override
  String get dismissalMovingAction => 'بدأ التحرك';

  @override
  String get dismissalAtGateAction => 'وصل للبوابة';

  @override
  String get dismissalReadyAction => 'جاهز للتسليم';

  @override
  String get dismissalUrgent => 'عاجل';

  @override
  String get dismissalDelayed => 'متأخر';

  @override
  String dismissalWaitMinutes(num minutes) {
    return 'انتظار $minutes د';
  }

  @override
  String get dismissalActive => 'نشط';

  @override
  String get dismissalOpen => 'مفتوحة';

  @override
  String get dismissalBusy => 'ضغط';

  @override
  String get dismissalClosed => 'مغلقة';

  @override
  String get dismissalMaintenance => 'صيانة';

  @override
  String get dismissalTotal => 'إجمالي';

  @override
  String get dismissalUnread => 'غير مقروء';

  @override
  String get dismissalCritical => 'حرج';

  @override
  String get dismissalDelivered => 'تم التسليم';

  @override
  String get dismissalCancelled => 'ملغية';

  @override
  String get dismissalExpired => 'منتهية';

  @override
  String get dismissalNoActiveRequests => 'لا توجد طلبات استلام نشطة';

  @override
  String get dismissalNoWaitingStudents => 'لا يوجد طلاب منتظرون حالياً';

  @override
  String get dismissalNoHistory => 'لا توجد طلبات مطابقة للتصفية المحددة';

  @override
  String get dismissalNoNotifications => 'لا توجد تنبيهات متاحة';

  @override
  String get dismissalNoNotificationsBody =>
      'ستظهر هنا التنبيهات التشغيلية الجديدة عند وصولها.';

  @override
  String get dismissalNoWaitingStudentsBody =>
      'ستظهر طلبات الانتظار هنا بمجرد انتقالها إلى مرحلة الاستدعاء.';

  @override
  String get dismissalCallsSubtitle => 'طلبات الانصراف النشطة الآن';

  @override
  String dismissalLiveCount(int count) {
    return '$count مباشر';
  }

  @override
  String get dismissalWaiting => 'منتظر';

  @override
  String get dismissalProcessing => 'جاري التنفيذ...';

  @override
  String get dismissalQueueTitle => 'قائمة النداءات';

  @override
  String get dismissalNoActiveRequestsBody =>
      'عند إنشاء ولي الأمر لطلب استلام سيظهر هنا مباشرة ضمن قائمة المتابعة.';

  @override
  String dismissalDeliverStudent(String name) {
    return 'تسليم $name';
  }

  @override
  String get dismissalDeliveryInstruction =>
      'تحقق من المستلم والكود قبل إنهاء الطلب.';

  @override
  String get dismissalAuthorizedRecipient => 'المستلم المعتمد';

  @override
  String get dismissalPickupCode => 'كود الاستلام';

  @override
  String get dismissalOptionalNote => 'ملاحظة اختيارية';

  @override
  String get dismissalProcessingDelivery => 'جاري إنهاء التسليم...';

  @override
  String get dismissalConfirmDelivery => 'تأكيد التسليم';

  @override
  String get dismissalRequestDetailsTitle => 'تفاصيل طلب الانصراف';

  @override
  String get dismissalStudentDetails => 'بيانات الطالب';

  @override
  String get dismissalStudentName => 'اسم الطالب';

  @override
  String get dismissalClass => 'الصف والفصل';

  @override
  String get dismissalPickupDetails => 'بيانات الاستلام';

  @override
  String get dismissalGuardianName => 'ولي الأمر';

  @override
  String get dismissalWaitLabel => 'مدة الانتظار';

  @override
  String get dismissalOperationDetails => 'بيانات العملية';

  @override
  String get dismissalRequestNumber => 'رقم الطلب';

  @override
  String get dismissalRequestedAt => 'وقت إنشاء الطلب';

  @override
  String get dismissalUpdatedAt => 'آخر تحديث';

  @override
  String get dismissalUnreadOnly => 'عرض التنبيهات غير المقروءة فقط';

  @override
  String get dismissalNotificationsList => 'قائمة التنبيهات';

  @override
  String dismissalNotificationsCount(num count) {
    return '$count تنبيه';
  }

  @override
  String get dismissalPriorityImportant => 'مهم';

  @override
  String get dismissalPriorityNormal => 'عادي';

  @override
  String get dismissalNoGates => 'لا توجد بوابات مسندة لهذا الحساب';

  @override
  String get dismissalGatesSectionTitle => 'حالة البوابات الآن';

  @override
  String get dismissalGatesSectionSubtitle =>
      'تابع نقاط التسليم المكلف بها ومناطق الانتظار المتاحة.';

  @override
  String dismissalAssignmentsCount(int count) {
    return '$count تكليف';
  }

  @override
  String get dismissalNoGatesTitle => 'لا توجد بوابات متاحة';

  @override
  String get dismissalNoGatesBody =>
      'سيتم عرض البوابات هنا بمجرد تفعيلها من لوحة الإدارة.';

  @override
  String get dismissalOperationalAssignmentsNote =>
      'تُعرض المناوبات من تكليفات ملف المشرف وحالة البوابات التشغيلية المسجلة.';

  @override
  String get dismissalInactive => 'غير نشطة';

  @override
  String get dismissalLocationConfigured => 'الموقع محدد';

  @override
  String get dismissalGateDetailsUnavailable => 'تفاصيل البوابة غير محددة';

  @override
  String get dismissalRetry => 'إعادة المحاولة';

  @override
  String get dismissalNoAuthorizedRecipient =>
      'لا يوجد مستلم معتمد لهذا الطلب حتى الآن.';

  @override
  String get dismissalPickupCodeRequired => 'أدخل كود الاستلام قبل التسليم.';

  @override
  String dismissalNoActionForStatus(String status) {
    return 'لا يوجد إجراء متاح لهذه الحالة: $status';
  }

  @override
  String dismissalRequestsCount(num count) {
    return '$count طلب';
  }

  @override
  String dismissalStudentsCount(num count) {
    return '$count طالب';
  }

  @override
  String dismissalOperationsCount(num count) {
    return '$count عملية';
  }

  @override
  String get dismissalLastUpdateUnknown => 'آخر تحديث غير محدد';

  @override
  String dismissalLastUpdate(String value) {
    return 'آخر تحديث $value';
  }

  @override
  String get snackbarSuccessTitle => 'تم بنجاح';

  @override
  String get snackbarErrorTitle => 'حدث خطأ';

  @override
  String get snackbarWarningTitle => 'تنبيه';

  @override
  String get snackbarInfoTitle => 'معلومة';

  @override
  String get errorNetwork => 'لا يوجد اتصال بالإنترنت';

  @override
  String get errorNetworkAction => 'تحقق من اتصالك بالإنترنت';

  @override
  String get errorTimeout => 'انتهت مهلة الطلب';

  @override
  String get errorServer => 'خطأ في الخادم. يرجى المحاولة لاحقاً';

  @override
  String get errorServerActionRetry => 'حاول مرة أخرى لاحقاً';

  @override
  String get errorServerActionContact => 'اتصل بالدعم';

  @override
  String get errorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get errorUnauthorizedAction =>
      'يرجى التحقق من البريد الإلكتروني وكلمة المرور';

  @override
  String get errorForbidden => 'تم رفض الوصول';

  @override
  String get errorForbiddenAction => 'ليس لديك إذن للوصول';

  @override
  String get errorNotFound => 'المورد غير موجود';

  @override
  String get errorNotFoundAction => 'المورد غير موجود';

  @override
  String get errorValidation => 'خطأ في التحقق من البيانات';

  @override
  String get errorValidationAction => 'تحقق من المدخلات';

  @override
  String get errorTokenExpired => 'انتهت صلاحية جلستك';

  @override
  String get errorTokenExpiredAction => 'جاري تحديث الجلسة...';

  @override
  String get errorUnknown => 'حدث خطأ غير متوقع';

  @override
  String get tryAgain => 'حاول مرة أخرى';
}
