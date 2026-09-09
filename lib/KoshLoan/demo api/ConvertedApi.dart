import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mysis/KoshLoan/demo%20api/Converted_model/ConvertedleadModel.dart';


class ConvertedApi {
  static const String apiUrl =
      "https://6a9fcfb63e0d88d3d7e5058a.mockapi.io/backend_API/Backend_API";

  Future<ConvertedLeadModel?> getConvertedLeadModel() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        return ConvertedLeadModel.fromJson(jsonData);
      } else {
        print("API Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}