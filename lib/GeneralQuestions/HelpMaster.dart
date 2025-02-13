class HelpMaster {
  final String id;
  final int srNo;
  final String category;
  final String title;
  final String detail;
  final int deleted;
  final String language;
  final DateTime dateModified;
  final DateTime updatedAt;

  HelpMaster({
    required this.id,
    required this.srNo,
    required this.category,
    required this.title,
    required this.detail,
    required this.deleted,
    required this.language,
    required this.dateModified,
    required this.updatedAt,
  });

  // Factory method to parse a JSON object into a Dart object
  factory HelpMaster.fromJson(Map<String, dynamic> json) {
    DateTime? safeParseDate(String? date) {
      if (date == null || date.isEmpty) {
        return null;
      }
      try {
        return DateTime.parse(date);
      } catch (e) {
        return null;
      }
    }
    return HelpMaster(
      id: json['ID'] ?? '',
      srNo: json['SR_NO'] ?? 0,
      category: json['CATEGORY'] ?? '',
      title: json['TITLE'] ?? '',
      detail: json['DETAIL'] ?? '',
      deleted: json['DELETED'] ?? 0,
      language: json['LANGUAGE'] ?? '',
      dateModified: safeParseDate(json['DATE_MODIFIED']) ?? DateTime.now(), // Handle null or invalid
      updatedAt: DateTime.now(),
    );
  }

  // Convert a Dart object into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'SR_NO': srNo,
      'CATEGORY': category,
      'TITLE': title,
      'DETAIL': detail,
      'DELETED': deleted,
      'LANGUAGE': language,
      'DATE_MODIFIED': dateModified.toIso8601String(),
    };
  }

  static const fields = {
    'id': 'TEXT PRIMARY KEY', // Unique identifier
    'srNo': 'INTEGER NOT NULL', // Serial number
    'category': 'TEXT NOT NULL', // Category of the help entry
    'title': 'TEXT NOT NULL', // Title of the help entry
    'detail': 'TEXT NOT NULL', // Detailed description
    'deleted': 'INTEGER NOT NULL', // Deleted flag (0 = not deleted, 1 = deleted)
    'language': 'TEXT NOT NULL', // Language of the help entry
    'dateModified': 'TEXT NOT NULL', // Store as ISO8601 string
    'updatedAt':'TEXT NOT NULL',
  };

  // Factory method to parse a Map (e.g., from a database) into a Dart object
  factory HelpMaster.fromMap(Map<String, dynamic> map) {
    return HelpMaster(
      id: map['id'] ?? '',
      srNo: map['srNo'] ?? 0,
      category: map['category'] ?? '',
      title: map['title'] ?? '',
      detail: map['detail'] ?? '',
      deleted: map['deleted'] ?? 0,
      language: map['language'] ?? '',
      dateModified: map['dateModified'] != null
          ? DateTime.parse(map['dateModified']) // Convert ISO string to DateTime
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt']) // Convert ISO string to DateTime
          : DateTime.now(),    );
  }

  // Convert a Dart object into a Map (e.g., for database insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'srNo': srNo,
      'category': category,
      'title': title,
      'detail': detail,
      'deleted': deleted,
      'language': language,
      'dateModified': dateModified.toIso8601String(),
      'updatedAt':updatedAt.toIso8601String(),
    };
  }
}
