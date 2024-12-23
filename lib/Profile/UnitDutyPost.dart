class UnitDutyPost {
  final String id;
  final String postName;
  final String address;
  final String geoLocation;
  final String qrId;
  final String unitCode;
  final int isGeoFenceAllow;
  final int allowDistance;
  final int deleted;
  final DateTime dateModified;

  UnitDutyPost({
    required this.id,
    required this.postName,
    required this.address,
    required this.geoLocation,
    required this.qrId,
    required this.unitCode,
    required this.isGeoFenceAllow,
    required this.allowDistance,
    required this.deleted,
    required this.dateModified,
  });

  // Factory method for JSON deserialization
  factory UnitDutyPost.fromJson(Map<String, dynamic> json) {
    return UnitDutyPost(
      id: json['ID'] as String,
      postName: json['POST_NAME'] as String,
      address: json['ADDRESS'] as String,
      geoLocation: json['GEO_LOCATION'] as String,
      qrId: json['QR_ID'] as String,
      unitCode: json['UNIT_CODE'] as String,
      isGeoFenceAllow: json['IS_GEO_FENCE_ALLOW'] as int,
      allowDistance: json['ALLOW_DISTANCE'] as int,
      deleted: json['DELETED'] as int,
      dateModified: DateTime.parse(json['DATE_MODIFIED']),
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
  };

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
      'deleted': deleted,
      'dateModified': dateModified.toIso8601String(), // Convert DateTime to ISO string.
    };
  }



}
