import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../CommonViews/Utility.dart';
import '../../SharedClasses/Preferences.dart';
import '../models/CredentialModel.dart';
import '../models/missing_claim_models.dart';

// =============================================================
// Date helpers  (port of DateUtils.* used in postClaimDataOnServer)
// =============================================================
class ClaimDateUtils {
  static final DateFormat _fmt = DateFormat('yyyy-MM-dd HH:mm:ss');

  static String _normalize(String t) {
    final p = t.split(':');
    final h = p[0].padLeft(2, '0');
    final m = (p.length > 1 ? p[1] : '00').padLeft(2, '0');
    final s = (p.length > 2 ? p[2] : '00').padLeft(2, '0');
    return '$h:$m:$s';
  }

  /// apiDate must be "yyyy-MM-dd".
  static DateTime toDateTime(String apiDate, String time) =>
      DateTime.parse('$apiDate ${_normalize(time)}');

  static String _2(int n) => n.toString().padLeft(2, '0');

  // static String format(DateTime d) => _fmt.format(d);
  /// Always "yyyy-MM-dd HH:mm:ss"
  static String format(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${_2(d.month)}-${_2(d.day)} '
      '${_2(d.hour)}:${_2(d.minute)}:${_2(d.second)}';

  /// Same date as [d] with the time removed -> "yyyy-MM-dd 00:00:00".
  static String dateAtMidnight(DateTime d) =>
      format(DateTime(d.year, d.month, d.day));

  static String toDateTimeString(String apiDate, String time) =>
      format(toDateTime(apiDate, time));

  /// Exact port of DateUtils.getDutyOutDateTime(shiftStartTime, dutyOutTime).
  ///
  /// Starts from [start]'s date, sets the out clock time on it, then compares
  /// CLOCK TIME ONLY (hour*60 + minute, seconds ignored):
  /// if out <= start  => crossed midnight => add 1 day.
  ///
  ///   start 2026-09-12 22:00, out "06:00"    -> 2026-09-13 06:00  (night shift)
  ///   start 2026-09-12 06:00, out "14:00"    -> 2026-09-12 14:00  (day shift)
  ///   start 2026-09-12 22:00, out "00:00:00" -> 2026-09-13 00:00  (SHIFT_END_DATE)
  ///   start 2026-09-12 08:00, out "08:00"    -> 2026-09-13 08:00  (24h shift)
  static DateTime dutyOutDateTime(DateTime start, String outTime) {
    final p = _normalize(outTime).split(':').map(int.parse).toList();
    final h = p[0], m = p[1], s = p[2];

    var out = DateTime(start.year, start.month, start.day, h, m, s);

    final startTotalMin = start.hour * 60 + start.minute;
    final outTotalMin = h * 60 + m;

    if (outTotalMin <= startTotalMin) {
      // day + 1 is safe across month / year end
      out = DateTime(start.year, start.month, start.day + 1, h, m, s);
    }
    return out;
  }

  static int totalMinutes(DateTime start, DateTime end) =>
      end.difference(start).inMinutes;

  static String now() => format(DateTime.now());

  /// Exact port of CFUtil.calculateDayValue(dutyMin, shiftMin).
  static double calculateDayValue(int dutyMin, int shiftMin) {
    if (shiftMin <= 0) return 0.0; // invalid shift config

    if (dutyMin >= shiftMin) return 1.0; // full day

    final halfShiftMin = shiftMin ~/ 2; // integer division, same as Java long
    if (dutyMin >= halfShiftMin) return 0.5; // half day

    return 0.0; // insufficient duty time
  }
}

// =============================================================
// API service (replaces Volley_Asynclass + VolleyAsyncClassPost)
// =============================================================
class NoInternetException implements Exception {}

class MissingClaimService {
  static String BASE_URL =
      "https://mysis.sisersys.com:8444/v10/Rest.svc/SitesForMissingAttendanceClaimByGuard";

  // ⚠️ Confirm the endpoint name = value of Constants.SyncAttendanceClaim
  static String submitUrl =
      "https://mysis.sisersys.com:8444/v10/Rest.svc/SyncAttendanceClaim";

  // // ⚠️ Fill these from your Constants.java / NetworkUtils.java
  // final String fetchUrl; // Constants.SitesForMissingAttendanceClaimByGuard
  // final String submitUrl; // Constants.SyncAttendanceClaim
  // final String user; // CSShearedPrefence.getUser()
  // final String deviceToken; // CSShearedPrefence.getDeviceToken()
  // final String password; // CSShearedPrefence.getPassword()
  MissingClaimService._();

  static Future<CredentialModel> _credentialBody() async {
    return CredentialModel(
      userName: await Preferences.getUserPreference(keyUserID) ?? '',
      deviceToken: '',
      password: await Preferences.getUserPreference(keyPwd) ?? '',
      pin: await Preferences.getUserPreference(keyPIN) ?? '',
    );
  }

  static Future<MissingClaimApiResponse> fetchMissingData() async {
    final CredentialModel credentials = await _credentialBody();
    final res = await _post(BASE_URL, credentials.toJson());
    print('MISSING..RESPONSE...${res.body}');
    print('MISSING..toJson...${credentials.toJson()}');
    return MissingClaimApiResponse.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// Sends the JSON array (same shape the Android code posts).
  /// Returns true when response.status == "true".
  static Future<bool> submitClaim111(List<Map<String, dynamic>> payload) async {
    final credentials = await _credentialBody();
    final Map<String, dynamic> jsonObject = {
      "data": payload,
    };
    final res = await _postJson(submitUrl, jsonObject, credentials.toJson());
    print('SUBMIT..RESPONSE...${res.body}');
    print('SUBMIT STATUS: ${res.statusCode}');
    print('SUBMIT RESPONSE: ${res.body}');
    final responseBody = res.body.replaceFirst('\uFEFF', '').trim();
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(
        'Submit claim failed: HTTP ${res.statusCode}: $responseBody',
      );
    }
    final j = jsonDecode(res.body);
    return j is Map && j['status'].toString().toLowerCase() == 'true';
  }

  static Future<http.Response> _postJson111(
    String url,
    Object body,
    Map<String, dynamic>? headers,
  ) async {
    try {
      print('_postJson..jsonEncode......${jsonEncode(body)}');
      return await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'text',
              'Accept': 'application/json',
              if (headers != null)
                ...headers.map((k, v) => MapEntry(k, v.toString())),
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 45));
    } on Exception catch (e) {
      if (e.toString().contains('SocketException')) throw NoInternetException();
      rethrow;
    }
  }

  static Future<bool> submitClaim(
    List<Map<String, dynamic>> payload,
  ) async {
    final credentials = await _credentialBody();

    final Map<String, dynamic> jsonObject = {
      'data': payload,
    };

    final res = await _postJson(
      submitUrl,
      jsonObject,
      credentials.toJson(),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(
        'HTTP ${res.statusCode}: ${res.body}',
      );
    }

    final responseBody = res.body.replaceFirst('\uFEFF', '').trim();

    final j = jsonDecode(responseBody);

    return j is Map && j['status']?.toString().toLowerCase() == 'true';
  }

  static Future<http.Response> _postJson(
    String url,
    Object body,
    Map<String, dynamic>? headers,
  ) async {
    try {
      final String requestBody = jsonEncode(body);

      final Map<String, String> requestHeaders = {
        'Content-Type': 'text',
        'Accept': 'application/json',
        if (headers != null)
          ...headers.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
      };

      print('REQUEST URL: $url');
      print('REQUEST HEADERS: $requestHeaders');
      print('REQUEST BODY: $requestBody');

      final request = http.Request('POST', Uri.parse(url))
        ..headers.addAll(requestHeaders)
        ..bodyBytes = utf8.encode(requestBody);

      final streamedResponse = await request.send().timeout(
            const Duration(seconds: 45),
          );

      final response = await http.Response.fromStream(streamedResponse);

      print('HTTP STATUS: ${response.statusCode}');
      print('RESPONSE HEADERS: ${response.headers}');
      print('RESPONSE BODY: ${response.body}');

      return response;
    } on Exception catch (e) {
      print('POST ERROR: $e');

      if (e.toString().contains('SocketException')) {
        throw NoInternetException();
      }

      rethrow;
    }
  }

  static Future<http.Response> _post(
    String url,
    Map<String, dynamic>? headers,
  ) async {
    try {
      return await http.get(
        Uri.parse(url),
        headers: {
          if (headers != null)
            ...headers.map((key, value) => MapEntry(key, value.toString())),
        },
      ).timeout(const Duration(seconds: 45));
    } on Exception catch (e) {
      if (e.toString().contains('SocketException')) throw NoInternetException();
      rethrow;
    }
  }
}
