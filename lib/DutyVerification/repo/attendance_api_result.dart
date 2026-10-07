import '../models/attendance_record.dart';

class AttendanceApiResult {
  final List<AttendanceRecord> records;
  final String startDate;
  final String endDate;

  AttendanceApiResult({
    required this.records,
    required this.startDate,
    required this.endDate,
  });
}
