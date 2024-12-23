class UserPosting {
  final String id;
  final String unitCode;
  final String siteName;
  final String siteAddress;
  final int isPrimary;
  final String dutyRank;
  final String dutyRankName;
  final String dutyRankSymbol;
  final String workingDays;
  final String workingHours;
  final int deleted;
  final DateTime dateModified;

  UserPosting({
    required this.id,
    required this.unitCode,
    required this.siteName,
    required this.siteAddress,
    required this.isPrimary,
    required this.dutyRank,
    required this.dutyRankName,
    required this.dutyRankSymbol,
    required this.workingDays,
    required this.workingHours,
    required this.deleted,
    required this.dateModified,
  });

  // Factory method to create an object from JSON
  factory UserPosting.fromJson(Map<String, dynamic> json) {
    return UserPosting(
      id: json['ID'] ?? '',
      unitCode: json['UNIT_CODE'] ?? '',
      siteName: json['SITE_NAME'] ?? '',
      siteAddress: json['SITE_ADDRESS'] ?? '',
      isPrimary: json['IS_PRIMARY'] ?? 0,
      dutyRank: json['DUTY_RANK'] ?? '',
      dutyRankName: json['DUTY_RANK_NAME'] ?? '',
      dutyRankSymbol: json['DUTY_RANK_SYMBOL'] ?? '',
      workingDays: json['WORKING_DAYS'] ?? '',
      workingHours: json['WORKING_HRS'] ?? '',
      deleted: json['DELETED'] ?? 0,
      dateModified: DateTime.parse(json['DATE_MODIFIED']),
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'UNIT_CODE': unitCode,
      'SITE_NAME': siteName,
      'SITE_ADDRESS': siteAddress,
      'IS_PRIMARY': isPrimary,
      'DUTY_RANK': dutyRank,
      'DUTY_RANK_NAME': dutyRankName,
      'DUTY_RANK_SYMBOL': dutyRankSymbol,
      'WORKING_DAYS': workingDays,
      'WORKING_HRS': workingHours,
      'DELETED': deleted,
      'DATE_MODIFIED': dateModified.toIso8601String(),
    };
  }

  factory UserPosting.fromMap(Map<String, dynamic> map) {
    return UserPosting(
      id: map['id'] ?? '',
      unitCode: map['unitCode'] ?? '',
      siteName: map['siteName'] ?? '',
      siteAddress: map['siteAddress'] ?? '',
      isPrimary: map['isPrimary'] ?? 0,
      dutyRank: map['dutyRank'] ?? '',
      dutyRankName: map['dutyRankName'] ?? '',
      dutyRankSymbol: map['dutyRankSymbol'] ?? '',
      workingDays: map['workingDays'] ?? '',
      workingHours: map['workingHours'] ?? '',
      deleted: map['deleted'] ?? 0,
      dateModified: map['dateModified'] != null
          ? DateTime.parse(map['dateModified']) // Convert ISO string to DateTime
          : DateTime.now(), // Fallback to current DateTime if null.
    );
  }

  static const fields = {
  'id': 'TEXT PRIMARY KEY', // SQLite uses TEXT for UUIDs
  'unitCode': 'TEXT NOT NULL',
  'siteName': 'TEXT NOT NULL',
  'siteAddress': 'TEXT NOT NULL',
  'isPrimary': 'INTEGER NOT NULL', // SQLite doesn't have a boolean type, so use INTEGER (1 or 0)
  'dutyRank': 'TEXT NOT NULL',
  'dutyRankName': 'TEXT NOT NULL',
  'dutyRankSymbol': 'TEXT NOT NULL',
  'workingDays': 'TEXT NOT NULL',
  'workingHours': 'TEXT NOT NULL',
  'deleted': 'INTEGER NOT NULL',
  'dateModified': 'TEXT NOT NULL', // Store DateTime as ISO8601 string
  };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'unitCode': unitCode,
      'siteName': siteName,
      'siteAddress': siteAddress,
      'isPrimary': isPrimary,
      'dutyRank': dutyRank,
      'dutyRankName': dutyRankName,
      'dutyRankSymbol': dutyRankSymbol,
      'workingDays': workingDays,
      'workingHours': workingHours,
      'deleted': deleted,
      'dateModified': dateModified.toIso8601String(), // Convert DateTime to ISO format.
    };
  }


}
