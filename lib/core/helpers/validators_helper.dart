/// Validators helper for common validation operations
class ValidatorsHelper {
  ValidatorsHelper._();

  /// Validate email address
  static String? validateEmail(String? value, {String? locale}) {
    if (value == null || value.isEmpty) {
      return locale == 'ar' ? 'البريد الإلكتروني مطلوب' : 'Email is required';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return locale == 'ar'
          ? 'يرجى إدخال بريد إلكتروني صالح'
          : 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? value, {String? locale, int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return locale == 'ar' ? 'كلمة المرور مطلوبة' : 'Password is required';
    }

    if (value.length < minLength) {
      return locale == 'ar'
          ? 'يجب أن تكون كلمة المرور $minLength أحرف على الأقل'
          : 'Password must be at least $minLength characters';
    }

    return null;
  }

  /// Validate password strength
  static String? validatePasswordStrength(String? value, {String? locale}) {
    if (value == null || value.isEmpty) {
      return locale == 'ar' ? 'كلمة المرور مطلوبة' : 'Password is required';
    }

    if (value.length < 8) {
      return locale == 'ar'
          ? 'يجب أن تكون كلمة المرور 8 أحرف على الأقل'
          : 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return locale == 'ar'
          ? 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل'
          : 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return locale == 'ar'
          ? 'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل'
          : 'Password must contain at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return locale == 'ar'
          ? 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل'
          : 'Password must contain at least one digit';
    }

    return null;
  }

  /// Validate password match
  static String? validateConfirmPassword(String? value, String password, {String? locale}) {
    if (value == null || value.isEmpty) {
      return locale == 'ar' ? 'يرجى تأكيد كلمة المرور' : 'Please confirm password';
    }

    if (value != password) {
      return locale == 'ar'
          ? 'كلمات المرور غير متطابقة'
          : 'Passwords do not match';
    }

    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? value, {String? locale}) {
    if (value == null || value.isEmpty) {
      return locale == 'ar' ? 'رقم الهاتف مطلوب' : 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return locale == 'ar'
          ? 'يرجى إدخال رقم هاتف صالح'
          : 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validate name
  static String? validateName(String? value, {String? locale, int minLength = 2}) {
    if (value == null || value.isEmpty) {
      return locale == 'ar' ? 'الاسم مطلوب' : 'Name is required';
    }

    if (value.length < minLength) {
      return locale == 'ar'
          ? 'يجب أن يكون الاسم $minLength أحرف على الأقل'
          : 'Name must be at least $minLength characters';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, {String? locale, String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      final name = fieldName ??(locale == 'ar' ? 'هذا الحقل' : 'This field');
      return locale == 'ar' ? '$name مطلوب' : '$name is required';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(String? value, int minLength, {String? locale, String? fieldName}) {
    if (value == null || value.isEmpty) {
      return validateRequired(value, locale: locale, fieldName: fieldName);
    }

    if (value.length < minLength) {
      final name = fieldName ?? (locale == 'ar' ? 'يجب أن يكون' : 'Must be at least');
      return locale == 'ar'
          ? '$name $minLength أحرف'
          : '$name $minLength characters';
    }

    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(String? value, int maxLength, {String? locale, String? fieldName}) {
    if (value != null && value.length > maxLength) {
      final name = fieldName ?? (locale == 'ar' ? 'يجب ألا يزيد عن' : 'Must not exceed');
      return locale == 'ar'
          ? '$name $maxLength حرف'
          : '$name $maxLength characters';
    }

    return null;
  }

  /// Validate URL
  static String? validateUrl(String? value, {String? locale}) {
    if (value == null || value.isEmpty) {
      return locale == 'ar' ? 'الرابط مطلوب' : 'URL is required';
    }

    final urlRegex = RegExp(r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$');
    if (!urlRegex.hasMatch(value)) {
      return locale == 'ar'
          ? 'يرجى إدخال رابط صالح'
          : 'Please enter a valid URL';
    }

    return null;
  }

  /// Validate number range
  static String? validateNumberRange(String? value, num min, num max, {String? locale, String? fieldName}) {
    if (value == null || value.isEmpty) {
      return validateRequired(value, locale: locale, fieldName: fieldName);
    }

    final number = num.tryParse(value);
    if (number == null) {
      return locale == 'ar'
          ? 'يرجى إدخال رقم صالح'
          : 'Please enter a valid number';
    }

    if (number < min || number > max) {
      return locale == 'ar'
          ? 'يجب أن يكون بين $min و $max'
          : 'Must be between $min and $max';
    }

    return null;
  }

  /// Validate date
  static String? validateDate(DateTime? value, {String? locale, DateTime? minDate, DateTime? maxDate}) {
    if (value == null) {
      return locale == 'ar' ? 'التاريخ مطلوب' : 'Date is required';
    }

    if (minDate != null && value.isBefore(minDate)) {
      return locale == 'ar'
          ? 'يجب أن يكون بعد ${_formatDate(minDate)}'
          : 'Must be after ${_formatDate(minDate)}';
    }

    if (maxDate != null && value.isAfter(maxDate)) {
      return locale == 'ar'
          ? 'يجب أن يكون قبل ${_formatDate(maxDate)}'
          : 'Must be before ${_formatDate(maxDate)}';
    }

    return null;
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Combine multiple validators
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final result = validator();
      if (result != null) return result;
    }
    return null;
  }
}