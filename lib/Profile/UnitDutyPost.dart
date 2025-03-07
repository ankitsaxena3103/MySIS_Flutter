class UnitDutyPost {
  final String id;
  final String postName;
  final String address;
  final String geoLocation;
  final String qrId;
  final String unitCode;
  final int isGeoFenceAllow;
  final int allowDistance;
  final int geoAlert;
  final int geoAlertDistance;
  final int ignoreBlankLocation;
  final int deleted;
  final DateTime dateModified;
  final DateTime updatedAt;


  UnitDutyPost({
    required this.id,
    required this.postName,
    required this.address,
    required this.geoLocation,
    required this.qrId,
    required this.unitCode,
    required this.isGeoFenceAllow,
    required this.allowDistance,
    required this.geoAlert,
    required this.geoAlertDistance,
    required this.ignoreBlankLocation,
    required this.deleted,
    required this.dateModified,
    required this.updatedAt,


  });

  // Factory method for JSON deserialization
  factory UnitDutyPost.fromJson(Map<String, dynamic> json) {
    return UnitDutyPost(
      id: json['ID'] ?? '',
      postName: json['POST_NAME'] ?? '',
      address: json['ADDRESS'] ?? '',
      geoLocation: json['GEO_LOCATION'] ?? '',
      qrId: json['QR_ID'] ?? '',
      unitCode: json['UNIT_CODE'] ?? '',
      isGeoFenceAllow: json['IS_GEO_FENCE_ALLOW'] ?? 0,
      allowDistance: json['ALLOW_DISTANCE'] ?? 0,
      geoAlert: json['GEO_ALERT'] ?? 0,
      geoAlertDistance: json['GEO_ALERT_DISTANCE'] ?? 0,
      ignoreBlankLocation: json['IGNORE_BLANK_LOCATION'] ?? 0,
      deleted: json['DELETED'] ?? 0,
      dateModified: json['DATE_MODIFIED'] != null
          ? DateTime.tryParse(json['DATE_MODIFIED']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'POST_NAME': postName,
      'ADDRESS': address,
      'GEO_LOCATION': geoLocation,
      'QR_ID': qrId,
      'UNIT_CODE': unitCode,
      'IS_GEO_FENCE_ALLOW': isGeoFenceAllow,
      'ALLOW_DISTANCE': allowDistance,
      'DELETED': deleted,
      'DATE_MODIFIED': dateModified.toIso8601String(),
    };
  }

  static const fields = {
  'id': 'TEXT PRIMARY KEY',
  'postName': 'TEXT NOT NULL',
  'address': 'TEXT NOT NULL',
  'geoLocation': 'TEXT NOT NULL',
  'qrId': 'TEXT NOT NULL',
  'unitCode': 'TEXT NOT NULL',
  'isGeoFenceAllow': 'INTEGER NOT NULL',
  'allowDistance': 'INTEGER NOT NULL',
  'deleted': 'INTEGER NOT NULL',
  'dateModified': 'TEXT NOT NULL',
  'updatedAt':'TEXT NOT NULL',
   'geoAlert': 'INTEGER NOT NULL',
   'geoAlertDistance': 'INTEGER NOT NULL',
   'ignoreBlankLocation': 'INTEGER NOT NULL',

  };
  factory UnitDutyPost.fromMap(Map<String, dynamic> map) {
    return UnitDutyPost(
      id: map['id'] ?? '',
      postName: map['postName'] ?? '',
      address: map['address'] ?? '',
      geoLocation: map['geoLocation'] ?? '',
      qrId: map['qrId'] ?? '',
      unitCode: map['unitCode'] ?? '',
      isGeoFenceAllow: map['isGeoFenceAllow'] ?? 0,
      allowDistance: map['allowDistance'] ?? 0,
      geoAlert: map['geoAlert'] ?? 0,
      geoAlertDistance: map['geoAlertDistance'] ?? 0,
      ignoreBlankLocation: map['ignoreBlankLocation'] ?? 0,
      deleted: map['deleted'] ?? 0,
      dateModified: map['dateModified'] != null
          ? DateTime.tryParse(map['dateModified']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postName': postName,
      'address': address,
      'geoLocation': geoLocation,
      'qrId': qrId,
      'unitCode': unitCode,
      'isGeoFenceAllow': isGeoFenceAllow,
      'allowDistance': allowDistance,
      'geoAlert': geoAlert,
      'geoAlertDistance': geoAlertDistance,
      'ignoreBlankLocation': ignoreBlankLocation,
      'deleted': deleted,
      'dateModified': dateModified.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }



}
