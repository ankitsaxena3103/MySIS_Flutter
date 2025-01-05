
class UnitShiftDetail {
  final String id;
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

  UnitShiftDetail({
    required this.id,
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
  });

  // Convert JSON into a UnitShiftDetail object
  factory UnitShiftDetail.fromJson(Map<String, dynamic> json) {
    return UnitShiftDetail(
      id: json['ID'],
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
    );
  }

  static const fields = {
    'id': 'TEXT PRIMARY KEY',
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
  };

  factory UnitShiftDetail.fromMap(Map<String, dynamic> map) {
    return UnitShiftDetail(
      id: map['id'] as String,
      postId: map['postId'] as String,
      shiftName: map['shiftName'] as String,
      unitCode: map['unitCode'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      dutyHrs: map['dutyHrs'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      activeDays: map['activeDays'] as String,
      deleted: map['deleted'] as int,
      dateModified: DateTime.parse(map['dateModified'] as String),
      shiftStartBefore: map['shiftStartBefore'] as String,
      dutyInBefore: map['dutyInBefore'] as String,
      shiftEndAfter: map['shiftEndAfter'] as String,
    );
  }

  // Convert UnitShiftDetail object into a Map to insert into the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
    };
  }

}
