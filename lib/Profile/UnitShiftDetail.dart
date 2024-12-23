// class UnitShiftDetail1 {
//   final String id;
//   final String postId;
//   final String shiftName;
//   final String unitCode;
//   final String startTime;
//   final String endTime;
//   final String dutyHours;
//   final DateTime startDate;
//   final DateTime endDate;
//   final String activeDays;
//   final int deleted;
//   final DateTime dateModified;
//   final String shiftStartBefore;
//   final String shiftEndAfter;
//
//   UnitShiftDetail({
//     required this.id,
//     required this.postId,
//     required this.shiftName,
//     required this.unitCode,
//     required this.startTime,
//     required this.endTime,
//     required this.dutyHours,
//     required this.startDate,
//     required this.endDate,
//     required this.activeDays,
//     required this.deleted,
//     required this.dateModified,
//     required this.shiftStartBefore,
//     required this.shiftEndAfter,
//   });
//
//   // Factory method for JSON deserialization
//   factory UnitShiftDetail.fromJson(Map<String, dynamic> json) {
//     return UnitShiftDetail(
//       id: json['ID'] as String,
//       postId: json['POST_ID'] as String,
//       shiftName: json['SHIFT_NAME'] as String,
//       unitCode: json['UNIT_CODE'] as String,
//       startTime: json['START_TIME'] as String,
//       endTime: json['END_TIME'] as String,
//       dutyHours: json['DUTY_HRS'] as String,
//       startDate: DateTime.parse(json['START_DATE']),
//       endDate: DateTime.parse(json['END_DATE']),
//       activeDays: json['ACTIVE_DAYS'] as String,
//       deleted: json['DELETED'] as int,
//       dateModified: DateTime.parse(json['DATE_MODIFIED']),
//       shiftStartBefore: json['SHIFT_START_BEFORE'] as String,
//       shiftEndAfter: json['SHIFT_END_AFTER'] as String,
//     );
//   }
//
//   // Method for JSON serialization
//   Map<String, dynamic> toJson() {
//     return {
//       'ID': id,
//       'POST_ID': postId,
//       'SHIFT_NAME': shiftName,
//       'UNIT_CODE': unitCode,
//       'START_TIME': startTime,
//       'END_TIME': endTime,
//       'DUTY_HRS': dutyHours,
//       'START_DATE': startDate.toIso8601String(),
//       'END_DATE': endDate.toIso8601String(),
//       'ACTIVE_DAYS': activeDays,
//       'DELETED': deleted,
//       'DATE_MODIFIED': dateModified.toIso8601String(),
//       'SHIFT_START_BEFORE': shiftStartBefore,
//       'SHIFT_END_AFTER': shiftEndAfter,
//     };
//   }
//
//
//
//   static const fields = {
//   'id': 'TEXT PRIMARY KEY',
//   'postId': 'TEXT NOT NULL',
//   'shiftName': 'TEXT NOT NULL',
//   'unitCode': 'TEXT NOT NULL',
//   'startTime': 'TEXT NOT NULL',
//   'endTime': 'TEXT NOT NULL',
//   'dutyHrs': 'TEXT NOT NULL',
//   'startDate': 'TEXT NOT NULL',
//   'endDate': 'TEXT NOT NULL',
//   'activeDays': 'TEXT NOT NULL',
//   'deleted': 'INTEGER NOT NULL',
//   'dateModified': 'TEXT NOT NULL',
//   'shiftStartBefore': 'TEXT NOT NULL',
//   'shiftEndAfter': 'TEXT NOT NULL',
//   };
//
//   // Convert the object to a Map for insertion into the database
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,  // matches 'id' in the fields map
//       'postId': postId,  // matches 'postId' in the fields map
//       'shiftName': shiftName,
//       'unitCode': unitCode,
//       'startTime': startTime,
//       'endTime': endTime,
//       'dutyHrs': dutyHours,
//       'startDate': startDate,
//       'endDate': endDate,
//       'activeDays': activeDays,
//       'deleted': deleted,
//       'dateModified': dateModified.toIso8601String(),
//       'shiftStartBefore': shiftStartBefore,
//       'shiftEndAfter': shiftEndAfter,
//     };
//   }
//
// }

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
    'shiftEndAfter': 'TEXT NOT NULL',
  };

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
      'shiftEndAfter': shiftEndAfter,
    };
  }
}
