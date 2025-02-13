class UserRoaster {
  final String id;
  final String rosterId;
  final String unitCode;
  final String siteName;
  final String shiftId;
  final String shiftName;
  final String rosterDate;
  final String startTime;
  final String endTime;
  final String dutyHrs;
  final DateTime shiftStartTime;
  final DateTime shiftEndTime;
  final DateTime dutyStartEnableTime;
  final DateTime dutyStartDisableTime;
  final DateTime dutyEndDisableTime;
  final int deleted;
  final DateTime dateModified;
  final String regNo;
  final String dutyPostId;
  final String postName;
  final String qrId;
  final String dutyPostAddress;
  final int geoFenceRange;
  final int isGeoFenceAllow;
  final String geoLocation;
  final String dutyRankCode;
  final String dutyRankName;
  final DateTime updatedAt;

  UserRoaster({
    required this.id,
    required this.rosterId,
    required this.unitCode,
    required this.siteName,
    required this.shiftId,
    required this.shiftName,
    required this.rosterDate,
    required this.startTime,
    required this.endTime,
    required this.dutyHrs,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.dutyStartEnableTime,
    required this.dutyStartDisableTime,
    required this.dutyEndDisableTime,
    required this.deleted,
    required this.dateModified,
    required this.regNo,
    required this.dutyPostId,
    required this.postName,
    required this.qrId,
    required this.dutyPostAddress,
    required this.geoFenceRange,
    required this.isGeoFenceAllow,
    required this.geoLocation,
    required this.dutyRankCode,
    required this.dutyRankName,
    required this.updatedAt,
  });

  factory UserRoaster.fromJson(Map<String, dynamic> json) {
    return UserRoaster(
      id: json['ID'],
      rosterId: json['ROSTER_ID'],
      unitCode: json['UNIT_CODE'],
      siteName: json['SITE_NAME'],
      shiftId: json['SHIFT_ID'],
      shiftName: json['SHIFT_NAME'],
      rosterDate: json['ROSTER_DATE'],
      startTime: json['START_TIME'],
      endTime: json['END_TIME'],
      dutyHrs: json['DUTY_HRS'],
      shiftStartTime: DateTime.parse(json['SHIFT_START_TIME']),
      shiftEndTime: DateTime.parse(json['SHIFT_END_TIME']),
      dutyStartEnableTime: DateTime.parse(json['DUTY_START_ENABLE_TIME']),
      dutyStartDisableTime: DateTime.parse(json['DUTY_START_DISABLE_TIME']),
      dutyEndDisableTime: DateTime.parse(json['DUTY_END_DISABLE_TIME']),
      deleted: json['DELETED'],
      dateModified: DateTime.parse(json['DATE_MODIFIED']),
      regNo: json['REGNO'],
      dutyPostId: json['DUTY_POST_ID'],
      postName: json['POST_NAME'],
      qrId: json['QR_ID'],
      dutyPostAddress: json['DUTY_POST_ADDRESS'],
      geoFenceRange: json['GEO_FENCE_RANGE'],
      isGeoFenceAllow: json['IS_GEO_FENCE_ALLOW'],
      geoLocation: json['GEO_LOCATION'],
      dutyRankCode: json['DUTY_RANK_CODE'],
      dutyRankName: json['DUTY_RANK_NAME'],
      updatedAt: DateTime.now(), // Default value if not in the JSON
    );
  }

  // Convert a UserRoaster instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'ROSTER_ID': rosterId,
      'UNIT_CODE': unitCode,
      'SITE_NAME': siteName,
      'SHIFT_ID': shiftId,
      'SHIFT_NAME': shiftName,
      'ROSTER_DATE': rosterDate,
      'START_TIME': startTime,
      'END_TIME': endTime,
      'DUTY_HRS': dutyHrs,
      'SHIFT_START_TIME': shiftStartTime.toIso8601String(),
      'SHIFT_END_TIME': shiftEndTime.toIso8601String(),
      'DUTY_START_ENABLE_TIME': dutyStartEnableTime.toIso8601String(),
      'DUTY_START_DISABLE_TIME': dutyStartDisableTime.toIso8601String(),
      'DUTY_END_DISABLE_TIME': dutyEndDisableTime.toIso8601String(),
      'DELETED': deleted,
      'DATE_MODIFIED': dateModified.toIso8601String(),
      'REGNO': regNo,
      'DUTY_POST_ID': dutyPostId,
      'POST_NAME': postName,
      'QR_ID': qrId,
      'DUTY_POST_ADDRESS': dutyPostAddress,
      'GEO_FENCE_RANGE': geoFenceRange,
      'IS_GEO_FENCE_ALLOW': isGeoFenceAllow,
      'GEO_LOCATION': geoLocation,
      'DUTY_RANK_CODE': dutyRankCode,
      'DUTY_RANK_NAME': dutyRankName,
    };
  }

  // Convert a Map into a UserRoaster instance
  factory UserRoaster.fromMap(Map<String, dynamic> map) {
    return UserRoaster(
      id: map['ID'],
      rosterId: map['ROSTER_ID'],
      unitCode: map['UNIT_CODE'],
      siteName: map['SITE_NAME'],
      shiftId: map['SHIFT_ID'],
      shiftName: map['SHIFT_NAME'],
      rosterDate: map['ROSTER_DATE'],
      startTime: map['START_TIME'],
      endTime: map['END_TIME'],
      dutyHrs: map['DUTY_HRS'],
      shiftStartTime: DateTime.parse(map['SHIFT_START_TIME']),
      shiftEndTime: DateTime.parse(map['SHIFT_END_TIME']),
      dutyStartEnableTime: DateTime.parse(map['DUTY_START_ENABLE_TIME']),
      dutyStartDisableTime: DateTime.parse(map['DUTY_START_DISABLE_TIME']),
      dutyEndDisableTime: DateTime.parse(map['DUTY_END_DISABLE_TIME']),
      deleted: map['DELETED'],
      dateModified: DateTime.parse(map['DATE_MODIFIED']),
      regNo: map['REGNO'],
      dutyPostId: map['DUTY_POST_ID'],
      postName: map['POST_NAME'],
      qrId: map['QR_ID'],
      dutyPostAddress: map['DUTY_POST_ADDRESS'],
      geoFenceRange: map['GEO_FENCE_RANGE'],
      isGeoFenceAllow: map['IS_GEO_FENCE_ALLOW'],
      geoLocation: map['GEO_LOCATION'],
      dutyRankCode: map['DUTY_RANK_CODE'],
      dutyRankName: map['DUTY_RANK_NAME'],
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt']) // Convert ISO string to DateTime
          : DateTime.now(),
    );
  }

// Fields for database
  static const fields = {
    'id': 'TEXT PRIMARY KEY', // Unique identifier
    'rosterId': 'TEXT NOT NULL',
    'unitCode': 'TEXT NOT NULL',
    'siteName': 'TEXT NOT NULL',
    'shiftId': 'TEXT NOT NULL',
    'shiftName': 'TEXT NOT NULL',
    'rosterDate': 'TEXT NOT NULL',
    'startTime': 'TEXT NOT NULL',
    'endTime': 'TEXT NOT NULL',
    'dutyHrs': 'TEXT NOT NULL',
    'shiftStartTime': 'TEXT NOT NULL',
    'shiftEndTime': 'TEXT NOT NULL',
    'dutyStartEnableTime': 'TEXT NOT NULL',
    'dutyStartDisableTime': 'TEXT NOT NULL',
    'dutyEndDisableTime': 'TEXT NOT NULL',
    'deleted': 'INTEGER NOT NULL',
    'dateModified': 'TEXT NOT NULL',
    'regNo': 'TEXT NOT NULL',
    'dutyPostId': 'TEXT NOT NULL',
    'postName': 'TEXT NOT NULL',
    'qrId': 'TEXT NOT NULL',
    'dutyPostAddress': 'TEXT NOT NULL',
    'geoFenceRange': 'INTEGER NOT NULL',
    'isGeoFenceAllow': 'INTEGER NOT NULL',
    'geoLocation': 'TEXT NOT NULL',
    'dutyRankCode': 'TEXT NOT NULL',
    'dutyRankName': 'TEXT NOT NULL',
    'updatedAt': 'TEXT NOT NULL',
  };

// toMap() method
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rosterId': rosterId,
      'unitCode': unitCode,
      'siteName': siteName,
      'shiftId': shiftId,
      'shiftName': shiftName,
      'rosterDate': rosterDate,
      'startTime': startTime,
      'endTime': endTime,
      'dutyHrs': dutyHrs,
      'shiftStartTime': shiftStartTime.toIso8601String(),
      'shiftEndTime': shiftEndTime.toIso8601String(),
      'dutyStartEnableTime': dutyStartEnableTime.toIso8601String(),
      'dutyStartDisableTime': dutyStartDisableTime.toIso8601String(),
      'dutyEndDisableTime': dutyEndDisableTime.toIso8601String(),
      'deleted': deleted,
      'dateModified': dateModified.toIso8601String(),
      'regNo': regNo,
      'dutyPostId': dutyPostId,
      'postName': postName,
      'qrId': qrId,
      'dutyPostAddress': dutyPostAddress,
      'geoFenceRange': geoFenceRange,
      'isGeoFenceAllow': isGeoFenceAllow,
      'geoLocation': geoLocation,
      'dutyRankCode': dutyRankCode,
      'dutyRankName': dutyRankName,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

}
