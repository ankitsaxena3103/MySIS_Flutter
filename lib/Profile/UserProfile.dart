class UserProfile {
  final String regNo;
  final String id;
  final String empName;
  final String gender;
  final String rank;
  final String unitCode;
  final String unitId;
  final String branchCode;
  final String branchName;
  final DateTime dateOfBirth;
  final DateTime joiningDate;
  final String mobile;
  final String email;
  final String qualification;
  final String experience;
  final double height;
  final double weight;
  final int age;
  final String bankIfscCode;
  final String accountNo;
  final String bankName;
  final String bankAddress;
  final String profileImageUrl;
  final String esiNo;
  final String uanNo;
  final String bankLogo;
  final String serviceName;
  final String symbol;
  final String managerRegNo;
  final String managerName;
  final String managerMobile;
  final DateTime dateModified;
  final DateTime updatedAt;

  UserProfile({
    required this.regNo,
    required this.id,
    required this.empName,
    required this.gender,
    required this.rank,
    required this.unitCode,
    required this.unitId,
    required this.branchCode,
    required this.branchName,
    required this.dateOfBirth,
    required this.joiningDate,
    required this.mobile,
    required this.email,
    required this.qualification,
    required this.experience,
    required this.height,
    required this.weight,
    required this.age,
    required this.bankIfscCode,
    required this.accountNo,
    required this.bankName,
    required this.bankAddress,
    required this.profileImageUrl,
    required this.esiNo,
    required this.uanNo,
    required this.bankLogo,
    required this.serviceName,
    required this.symbol,
    required this.managerRegNo,
    required this.managerName,
    required this.managerMobile,
    required this.dateModified,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    String? formatDate(DateTime? date) {
      return date?.toIso8601String();
    }

    return {
      'REGNO': regNo,
      'ID': id,
      'EMP_NAME': empName,
      'Gender': gender,
      'RANK': rank,
      'UNIT_CODE': unitCode,
      'UNIT_ID': unitId,
      'BRANCH_CODE': branchCode,
      'BRANCH_NAME': branchName,
      'DATE_OF_BIRTH': formatDate(dateOfBirth),
      'JOINING_DATE': formatDate(joiningDate),
      'MOBILE': mobile,
      'EMAIL': email,
      'Qualification': qualification,
      'Experience': experience,
      'HEIGHT': height,
      'WEIGHT': weight,
      'AGE': age,
      'BankIfscCode': bankIfscCode,
      'AccountNo': accountNo,
      'BankName': bankName,
      'BankAddress': bankAddress,
      'PROFILE_IMAGE_URL': profileImageUrl,
      'ESI_NO': esiNo,
      'UAN_NO': uanNo,
      'BankLogo': bankLogo,
      'SERVICE_NAME': serviceName,
      'SYMBOL': symbol,
      'ManagerRegNo': managerRegNo,
      'ManagerName': managerName,
      'ManagerMobile': managerMobile,
      'DATE_MODIFIED': formatDate(dateModified),
    };
  }


  factory UserProfile.fromJson(Map<String, dynamic> json) {
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

    return UserProfile(
      regNo: json['REGNO'] ?? '',
      id: json['ID'] ?? '',
      empName: json['EMP_NAME'] ?? '',
      gender: json['Gender'] ?? '',
      rank: json['RANK'] ?? '',
      unitCode: json['UNIT_CODE'] ?? '',
      unitId: json['UNIT_ID'] ?? '',
      branchCode: json['BRANCH_CODE'] ?? '',
      branchName: json['BRANCH_NAME'] ?? '',
      dateOfBirth: safeParseDate(json['DATE_OF_BIRTH']) ?? DateTime.now(), // Default to now if null or invalid
      joiningDate: safeParseDate(json['JOINING_DATE']) ?? DateTime.now(), // Default to now if null or invalid
      mobile: json['MOBILE'] ?? '',
      email: json['EMAIL'] ?? '',
      qualification: json['Qualification'] ?? '',
      experience: json['Experience'] ?? '',
      height: json['HEIGHT']?.toDouble() ?? 0.0,
      weight: json['WEIGHT']?.toDouble() ?? 0.0,
      age: json['AGE'] ?? 0,
      bankIfscCode: json['BankIfscCode'] ?? '',
      accountNo: json['AccountNo'] ?? '',
      bankName: json['BankName'] ?? '',
      bankAddress: json['BankAddress'] ?? '',
      profileImageUrl: json['PROFILE_IMAGE_URL'] ?? '',
      esiNo: json['ESI_NO'] ?? '',
      uanNo: json['UAN_NO'] ?? '',
      bankLogo: json['BankLogo'] ?? '',
      serviceName: json['SERVICE_NAME'] ?? '',
      symbol: json['SYMBOL'] ?? '',
      managerRegNo: json['ManagerRegNo'] ?? '',
      managerName: json['ManagerName'] ?? '',
      managerMobile: json['ManagerMobile'] ?? '',
      dateModified: safeParseDate(json['DATE_MODIFIED']) ?? DateTime.now(), // Handle null or invalid
      updatedAt: DateTime.now(), // Default value if not in the JSON
    );
  }

  // Create an instance of UserProfile from a Map
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '', // Ensures it defaults to an empty string if 'id' is null
      regNo: map['regNo'] ?? '', // Same for 'regNo'
      empName: map['empName'] ?? '', // Defaults to an empty string
      gender: map['gender'] ?? '',
      rank: map['rank'] ?? '',
      unitCode: map['unitCode'] ?? '',
      unitId: map['unitId'] ?? '',
      branchCode: map['branchCode'] ?? '',
      branchName: map['branchName'] ?? '',
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.parse(map['dateOfBirth'])
          : DateTime.now(), // Converts date string to DateTime
      joiningDate: map['joiningDate'] != null
          ? DateTime.parse(map['joiningDate'])
          : DateTime.now(), // Same for joiningDate
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      qualification: map['qualification'] ?? '',
      experience: map['experience'] ?? '',
      height: map['height'] ?? '',
      weight: map['weight'] ?? '',
      age: map['age'] ?? 0, // Default to 0 if age is null
      bankIfscCode: map['bankIfscCode'] ?? '',
      accountNo: map['accountNo'] ?? '',
      bankName: map['bankName'] ?? '',
      bankAddress: map['bankAddress'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      esiNo: map['esiNo'] ?? '',
      uanNo: map['uanNo'] ?? '',
      bankLogo: map['bankLogo'] ?? '',
      serviceName: map['serviceName'] ?? '',
      symbol: map['symbol'] ?? '',
      managerRegNo: map['managerRegNo'] ?? '',
      managerName: map['managerName'] ?? '',
      managerMobile: map['managerMobile'] ?? '',
      dateModified: map['dateModified'] != null
    ? DateTime.parse(map['dateModified']) // Convert ISO string to DateTime
        : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt']) // Convert ISO string to DateTime
          : DateTime.now(),

    );
  }

  static const fields = {
    'regNo': 'TEXT NOT NULL',
    'id': 'TEXT PRIMARY KEY', // Unique identifier
    'empName': 'TEXT NOT NULL',
    'gender': 'TEXT NOT NULL',
    'rank': 'TEXT NOT NULL',
    'unitCode': 'TEXT NOT NULL',
    'unitId': 'TEXT NOT NULL',
    'branchCode': 'TEXT NOT NULL',
    'branchName': 'TEXT NOT NULL',
    'dateOfBirth': 'TEXT NOT NULL', // Store as ISO8601 string
    'joiningDate': 'TEXT NOT NULL', // Store as ISO8601 string
    'mobile': 'TEXT NOT NULL',
    'email': 'TEXT',
    'qualification': 'TEXT',
    'experience': 'TEXT',
    'height': 'REAL NOT NULL', // SQLite uses REAL for double/float
    'weight': 'REAL NOT NULL',
    'age': 'INTEGER NOT NULL',
    'bankIfscCode': 'TEXT',
    'accountNo': 'TEXT',
    'bankName': 'TEXT',
    'bankAddress': 'TEXT',
    'profileImageUrl': 'TEXT',
    'esiNo': 'TEXT',
    'uanNo': 'TEXT',
    'bankLogo': 'TEXT',
    'serviceName': 'TEXT',
    'symbol': 'TEXT',
    'managerRegNo': 'TEXT',
    'managerName': 'TEXT',
    'managerMobile': 'TEXT',
    'dateModified':'TEXT NOT NULL',
    'updatedAt':'TEXT NOT NULL',
  };

  // toMap() method
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'regNo': regNo,
      'empName': empName,
      'gender': gender,
      'rank': rank,
      'unitCode': unitCode,
      'unitId': unitId,
      'branchCode': branchCode,
      'branchName': branchName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'joiningDate': joiningDate.toIso8601String(),
      'mobile': mobile,
      'email': email,
      'qualification': qualification,
      'experience': experience,
      'height': height,
      'weight': weight,
      'age': age,
      'bankIfscCode': bankIfscCode,
      'accountNo': accountNo,
      'bankName': bankName,
      'bankAddress': bankAddress,
      'profileImageUrl': profileImageUrl,
      'esiNo': esiNo,
      'uanNo': uanNo,
      'bankLogo': bankLogo,
      'serviceName': serviceName,
      'symbol':symbol,
     'managerRegNo':managerRegNo,
      'managerName':managerName,
      'managerMobile':managerMobile,
      'dateModified':dateModified.toIso8601String(),
      'updatedAt':updatedAt.toIso8601String(),

    };
  }



}



