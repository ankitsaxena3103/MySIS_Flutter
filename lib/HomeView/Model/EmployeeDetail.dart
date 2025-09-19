class EmployeeDetail {
  final String regNo;
  final String id;
  final String empName;
  final String gender;
  final String rank;
  final String mobile;
  final String email;
  final String profileImageUrl;
  final String empStatus;

  EmployeeDetail({
    required this.regNo,
    required this.id,
    required this.empName,
    required this.gender,
    required this.rank,
    required this.mobile,
    required this.email,
    required this.profileImageUrl,
    required this.empStatus,
  });

  factory EmployeeDetail.fromJson(Map<String, dynamic> json) {
    return EmployeeDetail(
      regNo: json['REGNO'] ?? '',
      id: json['ID'] ?? '',
      empName: json['EMP_NAME'] ?? '',
      gender: json['Gender'] ?? '',
      rank: json['RANK'] ?? '',
      mobile: json['MOBILE'] ?? '',
      email: json['EMAIL'] ?? '',
      profileImageUrl: json['PROFILE_IMAGE_URL'] ?? '',
      empStatus: json['EMP_STATUS'] ?? '',
    );
  }
}
