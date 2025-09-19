import 'package:easy_localization/easy_localization.dart';

class UserLeaves {
  final String id;
  final String regNo;
  final int leaveId;
  final String leaveTypeName; // Updated field
  final String leaveTypeSymbol; // Updated field
  final int leaveStatus;
  final DateTime leaveStartDate;
  final DateTime leaveEndDate;
  final int canceled;
  final int deleted;
  final DateTime dateModified;
  final int actionTaken;
  final DateTime? approvedOn;
  final DateTime? actionTakenOn;
  final String adminRemarks;
  final int dirtyFlag;
  final DateTime updatedAt;

  UserLeaves({
    required this.id,
    required this.regNo,
    required this.leaveId,
    required this.leaveTypeName, // Updated field
    required this.leaveTypeSymbol, // Updated field
    required this.leaveStatus,
    required this.leaveStartDate,
    required this.leaveEndDate,
    required this.canceled,
    required this.deleted,
    required this.dateModified,
    required this.actionTaken,
    this.approvedOn,
    this.actionTakenOn,
    required this.adminRemarks,
    required this.dirtyFlag,
    required this.updatedAt,
  });

  // Database fields
  static const fields = {
    'id': 'TEXT PRIMARY KEY',
    'regNo': 'TEXT NOT NULL',
    'leaveId': 'INTEGER NOT NULL',
    'leaveTypeName': 'TEXT NOT NULL', // Updated field
    'leaveTypeSymbol': 'TEXT NOT NULL', // Updated field
    'leaveStatus': 'INTEGER NOT NULL',
    'leaveStartDate': 'TEXT NOT NULL',
    'leaveEndDate': 'TEXT NOT NULL',
    'canceled': 'INTEGER NOT NULL',
    'deleted': 'INTEGER NOT NULL',
    'dateModified': 'TEXT NOT NULL',
    'actionTaken': 'INTEGER NOT NULL',
    'approvedOn': 'TEXT',
    'actionTakenOn': 'TEXT',
    'adminRemarks': 'TEXT NOT NULL',
    'dirtyFlag': 'INTEGER NOT NULL',
    'updatedAt':'TEXT NOT NULL',
  };

  // Factory method to parse a JSON object into a Dart object
  factory UserLeaves.fromJson(Map<String, dynamic> json) {
    return UserLeaves(
      id: json['ID'] ?? '',
      regNo: json['REGNO'] ?? '',
      leaveId: json['LEAVE_TYPE'] ?? 0,
      leaveTypeName: json['LEAVE_TYPE_NAME'] ?? '', // Updated field
      leaveTypeSymbol: json['LEAVE_TYPE_SYMBOL'] ?? '', // Updated field
      leaveStatus: json['LEAVE_STATUS'] ?? 0,
      leaveStartDate: DateTime.parse(json['LEAVE_START_DATE'] ?? DateTime.now().toIso8601String()),
      leaveEndDate: DateTime.parse(json['LEAVE_END_DATE'] ?? DateTime.now().toIso8601String()),
      canceled: json['CANCLED'] ?? 0,
      deleted: json['DELETED'] ?? 0,
      dateModified: DateTime.parse(json['DATE_MODIFIED'] ?? DateTime.now().toIso8601String()),
      actionTaken: json['ACTION_TAKEN'] ?? 0,
      approvedOn: json['APPROVED_ON'] != null ? DateTime.parse(json['APPROVED_ON']) : null,
      actionTakenOn: json['ACTION_TAKEN_ON'] != null ? DateTime.parse(json['ACTION_TAKEN_ON']) : null,
      adminRemarks: json['ADMIN_REMARKS'] ?? '',
      dirtyFlag: json['DIRTY_FLAG'] ?? 0,
      updatedAt: DateTime.now(),
    );
  }

  // Convert a Dart object into a JSON object

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return {
      'ID': id,
      'REGNO': regNo,
      'LEAVE_TYPE': leaveId,
      'LEAVE_TYPE_NAME': leaveTypeName, // Updated field
      'LEAVE_TYPE_SYMBOL': leaveTypeSymbol, // Updated field
      'LEAVE_STATUS': leaveStatus,
      'LEAVE_START_DATE': dateFormat.format(leaveStartDate),
      'LEAVE_END_DATE': dateFormat.format(leaveEndDate),
      'CANCLED': canceled,
      'DELETED': deleted,
      'DATE_MODIFIED': dateModified.toIso8601String(),
      'ACTION_TAKEN': actionTaken,
      'APPROVED_ON': approvedOn?.toIso8601String(),
      'ACTION_TAKEN_ON': actionTakenOn?.toIso8601String(),
      'ADMIN_REMARKS': adminRemarks,
      'DIRTY_FLAG': dirtyFlag,
    };
  }

  // Factory method to parse a Map into a Dart object
  factory UserLeaves.fromMap(Map<String, dynamic> map) {
    return UserLeaves(
      id: map['id'] ?? '',
      regNo: map['regNo'] ?? '',
      leaveId: map['leaveId'] ?? 0,
      leaveTypeName: map['leaveTypeName'] ?? '', // Updated field
      leaveTypeSymbol: map['leaveTypeSymbol'] ?? '', // Updated field
      leaveStatus: map['leaveStatus'] ?? 0,
      leaveStartDate: DateTime.parse(map['leaveStartDate'] ?? DateTime.now().toIso8601String()),
      leaveEndDate: DateTime.parse(map['leaveEndDate'] ?? DateTime.now().toIso8601String()),
      canceled: map['canceled'] ?? 0,
      deleted: map['deleted'] ?? 0,
      actionTaken: map['actionTaken'] ?? 0,
      approvedOn: map['approvedOn'] != null ? DateTime.parse(map['approvedOn']) : null,
      actionTakenOn: map['actionTakenOn'] != null ? DateTime.parse(map['actionTakenOn']) : null,
      adminRemarks: map['adminRemarks'] ?? '',
      dirtyFlag: map['dirtyFlag'] ?? 0,
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
      'regNo': regNo,
      'leaveId': leaveId,
      'leaveTypeName': leaveTypeName, // Updated field
      'leaveTypeSymbol': leaveTypeSymbol, // Updated field
      'leaveStatus': leaveStatus,
      'leaveStartDate': leaveStartDate.toIso8601String(),
      'leaveEndDate': leaveEndDate.toIso8601String(),
      'canceled': canceled,
      'deleted': deleted,
      'dateModified': dateModified.toIso8601String(),
      'actionTaken': actionTaken,
      'approvedOn': approvedOn?.toIso8601String(),
      'actionTakenOn': actionTakenOn?.toIso8601String(),
      'adminRemarks': adminRemarks,
      'dirtyFlag': dirtyFlag,
      'updatedAt':updatedAt.toIso8601String(),

    };
  }

  int get leaveCount {
    return leaveEndDate.difference(leaveStartDate).inDays + 1;
  }

  String get formattedLeaves{
    String leaveDates = '';

    if (leaveStartDate.isAtSameMomentAs(leaveEndDate)) {
      // Single date
      leaveDates = DateFormat('dd MMM').format(leaveStartDate);
    } else {
      // Date range
      leaveDates =
      '${DateFormat('dd MMM').format(leaveStartDate)} - ${DateFormat('dd MMM').format(leaveEndDate)}';
    }

    return leaveDates;
  }

}


