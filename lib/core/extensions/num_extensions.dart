import 'dart:math' as math;

/// Number extensions providing utility methods for numeric manipulation
extension NumExtensions on num {
  /// Check if number is between min and max (inclusive)
  bool isBetween(num min, num max) => this >= min && this <= max;

  /// Clamp value between min and max
  num clampValues(num min, num max) => clamp(min, max);

  /// Format number as currency
  String toCurrency({
    String symbol = '\$',
    String decimalSeparator = '.',
    String thousandSeparator = ',',
    int decimalDigits = 2,
  }) {
    final parts = toStringAsFixed(decimalDigits).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match.group(1)}$thousandSeparator',
    );
    final decPart = parts.length > 1 ? decimalSeparator + parts[1] : '';
    return '$symbol$intPart$decPart';
  }

  /// Format number as percentage
  String toPercentage({int decimalDigits = 0}) {
    return '${(this * 100).toStringAsFixed(decimalDigits)}%';
  }

  /// Format number with thousand separators
  String formatWithSeparators({String thousandSeparator = ','}) {
    final parts = toString().split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match.group(1)}$thousandSeparator',
    );
    return parts.length > 1 ? '$intPart.${parts[1]}' : intPart;
  }

  /// Check if number is even
  bool get isEven => this % 2 == 0;

  /// Check if number is odd
  bool get isOdd => this % 2 != 0;

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Get ordinal suffix (st, nd, rd, th)
  String get ordinal {
    if (this >= 11 && this <= 13) {
      return '${this}th';
    }
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  /// Convert to Duration in milliseconds
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// Convert to Duration in seconds
  Duration get seconds => Duration(seconds: toInt());

  /// Convert to Duration in minutes
  Duration get minutes => Duration(minutes: toInt());

  /// Convert to Duration in hours
  Duration get hours => Duration(hours: toInt());

  /// Convert to Duration in days
  Duration get days => Duration(days: toInt());

  /// Check if valid latitude
  bool get isValidLatitude => isBetween(-90, 90);

  /// Check if valid longitude
  bool get isValidLongitude => isBetween(-180, 180);

  /// Round to decimal places
  num roundTo(int places) {
    if (places < 0) return this;
    final mod = math.pow(10, places).toDouble();
    return (this * mod).round() / mod;
  }
}

/// Double extensions
extension DoubleExtensions on double {
  /// Format as compact number (e.g., 1.2K, 3.4M)
  String get compact {
    if (this >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(1)}B';
    } else if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toStringAsFixed(this == toInt() ? 0 : 1);
  }

  /// Round to specified decimal places
  double roundToDecimals(int places) {
    if (places < 0) return this;
    final mod = math.pow(10, places).toDouble();
    return (this * mod).round() / mod;
  }
}

/// Int extensions
extension IntExtensions on int {
  /// Get page count for given items per page
  int pageCount(int itemsPerPage) {
    if (itemsPerPage <= 0) return 0;
    return (this / itemsPerPage).ceil();
  }

  /// Check if this is a power of two
  bool get isPowerOfTwo {
    if (this <= 0) return false;
    return (this & (this - 1)) == 0;
  }

  /// Get next power of two
  int get nextPowerOfTwo {
    int n = this - 1;
    n |= n >> 1;
    n |= n >> 2;
    n |= n >> 4;
    n |= n >> 8;
    n |= n >> 16;
    return n + 1;
  }

  /// Convert bytes to human readable string
  String get bytesToReadable {
    if (this < 1024) return '$this B';
    if (this < 1024 * 1024) return '${(this / 1024).toStringAsFixed(1)} KB';
    if (this < 1024 * 1024 * 1024) return '${(this / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}