class UserAttendance {
  final String id;
  final String regNo;
  final String unitCode;
  final String siteName;
  final String dutyPostId;
  final String dutyPostName;
  final String shiftId;
  final String shiftName;
  final DateTime shiftStartDate;
  final DateTime shiftStartTime;
  final DateTime shiftEndTime;
  final DateTime actStartTime;
  final DateTime? actEndTime;
  final DateTime finalStartTime;
  final DateTime? finalEndTime;
  final int? approvedHr;
  final int? rejectedHr;
  final double dutyCount;
  final String dutyInLatLng;
  final String dutyOutLatLng;
  final int deleted;
  final bool isAbsent;
  final int isApproved;
  final String attendanceMode;
  final String dutyRank;
  final String dutyStatus;
  final DateTime createdOn;
  final String empRank;
  final String dutyRankName;
  final String shiftHrs;
  final int shiftMin;
  final int dirtyFlag;
  final DateTime dateModified;
  final DateTime updatedAt;

  UserAttendance({
    required this.id,
    required this.regNo,
    required this.unitCode,
    required this.siteName,
    required this.dutyPostId,
    required this.dutyPostName,
    required this.shiftId,
    required this.shiftName,
    required this.shiftStartDate,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.actStartTime,
    required this.actEndTime,
    required this.finalStartTime,
    required this.finalEndTime,
    required this.approvedHr,
    required this.rejectedHr,
    required this.dutyCount,
    required this.dutyInLatLng,
    required this.dutyOutLatLng,
    required this.deleted,
    required this.isAbsent,
    required this.isApproved,
    required this.attendanceMode,
    required this.dutyRank,
    required this.dutyStatus,
    required this.createdOn,
    required this.empRank,
    required this.dutyRankName,
    required this.shiftHrs,
    required this.shiftMin,
    required this.dirtyFlag,
    required this.dateModified,
    required this.updatedAt,
  });

  /// Factory constructor for creating an instance from JSON
  factory UserAttendance.fromJson(Map<String, dynamic> json) {
    DateTime? safeParseDate(String? date) {
      if (date == null || date.isEmpty) {
        return null;
      }
      try {
        return DateTime.parse(date);
      } catch (e) {
        return null;
      }
    }

    return UserAttendance(
      id: json['ID'] ?? '',
      regNo: json['REGNO'] ?? '',
      unitCode: json['UNIT_CODE'] ?? '',
      siteName: json['SITE_NAME'] ?? '',
      dutyPostId: json['DUTY_POST_ID'] ?? '',
      dutyPostName: json['DUTY_POST_NAME'] ?? '',
      shiftId: json['SHIFT_ID'] ?? '',
      shiftName: json['SHIFT_NAME'] ?? '',
      shiftStartDate: safeParseDate(json['SHIFT_START_DATE'])!,
      shiftStartTime: safeParseDate(json['SHIFT_START_TIME'])!,
      shiftEndTime: safeParseDate(json['SHIFT_END_TIME'])!,
      actStartTime: DateTime.parse(json['ACT_START_TIME']),
      actEndTime: safeParseDate(json['ACT_END_TIME']),
      finalStartTime: DateTime.parse(json['ACT_START_TIME']),
      finalEndTime: safeParseDate(json['FINAL_END_TIME']),
      approvedHr: json['APPROVED_HR'] as int?,
      rejectedHr: json['REJECTED_HR'] as int?,
      dutyCount: json['DUTY_COUNT'] ?? 0,
      dutyInLatLng: json['DUTY_IN_LAT_LNG'] ?? '',
      dutyOutLatLng: json['DUTY_OUT_LAT_LNG'] ?? '',
      deleted: json['DELETED'] ?? 0,
      isAbsent: json['IS_ABSENT'] ?? false,
      isApproved: json['IS_APPROVED'] ?? 0,
      attendanceMode: json['ATTENDANCE_MODE'] ?? '',
      dutyRank: json['DUTY_RANK'] ?? '',
      dutyStatus: json['DUTY_STATUS'] ?? '',
      createdOn: safeParseDate(json['CREATED_ON']) ?? DateTime.now(),
      empRank: json['EMP_RANK'] ?? '',
      dutyRankName: json['DUTY_RANK_NAME'] ?? '',
      shiftHrs: json['SHIFT_HRS'] ?? '',
      shiftMin: json['SHIFT_MIN'] ?? 0,
      dirtyFlag: json['DIRTY_FLAG'] ?? 0,
      dateModified: safeParseDate(json['DATE_MODIFIED']) ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static const fields = {
    'id': 'TEXT PRIMARY KEY', // Unique identifier
    'regNo': 'TEXT NOT NULL',
    'unitCode': 'TEXT',
    'siteName': 'TEXT',
    'dutyPostId': 'TEXT',
    'dutyPostName': 'TEXT',
    'shiftId': 'TEXT',
    'shiftName': 'TEXT',
    'shiftStartDate': 'TEXT',
    'shiftStartTime': 'TEXT',
    'shiftEndTime': 'TEXT',
    'actStartTime': 'TEXT',
    'actEndTime': 'TEXT', // Nullable
    'finalStartTime': 'TEXT',
    'finalEndTime': 'TEXT', // Nullable
    'approvedHr': 'INTEGER', // Nullable
    'rejectedHr': 'INTEGER', // Nullable
    'dutyCount': 'REAL', // For double
    'dutyInLatLng': 'TEXT',
    'dutyOutLatLng': 'TEXT',
    'deleted': 'INTEGER',
    'isAbsent': 'INTEGER', // Boolean as Integer
    'isApproved': 'INTEGER',
    'attendanceMode': 'TEXT',
    'dutyRank': 'TEXT',
    'dutyStatus': 'TEXT',
    'createdOn': 'TEXT',
    'empRank': 'TEXT',
    'dutyRankName': 'TEXT',
    'shiftHrs': 'TEXT',
    'shiftMin': 'INTEGER',
    'dirtyFlag': 'INTEGER',
    'dateModified':'TEXT NOT NULL',
    'updatedAt':'TEXT NOT NULL',
  };

  /// Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'REGNO': regNo,
      'UNIT_CODE': unitCode,
      'SITE_NAME': siteName,
      'DUTY_POST_ID': dutyPostId,
      'DUTY_POST_NAME': dutyPostName,
      'SHIFT_ID': shiftId,
      'SHIFT_NAME': shiftName,
      'SHIFT_START_DATE': shiftStartDate.toIso8601String(),
      'SHIFT_START_TIME': shiftStartTime.toIso8601String(),
      'SHIFT_END_TIME': shiftEndTime.toIso8601String(),
      'ACT_START_TIME': actStartTime.toIso8601String(),
      'ACT_END_TIME': actEndTime?.toIso8601String(),
      'FINAl_START_TIME': finalStartTime.toIso8601String(),
      'FINAL_END_TIME': finalEndTime?.toIso8601String(),
      'APPROVED_HR': approvedHr,
      'REJECTED_HR': rejectedHr,
      'DUTY_COUNT': dutyCount,
      'DUTY_IN_LAT_LNG': dutyInLatLng,
      'DUTY_OUT_LAT_LNG': dutyOutLatLng,
      'DELETED': deleted,
      'IS_ABSENT': isAbsent,
      'IS_APPROVED': isApproved,
      'ATTENDANCE_MODE': attendanceMode,
      'DUTY_RANK': dutyRank,
      'DUTY_STATUS': dutyStatus,
      'CREATED_ON': createdOn.toIso8601String(),
      'EMP_RANK': empRank,
      'DUTY_RANK_NAME': dutyRankName,
      'SHIFT_HRS': shiftHrs,
      'SHIFT_MIN': shiftMin,
      'DIRTY_FLAG' : dirtyFlag,
    };
  }

  factory UserAttendance.fromMap(Map<String, dynamic> map) {
    return UserAttendance(
      id: map['id'] ?? 0,
      regNo: map['regNo'] ?? '',
      unitCode: map['unitCode'] ?? '',
      siteName: map['siteName'] ?? '',
      dutyPostId: map['dutyPostId'] ?? '',
      dutyPostName: map['dutyPostName'] ?? '',
      shiftId: map['shiftId'] ?? '',
      shiftName: map['shiftName'] ?? '',
      shiftStartDate: DateTime.parse(map['shiftStartDate'] ?? DateTime.now().toIso8601String()),
      shiftStartTime: DateTime.parse(map['shiftStartTime'] ?? DateTime.now().toIso8601String()),
      shiftEndTime: DateTime.parse(map['shiftEndTime'] ?? DateTime.now().toIso8601String()),
      actStartTime: DateTime.parse(map['actStartTime'] ?? DateTime.now().toIso8601String()),
      actEndTime: map['actEndTime'] != null ? DateTime.parse(map['actEndTime']) : null, // Nullable

      finalStartTime: DateTime.parse(map['finalStartTime'] ?? DateTime.now().toIso8601String()),

      finalEndTime: map['finalEndTime'] != null ? DateTime.parse(map['finalEndTime']) : null, // Nullable

      approvedHr: map['approvedHr'] as int?, // Nullable
      rejectedHr: map['rejectedHr'] as int?, // Nullable

      dutyCount: map['dutyCount'] ?? 0,
      dutyInLatLng: map['dutyInLatLng'] ?? '',
      dutyOutLatLng: map['dutyOutLatLng'] ?? '',
      deleted: map['deleted'] ?? 0,
      isAbsent: map['isAbsent'] == 1,
      isApproved: map['isApproved'] ?? 0,
      attendanceMode: map['attendanceMode'] ?? '',
      dutyRank: map['dutyRank'] ?? '',
      dutyStatus: map['dutyStatus'] ?? '',
      createdOn: DateTime.parse(map['createdOn'] ?? DateTime.now().toIso8601String()),
      empRank: map['empRank'] ?? '',
      dutyRankName: map['dutyRankName'] ?? '',
      shiftHrs: map['shiftHrs'] ?? '',
      shiftMin: map['shiftMin'] ?? 0,
      dirtyFlag: map['dirtyFlag'] ?? 1,
      dateModified: map['dateModified'] != null
          ? DateTime.parse(map['dateModified']) // Convert ISO string to DateTime
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt']) // Convert ISO string to DateTime
          : DateTime.now(),
    );
  }

  /// Converts a UserAttendance object to a database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'regNo': regNo,
      'unitCode': unitCode,
      'siteName': siteName,
      'dutyPostId': dutyPostId,
      'dutyPostName': dutyPostName,
      'shiftId': shiftId,
      'shiftName': shiftName,
      'shiftStartDate': shiftStartDate.toIso8601String(), // Handle nullable
      'shiftStartTime': shiftStartTime.toIso8601String(), // Handle nullable
      'shiftEndTime': shiftEndTime.toIso8601String(), // Handle nullable
      'actStartTime': actStartTime.toIso8601String(), // Handle nullable
      'actEndTime': actEndTime?.toIso8601String(), // Handle nullable
      'finalStartTime': finalStartTime.toIso8601String(), // Handle nullable
      'finalEndTime': finalEndTime?.toIso8601String(), // Handle nullable
      'approvedHr': approvedHr,
      'rejectedHr': rejectedHr,
      'dutyCount': dutyCount,
      'dutyInLatLng': dutyInLatLng,
      'dutyOutLatLng': dutyOutLatLng,
      'deleted': deleted,
      'isAbsent': isAbsent ? 1 : 0,
      'isApproved': isApproved,
      'attendanceMode': attendanceMode,
      'dutyRank': dutyRank,
      'dutyStatus': dutyStatus,
      'createdOn': createdOn.toIso8601String(), // Handle nullable
      'empRank': empRank,
      'dutyRankName': dutyRankName,
      'shiftHrs': shiftHrs,
      'shiftMin': shiftMin,
      'dirtyFlag': dirtyFlag,
      'dateModified':dateModified.toIso8601String(),
      'updatedAt':updatedAt.toIso8601String(),
    };
  }
}

