class UserNotification {
  final int id;
  final String regNo;
  final int messageType;
  final bool isHtmlBody;
  final bool isHtmlPage;
  final bool isImageUrl;
  final String title;
  final String message;
  final String actionUrl;
  final DateTime expiryDate;
  final int? entityId;
  final int? parentId;
  final int? parentType;
  final bool readStatus;
  final DateTime? readDate; // ✅ NEW FIELD
  final bool popupAlert;
  final int deleted;
  final DateTime dateModified;
  final DateTime updatedAt;
  final int dirtyFlag;

  UserNotification({
    required this.id,
    required this.regNo,
    required this.messageType,
    required this.isHtmlBody,
    required this.isHtmlPage,
    required this.isImageUrl,
    required this.title,
    required this.message,
    required this.actionUrl,
    required this.expiryDate,
    this.entityId,
    this.parentId,
    this.parentType,
    required this.readStatus,
    this.readDate, // ✅ NEW FIELD
    required this.popupAlert,
    required this.deleted,
    required this.dateModified,
    required this.updatedAt,
    required this.dirtyFlag,
  });

  // ---------- JSON (API) ----------
  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'] ?? 0,
      regNo: json['RegNo'] ?? '',
      messageType: json['MESSAGE_TYPE'] ?? 0,
      isHtmlBody: (json['IS_HTML_BODY'] ?? 0) == 1,
      isHtmlPage: (json['IS_HTML_PAGE'] ?? 0) == 1,
      isImageUrl: (json['IS_IMAGE_URL'] ?? 0) == 1,
      title: json['TITLE'] ?? '',
      message: json['MESSAGE'] ?? '',
      actionUrl: json['ACTION_URL'] ?? '',
      expiryDate: json['EXPIRY_DATE'] != null
          ? DateTime.parse(json['EXPIRY_DATE'])
          : DateTime.now(),
      entityId: json['ENTITY_ID'],
      parentId: json['PARENT_ID'],
      parentType: json['PARENT_TYPE'],
      readStatus: (json['READ_STATUS'] ?? 0) == 1,
      readDate: json['READ_DATE'] != null
          ? DateTime.tryParse(json['READ_DATE'])
          : null, // ✅ parse or null
      popupAlert: (json['POPUP_ALERT'] ?? 0) == 1,
      deleted: (json['DELETED'] ?? 0),
      dateModified: json['DATE_MODIFIED'] != null
          ? DateTime.parse(json['DATE_MODIFIED'])
          : DateTime.now(),
      updatedAt: DateTime.now(),
      dirtyFlag: json['DIRTY_FLAG'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'RegNo': regNo,
      'MESSAGE_TYPE': messageType,
      'IS_HTML_BODY': isHtmlBody ? 1 : 0,
      'IS_HTML_PAGE': isHtmlPage ? 1 : 0,
      'IS_IMAGE_URL': isImageUrl ? 1 : 0,
      'TITLE': title,
      'MESSAGE': message,
      'ACTION_URL': actionUrl,
      'EXPIRY_DATE': expiryDate.toIso8601String(),
      'ENTITY_ID': entityId,
      'PARENT_ID': parentId,
      'PARENT_TYPE': parentType,
      'READ_STATUS': readStatus ? 1 : 0,
      'READ_DATE': readDate?.toIso8601String(), // ✅ NEW
      'POPUP_ALERT': popupAlert ? 1 : 0,
      'DELETED': deleted,
      'DATE_MODIFIED': dateModified.toIso8601String(),
      'DIRTY_FLAG': dirtyFlag,
    };
  }

  // ---------- SQLite ----------
  factory UserNotification.fromMap(Map<String, dynamic> map) {
    return UserNotification(
      id: map['id'],
      regNo: map['regNo'],
      messageType: map['messageType'],
      isHtmlBody: map['isHtmlBody'] == 1,
      isHtmlPage: map['isHtmlPage'] == 1,
      isImageUrl: map['isImageUrl'] == 1,
      title: map['title'],
      message: map['message'],
      actionUrl: map['actionUrl'],
      expiryDate: map['expiryDate'] != null
          ? DateTime.parse(map['expiryDate'])
          : DateTime.now(),
      entityId: map['entityId'],
      parentId: map['parentId'],
      parentType: map['parentType'],
      readStatus: map['readStatus'] == 1,
      readDate: map['readDate'] != null && map['readDate'] != ''
          ? DateTime.tryParse(map['readDate'])
          : null, // ✅ NEW
      popupAlert: map['popupAlert'] == 1,
      deleted: map['deleted'],
      dateModified: map['dateModified'] != null
          ? DateTime.parse(map['dateModified'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      dirtyFlag: map['dirtyFlag'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'regNo': regNo,
      'messageType': messageType,
      'isHtmlBody': isHtmlBody ? 1 : 0,
      'isHtmlPage': isHtmlPage ? 1 : 0,
      'isImageUrl': isImageUrl ? 1 : 0,
      'title': title,
      'message': message,
      'actionUrl': actionUrl,
      'expiryDate': expiryDate.toIso8601String(),
      'entityId': entityId,
      'parentId': parentId,
      'parentType': parentType,
      'readStatus': readStatus ? 1 : 0,
      'readDate': readDate?.toIso8601String(), // ✅ NEW
      'popupAlert': popupAlert ? 1 : 0,
      'deleted': deleted,
      'dateModified': dateModified.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dirtyFlag': dirtyFlag,
    };
  }

  // ---------- Table Schema ----------
  static const fields = {
    'id': 'INTEGER PRIMARY KEY',
    'regNo': 'TEXT NOT NULL',
    'messageType': 'INTEGER NOT NULL',
    'isHtmlBody': 'INTEGER NOT NULL',
    'isHtmlPage': 'INTEGER NOT NULL',
    'isImageUrl': 'INTEGER NOT NULL',
    'title': 'TEXT NOT NULL',
    'message': 'TEXT NOT NULL',
    'actionUrl': 'TEXT',
    'expiryDate': 'TEXT NOT NULL',
    'entityId': 'INTEGER',
    'parentId': 'INTEGER',
    'parentType': 'INTEGER',
    'readStatus': 'INTEGER NOT NULL',
    'readDate': 'TEXT', // ✅ NEW COLUMN
    'popupAlert': 'INTEGER NOT NULL',
    'deleted': 'INTEGER NOT NULL',
    'dateModified': 'TEXT NOT NULL',
    'updatedAt': 'TEXT NOT NULL',
    'dirtyFlag': 'INTEGER NOT NULL',
  };
}

