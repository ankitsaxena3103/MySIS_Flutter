import 'package:easy_localization/easy_localization.dart';

class EscortDuty {
  final String id;
  final String unitCode;
  final DateTime startDate;
  final DateTime endDate;
  final int status;
  final String regNo;
  final DateTime createdOn;
  final DateTime dateModified;
  final int deleted;
  final int dirtyFlag;
  final DateTime updatedAt;

  EscortDuty({
    required this.id,
    required this.unitCode,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.regNo,
    required this.createdOn,
    required this.dateModified,
    required this.deleted,
    required this.dirtyFlag,
    required this.updatedAt,

  });

  // Factory method to create an instance from JSON
  factory EscortDuty.fromJson(Map<String, dynamic> json) {
    return EscortDuty(
      id: json['ID'] ?? '',
      unitCode: json['UNIT_CODE'] ?? '',
      startDate: DateTime.parse(json['START_DATE'] ?? DateTime.now()),
      endDate: DateTime.parse(json['END_DATE'] ?? DateTime.now()),
      status: json['STATUS'] ?? 0,
      regNo: json['REGNO'] ?? '',
      createdOn: DateTime.parse(json['CREATED_ON'] ?? DateTime.now()),
      dateModified: DateTime.parse(json['DATE_MODIFIED'] ?? DateTime.now()),
      deleted: json['DELETED'] ?? 0,
      dirtyFlag: json['DIRTY_FLAG'] ?? 0,
      updatedAt: DateTime.now(),
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'UNIT_CODE': unitCode,
      'START_DATE': startDate,
      'END_DATE': endDate,
      'STATUS': status,
      'REGNO': regNo,
      'CREATED_ON': createdOn,
      'DATE_MODIFIED': dateModified,
      'DELETED': deleted,
      'DIRTY_FLAG': dirtyFlag,
      'UPDATED_AT':updatedAt,
    };
  }
  static const fields = {
    'id': 'TEXT PRIMARY KEY', // Unique identifier
    'unitCode': 'TEXT NOT NULL', // Unit code associated with the duty
    'startDate': 'TEXT NOT NULL', // Start date of the duty (ISO8601)
    'endDate': 'TEXT NOT NULL', // End date of the duty (ISO8601)
    'status': 'INTEGER NOT NULL', // Status code of the duty
    'regNo': 'TEXT NOT NULL', // Registration number
    'createdOn': 'TEXT NOT NULL', // Date & time when created (ISO8601)
    'dateModified': 'TEXT NOT NULL', // Last modified date (ISO8601)
    'deleted': 'INTEGER NOT NULL', // Deleted flag (0 = active, 1 = deleted)
    'dirtyFlag': 'INTEGER NOT NULL',
    'updatedAt':'TEXT NOT NULL',
  };


  // Convert Map (DB record) to EscortDuty instance
  factory EscortDuty.fromMap(Map<String, dynamic> map) {
    return EscortDuty(
      id: map['id']  ?? '',
      unitCode: map['unitCode'] ?? '',
      startDate: DateTime.parse(map['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(map['endDate'] ?? DateTime.now().toIso8601String()),
      status: map['status'] ?? 0,
      regNo: map['regNo'] ?? '',
      createdOn: DateTime.parse(map['createdOn'] ?? DateTime.now().toIso8601String()),
      dateModified: DateTime.parse(map['dateModified'] ?? DateTime.now().toIso8601String()),
      deleted: map['deleted']  ?? 0,
      dirtyFlag: map['dirtyFlag'] ?? 0,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt']) // Convert ISO string to DateTime
          : DateTime.now(),
    );
  }

  // Convert EscortDuty instance to Map (for DB storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'unitCode': unitCode,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'regNo': regNo,
      'createdOn': createdOn.toIso8601String(),
      'dateModified': dateModified.toIso8601String(),
      'deleted': deleted,
      'dirtyFlag': dirtyFlag,
      'updatedAt':updatedAt.toIso8601String(),
    };
  }

  int get dutyCount {
    return endDate.difference(startDate).inDays + 1;
  }

  String get formattedLeaves{
    String leaveDates = '';

    if (startDate.isAtSameMomentAs(endDate)) {
      // Single date
      leaveDates = DateFormat('dd MMM').format(startDate);
    } else {
      // Date range
      leaveDates =
      '${DateFormat('dd MMM').format(startDate)} - ${DateFormat('dd MMM').format(endDate)}';
    }

    return leaveDates;
  }
}
