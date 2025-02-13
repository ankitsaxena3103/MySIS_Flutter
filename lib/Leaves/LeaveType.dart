class LeaveType {
  final String id;
  final int leaveId;
  final String leaveCode;
  final String leaveType;
  final int maxDays;
  final String colorCode;
  final String remark;
  final int forSelf;
  final int visible;
  final DateTime dateModified;
  final DateTime updatedAt;


  LeaveType({
    required this.id,
    required this.leaveId,
    required this.leaveCode,
    required this.leaveType,
    required this.maxDays,
    required this.colorCode,
    required this.remark,
    required this.forSelf,
    required this.visible,
    required this.dateModified,
    required this.updatedAt,
  });

  // Factory method to parse JSON into a Dart object
  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['ID'],
      leaveId: json['LEAVE_ID'],
      leaveCode: json['LEAVE_CODE'],
      leaveType: json['LEAVE_TYPE'],
      maxDays: json['MAX_DAYS'],
      colorCode: json['COLOR_CODE'],
      remark: json['REMARK'],
      forSelf: json['FOR_SELF'],
      visible: json['VISIBLE'],
      dateModified: DateTime.parse(json['DATE_MODIFIED']),
      updatedAt: DateTime.now(),
    );
  }

  // Convert Dart object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'LEAVE_ID': leaveId,
      'LEAVE_CODE': leaveCode,
      'LEAVE_TYPE': leaveType,
      'MAX_DAYS': maxDays,
      'COLOR_CODE': colorCode,
      'REMARK': remark,
      'FOR_SELF': forSelf,
      'VISIBLE': visible,
      'DATE_MODIFIED': dateModified.toIso8601String(),
    };
  }

  static const fields = {
    'id': 'TEXT PRIMARY KEY',
    'leaveId': 'INTEGER NOT NULL',
    'leaveCode': 'TEXT NOT NULL',
    'leaveType': 'TEXT NOT NULL',
    'maxDays': 'INTEGER NOT NULL',
    'colorCode': 'TEXT NOT NULL',
    'remark': 'TEXT',
    'forSelf': 'INTEGER NOT NULL',
    'visible': 'INTEGER NOT NULL',
    'dateModified': 'TEXT NOT NULL',
    'updatedAt':'TEXT NOT NULL',
  };

  // Factory method to parse a database Map (row) into a Dart object
  factory LeaveType.fromMap(Map<String, dynamic> map) {
    return LeaveType(
      id: map['id'] ?? '', // Ensures it defaults to an empty string if 'id' is null
      leaveId: map['leaveId'] ?? 0,
      leaveCode: map['leaveCode'] ?? '',
      leaveType: map['leaveType'] ?? '',
      maxDays: map['maxDays'] ?? 0,
      colorCode: map['colorCode'] ?? '',
      remark: map['remark'] ?? '',
      forSelf: map['forSelf'] ?? 0,
      visible: map['visible'] ?? 0,
      dateModified: map['dateModified'] != null
          ? DateTime.parse(map['dateModified']) // Convert ISO string to DateTime
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt']) // Convert ISO string to DateTime
          : DateTime.now(),
    );
  }

  // Convert a Dart object into a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'leaveId': leaveId,
      'leaveCode': leaveCode,
      'leaveType': leaveType,
      'maxDays': maxDays,
      'colorCode': colorCode,
      'remark': remark,
      'forSelf': forSelf,
      'visible': visible,
      'dateModified': dateModified.toIso8601String(),
      'updatedAt':updatedAt.toIso8601String(),
    };
  }

}
