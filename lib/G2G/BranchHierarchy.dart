class BranchHierarchy {
  final String companyCode;
  final String companyName;
  final String zoneCode;
  final String zoneName;
  final String regionCode;
  final String regionName;
  final String branchCode;
  final String branchName;

  BranchHierarchy({
    required this.companyCode,
    required this.companyName,
    required this.zoneCode,
    required this.zoneName,
    required this.regionCode,
    required this.regionName,
    required this.branchCode,
    required this.branchName,
  });

  // Factory constructor to create a BranchHierarchy object from JSON
  factory BranchHierarchy.fromJson(Map<String, dynamic> json) {
    return BranchHierarchy(
      companyCode: json['CompanyCode']?.toString() ?? '',
      companyName: json['CompanyName']?.toString() ?? '',
      zoneCode: json['ZoneCode']?.toString() ?? '',
      zoneName: json['ZoneName']?.toString() ?? '',
      regionCode: json['RegionCode']?.toString() ?? '',
      regionName: json['RegionName']?.toString() ?? '',
      branchCode: json['BranchCode']?.toString() ?? '',
      branchName: json['BranchName']?.toString() ?? '',
    );
  }

  // Convert instance to JSON format
  Map<String, dynamic> toJson() {
    return {
      'CompanyCode': companyCode,
      'CompanyName': companyName,
      'ZoneCode': zoneCode,
      'ZoneName': zoneName,
      'RegionCode': regionCode,
      'RegionName': regionName,
      'BranchCode': branchCode,
      'BranchName': branchName,
    };
  }


  static const fields = {
    'companyCode': 'TEXT NOT NULL',
    'companyName': 'TEXT NOT NULL',
    'zoneCode': 'TEXT NOT NULL',
    'zoneName': 'TEXT NOT NULL',
    'regionCode': 'TEXT NOT NULL',
    'regionName': 'TEXT NOT NULL',
    'branchCode': 'TEXT NOT NULL',
    'branchName': 'TEXT NOT NULL',
  };

  // Factory constructor to create a BranchHierarchy object from a Map (for DB)
  factory BranchHierarchy.fromMap(Map<String, dynamic> map) {
    return BranchHierarchy(
      companyCode: map['companyCode']?.toString() ?? '',
      companyName: map['companyName']?.toString() ?? '',
      zoneCode: map['zoneCode']?.toString() ?? '',
      zoneName: map['zoneName']?.toString() ?? '',
      regionCode: map['regionCode']?.toString() ?? '',
      regionName: map['regionName']?.toString() ?? '',
      branchCode: map['branchCode']?.toString() ?? '',
      branchName: map['branchName']?.toString() ?? '',
    );
  }

  // Convert instance to Map format (for DB storage)
  Map<String, dynamic> toMap() {
    return {
      'companyCode': companyCode,
      'companyName': companyName,
      'zoneCode': zoneCode,
      'zoneName': zoneName,
      'regionCode': regionCode,
      'regionName': regionName,
      'branchCode': branchCode,
      'branchName': branchName,

    };
  }
}

