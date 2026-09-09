import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mysis/KoshLoan/walletmodel.dart';


class WalletApi {
  static const String apiUrl =
      'https://6a44ad29aab3faec3f68af91.mockapi.io/shivam/api/wallet';

  static Future<walletmodel> getWallet() async {
    final response = await http.get(
      Uri.parse(apiUrl),
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        return walletmodel.fromJson(data[0]);
      }

      throw Exception("Wallet data is empty");
    } else {
      throw Exception(
        "Failed to load wallet: ${response.statusCode}",
      );
    }
  }
}