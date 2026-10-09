/*
 * Created by Ankit Saxena on 08-10-2026.
 */



import 'attendance_status.dart';
// Port of: DateEntry.java / AttendanceRecord.java (inferred from usage in
// AttendanceRepository.java and AttendanceVerificationActivity.java)

class AttendanceVerifyModel {
  final String id;
  final String shiftId;
  final String shiftName;
  final String unitName;
  final String unitCode;
  final String postId;
  final String postName;

  /// Display strings ("02:00 PM"), "—" when missing.
  final String shiftStart;
  final String shiftEnd;
  final String dutyIn;
  final String dutyOut;

  final String dutyStatus; // raw DUTY_STATUS: DUTY_OUT | DUTY_IN_ONLY | ABSENT
  final String shiftStartTime; // raw SHIFT_START_TIME "yyyy-MM-dd HH:mm:ss"
  final int dutyMinutes;
  final int shiftMinutes;
  final int approvedHrs;

  // Claim fields (needed by the Missing-Claim screen)
  final int claimReason;
  final String claimRemark;
  final int claimStatus;
  final String claimSubmittedOn;
  final int raiseComplaintStatus;

  /// Replaces CFUtil.resolveNudgeType(...) – derived here from the raw times.
  final bool dutyOutMissing;
  final bool lateDutyIn;

  /// "Pending" | "Approved" | "Rejected"
  String status;

  final Map<String, dynamic> raw;

  /// Port of AttendanceRecord.dateKey()
  String get dateKey =>
      shiftStartTime.length < 10 ? '' : shiftStartTime.substring(0, 10);

  /// Port of isClaimSubmitted()
  bool get isClaimSubmitted => claimSubmittedOn.trim().isNotEmpty;

  /// Port of isClaimPending()
  bool get isClaimPending => isClaimSubmitted && claimStatus == 0;

  AttendanceVerifyModel({
    required this.id,
    required this.shiftId,
    required this.shiftName,
    required this.unitName,
    required this.unitCode,
    required this.postId,
    required this.postName,
    required this.shiftStart,
    required this.shiftEnd,
    required this.dutyIn,
    required this.dutyOut,
    required this.dutyStatus,
    required this.shiftStartTime,
    required this.dutyMinutes,
    required this.shiftMinutes,
    required this.approvedHrs,
    required this.claimReason,
    required this.claimRemark,
    required this.claimStatus,
    required this.claimSubmittedOn,
    required this.raiseComplaintStatus,
    required this.dutyOutMissing,
    required this.lateDutyIn,
    required this.status,
    required this.raw,
  });
}

class DateEntry {
  final String dayName; // Mon
  final String dayNumber; // 21
  final String shortDateLabel; // 21 Sep 2026
  final String fullDateLabel; // Monday, 21 September 2026
  final String monthYearTag; // September 2026
  final String apiDate; // 2026-09-21
  final List<AttendanceVerifyModel> records;

  final String startDateRange;
  final String endDateRange;
  final bool isCompleted;

  /// 1 = view-only (no verify / claim actions allowed)
  final int viewType;

  /// "Absent" | "Pending" | "Approved" | "Rejected"
  String overallStatus;
  bool isSubmitted;

  DateEntry({
    required this.dayName,
    required this.dayNumber,
    required this.shortDateLabel,
    required this.fullDateLabel,
    required this.monthYearTag,
    required this.apiDate,
    required this.records,
    required this.startDateRange,
    required this.endDateRange,
    required this.isCompleted,
    required this.viewType,
    required this.overallStatus,
    required this.isSubmitted,
  });

  bool get isViewOnly => viewType == 1;

  /// Buttons are usable only for editable, not-yet-verified days.
  bool get canAct => !isSubmitted && !isViewOnly && overallStatus != 'Approved';

  /// Port of entry.refreshOverallStatus() after a successful verify.
  void markVerified() {
    for (final r in records) {
      r.status = 'Approved';
    }
    overallStatus = 'Approved';
    isSubmitted = true;
  }
}