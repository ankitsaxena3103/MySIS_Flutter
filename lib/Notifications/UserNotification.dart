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
  final bool popupAlert;
  final bool deleted;
  final DateTime dateModified;

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
    required this.popupAlert,
    required this.deleted,
    required this.dateModified,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['ID'] ?? 0, // Defaulting to 0 if null
      regNo: json['REGNO'] ?? '',
      messageType: json['MESSAGE_TYPE'] ?? 0,
      isHtmlBody: (json['IS_HTML_BODY'] ?? 0) == 1,
      isHtmlPage: (json['IS_HTML_PAGE'] ?? 0) == 1,
      isImageUrl: (json['IS_IMAGE_URL'] ?? 0) == 1,
      title: json['TITLE'] ?? '',
      message: json['MESSAGE'] ?? '',
      actionUrl: json['ACTION_URL'] ?? '',
      expiryDate: json['EXPIRY_DATE'] != null
          ? DateTime.parse(json['EXPIRY_DATE'])
          : DateTime.now(), // Fallback to current date if null
      entityId: json['ENTITY_ID'],
      parentId: json['PARENT_ID'],
      parentType: json['PARENT_TYPE'],
      readStatus: (json['READ_STATUS'] ?? 0) == 1,
      popupAlert: (json['POPUP_ALERT'] ?? 0) == 1,
      deleted: (json['DELETED'] ?? 0) == 1,
      dateModified: json['DATE_MODIFIED'] != null
          ? DateTime.parse(json['DATE_MODIFIED'])
          : DateTime.now(), // Fallback to current date if null
    );
  }

  // To JSON
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
      'POPUP_ALERT': popupAlert ? 1 : 0,
      'DELETED': deleted ? 1 : 0,
      'DATE_MODIFIED': dateModified.toIso8601String(),
    };
  }

  factory UserNotification.fromMap(Map<String, dynamic> map) {
    return UserNotification(
      id: map['id'],
      regNo: map['RegNo'],
      messageType: map['MESSAGE_TYPE'],
      isHtmlBody: map['IS_HTML_BODY'] == 1,
      isHtmlPage: map['IS_HTML_PAGE'] == 1,
      isImageUrl: map['IS_IMAGE_URL'] == 1,
      title: map['TITLE'],
      message: map['MESSAGE'],
      actionUrl: map['ACTION_URL'],
      expiryDate: DateTime.parse(map['EXPIRY_DATE']),
      entityId: map['ENTITY_ID'],
      parentId: map['PARENT_ID'],
      parentType: map['PARENT_TYPE'],
      readStatus: map['READ_STATUS'] == 1,
      popupAlert: map['POPUP_ALERT'] == 1,
      deleted: map['DELETED'] == 1,
      dateModified: DateTime.parse(map['DATE_MODIFIED']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'regNo': regNo,
      'messageType': messageType,
      'isHtmlBody': isHtmlBody ? 1 : 0, // Convert bool to int (1 for true, 0 for false)
      'isHtmlPage': isHtmlPage ? 1 : 0,
      'isImageUrl': isImageUrl ? 1 : 0,
      'title': title,
      'message': message,
      'actionUrl': actionUrl,
      'expiryDate': expiryDate.toIso8601String(), // Convert DateTime to ISO8601 string
      'entityId': entityId,
      'parentId': parentId,
      'parentType': parentType,
      'readStatus': readStatus ? 1 : 0, // Convert bool to int
      'popupAlert': popupAlert ? 1 : 0,
      'deleted': deleted ? 1 : 0,
      'dateModified': dateModified.toIso8601String(), // Convert DateTime to ISO8601 string
    };
  }

  static const fields = {
    'id': 'INTEGER PRIMARY KEY', // Unique identifier
    'regNo': 'TEXT NOT NULL',
    'messageType': 'INTEGER NOT NULL', // 1 = Notification type, 2 = Alert, etc.
    'isHtmlBody': 'INTEGER NOT NULL', // 0 = false, 1 = true
    'isHtmlPage': 'INTEGER NOT NULL', // 0 = false, 1 = true
    'isImageUrl': 'INTEGER NOT NULL', // 0 = false, 1 = true
    'title': 'TEXT NOT NULL',
    'message': 'TEXT NOT NULL',
    'actionUrl': 'TEXT', // Optional URL for actions
    'expiryDate': 'TEXT NOT NULL', // ISO8601 string format
    'entityId': 'INTEGER', // Nullable foreign key
    'parentId': 'INTEGER', // Nullable foreign key
    'parentType': 'INTEGER', // Nullable type ID
    'readStatus': 'INTEGER NOT NULL', // 0 = Unread, 1 = Read
    'popupAlert': 'INTEGER NOT NULL', // 0 = Disabled, 1 = Enabled
    'deleted': 'INTEGER NOT NULL', // 0 = Active, 1 = Deleted
    'dateModified': 'TEXT NOT NULL', // ISO8601 string format
  };

}

