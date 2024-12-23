


import 'dart:convert';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysis/CommonViews/Utility.dart';


class APIHelper {
  // Private constructor
  APIHelper._() {}
  // Singleton instance
  static final APIHelper _instance = APIHelper._();
  // Getter for the instance
  static APIHelper get instance => _instance;


  void postData(String apiName,Map<String,dynamic> data, Function(Map<String, dynamic>) completion,Function(Map<String, dynamic>) error) async {
    Map<String, dynamic> responseData = {};
    Map<String, dynamic> responseError = {};

    var url = Uri.https(baseUrl,apiName);
    final header = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = data;
    printInDebug('request = $data');

    try {
      final response = await http.post(
        url,
        headers: header,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        // Successful request, you can handle the response here
        print('Response: ${response.body}');
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


}