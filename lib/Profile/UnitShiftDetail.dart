
class UnitShiftDetail {
  final String id;
  final String shiftId;
  final String postId;
  final String shiftName;
  final String unitCode;
  final String startTime;
  final String endTime;
  final String dutyHrs;
  final DateTime startDate;
  final DateTime endDate;
  final String activeDays;
  final int deleted;
  final DateTime dateModified;
  final String shiftStartBefore;
  final String dutyInBefore;
  final String shiftEndAfter;
  final DateTime updatedAt;
  final int allowedMark;
  final String notAllowedReason;

  UnitShiftDetail({
    required this.id,
    required this.shiftId,
    required this.postId,
    required this.shiftName,
    required this.unitCode,
    required this.startTime,
    required this.endTime,
    required this.dutyHrs,
    required this.startDate,
    required this.endDate,
    required this.activeDays,
    required this.deleted,
    required this.dateModified,
    required this.shiftStartBefore,
    required this.shiftEndAfter,
    required this.dutyInBefore,
    required this.updatedAt,
    this.allowedMark = 0,          // default
    this.notAllowedReason = '',     // default

  });

  Map<String, dynamic> toJson() {
    String? formatDate(DateTime? date) => date?.toIso8601String();

    return {
      'ID': id,
      'SHIFT_ID': shiftId,
      'POST_ID': postId,
      'SHIFT_NAME': shiftName,
      'UNIT_CODE': unitCode,
      'START_TIME': startTime,
      'END_TIME': endTime,
      'DUTY_HRS': dutyHrs,
      'START_DATE': formatDate(startDate),
      'END_DATE': formatDate(endDate),
      'ACTIVE_DAYS': activeDays,
      'DELETED': deleted,
      'DATE_MODIFIED': formatDate(dateModified),
      'SHIFT_START_BEFORE': shiftStartBefore,
      'SHIFT_END_AFTER': shiftEndAfter,
      'DUTY_IN_BEFORE': dutyInBefore,
    };
  }

  // Convert JSON into a UnitShiftDetail object
  factory UnitShiftDetail.fromJson(Map<String, dynamic> json) {
    return UnitShiftDetail(
      id: json['ID'],
      shiftId: json['SHIFT_ID'],
      postId: json['POST_ID'],
      shiftName: json['SHIFT_NAME'],
      unitCode: json['UNIT_CODE'],
      startTime: json['START_TIME'],
      endTime: json['END_TIME'],
      dutyHrs: json['DUTY_HRS'],
      startDate: DateTime.parse(json['START_DATE']),
      endDate: DateTime.parse(json['END_DATE']),
      activeDays: json['ACTIVE_DAYS'],
      deleted: json['DELETED'],
      dateModified: DateTime.parse(json['DATE_MODIFIED']),
      shiftStartBefore: json['SHIFT_START_BEFORE'],
      shiftEndAfter: json['SHIFT_END_AFTER'],
      dutyInBefore:json['DUTY_IN_BEFORE'],
      updatedAt:DateTime.now(),

    );
  }

  static const fields = {
    'id': 'TEXT PRIMARY KEY',
    'shiftId': 'TEXT NOT NULL',
    'postId': 'TEXT NOT NULL',
    'shiftName': 'TEXT NOT NULL',
    'unitCode': 'TEXT NOT NULL',
    'startTime': 'TEXT NOT NULL',
    'endTime': 'TEXT NOT NULL',
    'dutyHrs': 'TEXT NOT NULL',
    'startDate': 'TEXT NOT NULL',
    'endDate': 'TEXT NOT NULL',
    'activeDays': 'TEXT NOT NULL',
    'deleted': 'INTEGER NOT NULL',
    'dateModified': 'TEXT NOT NULL',
    'shiftStartBefore': 'TEXT NOT NULL',
    'dutyInBefore': 'TEXT NOT NULL',
    'shiftEndAfter': 'TEXT NOT NULL',
    'updatedAt':'TEXT NOT NULL',

  };

  factory UnitShiftDetail.fromMap(Map<String, dynamic> map) {
    return UnitShiftDetail(
      id: map['id'] ?? '',
      shiftId: map['shiftId'] ?? '',
      postId: map['postId'] ?? '',
      shiftName: map['shiftName'] ?? '',
      unitCode: map['unitCode'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      dutyHrs: map['dutyHrs'] ?? '',
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : DateTime.now(), // Fallback to current DateTime if null.
      endDate: map['endDate'] != null
          ? DateTime.parse(map['endDate'])
          : DateTime.now(), // Fallback to current DateTime if null.
      activeDays: map['activeDays'] ?? '',
      deleted: map['deleted'] ?? 0,
      dateModified: map['dateModified'] != null
          ? DateTime.parse(map['dateModified'])
          : DateTime.now(), // Fallback to current DateTime if null.
      shiftStartBefore: map['shiftStartBefore'] ?? '',
      dutyInBefore: map['dutyInBefore'] ?? '',
      shiftEndAfter: map['shiftEndAfter'] ?? '',
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(), // Fallback to current DateTime if null.
    );
  }

  // Convert UnitShiftDetail object into a Map to insert into the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shiftId':shiftId,
      'postId': postId,
      'shiftName': shiftName,
      'unitCode': unitCode,
      'startTime': startTime,
      'endTime': endTime,
      'dutyHrs': dutyHrs,
      'startDate': startDate.toIso8601String(),  // Convert DateTime to string
      'endDate': endDate.toIso8601String(),  // Convert DateTime to string
      'activeDays': activeDays,
      'deleted': deleted,
      'dateModified': dateModified.toIso8601String(),  // Convert DateTime to string
      'shiftStartBefore': shiftStartBefore,
      'dutyInBefore':dutyInBefore,
      'shiftEndAfter': shiftEndAfter,
      'updatedAt':updatedAt.toIso8601String(),
    };
  }

  factory UnitShiftDetail.fromViewMap(Map<String, dynamic> map) {
    return UnitShiftDetail(
      id: map['id'] ?? '',
      shiftId: map['shiftId'] ?? '',
      postId: map['postId'] ?? '',
      shiftName: map['shiftName'] ?? '',
      unitCode: map['unitCode'] ?? '',
      startTime: map['shiftStartTime'] ?? '',   // view column
      endTime: map['shiftEndTime'] ?? '',       // view column
      dutyHrs: map['dutyHrs'] ?? '',
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : DateTime.now(),
      endDate: map['endDate'] != null
          ? DateTime.parse(map['endDate'])
          : DateTime.now(),
      activeDays: map['activeDays'] ?? '',
      deleted: map['deleted'] ?? 0,
      dateModified: map['dateModified'] != null
          ? DateTime.parse(map['dateModified'])
          : DateTime.now(),
      shiftStartBefore: map['shiftStartBefore'] ?? '',
      dutyInBefore: map['dutyInBefore'] ?? '',
      shiftEndAfter: map['shiftEndAfter'] ?? '',
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      allowedMark: map['allowedMark'] ?? 1,
      notAllowedReason: map['notAllowedReason'] ?? '',
    );
  }

}
