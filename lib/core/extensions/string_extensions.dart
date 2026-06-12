/// String extensions providing utility methods for string manipulation and validation
extension StringExtensions on String {
  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegex.hasMatch(replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize first letter of each word
  String get capitalizeEachWord {
    if (isEmpty) return this;
    return split(' ').map((word) => word.isEmpty ? word : word.capitalize).join(' ');
  }

  /// Convert to title case
  String get toTitleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.isEmpty ? word : word.capitalize).join(' ');
  }

  /// Check if string is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if string is null, empty, or whitespace only
  bool get isNullOrEmptyTrimmed => trim().isEmpty;

  /// Get string or default value if null or empty
  String orDefault(String defaultValue) => isEmpty ? defaultValue : this;

  /// Trim string and replace multiple spaces with single space
  String get normalizeSpaces {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Remove all HTML tags from string
  String get removeHtmlTags {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Check if string contains only digits
  bool get isNumeric {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Check if string contains at least one letter
  bool get hasLetter {
    return RegExp(r'[a-zA-Z]').hasMatch(this);
  }

  /// Check if string contains at least one uppercase letter
  bool get hasUpperCase {
    return RegExp(r'[A-Z]').hasMatch(this);
  }

  /// Check if string contains at least one lowercase letter
  bool get hasLowerCase {
    return RegExp(r'[a-z]').hasMatch(this);
  }

  /// Check if string contains at least one digit
  bool get hasDigit {
    return RegExp(r'[0-9]').hasMatch(this);
  }

  /// Check if string contains at least one special character
  bool get hasSpecialChar {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(this);
  }

  /// Convert duration string (like "1h 30m") to Duration
  Duration get toDuration {
    final hoursMatch = RegExp(r'(\d+)h').firstMatch(this);
    final minutesMatch = RegExp(r'(\d+)m').firstMatch(this);

    int hours = 0;
    int minutes = 0;

    if (hoursMatch != null) {
      hours = int.tryParse(hoursMatch.group(1) ?? '0') ?? 0;
    }
    if (minutesMatch != null) {
      minutes = int.tryParse(minutesMatch.group(1) ?? '0') ?? 0;
    }

    return Duration(hours: hours, minutes: minutes);
  }

  /// Get initials from full name (e.g., "John Doe" -> "JD")
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0].isNotEmpty ? words[0][0].toUpperCase() : '';
    }
    return words.take(2).map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').join();
  }

  /// Reverse the string
  String get reverse {
    return split('').reversed.join();
  }

  /// Check if string is palindrome
  bool get isPalindrome {
    final cleaned = toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == cleaned.reverse;
  }

  /// Convert to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '${match.group(0)}_',
    ).toLowerCase().replaceAll(RegExp(r'^_|_+$'), '').replaceAll(RegExp(r'_+'), '_');
  }

  /// Convert to camelCase
  String get toCamelCase {
    final words = split(RegExp(r'[_\s]+'));
    if (words.isEmpty) return '';
    return words.first.toLowerCase() + words.skip(1).map((w) => w.capitalize).join();
  }

  /// Convert to PascalCase
  String get toPascalCase {
    return split(RegExp(r'[_\s]+')).map((w) => w.capitalize).join();
  }

  /// Mask string showing only first and last characters
  String mask({int visibleStart = 2, int visibleEnd = 2, String maskChar = '*'}) {
    if (length <= visibleStart + visibleEnd) return this;
    final start = substring(0, visibleStart);
    final end = substring(length - visibleEnd);
    final maskedLength = length - visibleStart - visibleEnd;
    final masked = maskChar * maskedLength;
    return '$start$masked$end';
  }
}

/// Nullable String extensions
extension NullableStringExtensions on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if string is null, empty, or whitespace
  bool get isNullOrEmptyTrimmed => this == null || this!.trim().isEmpty;

  /// Get string or default value if null or empty
  String orDefault(String defaultValue) => isNullOrEmpty ? defaultValue : this!;

  /// Get string value or empty string
  String get orEmpty => this ?? '';
}