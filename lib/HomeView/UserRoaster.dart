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
  final DateTime? shiftStartTime;
  final DateTime? shiftEndTime;
  final DateTime? dutyStartEnableTime;
  final DateTime? dutyStartDisableTime;
  final DateTime? dutyEndDisableTime;
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

  // ✅ Extra fields from vwRosterDetail
  final DateTime? actStartTime;
  final DateTime? actEndTime;
  final String? dutyStatus;

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

    this.actStartTime,
    this.actEndTime,
    this.dutyStatus,
  });

  factory UserRoaster.fromMap(Map<String, dynamic> map) {
    return UserRoaster(
      id: map['id']?.toString() ?? '',
      rosterId: map['rosterId']?.toString() ?? '',
      unitCode: map['unitCode']?.toString() ?? '',
      siteName: map['siteName']?.toString() ?? '',
      shiftId: map['shiftId']?.toString() ?? '',
      shiftName: map['shiftName']?.toString() ?? '',
      rosterDate: map['rosterDate']?.toString() ?? '',
      startTime: map['startTime']?.toString() ?? '',
      endTime: map['endTime']?.toString() ?? '',
      dutyHrs: map['dutyHrs']?.toString() ?? '',

      shiftStartTime: _parseDateTime(map['shiftStartTime']),
      shiftEndTime: _parseDateTime(map['shiftEndTime']),
      dutyStartEnableTime: _parseDateTime(map['dutyStartEnableTime']),
      dutyStartDisableTime: _parseDateTime(map['dutyStartDisableTime']),
      dutyEndDisableTime: _parseDateTime(map['dutyEndDisableTime']),

      deleted: map['deleted'] is int
          ? map['deleted']
          : int.tryParse(map['deleted']?.toString() ?? '0') ?? 0,
      dateModified: _parseDateTime(map['dateModified']),

      regNo: map['regNo']?.toString() ?? '',
      dutyPostId: map['dutyPostId']?.toString() ?? '',
      postName: map['postName']?.toString() ?? '',
      qrId: map['qrId']?.toString() ?? '',
      dutyPostAddress: map['dutyPostAddress']?.toString() ?? '',

      geoFenceRange: map['geoFenceRange'] is int
          ? map['geoFenceRange']
          : int.tryParse(map['geoFenceRange']?.toString() ?? '0') ?? 0,
      isGeoFenceAllow: map['isGeoFenceAllow'] is int
          ? map['isGeoFenceAllow']
          : int.tryParse(map['isGeoFenceAllow']?.toString() ?? '0') ?? 0,
      geoLocation: map['geoLocation']?.toString() ?? '',
      dutyRankCode: map['dutyRankCode']?.toString() ?? '',
      dutyRankName: map['dutyRankName']?.toString() ?? '',

      updatedAt: _parseDateTime(map['updatedAt']),

      // ✅ Extra fields (nullable)
      actStartTime: _parseDateTimeNullable(map['actStartTime']),
      actEndTime: _parseDateTimeNullable(map['actEndTime']),
      dutyStatus: map['dutyStatus']?.toString(),
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {}
    }
    return DateTime.now();
  }

  static DateTime? _parseDateTimeNullable(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {}
    }
    return null;
  }


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
      'shiftStartTime': shiftStartTime?.toIso8601String(),
      'shiftEndTime': shiftEndTime?.toIso8601String(),
      'dutyStartEnableTime': dutyStartEnableTime?.toIso8601String(),
      'dutyStartDisableTime': dutyStartDisableTime?.toIso8601String(),
      'dutyEndDisableTime': dutyEndDisableTime?.toIso8601String(),
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
