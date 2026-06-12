import 'pickup_request.dart';

class CallsHistoryRecord {
  const CallsHistoryRecord({
    required this.date,
    required this.durationLabel,
    required this.request,
  });

  final DateTime date;
  final String durationLabel;
  final PickupRequest request;
}

bool isSameHistoryDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

String formatHistoryDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
