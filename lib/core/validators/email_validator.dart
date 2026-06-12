/// Email validation utilities with comprehensive pattern matching
/// and localization support.
class EmailValidator {
  /// Regular expression pattern for email validation.
  /// Based on W3C HTML5 specification recommendations.
  static final RegExp _emailPattern = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]"
    r"(?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9]"
    r"(?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    caseSensitive: false,
  );

  /// Simplified but strict email pattern for common use cases.
  static final RegExp _strictPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Pattern for educational/institutional emails.
  static final RegExp _educationalPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(edu|ac|sch|edu\.[a-zA-Z]{2})$',
  );

  /// Pattern for government emails.
  static final RegExp _governmentPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(gov|govt|goverment|gov\.[a-zA-Z]{2})$',
  );

  /// Validates an email address using the standard pattern.
  ///
  /// Returns `true` if the email is valid, `false` otherwise.
  static bool isValid(String? email) {
    if (email == null || email.isEmpty) {
      return false;
    }
    return _emailPattern.hasMatch(email.trim());
  }

  /// Validates an email address using the strict pattern.
  ///
  /// The strict pattern is more conservative and rejects
  /// some valid but unusual email formats.
  static bool isValidStrict(String? email) {
    if (email == null || email.isEmpty) {
      return false;
    }
    return _strictPattern.hasMatch(email.trim());
  }

  /// Validates if an email belongs to an educational institution.
  ///
  /// Checks for common educational domains like .edu, .ac, etc.
  static bool isEducational(String? email) {
    if (!isValid(email)) {
      return false;
    }
    return _educationalPattern.hasMatch(email!);
  }

  /// Validates if an email belongs to a government entity.
  ///
  /// Checks for common government domains like .gov, .govt, etc.
  static bool isGovernment(String? email) {
    if (!isValid(email)) {
      return false;
    }
    return _governmentPattern.hasMatch(email!);
  }

  /// Validates if an email uses a specific domain.
  ///
  /// Comparison is case-insensitive.
  static bool isDomain(String? email, String domain) {
    if (!isValid(email)) {
      return false;
    }
    final parts = email!.split('@');
    if (parts.length != 2) {
      return false;
    }
    return parts[1].toLowerCase() == domain.toLowerCase();
  }

  /// Validates if an email uses one of the specified domains.
  ///
  /// Comparison is case-insensitive.
  static bool isAnyDomain(String? email, List<String> domains) {
    if (!isValid(email)) {
      return false;
    }
    final parts = email!.split('@');
    if (parts.length != 2) {
      return false;
    }
    final emailDomain = parts[1].toLowerCase();
    return domains.any((d) => emailDomain == d.toLowerCase());
  }

  /// Validates if an email is from a free email provider.
  ///
  /// Common free providers include gmail, yahoo, hotmail, etc.
  static bool isFreeEmail(String? email) {
    if (!isValid(email)) {
      return false;
    }
    const freeDomains = [
      'gmail.com',
      'yahoo.com',
      'yahoo.co.uk',
      'hotmail.com',
      'hotmail.co.uk',
      'outlook.com',
      'live.com',
      'msn.com',
      'aol.com',
      'icloud.com',
      'mail.com',
      'protonmail.com',
      'zoho.com',
      'yandex.com',
    ];
    return isAnyDomain(email, freeDomains);
  }

  /// Extracts the domain from an email address.
  ///
  /// Returns `null` if the email is invalid.
  static String? extractDomain(String? email) {
    if (!isValid(email)) {
      return null;
    }
    final parts = email!.split('@');
    return parts.length == 2 ? parts[1] : null;
  }

  /// Extracts the local part (before @) from an email address.
  ///
  /// Returns `null` if the email is invalid.
  static String? extractLocalPart(String? email) {
    if (!isValid(email)) {
      return null;
    }
    final parts = email!.split('@');
    return parts.length == 2 ? parts[0] : null;
  }

  /// Returns a validation error message for an invalid email.
  ///
  /// Supports localization by accepting a custom message generator.
  static String getErrorMessage(
    String? email, {
    String? customMessage,
    bool isRequired = true,
  }) {
    if (email == null || email.isEmpty) {
      return customMessage ??
          (isRequired ? 'Email is required' : 'Invalid email format');
    }

    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      return customMessage ??
          (isRequired ? 'Email is required' : 'Invalid email format');
    }

    return customMessage ?? 'Please enter a valid email address';
  }

  /// Validates an email and returns detailed validation result.
  static EmailValidationResult validate(String? email) {
    if (email == null || email.isEmpty) {
      return const EmailValidationResult(
        isValid: false,
        errorCode: EmailErrorCode.empty,
        errorMessage: 'Email is required',
      );
    }

    final trimmed = email.trim();

    if (trimmed.isEmpty) {
      return const EmailValidationResult(
        isValid: false,
        errorCode: EmailErrorCode.empty,
        errorMessage: 'Email is required',
      );
    }

    // Check basic format
    if (!_emailPattern.hasMatch(trimmed)) {
      return EmailValidationResult(
        isValid: false,
        errorCode: EmailErrorCode.invalidFormat,
        errorMessage: 'Please enter a valid email address',
        domain: extractDomain(trimmed),
      );
    }

    // Check for common typos in major domains
    final domain = extractDomain(trimmed);
    final typoResult = _checkCommonTypos(trimmed, domain);
    if (typoResult != null) {
      return typoResult;
    }

    return EmailValidationResult(
      isValid: true,
      errorCode: null,
      errorMessage: null,
      domain: domain,
      localPart: extractLocalPart(trimmed),
    );
  }

  /// Checks for common email domain typos and suggests corrections.
  static EmailValidationResult? _checkCommonTypos(
    String email,
    String? domain,
  ) {
    if (domain == null) return null;

    // Common typos mapping
    const typos = {
      'gmal.com': 'gmail.com',
      'gmial.com': 'gmail.com',
      'gamil.com': 'gmail.com',
      'gnail.com': 'gmail.com',
      'yahooo.com': 'yahoo.com',
      'yaho.com': 'yahoo.com',
      'hotmial.com': 'hotmail.com',
      'hotmal.com': 'hotmail.com',
      'outloo.com': 'outlook.com',
      'outlok.com': 'outlook.com',
    };

    final lowerDomain = domain.toLowerCase();
    if (typos.containsKey(lowerDomain)) {
      return EmailValidationResult(
        isValid: false,
        errorCode: EmailErrorCode.typo,
        errorMessage: 'Did you mean ${typos[lowerDomain]}?',
        domain: domain,
        suggestedCorrection: '${extractLocalPart(email)}@${typos[lowerDomain]}',
      );
    }

    return null;
  }

  /// Sanitizes an email address by trimming whitespace and
  /// converting to lowercase.
  static String sanitize(String? email) {
    if (email == null) return '';
    return email.trim().toLowerCase();
  }

  /// Checks if two email addresses are equal (case-insensitive).
  static bool equals(String? email1, String? email2) {
    if (email1 == null && email2 == null) return true;
    if (email1 == null || email2 == null) return false;
    return sanitize(email1) == sanitize(email2);
  }
}

/// Result of email validation with detailed information.
class EmailValidationResult {
  /// Whether the email is valid.
  final bool isValid;

  /// Error code if validation failed.
  final EmailErrorCode? errorCode;

  /// Error message if validation failed.
  final String? errorMessage;

  /// The domain part of the email (if valid).
  final String? domain;

  /// The local part of the email (if valid).
  final String? localPart;

  /// Suggested correction if a typo was detected.
  final String? suggestedCorrection;

  const EmailValidationResult({
    required this.isValid,
    required this.errorCode,
    required this.errorMessage,
    this.domain,
    this.localPart,
    this.suggestedCorrection,
  });

  /// Returns true if there's a suggested correction available.
  bool get hasSuggestion => suggestedCorrection != null;
}

/// Error codes for email validation failures.
enum EmailErrorCode {
  /// Email is empty or null.
  empty,

  /// Email format is invalid.
  invalidFormat,

  /// Possible typo detected.
  typo,

  /// Email domain doesn't exist.
  domainNotExist,

  /// Email isdisposable.
  disposable,

  /// Email is not allowed for this context.
  notAllowed,
}
