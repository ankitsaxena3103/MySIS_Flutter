


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
    } else {
      // Request failed, handle error
      printInDebug('Request failed with status: ${response.statusCode}');
      printInDebug('error: ${response.body}');
      responseError = jsonDecode(response.body) as Map<String, dynamic>;

      error(responseError);

    }
  }

  void getData( String apiName, Function(List<dynamic>) completion) async {
    List<dynamic> responseData = [];
    Map<String, dynamic> responseError = {};

      var url = Uri.https(baseUrl,apiName);
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
          final List< dynamic> dataList =  jsonDecode(response.body);
          responseData = dataList;
          completion(responseData);
        } else {
          printInDebug('Request failed with status: ${response.statusCode}');
          printInDebug('error: ${response.body}');

          completion(responseData);
        }
      }
      catch (e) {
        printInDebug('Error: $e');

      }
  }


  void saveVisitor(String apiName,Map<String,dynamic> data, Function(Map<String, dynamic>) completion,Function(Map<String, dynamic>) error) async {
    Map<String, dynamic> responseData = {};
    Map<String, dynamic> responseError = {};

    final Map<String, String> headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };

    final url = Uri.parse('http://api.addonshareware.com/Visitors/save');
    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);

    print('Request: $data');

// Add form fields and files to the request
    request.fields['RegNo'] = data['RegNo'];
    request.fields['UserId'] = data['UserId'];
    request.fields['EventId'] = data['EventId'];
    request.fields['Comment'] = data['Comment'];
    // request.fields['ImageName'] = data['RegNo'];
    // request.fields['ImagePath'] = '';
    // request.fields['ImageWith64BitString'] = data['Image'];


    // request.files.add(await http.MultipartFile.fromPath('ImagePath', data['path']));

// Send the request and await the response
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    // print('Response: $responseString');

    if (response.statusCode == 200) {
      // Successful request, you can handle the response here
      print('Response success: $responseString');
      responseData = jsonDecode(responseString) as Map<String, dynamic>;
      completion(responseData);
    }
    else {
      // Request failed, handle error
      printInDebug('Request failed with status: ${response.statusCode}');
      printInDebug('error: $responseString');

      responseError = jsonDecode(responseString) as Map<String, dynamic>;

      error(responseError);

    }



  }


}