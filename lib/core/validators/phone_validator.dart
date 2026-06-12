/// Phone number validation utilities with international support,
/// formatting, and localization.
class PhoneValidator {
  /// Regular expression for basic phone number validation.
  /// Allows digits, spaces, dashes, parentheses, and plus sign.
  static final RegExp _basicPattern = RegExp(
    r'^[\d\s\-\(\)\+]+$',
  );

  /// E.164 international phone number format pattern.
  static final RegExp _e164Pattern = RegExp(
    r'^\+[1-9]\d{1,14}$',
  );

  /// Validates a phone number using basic format checks.
  ///
  /// Returns `true` if the phone number appears valid, `false` otherwise.
  static bool isValid(String? phone) {
    if (phone == null || phone.isEmpty) {
      return false;
    }

    // Remove all formatting characters
    final digitsOnly = _extractDigits(phone);

    // Check minimum length (at least 7 digits for local numbers)
    if (digitsOnly.length < 7) {
      return false;
    }

    // Check maximum length (15 digits per ITU standards)
    if (digitsOnly.length > 15) {
      return false;
    }

    // Check that it matches the basic pattern
    return _basicPattern.hasMatch(phone);
  }

  /// Validates a phone number in E.164 international format.
  ///
  /// E.164 format: +[country code][number] (e.g., +12025551234)
  static bool isValidE164(String? phone) {
    if (phone == null || phone.isEmpty) {
      return false;
    }
    return _e164Pattern.hasMatch(phone);
  }

  /// Validates a phone number for a specific country.
  ///
  /// Uses the provided country code (ISO 3166-1 alpha-2) to
  /// validate against country-specific rules.
  static bool isValidForCountry(
    String? phone,
    String countryCode, {
    bool checkLength = true,
  }) {
    if (!isValid(phone)) {
      return false;
    }

    final countryInfo = _CountryData.byCode(countryCode.toUpperCase());
    if (countryInfo == null) {
      // If country not found, fall back to basic validation
      return true;
    }

    final digitsOnly = _extractDigits(phone!);

    // Handle international prefix
    String numberForLength = digitsOnly;
    if (digitsOnly.startsWith('${countryInfo.countryCode}')) {
      numberForLength = digitsOnly.substring(
        countryInfo.countryCode.toString().length,
      );
    }

    if (checkLength) {
      // Check minimum length (national number without country code)
      if (numberForLength.length < countryInfo.minLength) {
        return false;
      }

      // Check maximum length (national number without country code)
      if (numberForLength.length > countryInfo.maxLength) {
        return false;
      }
    }

    return true;
  }

  /// Validates a phone number and returns detailed result.
  static PhoneValidationResult validate(String? phone) {
    if (phone == null || phone.isEmpty) {
      return const PhoneValidationResult(
        isValid: false,
        errorCode: PhoneErrorCode.empty,
        errorMessage: 'Phone number is required',
      );
    }

    final digitsOnly = _extractDigits(phone);

    if (digitsOnly.isEmpty) {
      return const PhoneValidationResult(
        isValid: false,
        errorCode: PhoneErrorCode.invalidCharacters,
        errorMessage: 'Phone number contains invalid characters',
      );
    }

    // Check minimum length
    if (digitsOnly.length < 7) {
      return PhoneValidationResult(
        isValid: false,
        errorCode: PhoneErrorCode.tooShort,
        errorMessage: 'Phone number is too short',
        digitsOnly: digitsOnly,
      );
    }

    // Check maximum length
    if (digitsOnly.length > 15) {
      return PhoneValidationResult(
        isValid: false,
        errorCode: PhoneErrorCode.tooLong,
        errorMessage: 'Phone number is too long',
        digitsOnly: digitsOnly,
      );
    }

    // Check if starts with + (international format)
    final isInternational = phone.startsWith('+');

    // Extract country code if possible
    String? countryCode;
    String? nationalNumber;

    if (isInternational) {
      final parsed = _parseCountryCode(digitsOnly);
      if (parsed != null) {
        countryCode = parsed['countryCode'];
        nationalNumber = parsed['nationalNumber'];
      }
    }

    return PhoneValidationResult(
      isValid: true,
      errorCode: null,
      errorMessage: null,
      digitsOnly: digitsOnly,
      isInternational: isInternational,
      countryCode: countryCode,
      nationalNumber: nationalNumber ?? digitsOnly,
    );
  }

  /// Extracts only the digits from a phone number string.
  static String _extractDigits(String phone) {
    return phone.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Parses the country code from a phone number.
  static Map<String, String>? _parseCountryCode(String digitsOnly) {
    // Check for country codes (single, double, and triple digit)
    for (int len = 3; len >= 1; len--) {
      if (digitsOnly.length > len) {
        final code = digitsOnly.substring(0, len);
        final countryName = _countryCodeToName(code);
        if (countryName != null) {
          final countryInfo = _CountryData.byCode(countryName);
          if (countryInfo != null) {
          return {
            'countryCode': code,
          };
        }
        }
      }
    }
    return null;
  }

  /// Converts country code number to name.
  static String? _countryCodeToName(String code) {
    const codeToName = {
      '1': 'US',
      '7': 'RU',
      '20': 'EG',
      '27': 'ZA',
      '30': 'GR',
      '31': 'NL',
      '32': 'BE',
      '33': 'FR',
      '34': 'ES',
      '36': 'HU',
      '39': 'IT',
      '40': 'RO',
      '41': 'CH',
      '43': 'AT',
      '44': 'GB',
      '45': 'DK',
      '46': 'SE',
      '47': 'NO',
      '48': 'PL',
      '49': 'DE',
      '51': 'PE',
      '52': 'MX',
      '53': 'CU',
      '54': 'AR',
      '55': 'BR',
      '56': 'CL',
      '57': 'CO',
      '58': 'VE',
      '60': 'MY',
      '61': 'AU',
      '62': 'ID',
      '63': 'PH',
      '64': 'NZ',
      '65': 'SG',
      '66': 'TH',
      '81': 'JP',
      '82': 'KR',
      '84': 'VN',
      '86': 'CN',
      '90': 'TR',
      '91': 'IN',
      '92': 'PK',
      '93': 'AF',
      '94': 'LK',
      '95': 'MM',
      '98': 'IR',
      '211': 'SS',
      '212': 'MA',
      '213': 'DZ',
      '216': 'TN',
      '218': 'LY',
      '220': 'GM',
      '221': 'SN',
      '222': 'MR',
      '223': 'ML',
      '224': 'GN',
      '225': 'CI',
      '226': 'BF',
      '227': 'NE',
      '228': 'TG',
      '229': 'BJ',
      '230': 'MU',
      '231': 'LR',
      '232': 'SL',
      '233': 'GH',
      '234': 'NG',
      '235': 'TD',
      '236': 'CF',
      '237': 'CM',
      '238': 'CV',
      '239': 'ST',
      '240': 'GQ',
      '241': 'GA',
      '242': 'CG',
      '243': 'CD',
      '244': 'AO',
      '245': 'GW',
      '246': 'IO',
      '247': 'AC',
      '248': 'SC',
      '249': 'SD',
      '250': 'RW',
      '251': 'ET',
      '252': 'SO',
      '253': 'DJ',
      '254': 'KE',
      '255': 'TZ',
      '256': 'UG',
      '257': 'BI',
      '258': 'MZ',
      '260': 'ZM',
      '261': 'MG',
      '262': 'RE',
      '263': 'ZW',
      '264': 'NA',
      '265': 'MW',
      '266': 'LS',
      '267': 'BW',
      '268': 'SZ',
      '269': 'KM',
      '290': 'SH',
      '291': 'ER',
      '297': 'AW',
      '298': 'FO',
      '299': 'GL',
      '350': 'GI',
      '351': 'PT',
      '352': 'LU',
      '353': 'IE',
      '354': 'IS',
      '355': 'AL',
      '356': 'MT',
      '357': 'CY',
      '358': 'FI',
      '359': 'BG',
      '370': 'LT',
      '371': 'LV',
      '372': 'EE',
      '373': 'MD',
      '374': 'AM',
      '375': 'BY',
      '376': 'AD',
      '377': 'MC',
      '378': 'SM',
      '380': 'UA',
      '381': 'RS',
      '382': 'ME',
      '383': 'XK',
      '385': 'HR',
      '386': 'SI',
      '387': 'BA',
      '389': 'MK',
      '420': 'CZ',
      '421': 'SK',
      '423': 'LI',
      '501': 'BZ',
      '502': 'GT',
      '503': 'SV',
      '504': 'HN',
      '505': 'NI',
      '506': 'CR',
      '507': 'PA',
      '508': 'PM',
      '509': 'HT',
      '590': 'GP',
      '591': 'BO',
      '592': 'GY',
      '593': 'EC',
      '594': 'GF',
      '595': 'PY',
      '596': 'MQ',
      '597': 'SR',
      '598': 'UY',
      '599': 'CW',
      '670': 'TL',
      '672': 'NF',
      '673': 'BN',
      '674': 'NR',
      '675': 'PG',
      '676': 'TO',
      '677': 'SB',
      '678': 'VU',
      '679': 'FJ',
      '680': 'PW',
      '681': 'WF',
      '682': 'CK',
      '683': 'NU',
      '685': 'WS',
      '686': 'KI',
      '687': 'NC',
      '688': 'TV',
      '689': 'TF',
      '690': 'TK',
      '691': 'FM',
      '692': 'MH',
      '850': 'KP',
      '852': 'HK',
      '853': 'MO',
      '855': 'KH',
      '856': 'LA',
      '880': 'BD',
      '886': 'TW',
      '960': 'MV',
      '961': 'LB',
      '962': 'JO',
      '963': 'SY',
      '964': 'IQ',
      '965': 'KW',
      '966': 'SA',
      '967': 'YE',
      '968': 'OM',
      '970': 'PS',
      '971': 'AE',
      '972': 'IL',
      '973': 'BH',
      '974': 'QA',
      '975': 'BT',
      '976': 'MN',
      '977': 'NP',
      '992': 'TJ',
      '993': 'TM',
      '994': 'AZ',
      '995': 'GE',
      '996': 'KG',
      '998': 'UZ',
    };
    return codeToName[code];
  }

  /// Formats a phone number according to the specified country.
  static String format(
    String? phone, {
    String? countryCode,
    PhoneFormat format = PhoneFormat.international,
  }) {
    if (phone == null || phone.isEmpty) {
      return '';
    }

    final digitsOnly = _extractDigits(phone);

    switch (format) {
      case PhoneFormat.digits:
        return digitsOnly;

      case PhoneFormat.international:
        return _formatInternational(digitsOnly, countryCode);

      case PhoneFormat.national:
        return _formatNational(digitsOnly, countryCode);

      case PhoneFormat.e164:
        return _formatE164(digitsOnly, countryCode);
    }
  }

  static String _formatInternational(String digitsOnly, String? countryCode) {
    if (digitsOnly.startsWith('+')) {
      digitsOnly = digitsOnly.substring(1);
    }

    final countryInfo = countryCode != null
        ? _CountryData.byCode(countryCode.toUpperCase())
        : null;

    if (countryInfo != null) {
      final nationalNumber = digitsOnly.startsWith(countryInfo.countryCode.toString())
          ? digitsOnly.substring(countryInfo.countryCode.toString().length)
          : digitsOnly;

      return '+${countryInfo.countryCode} $nationalNumber';
    }

    // Fallback: just add + prefix
    return '+$digitsOnly';
  }

  static String _formatNational(String digitsOnly, String? countryCode) {
    if (digitsOnly.startsWith('+')) {
      digitsOnly = digitsOnly.substring(1);
    }

    final countryInfo = countryCode != null
        ? _CountryData.byCode(countryCode.toUpperCase())
        : null;

    if (countryInfo != null) {
      final nationalNumber = digitsOnly.startsWith(countryInfo.countryCode.toString())
          ? digitsOnly.substring(countryInfo.countryCode.toString().length)
          : digitsOnly;

      return nationalNumber;
    }

    return digitsOnly;
  }

  static String _formatE164(String digitsOnly, String? countryCode) {
    if (!digitsOnly.startsWith('+')) {
      digitsOnly = '+$digitsOnly';
    }
    return digitsOnly;
  }

  /// Sanitizes a phone number by removing all non-digit characters
  /// except the leading + sign.
  static String sanitize(String? phone) {
    if (phone == null || phone.isEmpty) {
      return '';
    }

    final isInternational = phone.startsWith('+');
    final digits = _extractDigits(phone);

    return isInternational ? '+$digits' : digits;
  }

  /// Checks if two phone numbers are equal (ignoring formatting).
  static bool equals(String? phone1, String? phone2) {
    if (phone1 == null && phone2 == null) return true;
    if (phone1 == null || phone2 == null) return false;
    return sanitize(phone1) == sanitize(phone2);
  }

  /// Normalizes a phone number to E.164 format if possible.
  static String? normalizeToE164(String? phone, String defaultCountryCode) {
    if (phone == null || phone.isEmpty) {
      return null;
    }

    final digitsOnly = _extractDigits(phone);
    final countryInfo = _CountryData.byCode(defaultCountryCode.toUpperCase());

    if (countryInfo != null) {
      // If doesn't start with country code, prepend it
      if (!digitsOnly.startsWith(countryInfo.countryCode.toString())) {
        return '+${countryInfo.countryCode}$digitsOnly';
      }
    }

    return phone.startsWith('+') ? phone : '+$digitsOnly';
  }
}

/// Phone number format options.
enum PhoneFormat {
  /// Digits only (e.g., 12025551234).
  digits,

  /// International format (e.g., +1 202 555 1234).
  international,

  /// National format (e.g., (202) 555-1234).
  national,

  /// E.164 format (e.g., +12025551234).
  e164,
}

/// Result of phone number validation.
class PhoneValidationResult {
  /// Whether the phone number is valid.
  final bool isValid;

  /// Error code if validation failed.
  final PhoneErrorCode? errorCode;

  /// Error message if validation failed.
  final String? errorMessage;

  /// Digits only (no formatting).
  final String? digitsOnly;

  /// Whether the number uses international format (+).
  final bool? isInternational;

  /// Country code if detected (e.g., '1' for US).
  final String? countryCode;

  /// National number (without country code).
  final String? nationalNumber;

  const PhoneValidationResult({
    required this.isValid,
    required this.errorCode,
    required this.errorMessage,
    this.digitsOnly,
    this.isInternational,
    this.countryCode,
    this.nationalNumber,
  });

  /// Returns true if country code was successfully detected.
  bool get hasCountryCode => countryCode != null;
}

/// Error codes for phone validation.
enum PhoneErrorCode {
  /// Phone number is empty or null.
  empty,

  /// Phone number contains invalid characters.
  invalidCharacters,

  /// Phone number is too short.
  tooShort,

  /// Phone number is too long.
  tooLong,

  /// Invalid country code.
  invalidCountryCode,

  /// Invalid format for the specified country.
  invalidForCountry,
}

/// Internal class for country-specific phone data.
class _CountryData {
  final String code;
  final int countryCode;
  final int minLength;
  final int maxLength;

  const _CountryData({
    required this.code,
    required this.countryCode,
    required this.minLength,
    required this.maxLength,
  });

  static _CountryData? byCode(String code) {
    const countries = {
      'US': _CountryData(code: 'US', countryCode: 1, minLength: 10, maxLength: 10),
      'GB': _CountryData(code: 'GB', countryCode: 44, minLength: 10, maxLength: 10),
      'DE': _CountryData(code: 'DE', countryCode: 49, minLength: 10, maxLength: 11),
      'FR': _CountryData(code: 'FR', countryCode: 33, minLength: 9, maxLength: 9),
      'SA': _CountryData(code: 'SA', countryCode: 966, minLength: 9, maxLength: 9),
      'AE': _CountryData(code: 'AE', countryCode: 971, minLength: 9, maxLength: 9),
      'EG': _CountryData(code: 'EG', countryCode: 20, minLength: 10, maxLength: 10),
      'IN': _CountryData(code: 'IN', countryCode: 91, minLength: 10, maxLength: 10),
      'CN': _CountryData(code: 'CN', countryCode: 86, minLength: 11, maxLength: 11),
      'JP': _CountryData(code: 'JP', countryCode: 81, minLength: 10, maxLength: 10),
      'KR': _CountryData(code: 'KR', countryCode: 82, minLength: 10, maxLength: 10),
      'AU': _CountryData(code: 'AU', countryCode: 61, minLength: 9, maxLength: 9),
      'BR': _CountryData(code: 'BR', countryCode: 55, minLength: 10, maxLength: 11),
      'MX': _CountryData(code: 'MX', countryCode: 52, minLength: 10, maxLength: 11),
      'AR': _CountryData(code: 'AR', countryCode: 54, minLength: 10, maxLength: 10),
    };

    return countries[code];
  }
}
