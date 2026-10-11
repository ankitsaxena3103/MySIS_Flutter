import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../CommonViews/Utility.dart';
import '../../SharedClasses/Preferences.dart';
import '../models/CredentialModel.dart';

class ComplaintResult {
  final bool success;
  final String message;
  final String? complaintId;

  const ComplaintResult({
    required this.success,
    required this.message,
    this.complaintId,
  });
}

/// Port of RaiseComplaintFragment.postComplaintOnServer()
class ComplaintApiService {
  // TODO: replace with Constants.BASE_URL + Constants.postAttendanceComplaint
  static const String baseUrl =
      "https://mysis.sisersys.com:8444/v10/Rest.svc/"; // Constants base
  static const String postAttendanceComplaint = 'PostAttendanceComplaint';

  /// TODO: port NetworkUtils.getEmployeeDeatils_JSON(user, deviceToken, password)
  /// Put the same headers your Android app sends here (do NOT set Content-Type,
  /// the multipart request sets it with the boundary automatically).
  static Future<Map<String, String>> _headers() async {
    return {
      // 'user': await Prefs.getUser(),
      // 'deviceToken': await Prefs.getDeviceToken(),
      // 'password': await Prefs.getPassword(),
    };
  }

  static Future<CredentialModel> _credentialBody() async {
    return CredentialModel(
      userName: await Preferences.getUserPreference(keyUserID) ?? '',
      deviceToken: '',
      password: await Preferences.getUserPreference(keyPwd) ?? '',
      pin: await Preferences.getUserPreference(keyPIN) ?? '',
    );
  }

  static Future<ComplaintResult> submitComplaint({
    required String attendanceId,
    required String remark,
    required int categoryIndex, // same value as spinner position (1..6)
    String? voicePath,
  }) async {
    try {
      final credentials = await _credentialBody();
      final Map<String, String> requestHeaders = {
        'Content-Type': 'text',
        'Accept': 'application/json',
        if (credentials.toJson() != null)
          ...credentials.toJson().map(
                (key, value) => MapEntry(key, value.toString()),
              ),
      };
      final body = jsonEncode({
        'data': [
          {
            'ID': const Uuid().v4(),
            'ATN_ID': attendanceId,
            'REMARK': remark,
            'COMPLAINT_CATEGORY': categoryIndex,
          }
        ]
      });
      print('RAISE_COMPLAINT...JSON..${body}');
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$postAttendanceComplaint'),
      );
      request.headers.addAll(requestHeaders);
      request.fields['request'] = body;

      if (voicePath != null) {
        final file = File(voicePath);
        if (await file.exists() && await file.length() > 0) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'voice',
              voicePath,
              filename: file.uri.pathSegments.last,
            ),
          );
        }
      }

      final streamed =
          await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamed);
      print('RAISE_COMPLAINT...response..${response.body}');
      print('RAISE_COMPLAINT...response..${response.statusCode}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return ComplaintResult(
          success: false,
          message: 'Server error (${response.statusCode})',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final status = json['status'] == 'true';
      print('RAISE_COMPLAINT...response.status....${status}');

      if (status) {
        final data = json['data'];
        String? id;
        if (data is List && data.isNotEmpty) {
          id = data[0]['ID']?.toString();
        }
        return ComplaintResult(
          success: true,
          message: 'Complaint submitted successfully',
          complaintId: id,
        );
      }
      return ComplaintResult(
        success: false,
        message: (json['error'] ?? 'Something went wrong').toString(),
      );
    } on TimeoutException {
      return const ComplaintResult(
          success: false, message: 'Request timed out');
    } on SocketException {
      return const ComplaintResult(
          success: false, message: 'No internet connection');
    } catch (e) {
      return ComplaintResult(success: false, message: e.toString());
    }
  }
}
