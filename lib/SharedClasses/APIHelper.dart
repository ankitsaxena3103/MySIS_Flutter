


import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mysis/CommonViews/Utility.dart';

import 'Preferences.dart';


class APIHelper {
  // Private constructor
  APIHelper._() {}
  // Singleton instance
  static final APIHelper _instance = APIHelper._();
  // Getter for the instance
  static APIHelper get instance => _instance;


  void postAllData(String apiName, dynamic data, Function(List<dynamic>) completion, Function(Map<String, dynamic>) error,) async {

    List<dynamic> responseDataList = [];
    Map<String, dynamic> responseError = {};
    var url = Uri.https(baseUrl, apiName);
    final header = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = data;

    final jsonString = jsonEncode(data);
    printInDebug('Request (JSON): $jsonString');

    try {
      final response = await http.post(
        url,
        headers: header,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Successful request, handle the response here
        printInDebug('Response: ${response.body}');

        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse.containsKey('data')) {
          // Extract the list from the "data" key
          responseDataList = jsonResponse['data'] as List<dynamic>;

          if (responseDataList.isNotEmpty) {
            completion(responseDataList);
          } else {
            printInDebug('Data list is empty.');
            error({'ErrorMessage': 'Empty data list in response.'});
          }
        }
        else {
          printInDebug('Response does not contain "data" key.');
          error({'ErrorMessage': 'Invalid response format.'});
        }
      }
      else if(response.statusCode == 401 && apiName != tokenApi){

        final Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        responseError = jsonResponse.containsKey('data')
            ? jsonResponse['data'] as Map<String, dynamic>
            : {'ErrorMessage': 'Unexpected error'};

        bool isForceLogout = (responseError['ForceLogout'] ?? 0) == 1;

        if(isForceLogout){
          Preferences.saveUserPreferenceBool(keyIsForcedLogOut, true);
        }else{
          recallGetToken();
        }

          error(responseError);
      }
      else {
        // Handle other response statuses
        printInDebug('Request failed with status: ${response.statusCode}');
        printInDebug('Error: ${response.body}');

        final Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        responseError = jsonResponse.containsKey('data')
            ? jsonResponse['data'] as Map<String, dynamic>
            : {'ErrorMessage': 'Unexpected error'};
        error(responseError);
      }
    } catch (e) {
      // Handle exceptions
      printInDebug('Error: $e');
      responseError = {'ErrorMessage': 'Unexpected error'};
      error(responseError);
    }
  }

  void postData(String apiName,Map<String, dynamic> data, Function(Map<String, dynamic>) completion,Function(Map<String, dynamic>) error) async {

    Map<String, dynamic> responseData = {};
    Map<String, dynamic> responseError = {};

    var url = Uri.https(baseUrl,apiName);
    final header = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = data;

    final jsonString = jsonEncode(data);
    printInDebug('Request (JSON): $jsonString');

    try {
      final response = await http.post(
        url,
        headers: header,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Successful request, you can handle the response here
        printInDebug('Response: ${response.body}');
        responseData = jsonDecode(response.body) as Map<String, dynamic>;
        completion(responseData);

      }
      else if(response.statusCode == 401 && apiName != tokenApi){
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        responseError = jsonResponse.containsKey('data')
            ? jsonResponse['data'] as Map<String, dynamic>
            : {'ErrorMessage': 'Unexpected error'};

        bool isForceLogout = (responseError['ForceLogout'] ?? 0) == 1;

        if(isForceLogout){
          Preferences.saveUserPreferenceBool(keyIsForcedLogOut, true);
        }else{
          recallGetToken();
        }
        error(responseError);
      }
      else {
        printInDebug('Request failed with status: ${response.statusCode}');
        printInDebug('error: ${response.body}');

        final Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

        if (jsonResponse.containsKey('data')) {
          final Map<String, dynamic> data = jsonResponse['data'];
          responseError = data;
        }
        else {
          responseError = {'ErrorMessage': 'Unexpected error'};
        }

        error(responseError);
      }
    }
    catch (e) {
      printInDebug('Error: $e');
      responseError = {'ErrorMessage': 'Unexpected error'};
      error(responseError);
    }

  }

  void getData(
      String apiName,
      Map<String, String> queryParams,
      Function(List<dynamic>) completion,
      Function(Map<String, dynamic>) error,
      ) async {
    List<dynamic> responseData = [];
    Map<String, dynamic> responseError = {};

    var apiUrl = Uri.https(baseUrl, apiName);
    var url = queryParams.isNotEmpty
        ? Uri.parse('$apiUrl').replace(queryParameters: queryParams)
        : apiUrl;

    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);
      printInDebug('request url=$url headers=$headers');

      if (response.statusCode == 200) {
        printInDebug('Response: ${response.body}');

        final Map<String, dynamic> jsonResponse =
        jsonDecode(response.body) as Map<String, dynamic>;

        if (jsonResponse.containsKey('data')) {
          // Case 1: response has "data"
          final List<dynamic> dataList = jsonResponse['data'];
          responseData = dataList;
          completion(responseData);
        } else {
          // Case 2: response is a single object (like login token)
          responseData = [jsonResponse]; // wrap into list
          completion(responseData);
        }
      } else if (response.statusCode == 401) {
        final Map<String, dynamic> jsonResponse =
        jsonDecode(response.body) as Map<String, dynamic>;

        responseError = jsonResponse.containsKey('data')
            ? jsonResponse['data'] as Map<String, dynamic>
            : {'ErrorMessage': 'Unexpected error'};

        bool isForceLogout = (responseError['ForceLogout'] ?? 0) == 1;

        if (isForceLogout) {
          Preferences.saveUserPreferenceBool(keyIsForcedLogOut, true);
        } else {
          recallGetToken();
        }
        error(responseError);
      } else {
        printInDebug('Request failed with status: ${response.statusCode}');
        printInDebug('error: ${response.body}');

        final Map<String, dynamic> jsonResponse =
        jsonDecode(response.body) as Map<String, dynamic>;

        if (jsonResponse.containsKey('data')) {
          responseError = jsonResponse['data'] as Map<String, dynamic>;
        } else {
          responseError = {'ErrorMessage': 'Unexpected error'};
        }

        error(responseError);
      }
    } catch (e) {
      printInDebug('Error: $e');
      responseError = {'ErrorMessage': 'Unexpected error'};
      error(responseError);
    }
  }

  void getHTMLData(
      String apiName,
      Map<String, String> queryParams,
      Function(String) completion,
      Function(Map<String, dynamic>) error,
      ) async {
    Map<String, dynamic> responseError = {};

    var apiUrl = Uri.https(baseUrl, apiName);
    var url = queryParams.isNotEmpty
        ? Uri.parse('$apiUrl').replace(queryParameters: queryParams)
        : apiUrl;

    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);
      printInDebug('request url=$url headers=$headers');

      if (response.statusCode == 200) {
        printInDebug('Response: ${response.body}');

        // HTML response is returned directly
        completion(response.body);
      } else {
        responseError = {
          'ErrorMessage': 'Status code: ${response.statusCode}',
          'Response': response.body
        };
        error(responseError);
      }
    } catch (e) {
      printInDebug('Error: $e');
      responseError = {'ErrorMessage': 'Unexpected error'};
      error(responseError);
    }
  }


  void getUserData( String apiName,Map<String, String> queryParams, Function(Map<String, dynamic>) completion,Function(Map<String, dynamic>) error) async {
    Map<String, dynamic> responseData = {};
    // List<dynamic> responseData = [];

    Map<String, dynamic> responseError = {};

    var apiIURL = Uri.https(baseUrl,apiName);

    var url = queryParams.isNotEmpty ? Uri.parse('$apiIURL').replace(queryParameters: queryParams) : apiIURL;

    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      printInDebug('request  url=$url headers =$headers');

      if (response.statusCode == 200) {
        printInDebug('Response: ${response.body}');

        final Map<String, dynamic> jsonResponse =
        jsonDecode(response.body) as Map<String, dynamic>;

        if (jsonResponse.containsKey('data')) {

            responseData = jsonResponse['data'];
            completion(responseData);
        }

        // completion(responseData);
      }
      else if(response.statusCode == 401 && apiName != tokenApi){
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        responseError = jsonResponse.containsKey('data')
            ? jsonResponse['data'] as Map<String, dynamic>
            : {'ErrorMessage': 'Unexpected error'};

        bool isForceLogout = (responseError['ForceLogout'] ?? 0) == 1;

        if(isForceLogout){
          Preferences.saveUserPreferenceBool(keyIsForcedLogOut, true);
        }else{
          recallGetToken();
        }
        error(responseError);
      }

      else {
        printInDebug('Request failed with status: ${response.statusCode}');
        printInDebug('error: ${response.body}');

        final Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

        if (jsonResponse.containsKey('data')) {
          final Map<String, dynamic> data = jsonResponse['data'];
          responseError = data;
        }
        else {
          responseError = {'ErrorMessage': 'Unexpected error'};
        }

        error(responseError);
      }
    }
    catch (e) {
      printInDebug('Error: $e');
      responseError = {'ErrorMessage': 'Unexpected error'};
      error(responseError);
    }
  }

  void postImage(String apiName, Map<String, dynamic> data, Function(Map<String, dynamic>) completion, Function(Map<String, dynamic>) error) async {
    Map<String, dynamic> responseData = {};
    Map<String, dynamic> responseError = {};

    try {
      var apiIURL = Uri.https(baseUrl,apiName);

      var url = data.isNotEmpty ? Uri.parse('$apiIURL').replace(queryParameters: data) : apiIURL;

      // Create a Multipart Request
      var request = http.MultipartRequest('POST', url);

      // Add Authorization header
      request.headers.addAll({
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      });


      String fileName = data['file'] ?? 'file Not found';
      printInDebug(fileName);
      request.files.add(await http.MultipartFile.fromPath(
          'fileName',fileName
      ));

      http.StreamedResponse streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Successful response
        printInDebug('Response: ${response.body}');
        responseData = jsonDecode(response.body) as Map<String, dynamic>;
        completion(responseData);
      } else {
        // Failed response
        printInDebug('Request failed with status: ${response.statusCode}');
        printInDebug('Error: ${response.body}');

        final Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse.containsKey('errors')) {
          responseError = jsonResponse['errors'];
        } else {
          responseError = {'ErrorMessage': 'Unexpected error'};
        }

        error(responseError);
      }
    } catch (e) {
      printInDebug('Error: $e');
      responseError = {'ErrorMessage': 'Unexpected error: $e'};
      error(responseError);
    }
  }

  void patchData(String apiName,Map<String, dynamic> data, Function(List<dynamic>) completion,Function(Map<String, dynamic>) error) async {

    // Map<String, dynamic> responseData = {};
    List<dynamic> responseData = [];

    Map<String, dynamic> responseError = {};

    var url = Uri.https(baseUrl,apiName);
    final header = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = data;

    final jsonString = jsonEncode(data);
    printInDebug('Request (JSON): $jsonString');

    try {
      final response = await http.patch(
        url,
        headers: header,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Successful request, you can handle the response here
        printInDebug('Response: ${response.body}');
        final Map<String, dynamic> jsonResponse =
        jsonDecode(response.body) as Map<String, dynamic>;

        if (jsonResponse.containsKey('data')) {
          final List<dynamic> dataList = jsonResponse['data'];
          responseData = dataList;

          if (dataList.isNotEmpty) {
            completion(responseData);
          }
        }

      }
      else if(response.statusCode == 401 && apiName != tokenApi){

        final Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        responseError = jsonResponse.containsKey('data')
            ? jsonResponse['data'] as Map<String, dynamic>
            : {'ErrorMessage': 'Unexpected error'};

        bool isForceLogout = (responseError['ForceLogout'] ?? 0) == 1;

        if(isForceLogout){
          Preferences.saveUserPreferenceBool(keyIsForcedLogOut, true);
        }else{
          recallGetToken();
        }
        error(responseError);
      }
      else {
        printInDebug('Request failed with status: ${response.statusCode}');
        printInDebug('error: ${response.body}');

        final Map<String, dynamic> jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

        if (jsonResponse.containsKey('data')) {
          final Map<String, dynamic> data = jsonResponse['data'];
          responseError = data;
        }
        else {
          responseError = {'ErrorMessage': 'Unexpected error'};
        }
        error(responseError);
      }
    }
    catch (e) {
      printInDebug('Error: $e');
      responseError = {'ErrorMessage': 'Unexpected error'};
      error(responseError);
    }

  }

  void getToken(String userId, String pwd) {
    Map<String, String> inputData = {
      "Username": userId,
      "Password": pwd,
      "AppToken": appToken,
    };

    APIHelper.instance.getData(tokenApi, inputData, (data) {
      if (data.isNotEmpty) {
        // Since getData returns List<dynamic>, take first object
        final Map<String, dynamic> tokenData = data.first;

        token = tokenData['token'] ?? '';
        String expiryTime = tokenData['expirytime'] ?? '';

        Preferences.saveUserPreference(keyUserToken, token);
        Preferences.saveUserPreference(keyTokenExpiryTime, expiryTime);
        Preferences.saveUserPreferenceBool(keyIsForcedLogOut, false);

        printInDebug("✅ Token received: $token");
        printInDebug("✅ Expiry: $expiryTime");
      }
    }, (error) {
      if (kDebugMode) {
        printInDebug("❌ Error in getToken: $error");
      }
    });
  }

  Future<bool> checkForTokenExpiry() async {
    bool isTokenExpire = false;
    DateTime currentDate = DateTime.now();

    String expiryDate = await Preferences.getUserPreference(keyTokenExpiryTime) ?? '';
    printInDebug("Expiry Date from storage: $expiryDate");

    if (expiryDate.isEmpty) {
      printInDebug("No expiry date found. Marking token as expired.");
      return true;
    }

    try {
      // Use correct format with locale
      DateFormat format = DateFormat('M/d/yyyy h:mm:ss a', 'en_US'); // Force US locale
      DateTime tokenExpiryDateTime = format.parseStrict(expiryDate);

      printInDebug("Parsed Expiry Date: $tokenExpiryDateTime");

      // Check if token is expired
      bool isTokenAlreadyExpired = tokenExpiryDateTime.isBefore(currentDate);
      bool isTokenExpireToday = tokenExpiryDateTime.year == currentDate.year &&
          tokenExpiryDateTime.month == currentDate.month &&
          tokenExpiryDateTime.day == currentDate.day;

      if (isTokenAlreadyExpired) {
        printInDebug("Token is already expired.");
        isTokenExpire = true;
      } else if (isTokenExpireToday) {
        printInDebug("Token will expire today.");
        isTokenExpire = true;
      } else {
        printInDebug("Token is still valid.");
        isTokenExpire = false;
      }
    } catch (e) {
      printInDebug("Error parsing expiry date: $e \nExpiry Date String: '$expiryDate'");
      isTokenExpire = true; // Assume expired on error
    }

    return isTokenExpire;
  }
  Future<void> recallGetToken() async {
    String userIdOrMobile = regNo.isNotEmpty ? await Preferences.getUserPreference(keyUserID) ?? '' : '';
    String pwd = await Preferences.getUserPreference(keyPwd) ?? '';
    if(userIdOrMobile != '' && pwd != '') {
    getToken(userIdOrMobile, pwd);
    }
  }

}

