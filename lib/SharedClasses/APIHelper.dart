


import 'dart:convert';
// import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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


  void postAllData(
      String apiName,
      dynamic data,
      Function(List<dynamic>) completion,
      Function(Map<String, dynamic>) error,
      ) async {
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



  void getData( String apiName,Map<String, String> queryParams, Function(List<dynamic>) completion,Function(Map<String, dynamic>) error) async {
    // Map<String, dynamic> responseData = {};
    List<dynamic> responseData = [];

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
          // final List< dynamic> dataList =  jsonDecode(response.body);
          // responseData = dataList;

          final Map<String, dynamic> jsonResponse =
          jsonDecode(response.body) as Map<String, dynamic>;

          if (jsonResponse.containsKey('data')) {

            final List<dynamic> dataList = jsonResponse['data'];
             responseData = dataList;

            if (dataList.isNotEmpty) {
              completion(responseData);
            }
          }

          // completion(responseData);
        }
        else if(response.statusCode == 401){
          String userId = await Preferences.getUserPreference(keyUserID) ?? '';
          String pwd = await Preferences.getUserPreference(keyUserID) ?? '';
          if(userId != '' && pwd != '') {
            getToken(userId, pwd);
          }
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


  void getToken(String userId, String pwd){
    Map <String,String> inputData = {
      "Username": userId,
      "Password": pwd,

    };
    APIHelper.instance.postData(tokenApi,inputData, (data) {

      if(data.isNotEmpty){

        token = data['token'] ?? '';
        Preferences.saveUserPreference(keyUserToken, token);


      }

    },(error){
      if (kDebugMode) {
        print(error);
      }
    });
  }

}