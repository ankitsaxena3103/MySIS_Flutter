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
  final DateTime updatedAt;



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
    required this.updatedAt,

  });

  // Factory method to create ContactSIS from JSON
  factory ContactSIS.fromJson(Map<String, dynamic> json) {
    return ContactSIS(
      id: json['ID'] ?? 0, // Default to 0 if 'ID' is null or missing
      whatsappNumber: json['WhatsAppNumber'] ?? '', // Default to empty string
      ercNumber: json['ERC_Number'] ?? '',
      ucName: json['UC_Name'] ?? '',
      ucNumber: json['UC_Number'] ?? '',
      ucImage: json['UC_Image'] ?? '',
      aoName: json['AO_Name'] ?? '',
      aoNumber: json['AO_Number'] ?? '',
      aoImage: json['AO_Image'] ?? '',
      bhName: json['BH_Name'] ?? '',
      bhNumber: json['BH_Number'] ?? '',
      bhImage: json['BH_Image'] ?? '',
      oldIssueUrl: json['OldIssueUrl'] ?? '',
      newIssueUrl: json['NewIssueUrl'] ?? '',
      dateModified: json['DATE_MODIFIED'] != null
          ? DateTime.parse(json['DATE_MODIFIED'])
          : DateTime.now(), // Default to current date-time if null or missing
      updatedAt: DateTime.now(), // Default value if not in the JSON

    );

  }

  // Factory method to create ContactSIS from a Map
  factory ContactSIS.fromMap(Map<String, dynamic> map) {
    return ContactSIS(
      id: map['id'] ?? 0, // Default to 0 if 'id' is null or missing
      whatsappNumber: map['whatsappNumber'] ?? '', // Default to empty string
      ercNumber: map['ercNumber'] ?? '',
      ucName: map['ucName'] ?? '',
      ucNumber: map['ucNumber'] ?? '',
      ucImage: map['ucImage'] ?? '',
      aoName: map['aoName'] ?? '',
      aoNumber: map['aoNumber'] ?? '',
      aoImage: map['aoImage'] ?? '',
      bhName: map['bhName'] ?? '',
      bhNumber: map['bhNumber'] ?? '',
      bhImage: map['bhImage'] ?? '',
      oldIssueUrl: map['oldIssueUrl'] ?? '',
      newIssueUrl: map['newIssueUrl'] ?? '',
      dateModified: map['dateModified'] != null
          ? DateTime.parse(map['dateModified'])
          : DateTime.now(), // Default to current date-time if null or missing
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt']) // Convert ISO string to DateTime
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'WhatsAppNumber': whatsappNumber,
      'ercNumber': ercNumber,
      'ucName': ucName,
      'ucNumber': ucNumber,
      'ucImage': ucImage,
      'aoName': aoName,
      'aoNumber': aoNumber,
      'aoImage': aoImage,
      'bhName': bhName,
      'bhNumber': bhNumber,
      'bhImage': bhImage,
      'oldIssueUrl': oldIssueUrl,
      'newIssueUrl': newIssueUrl,
      'dateModified': dateModified.toIso8601String(),
      'updatedAt':updatedAt.toIso8601String(),
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
    'updatedAt':'TEXT NOT NULL',
  };


}

