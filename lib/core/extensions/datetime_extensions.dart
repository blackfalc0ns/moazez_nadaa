import 'package:intl/intl.dart';

/// DateTime extensions providing utility methods for date manipulation and formatting
extension DateTimeExtensions on DateTime {
  /// Format date to string with given format
  String format(String formatPattern) {
    return DateFormat(formatPattern).format(this);
  }

  /// Format to date string (yyyy-MM-dd)
  String get toDateString => format('yyyy-MM-dd');

  /// Format to time string (HH:mm:ss)
  String get toTimeString => format('HH:mm:ss');

  /// Format to date and time string (yyyy-MM-dd HH:mm:ss)
  String get toDateTimeString => format('yyyy-MM-dd HH:mm:ss');

  /// Format to readable date (e.g., "Jan 15, 2024")
  String get toReadableDate => format('MMM d, yyyy');

  /// Format to readable date with time (e.g., "Jan 15, 2024 at 3:30 PM")
  String get toReadableDateTime => format('MMM d, yyyy \'at\' h:mm a');

  /// Format to short date (e.g., "1/15/2024")
  String get toShortDate => format('M/d/yyyy');

  /// Format to long date (e.g., "January 15, 2024")
  String get toLongDate => format('MMMM d, yyyy');

  /// Format to month and year (e.g., "January 2024")
  String get toMonthYear => format('MMMM yyyy');

  /// Format to time only (e.g., "3:30 PM")
  String get toTime12Hour => format('h:mm a');

  /// Format to time in 24 hour format (e.g., "15:30")
  String get toTime24Hour => format('HH:mm');

  /// Get relative time string (e.g., "2 hours ago", "in 3 days")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      return _futureTimeAgo(difference.abs());
    }
    return _pastTimeAgo(difference);
  }

  String _pastTimeAgo(Duration difference) {
    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  String _futureTimeAgo(Duration difference) {
    if (difference.inSeconds < 60) {
      return 'in a few seconds';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'in $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'in $hours ${hours == 1 ? 'hour' : 'hours'}';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'in $days ${days == 1 ? 'day' : 'days'}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'in $weeks ${weeks == 1 ? 'week' : 'weeks'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'in $months ${months == 1 ? 'month' : 'months'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'in $years ${years == 1 ? 'year' : 'years'}';
    }
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Check if date is in the current week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
           isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if date is in the current month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Check if date is in the current year
  bool get isThisYear => year == DateTime.now().year;

  /// Check if date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Get start of day
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get start of week (Monday)
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1)).startOfDay;
  }

  /// Get end of week (Sunday)
  DateTime get endOfWeek {
    return add(Duration(days: DateTime.daysPerWeek - weekday)).endOfDay;
  }

  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Get number of days in month
  int get daysInMonth => DateTime(year, month + 1, 0).day;

  /// Check if date is same day as other date
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Get difference in days from other date
  int daysDifference(DateTime other) {
    return difference(other).inDays.abs();
  }

  /// Add days to date
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract days from date
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Get age from this date
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Format for API (ISO 8601)
  String get toApiFormat => toIso8601String();

  /// Get day name
  String get dayName {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  /// Get short day name
  String get shortDayName {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  /// Get month name
  String get monthName {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  /// Get short month name
  String get shortMonthName {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}

/// Nullable DateTime extensions
extension NullableDateTimeExtensions on DateTime? {
  /// Check if null
  bool get isNull => this == null;

  /// Check if not null
  bool get isNotNull => this != null;

  /// Get value or now
  DateTime get orNow => this ?? DateTime.now();

  /// Get value or null and apply operation safely
  String? format(String pattern) => isNotNull ? this!.format(pattern) : null;
}