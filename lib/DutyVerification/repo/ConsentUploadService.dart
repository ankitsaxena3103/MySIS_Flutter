import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../CommonViews/Utility.dart';
import '../../SharedClasses/Preferences.dart';

class ConsentUploadResult {
  final bool success;
  final String message;
  const ConsentUploadResult(this.success, this.message);
}

/// Flutter version of captureAndUpload() from ConsentLetterActivity.kt
///
/// Flow (same as native):
///   1. save captured PNG to a temp FILE      (bitmapToFile)
///   2. compress it                            (ImageCompresssion THIRD_GEAR)
///   3. file -> base64                         (fileToBase64)
///   4. POST JSON to SyncVerifyAttendanceMaster
class ConsentUploadService {
  // TODO: put the same values as Constants.BASE_URL / SyncVerifyAttendanceMaster
  static const String _url = 'https://mysis.sisersys.com:8444/v10/Rest.svc/SyncVerifyAttendanceMaster';

  // TODO: native sends these through CSApplicationHelper.postDataParam.
  // Fill with the same params your other Flutter API calls send
  // (UserName, Password, DeviceID, AppType, VERSION, CompanyCode ...).


  static Future<Map<String, String>> _commonParams() async => {
    'UserName': await  Preferences.getUserPreference(keyUserID)??'',
    'Password': await  Preferences.getUserPreference(keyPwd)??'',
    'MPIN': await  Preferences.getUserPreference(keyPIN)??'',
    // 'DeviceID': await CSShearedPrefence.getDeviceToken(),
    'AppType': 'Guard',

  };

  static Future<ConsentUploadResult> submit({
    required Uint8List png,
    required BuildContext mContext,
    required String regNo,
    required String fromDate,
    required String toDate,
  }) async {
    File? raw;
    File? compressed;
    try {
      // 1. PNG -> file
      final dir = await getTemporaryDirectory();
      final ts = DateTime.now().millisecondsSinceEpoch;
      raw = File('${dir.path}/consent_$ts.png');
      await raw.writeAsBytes(png, flush: true);

      // 2. compress (PNG -> JPEG, much smaller for upload)
      final xfile = await FlutterImageCompress.compressAndGetFile(
        raw.path,
        '${dir.path}/consent_${regNo}_$ts.jpg',
        quality: 70,
        format: CompressFormat.jpeg,
      );
      compressed = xfile == null ? raw : File(xfile.path);
      // await showDialog(
      //   context: mContext,
      //   builder: (_) => Dialog(
      //     child: InteractiveViewer(
      //       child: SingleChildScrollView(child: Image.memory(png)),
      //     ),
      //   ),
      // );
      // 3 + 4. upload
      return await _uploadAsJsonBase64(compressed, regNo, fromDate, toDate);
      // Server wants a real file instead? use:
      // return await _uploadAsMultipart(compressed, regNo, fromDate, toDate);
    } catch (e) {
      return ConsentUploadResult(false, 'Upload failed: $e');
    } finally {
      try {
        if (raw != null && await raw.exists()) await raw.delete();
        if (compressed != null && await compressed.exists()) {
          await compressed.delete();
        }
      } catch (_) {}
    }
  }

  /// Exactly what native does: JSON with base64 image.
  static Future<ConsentUploadResult> _uploadAsJsonBase64(
    File file,
    String regNo,
    String fromDate,
    String toDate,
  ) async {
    final base64Image = base64Encode(await file.readAsBytes());

    final body = {
      'Acknowledgement': base64Image,
      'RegNo': regNo,
      'FromDate': fromDate,
      'ToDate': toDate,
      'isCompleted': 1,
      // ...await _commonParams(),
    };
print('body......$body');
print('body...._commonParams....${await _commonParams()}');
    final res = await http
        .post(
          Uri.parse(_url),
          // headers: {'Content-Type': 'application/json'},
          headers: await _commonParams(),
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 60));
    print('RESPONSE...FILE UPLOAD........${res.body}');

    return _parse(res);
  }

  // /// Alternative: send the image as an actual multipart FILE.
  // static Future<ConsentUploadResult> _uploadAsMultipart(
  //   File file,
  //   String regNo,
  //   String fromDate,
  //   String toDate,
  // ) async {
  //   final req = http.MultipartRequest('POST', Uri.parse(_url))
  //     ..fields.addAll({
  //       'RegNo': regNo,
  //       'FromDate': fromDate,
  //       'ToDate': toDate,
  //       'isCompleted': '1',
  //       ...await _commonParams(),
  //     })
  //     ..files.add(await http.MultipartFile.fromPath('Acknowledgement', file.path));
  //
  //   final streamed = await req.send().timeout(const Duration(seconds: 60));
  //   final res = await http.Response.fromStream(streamed);
  //   return _parse(res);
  // }

  static ConsentUploadResult _parse(http.Response res) {
    if (res.statusCode != 200) {
      return ConsentUploadResult(false, 'Server error ${res.statusCode}');
    }
    try {
      final json = jsonDecode(res.body);
      final ok = json['status'].toString().toLowerCase() == 'true';
      return ConsentUploadResult(
        ok,
        ok ? 'Submitted' : (json['message']?.toString() ?? 'Submit failed'),
      );
    } catch (_) {
      return const ConsentUploadResult(false, 'Invalid server response');
    }
  }
}
