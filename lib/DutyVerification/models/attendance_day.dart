import 'attendance_status.dart';

/// One calendar day, built from all shifts of that date
/// (port of AttendanceDayModel).
class AttendanceDay {
  String dateKey = '';
  String dateLabel = ''; // "11 September"
  String dayName = ''; // "Fri"
  int shiftCount = 0;
  String? unitCode;
  int totalDutyMin = 0;
  double totalDutyCount = 0.0;
  bool anyMissingHours = true;
  int status = AttendanceStatus.pending;
  bool claimPending = false;
  List<String> shiftLabels = const [];
}
