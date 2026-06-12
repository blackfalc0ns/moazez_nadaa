/// Maps common English backend error messages to Arabic.
///
/// The backend sometimes returns English messages regardless of locale.
/// This utility ensures users always see Arabic messages.
class ErrorMessageMapper {
  const ErrorMessageMapper._();

  static const Map<String, String> _englishToArabic = {
    // Generic errors
    'An unexpected error occurred': 'حدث خطأ غير متوقع',
    'unexpected error': 'حدث خطأ غير متوقع',
    'internal error': 'حدث خطأ داخلي',
    'Something went wrong': 'حدث خطأ ما',

    // Network / timeout
    'Connection timed out': 'انتهت مهلة الاتصال',
    'No internet connection': 'لا يوجد اتصال بالإنترنت',
    'Request was cancelled': 'تم إلغاء الطلب',
    'Request timeout': 'انتهت مهلة الطلب',
    'connection error': 'خطأ في الاتصال',

    // Server errors
    'Server error': 'خطأ في الخادم',
    'Server returned null response': 'لم يتم الحصول على رد من الخادم',
    'Service unavailable': 'الخدمة غير متوفرة حالياً',

    // Auth
    'Invalid email or password': 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
    'Unauthorized': 'غير مصرح',
    'Access denied': 'تم رفض الوصول',
    'Active scope is required for this action': 'ليس لديك صلاحية لتنفيذ هذا الإجراء',
    'scope is required': 'ليس لديك الصلاحية المطلوبة',
    'auth.scope.missing': 'ليس لديك صلاحية لتنفيذ هذا الإجراء',
    'Read-only participants cannot send messages': 'المشاركون للقراءة فقط لا يمكنهم إرسال رسائل',
    'communication.message.send_forbidden': 'المشاركون للقراءة فقط لا يمكنهم إرسال رسائل',
    'Session expired': 'انتهت الجلسة',
    'Token expired': 'انتهت صلاحية الجلسة',

    // Validation
    'Validation error': 'خطأ في التحقق من البيانات',
    'Validation failed': 'فشل التحقق من البيانات',
    'property should not exist': 'خاصية غير مسموح بها',
    'Invalid input': 'بيانات غير صالحة',

    // Not found
    'Resource not found': 'المصدر غير موجود',
    'Not found': 'غير موجود',

    // Chat / messages
    'Message not found': 'الرسالة غير موجودة',
    'Conversation not found': 'المحادثة غير موجودة',
    'Failed to send message': 'فشل إرسال الرسالة',
    'Failed to load messages': 'فشل تحميل الرسائل',
  };

  /// Try to map a raw English message to Arabic.
  /// Returns `null` if no mapping found.
  static String? _tryMap(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final lower = raw.toLowerCase();

    // Exact match
    if (_englishToArabic.containsKey(raw)) {
      return _englishToArabic[raw];
    }

    // Partial / contains match
    for (final entry in _englishToArabic.entries) {
      if (lower.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }

    return null;
  }

  /// Convert any raw message (English or Arabic) into a clean Arabic message.
  ///
  /// If the raw message is already Arabic, it's returned as-is.
  /// If it's a known English backend message, it's mapped to Arabic.
  /// Otherwise returns [defaultMessage].
  static String toArabic(String? raw, {required String defaultMessage}) {
    if (raw == null || raw.isEmpty) return defaultMessage;

    // Already Arabic? (basic heuristic: contains Arabic chars)
    final hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(raw);
    if (hasArabic) return raw;

    // Try mapping
    final mapped = _tryMap(raw);
    if (mapped != null) return mapped;

    // Unknown English message → return generic Arabic default
    return defaultMessage;
  }
}
