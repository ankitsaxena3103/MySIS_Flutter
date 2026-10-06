import 'attendance_record.dart';
import 'verify_status.dart';

/// One card/tab per calendar date in the verification window (Java: DateEntry).
class DateEntry {
  DateEntry({
    required this.dayName,
    required this.dayNumber,
    required this.shortDateLabel,
    required this.fullDateLabel,
    required this.records,
    required this.overall,
    required this.startDateRange,
    required this.endDateRange,
    required this.isCompleted,
    required this.apiDate,
    required this.monthYearTag,
    required this.viewType,
  }) : isSubmitted = overall == VerifyStatus.approved;

  final String dayName;
  final String dayNumber;
  final String shortDateLabel;
  final String fullDateLabel;
  final List<AttendanceRecord> records;
  final VerifyStatus overall;
  final String startDateRange;
  final String endDateRange;
  final bool isCompleted;
  final String apiDate; // "yyyy-MM-dd"
  final String monthYearTag; // "June 2026"
  final int viewType; // API VIEW_ONLY

  /// Mutable on purpose: flipped after a successful verify/claim submit.
  bool isSubmitted;
}
