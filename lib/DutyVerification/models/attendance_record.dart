import 'attendance_status.dart';

/// One shift row exactly as the API returns it
/// (port of MonthlyAttendanceRecordModel).
/// !! Check the JSON keys against your real API response.
class AttendanceRecord {
  final String? dateKey; // "yyyy-MM-dd"
  final String? unitCode;
  final String? shiftName;
  final double? dutyCount;
  final int? dutyMin;
  final int status;
  final bool claimPending;

  AttendanceRecord({
    this.dateKey,
    this.unitCode,
    this.shiftName,
    this.dutyCount,
    this.dutyMin,
    this.status = AttendanceStatus.pending,
    this.claimPending = false,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> j) {
    final rawDate =
        (j['dateKey'] ?? j['ATTENDANCE_DATE'] ?? j['DATE'])?.toString();

    return AttendanceRecord(
      dateKey: (rawDate != null && rawDate.length >= 10)
          ? rawDate.substring(0, 10)
          : null,
      unitCode: j['unitCode']?.toString(),
      shiftName: j['shiftName']?.toString(),
      dutyCount: double.tryParse('${j['dutyCount']}'),
      dutyMin: int.tryParse('${j['dutyMin']}'),
      status: int.tryParse('${j['status']}') ?? AttendanceStatus.pending,
      // !! Port of isClaimPending() from the Java model
      claimPending:
          j['claimPending'] == true || '${j['claimStatus']}' == 'PENDING',
    );
  }
}
