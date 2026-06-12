
/// Password validation utilities with customizable rules
/// for strength requirements and security policies.
class PasswordValidator {
  /// Minimum password length (default).
  static const int defaultMinLength = 8;

  /// Maximum password length (default).
  static const int defaultMaxLength = 128;

  /// Minimum required uppercase letters.
  static const int defaultMinUppercase = 1;

  /// Minimum required lowercase letters.
  static const int defaultMinLowercase = 1;

  /// Minimum required digits.
  static const int defaultMinDigits = 1;

  /// Minimum required special characters.
  static const int defaultMinSpecialChars = 1;

  /// Validates a password against the default rules.
  ///
  /// Default rules require:
  /// - At least 8 characters
  /// - At least 1 uppercase letter
  /// - At least 1 lowercase letter
  /// - At least 1 digit
  /// - At least 1 special character
  static PasswordValidationResult validate(String? password) {
    return validateWithRules(
      password,
      PasswordValidationRules(),
    );
  }

  /// Validates a password with custom rules.
  static PasswordValidationResult validateWithRules(
    String? password,
    PasswordValidationRules rules,
  ) {
    if (password == null) {
      return PasswordValidationResult(
        isValid: false,
        errors: [PasswordValidationError.empty()],
        score: 0,
      );
    }

    final errors = <PasswordValidationError>[];
    int score = 0;

    // Check empty
    if (password.isEmpty) {
      errors.add(PasswordValidationError.empty());
      return PasswordValidationResult(
        isValid: false,
        errors: errors,
        score: 0,
      );
    }

    // Check minimum length
    if (password.length < rules.minLength) {
      errors.add(PasswordValidationError.tooShort(
        minLength: rules.minLength,
        actualLength: password.length,
      ));
    } else {
      score += 20;
    }

    // Check maximum length
    if (password.length > rules.maxLength) {
      errors.add(PasswordValidationError.tooLong(
        maxLength: rules.maxLength,
        actualLength: password.length,
      ));
    }

    // Check uppercase letters
    final uppercaseCount = _countUppercase(password);
    if (uppercaseCount < rules.minUppercase) {
      errors.add(PasswordValidationError.missingUppercase(
        required: rules.minUppercase,
        found: uppercaseCount,
      ));
    } else {
      score += 20;
    }

    // Check lowercase letters
    final lowercaseCount = _countLowercase(password);
    if (lowercaseCount < rules.minLowercase) {
      errors.add(PasswordValidationError.missingLowercase(
        required: rules.minLowercase,
        found: lowercaseCount,
      ));
    } else {
      score += 20;
    }

    // Check digits
    final digitCount = _countDigits(password);
    if (digitCount < rules.minDigits) {
      errors.add(PasswordValidationError.missingDigit(
        required: rules.minDigits,
        found: digitCount,
      ));
    } else {
      score += 20;
    }

    // Check special characters
    final specialCount = _countSpecialChars(password);
    if (specialCount < rules.minSpecialChars) {
      errors.add(PasswordValidationError.missingSpecialChar(
        required: rules.minSpecialChars,
        found: specialCount,
      ));
    } else {
      score += 20;
    }

    // Check for common patterns
    if (rules.checkCommonPatterns) {
      final commonPatternError = _checkCommonPatterns(password);
      if (commonPatternError != null) {
        errors.add(commonPatternError);
        score -= 10;
      }
    }

    // Check for sequential characters
    if (rules.checkSequentialChars) {
      final sequentialError = _checkSequentialChars(password);
      if (sequentialError != null) {
        errors.add(sequentialError);
        score -= 10;
      }
    }

    // Check for repeated characters
    if (rules.checkRepeatedChars) {
      final repeatedError = _checkRepeatedChars(password);
      if (repeatedError != null) {
        errors.add(repeatedError);
        score -= 10;
      }
    }

    // Check for keyboard patterns
    if (rules.checkKeyboardPatterns) {
      final keyboardError = _checkKeyboardPatterns(password);
      if (keyboardError != null) {
        errors.add(keyboardError);
        score -= 10;
      }
    }

    // Normalize score to 0-100
    score = score.clamp(0, 100);

    return PasswordValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      score: score,
    );
  }

  /// Returns the strength level based on the score.
  static PasswordStrength getStrength(int score) {
    if (score >= 80) return PasswordStrength.strong;
    if (score >= 60) return PasswordStrength.good;
    if (score >= 40) return PasswordStrength.fair;
    if (score >= 20) return PasswordStrength.weak;
    return PasswordStrength.veryWeak;
  }

  /// Gets a description of the password strength.
  static String getStrengthDescription(int score) {
    final strength = getStrength(score);
    switch (strength) {
      case PasswordStrength.veryWeak:
        return 'Very Weak - Please choose a stronger password';
      case PasswordStrength.weak:
        return 'Weak - Add more character types';
      case PasswordStrength.fair:
        return 'Fair - Consider adding special characters';
      case PasswordStrength.good:
        return 'Good - Almost there!';
      case PasswordStrength.strong:
        return 'Strong - Great password!';
    }
  }

  static int _countUppercase(String password) {
    return password.split('').where((c) => c.contains(RegExp(r'[A-Z]'))).length;
  }

  static int _countLowercase(String password) {
    return password.split('').where((c) => c.contains(RegExp(r'[a-z]'))).length;
  }

  static int _countDigits(String password) {
    return password.split('').where((c) => c.contains(RegExp(r'[0-9]'))).length;
  }

  static int _countSpecialChars(String password) {
    return password.split('').where((c) => c.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))).length;
  }

  static PasswordValidationError? _checkCommonPatterns(String password) {
    const commonPasswords = [
      'password',
      'password123',
      'password1',
      'letmein',
      'welcome',
      'monkey',
      'dragon',
      'master',
      'admin',
      'login',
      'passw0rd',
      'p@ssword',
      'qwerty',
      'abc123',
      '123456',
      '12345678',
      '123456789',
      '1234567890',
    ];

    final lowerPassword = password.toLowerCase();
    if (commonPasswords.contains(lowerPassword)) {
      return PasswordValidationError.commonPattern();
    }

    return null;
  }

  static PasswordValidationError? _checkSequentialChars(String password) {
    const sequences = [
      'abcdefghijklmnopqrstuvwxyz',
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      '0123456789',
      'qwertyuiop',
      'asdfghjkl',
      'zxcvbnm',
    ];

    final lowerPassword = password.toLowerCase();
    for (final sequence in sequences) {
      for (int i = 0; i <= sequence.length - 4; i++) {
        final subseq = sequence.substring(i, i + 4);
        if (lowerPassword.contains(subseq) ||
            lowerPassword.contains(subseq.split('').reversed.join())) {
          return PasswordValidationError.sequentialChars();
        }
      }
    }

    return null;
  }

  static PasswordValidationError? _checkRepeatedChars(String password) {
    final regex = RegExp(r'(.)\1{2,}');
    if (regex.hasMatch(password)) {
      return PasswordValidationError.repeatedChars();
    }
    return null;
  }

  static PasswordValidationError? _checkKeyboardPatterns(String password) {
    const keyboardPatterns = [
      'qweasd',
      'qazwsx',
      'asdfgh',
      'zxcvbn',
      '1qaz',
      '2wsx',
      '3edc',
      '!qaz',
      '@wsx',
      '#edc',
    ];

    final lowerPassword = password.toLowerCase();
    for (final pattern in keyboardPatterns) {
      if (lowerPassword.contains(pattern)) {
        return PasswordValidationError.keyboardPattern();
      }
    }

    return null;
  }
}

/// Rules for password validation.
class PasswordValidationRules {
  /// Minimum password length.
  final int minLength;

  /// Maximum password length.
  final int maxLength;

  /// Minimum uppercase letters required.
  final int minUppercase;

  /// Minimum lowercase letters required.
  final int minLowercase;

  /// Minimum digits required.
  final int minDigits;

  /// Minimum special characters required.
  final int minSpecialChars;

  /// Whether to check for common password patterns.
  final bool checkCommonPatterns;

  /// Whether to check for sequential characters.
  final bool checkSequentialChars;

  /// Whether to check for repeated characters.
  final bool checkRepeatedChars;

  /// Whether to check for keyboard patterns.
  final bool checkKeyboardPatterns;

  const PasswordValidationRules({
    this.minLength = PasswordValidator.defaultMinLength,
    this.maxLength = PasswordValidator.defaultMaxLength,
    this.minUppercase = PasswordValidator.defaultMinUppercase,
    this.minLowercase = PasswordValidator.defaultMinLowercase,
    this.minDigits = PasswordValidator.defaultMinDigits,
    this.minSpecialChars = PasswordValidator.defaultMinSpecialChars,
    this.checkCommonPatterns = true,
    this.checkSequentialChars = true,
    this.checkRepeatedChars = true,
    this.checkKeyboardPatterns = true,
  });

  /// Creates rules for weak passwords (minimal validation).
  const PasswordValidationRules.weak()
      : minLength = 6,
        maxLength = 128,
        minUppercase = 0,
        minLowercase = 0,
        minDigits = 0,
        minSpecialChars = 0,
        checkCommonPatterns = false,
        checkSequentialChars = false,
        checkRepeatedChars = false,
        checkKeyboardPatterns = false;

  /// Creates rules for medium passwords.
  const PasswordValidationRules.medium()
      : minLength = 8,
        maxLength = 128,
        minUppercase = 1,
        minLowercase = 1,
        minDigits = 1,
        minSpecialChars = 0,
        checkCommonPatterns = true,
        checkSequentialChars = true,
        checkRepeatedChars = true,
        checkKeyboardPatterns = false;

  /// Creates rules for strong passwords (strict validation).
  const PasswordValidationRules.strong()
      : minLength = 10,
        maxLength = 128,
        minUppercase = 2,
        minLowercase = 2,
        minDigits = 2,
        minSpecialChars = 2,
        checkCommonPatterns = true,
        checkSequentialChars = true,
        checkRepeatedChars = true,
        checkKeyboardPatterns = true;
}

/// Result of password validation.
class PasswordValidationResult {
  /// Whether the password meets all requirements.
  final bool isValid;

  /// List of validation errors (empty if valid).
  final List<PasswordValidationError> errors;

  /// Password strength score (0-100).
  final int score;

  const PasswordValidationResult({
    required this.isValid,
    required this.errors,
    required this.score,
  });

  /// Returns the password strength level based on score.
  PasswordStrength get strength => PasswordValidator.getStrength(score);

  /// Returns a description of the password strength.
  String get strengthDescription =>
      PasswordValidator.getStrengthDescription(score);

  /// Returns the first error, or null if valid.
  PasswordValidationError? get firstError =>
      errors.isNotEmpty ? errors.first : null;

  /// Returns all error messages.
  List<String> get errorMessages => errors.map((e) => e.message).toList();
}

/// Password strength levels.
enum PasswordStrength {
  /// Score 0-19.
  veryWeak,

  /// Score 20-39.
  weak,

  /// Score 40-59.
  fair,

  /// Score 60-79.
  good,

  /// Score 80-100.
  strong,
}

/// Individual password validation error.
class PasswordValidationError {
  /// Error code for programmatic handling.
  final PasswordErrorCode code;

  /// Human-readable error message.
  final String message;

  /// Additional error details.
  final Map<String, dynamic>? details;

  const PasswordValidationError._({
    required this.code,
    required this.message,
    this.details,
  });

  factory PasswordValidationError.empty() {
    return const PasswordValidationError._(
      code: PasswordErrorCode.empty,
      message: 'Password is required',
    );
  }

  factory PasswordValidationError.tooShort({
    required int minLength,
    required int actualLength,
  }) {
    return PasswordValidationError._(
      code: PasswordErrorCode.tooShort,
      message: 'Password must be at least $minLength characters',
      details: {'minLength': minLength, 'actualLength': actualLength},
    );
  }

  factory PasswordValidationError.tooLong({
    required int maxLength,
    required int actualLength,
  }) {
    return PasswordValidationError._(
      code: PasswordErrorCode.tooLong,
      message: 'Password must be at most $maxLength characters',
      details: {'maxLength': maxLength, 'actualLength': actualLength},
    );
  }

  factory PasswordValidationError.missingUppercase({
    required int required,
    required int found,
  }) {
    return PasswordValidationError._(
      code: PasswordErrorCode.missingUppercase,
      message: 'Password must contain at least $required uppercase letter(s)',
      details: {'required': required, 'found': found},
    );
  }

  factory PasswordValidationError.missingLowercase({
    required int required,
    required int found,
  }) {
    return PasswordValidationError._(
      code: PasswordErrorCode.missingLowercase,
      message: 'Password must contain at least $required lowercase letter(s)',
      details: {'required': required, 'found': found},
    );
  }

  factory PasswordValidationError.missingDigit({
    required int required,
    required int found,
  }) {
    return PasswordValidationError._(
      code: PasswordErrorCode.missingDigit,
      message: 'Password must contain at least $required number(s)',
      details: {'required': required, 'found': found},
    );
  }

  factory PasswordValidationError.missingSpecialChar({
    required int required,
    required int found,
  }) {
    return PasswordValidationError._(
      code: PasswordErrorCode.missingSpecialChar,
      message: 'Password must contain at least $required special character(s)',
      details: {'required': required, 'found': found},
    );
  }

  factory PasswordValidationError.commonPattern() {
    return const PasswordValidationError._(
      code: PasswordErrorCode.commonPattern,
      message: 'This is a commonly used password. Please choose a stronger one.',
    );
  }

  factory PasswordValidationError.sequentialChars() {
    return const PasswordValidationError._(
      code: PasswordErrorCode.sequentialChars,
      message: 'Avoid using sequential characters (e.g., abc, 123)',
    );
  }

  factory PasswordValidationError.repeatedChars() {
    return const PasswordValidationError._(
      code: PasswordErrorCode.repeatedChars,
      message: 'Avoid using repeated characters (e.g., aaa, 111)',
    );
  }

  factory PasswordValidationError.keyboardPattern() {
    return const PasswordValidationError._(
      code: PasswordErrorCode.keyboardPattern,
      message: 'Avoid keyboard patterns (e.g., qwerty, asdf)',
    );
  }
}

/// Error codes for password validation.
enum PasswordErrorCode {
  /// Password is empty.
  empty,

  /// Password is too short.
  tooShort,

  /// Password is too long.
  tooLong,

  /// Missing uppercase letters.
  missingUppercase,

  /// Missing lowercase letters.
  missingLowercase,

  /// Missing digits.
  missingDigit,

  /// Missing special characters.
  missingSpecialChar,

  /// Common password pattern detected.
  commonPattern,

  /// Sequential characters detected.
  sequentialChars,

  /// Repeated characters detected.
  repeatedChars,

  /// Keyboard pattern detected.
  keyboardPattern,
}
