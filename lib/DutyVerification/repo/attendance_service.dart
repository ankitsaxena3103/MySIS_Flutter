import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/attendance_record.dart';
import 'attendance_api_result.dart';

/// Port of callAttendanceAPi() + onGetResponse().
class AttendanceService {
   final String BASE_URL = "https://mysis.sisersys.com:8444/v10/Rest.svc/";

  AttendanceService._();

  // !! Replace with Constants.GetAttendanceForVerification
  static final String _url =
      "https://mysis.sisersys.com:8444/v10/Rest.svc/GetAttendanceForVerification";

  /// !! Body = what NetworkUtils.getEmployeeDeatils_JSON(...) builds.
  static Future<AttendanceApiResult> fetch({
    required String user,
    required String deviceToken,
    required String password,
    required String pin,
  }) async {
    final res = await http.get(
      Uri.parse(_url),
      headers: {
        'UserName': user,
        'DeviceID': deviceToken,
        'Password': password,
        'MPIN': pin,
        'AuthType': 'DEVICE',
        'AppType': 'GUARD',
        'VERSION': "2.3.6",
        'CompanyCode':"",
        'AUTH_TOKEN': "",
        'VERSION_CODE': "169"
      },
    )
        .timeout(const Duration(seconds: 30));

    if (res.statusCode != 200) {
      throw Exception('Server error (${res.statusCode})');
    }
print('DUTY_RESPONSE>>>>...${res.body}');
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if ('${json['status']}'.toLowerCase() != 'true') {
      throw Exception('${json['error'] ?? 'Something went wrong'}');
    }

    final range = (json['dateRange'] as List).first as Map<String, dynamic>;
    final records = (json['data'] as List)
        .map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
        .toList();

    return AttendanceApiResult(
      records: records,
      startDate: '${range['START_DATE']}',
      endDate: '${range['END_DATE']}',
    );
  }
}
