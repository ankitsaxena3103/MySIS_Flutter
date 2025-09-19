import 'package:mysis/Profile/UserProfile.dart';

import '../../Profile/UnitDutyPost.dart';
import '../../Profile/UnitShiftDetail.dart';
import '../../Profile/UserPosting.dart';
import '../UserAttendance.dart';

class EmployeeRoasterDetail {
  final List<UserProfile> employeeDetail;
  final List<UserAttendance> employeeAttendance;
  final List<UserPosting> userPosting;
  final List<UnitDutyPost> unitDutyPost;
  final List<UnitShiftDetail> unitShiftDetail;

  EmployeeRoasterDetail({
    required this.employeeDetail,
    required this.employeeAttendance,
    required this.userPosting,
    required this.unitDutyPost,
    required this.unitShiftDetail,
  });

  factory EmployeeRoasterDetail.fromJson(Map<String, dynamic> json) {
    return EmployeeRoasterDetail(
      employeeDetail: (json['EmployeeDetail'] as List<dynamic>?)
          ?.map((e) => UserProfile.fromJson(e))
          .toList() ??
          [],
      employeeAttendance: (json['EmployeeAttendance'] as List<dynamic>?)
          ?.map((e) => UserAttendance.fromJson(e))
          .toList() ??
          [],
      userPosting: (json['UserPosting'] as List<dynamic>?)
          ?.map((e) => UserPosting.fromJson(e))
          .toList() ??
          [],
      unitDutyPost: (json['UnitDutyPost'] as List<dynamic>?)
          ?.map((e) => UnitDutyPost.fromJson(e))
          .toList() ??
          [],
      unitShiftDetail: (json['UnitShiftDetail'] as List<dynamic>?)
          ?.map((e) => UnitShiftDetail.fromJson(e))
          .toList() ??
          [],
    );
  }
}
