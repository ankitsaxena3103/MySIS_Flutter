// Port of: AttendanceRepository.java + the two network calls made in
// AttendanceVerificationActivity.java (Volley_Asynclass / VolleyAsyncClassPost).
//
// pubspec.yaml:  http: ^1.2.0   (intl comes with easy_localization)

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/attendance_verify_model.dart';

/// TODO: fill from Constants.java (not part of the uploaded files).
class AttendanceApi {
  static const String baseUrl =
      "https://mysis.sisersys.com:8444/v10/Rest.svc"; // Constants base
  static const String getAttendanceForVerification =
      '/GetAttendanceForVerification'; // Constants.GetAttendanceForVerification
  static const String syncVerifyAttendance =
      '/SyncVerifyAttendance'; // Constants.SyncVerifyAttendance
}

class AttendanceApiException implements Exception {
  final String message;

  AttendanceApiException(this.message);

  @override
  String toString() => message;
}

class AttendanceFetchResult {
  final List<DateEntry> entries;
  final bool isCompleted;

  AttendanceFetchResult(this.entries, this.isCompleted);
}

class AttendanceRepository {
  AttendanceRepository({http.Client? client})
      : _client = client ?? http.Client();
  final http.Client _client;

  static final DateFormat _apiDt = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US');
  static final DateFormat _dayKey = DateFormat('yyyy-MM-dd', 'en_US');

  // ────────────────────────────────────────────────────────────
  // 1. GET attendance  (callAttendanceAPi + onGetResponse, requestCode 1231)
  // ────────────────────────────────────────────────────────────
  Future<AttendanceFetchResult> fetchAttendance({
    required String user,
    required String deviceToken,
    required String password,
    required String pin,
  }) async {
    // NetworkUtils.getEmployeeDeatils_JSON(user, deviceToken, password)
    // TODO: confirm the exact key names used by NetworkUtils.java
    final body = jsonEncode({
      'USER': user,
      'DEVICE_TOKEN': deviceToken,
      'PASSWORD': password,
    });

    final res = await _client
        .get(
          Uri.parse(AttendanceApi.baseUrl +
              AttendanceApi.getAttendanceForVerification),
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
        .timeout(const Duration(seconds: 60));

    if (res.statusCode != 200) {
      throw AttendanceApiException('Server error (${res.statusCode})');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (json['status'].toString().toLowerCase() != 'true') {
      throw AttendanceApiException(
          json['error']?.toString() ?? 'Something went wrong');
    }
    return parseResponse(json);
  }

  // ────────────────────────────────────────────────────────────
  // 2. POST verify  (SyncVerifyAttendance) – body is [{"ID": "..."}, ...]
  // ────────────────────────────────────────────────────────────
  Future<void> verifyRecords(List<String> ids) async {
    final body = jsonEncode(ids.map((id) => {'ID': id}).toList());

    final res = await _client
        .post(
          Uri.parse(AttendanceApi.baseUrl + AttendanceApi.syncVerifyAttendance),
          headers: {'Content-Type': 'application/json'},
          body: body,
        )
        .timeout(const Duration(seconds: 60));

    if (res.statusCode != 200) {
      throw AttendanceApiException('Server error (${res.statusCode})');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (json['status'].toString().toLowerCase() != 'true') {
      throw AttendanceApiException(
          json['error']?.toString() ?? 'Verification failed');
    }
  }

  // ────────────────────────────────────────────────────────────
  // 3. parseRealResponse
  // ────────────────────────────────────────────────────────────
  static AttendanceFetchResult parseResponse(Map<String, dynamic> response) {
    final ranges = response['dateRange'];
    if (ranges is! List || ranges.isEmpty || ranges[0] is! Map) {
      return AttendanceFetchResult([], false);
    }
    final range = ranges[0] as Map<String, dynamic>;
    final startRaw = (range['START_DATE'] ?? '').toString();
    final endRaw = (range['END_DATE'] ?? '').toString();
    if (startRaw.isEmpty || endRaw.isEmpty)
      return AttendanceFetchResult([], false);

    final isCompleted = _asInt(range['isCompleted']) == 1;
    final viewOnly = _asInt(range['VIEW_ONLY']);

    final DateTime rangeStart, rangeEnd;
    try {
      rangeStart = _apiDt.parse(startRaw);
      rangeEnd = _apiDt.parse(endRaw);
    } catch (_) {
      return AttendanceFetchResult([], isCompleted);
    }

    // Pre-populate every day in the window with an empty list
    final byDate = <String, List<AttendanceVerifyModel>>{};
    var walker = DateTime(rangeStart.year, rangeStart.month, rangeStart.day);
    final last = DateTime(rangeEnd.year, rangeEnd.month, rangeEnd.day);
    while (!walker.isAfter(last)) {
      byDate[_dayKey.format(walker)] = [];
      walker = DateTime(walker.year, walker.month, walker.day + 1);
    }

    final data = response['data'];
    if (data is List) {
      for (final item in data) {
        if (item is! Map<String, dynamic>) continue;

        final startDateStr = (item['SHIFT_START_DATE'] ?? '').toString();
        final dateKey = startDateStr.length >= 10
            ? startDateStr.substring(0, 10)
            : startDateStr;
        if (!byDate.containsKey(dateKey)) continue; // outside window / bad date

        byDate[dateKey]!.add(_parseRecord(item));
      }
    }

    final entries = <DateEntry>[];
    byDate.forEach((dateKey, recs) {
      final d = _dayKey.parse(dateKey);

      String overall;
      if (recs.isEmpty) {
        overall = 'Absent';
      } else {
        final allApproved = recs.every((r) => r.status == 'Approved');
        final anyRejected = recs.any((r) => r.status == 'Rejected');
        overall =
            allApproved ? 'Approved' : (anyRejected ? 'Rejected' : 'Pending');
      }

      entries.add(DateEntry(
        dayName: DateFormat('EEE').format(d),
        dayNumber: DateFormat('dd').format(d),
        shortDateLabel: DateFormat('dd MMM yyyy').format(d),
        fullDateLabel: DateFormat('EEEE, dd MMMM yyyy').format(d),
        monthYearTag: DateFormat('MMMM yyyy').format(d),
        apiDate: dateKey,
        records: recs,
        startDateRange: startRaw,
        endDateRange: endRaw,
        isCompleted: isCompleted,
        // viewType: viewOnly,
        viewType: 0,
        overallStatus: overall,
        isSubmitted: overall == 'Approved',
      ));
    });

    return AttendanceFetchResult(entries, isCompleted);
  }

  static AttendanceVerifyModel _parseRecord(Map<String, dynamic> row) {
    final timeFmt = DateFormat('hh:mm a');
    String show(DateTime? d) => d != null ? timeFmt.format(d) : '—';

    final shiftStart = _tryParse(row['SHIFT_START_TIME']);
    final shiftEnd = _tryParse(row['SHIFT_END_TIME']);
    final actStart = _tryParse(row['ACT_START_TIME']);
    final actEnd = _tryParse(row['ACT_END_TIME']);

    final dutyStatus = (row['DUTY_STATUS'] ?? '').toString();
    final hasDutyOut = dutyStatus.toUpperCase() == 'DUTY_OUT' && actEnd != null;

    final apiStatus = _asInt(row['STATUS']);
    final status =
        apiStatus == 0 ? 'Pending' : (apiStatus == 1 ? 'Approved' : 'Rejected');

    String str(String k) {
      final v = row[k]?.toString();
      return (v == null || v.isEmpty) ? '—' : v;
    }

    return AttendanceVerifyModel(
      id: (row['ID'] ?? '').toString(),
      shiftId: (row['SHIFT_ID'] ?? '').toString(),
      shiftName: str('SHIFT_NAME'),
      unitName: str('UNIT_NAME'),
      unitCode: str('UNIT_CODE'),
      postId: (row['POST_ID'] ?? '').toString(),
      postName: str('POST_NAME'),
      shiftStart: show(shiftStart),
      shiftEnd: show(shiftEnd),
      dutyIn: show(actStart),
      dutyOut: hasDutyOut ? show(actEnd) : '—',
      dutyStatus: dutyStatus,
      shiftStartTime: (row['SHIFT_START_TIME'] ?? '').toString(),
      dutyMinutes: _asInt(row['DUTY_MIN']),
      shiftMinutes: _asInt(row['SHIFT_MIN']),
      approvedHrs: _asInt(row['APPROVED_HR']),
      claimReason: _asInt(row['CLAIM_REASON']),
      claimRemark: (row['CLAIM_REMARK'] ?? '').toString(),
      claimStatus: _asInt(row['CLAIM_STATUS']),
      claimSubmittedOn: (row['CLAIM_SUBMITTED_ON'] ?? '').toString(),
      raiseComplaintStatus: _asInt(row['RAISE_COMPLAINT_STATUS']),
      dutyOutMissing: !hasDutyOut,
      lateDutyIn: actStart != null &&
          shiftStart != null &&
          actStart.isAfter(shiftStart),
      status: status,
      raw: row,
    );
  }

  static DateTime? _tryParse(dynamic raw) {
    final s = raw?.toString() ?? '';
    if (s.isEmpty) return null;
    try {
      return _apiDt.parse(s);
    } catch (_) {
      return null;
    }
  }

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is bool) return v ? 1 : 0;
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}
