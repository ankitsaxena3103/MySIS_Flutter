import 'dart:convert';

class ContactSIS {
  final int id;
  final String whatsappNumber;
  final String ercNumber;
  final String ucName;
  final String ucNumber;
  final String ucImage;
  final String aoName;
  final String aoNumber;
  final String aoImage;
  final String bhName;
  final String bhNumber;
  final String bhImage;
  final String oldIssueUrl;
  final String newIssueUrl;
  final DateTime dateModified;

  ContactSIS({
    required this.id,
    required this.whatsappNumber,
    required this.ercNumber,
    required this.ucName,
    required this.ucNumber,
    required this.ucImage,
    required this.aoName,
    required this.aoNumber,
    required this.aoImage,
    required this.bhName,
    required this.bhNumber,
    required this.bhImage,
    required this.oldIssueUrl,
    required this.newIssueUrl,
    required this.dateModified,
  });

  // Factory method to create ContactSIS from JSON
  factory ContactSIS.fromJson(Map<String, dynamic> json) {
    return ContactSIS(
      id: json['ID'] as int,
      whatsappNumber: json['WhatsAppNumber'] as String,
      ercNumber: json['ERC_Number'] as String,
      ucName: json['UC_Name'] as String,
      ucNumber: json['UC_Number'] as String,
      ucImage: json['UC_Image'] as String,
      aoName: json['AO_Name'] as String,
      aoNumber: json['AO_Number'] as String,
      aoImage: json['AO_Image'] as String,
      bhName: json['BH_Name'] as String,
      bhNumber: json['BH_Number'] as String,
      bhImage: json['BH_Image'] as String,
      oldIssueUrl: json['OldIssueUrl'] as String,
      newIssueUrl: json['NewIssueUrl'] as String,
      dateModified: DateTime.parse(json['DATE_MODIFIED']),
    );
  }

  // Method to convert ContactSIS to JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'WhatsAppNumber': whatsappNumber,
      'ERC_Number': ercNumber,
      'UC_Name': ucName,
      'UC_Number': ucNumber,
      'UC_Image': ucImage,
      'AO_Name': aoName,
      'AO_Number': aoNumber,
      'AO_Image': aoImage,
      'BH_Name': bhName,
      'BH_Number': bhNumber,
      'BH_Image': bhImage,
      'OldIssueUrl': oldIssueUrl,
      'NewIssueUrl': newIssueUrl,
      'DATE_MODIFIED': dateModified.toIso8601String(),
    };
  }

  // Factory method to create ContactSIS from a Map
  factory ContactSIS.fromMap(Map<String, dynamic> map) {
    return ContactSIS(
      id: map['ID'] as int,
      whatsappNumber: map['WhatsAppNumber'] as String,
      ercNumber: map['ERC_Number'] as String,
      ucName: map['UC_Name'] as String,
      ucNumber: map['UC_Number'] as String,
      ucImage: map['UC_Image'] as String,
      aoName: map['AO_Name'] as String,
      aoNumber: map['AO_Number'] as String,
      aoImage: map['AO_Image'] as String,
      bhName: map['BH_Name'] as String,
      bhNumber: map['BH_Number'] as String,
      bhImage: map['BH_Image'] as String,
      oldIssueUrl: map['OldIssueUrl'] as String,
      newIssueUrl: map['NewIssueUrl'] as String,
      dateModified: DateTime.parse(map['DATE_MODIFIED'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'WhatsAppNumber': whatsappNumber,
      'ERC_Number': ercNumber,
      'UC_Name': ucName,
      'UC_Number': ucNumber,
      'UC_Image': ucImage,
      'AO_Name': aoName,
      'AO_Number': aoNumber,
      'AO_Image': aoImage,
      'BH_Name': bhName,
      'BH_Number': bhNumber,
      'BH_Image': bhImage,
      'OldIssueUrl': oldIssueUrl,
      'NewIssueUrl': newIssueUrl,
      'DATE_MODIFIED': dateModified.toIso8601String(),
    };

  }

  static const fields = {
    'id': 'INTEGER PRIMARY KEY', // ID is unique and primary key
    'whatsappNumber': 'TEXT NOT NULL',
    'ercNumber': 'TEXT NOT NULL',
    'ucName': 'TEXT NOT NULL',
    'ucNumber': 'TEXT NOT NULL',
    'ucImage': 'TEXT NOT NULL',
    'aoName': 'TEXT NOT NULL',
    'aoNumber': 'TEXT NOT NULL',
    'aoImage': 'TEXT NOT NULL',
    'bhName': 'TEXT NOT NULL',
    'bhNumber': 'TEXT NOT NULL',
    'bhImage': 'TEXT NOT NULL',
    'oldIssueUrl': 'TEXT NOT NULL',
    'newIssueUrl': 'TEXT NOT NULL',
    'dateModified': 'TEXT NOT NULL', // Store DateTime as ISO8601 string
  };


}

