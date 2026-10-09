import 'attendance_status.dart';

/// One shift row exactly as the API returns it
/// (port of MonthlyAttendanceRecordModel.java, same @SerializedName keys).
class AttendanceRecord {
  final String? id;
  final String? unitCode;
  final String? unitName;
  final String? postName;
  final String? shiftName;
  final String? shiftStartDate; // "2026-06-05 00:00:00"
  final int? dutyMin; // nullable
  final int status; // 0 = Pending, 1 = Approved, 2 = Rejected
  final double? dutyCount;
  final String? claimSubmittedOn;
  final int? claimStatus; // nullable, 0 = pending

  AttendanceRecord({
    this.id,
    this.unitCode,
    this.unitName,
    this.postName,
    this.shiftName,
    this.shiftStartDate,
    this.dutyMin,
    this.status = AttendanceStatus.pending,
    this.dutyCount,
    this.claimSubmittedOn,
    this.claimStatus,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> j) {
    return AttendanceRecord(
      id: j['ID']?.toString(),
      unitCode: j['UNIT_CODE']?.toString(),
      unitName: j['UNIT_NAME']?.toString(),
      postName: j['POST_NAME']?.toString(),
      shiftName: j['SHIFT_NAME']?.toString(),
      shiftStartDate: j['SHIFT_START_DATE']?.toString(),
      dutyMin: _toInt(j['DUTY_MIN']),
      status: _toInt(j['STATUS']) ?? AttendanceStatus.pending,
      dutyCount: _toDouble(j['DUTY_COUNT']),
      claimSubmittedOn: j['CLAIM_SUBMITTED_ON']?.toString(),
      claimStatus: _toInt(j['CLAIM_STATUS']),
    );
  }

  bool get isClaimSubmitted =>
      claimSubmittedOn != null && claimSubmittedOn!.trim().isNotEmpty;

  bool get claimPending => isClaimSubmitted && claimStatus == 0;

  /// "2026-06-05 00:00:00" -> "2026-06-05"
  String get dateKey {
    final s = shiftStartDate;
    if (s == null || s.length < 10) return '';
    return s.substring(0, 10);
  }

  // API may send numbers as int, double or string — handle all.
  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString().trim()) ??
        double.tryParse(v.toString().trim())?.toInt();
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString().trim());
  }
}