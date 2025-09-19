import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../CommonViews/Utility.dart';

class GMDSeBolo extends StatefulWidget {
  @override
  GMDSeBoloState createState() => GMDSeBoloState();
}

class GMDSeBoloState extends State<GMDSeBolo> {
  String? token;
  bool isLoading = true;
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://apps.knowledgeflex.com/TicketManagementFreshdeskSISAPI/api/Token/TokenGenerate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "RegNo": regNo,
          "UserId": "GMDBot@SIS",
          "Password": "GMDBot@SIS#7895"
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["StatusCode"] == 200) {
          setState(() {
            token = data["Token"];
            isLoading = false;
          });
        } else {
          _showError("Failed: ${data["StatusMessage"]}");
        }
      } else {
        _showError("Error ${response.statusCode}");
      }
    } catch (e) {
      _showError("Exception: $e");
    }
  }

  void _showError(String msg) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final url = token != null
        ? "https://gmdsebolo.azurewebsites.net/ChatSupport/GrievanceChat?Token=$token"
        : null;

    return Scaffold(
      backgroundColor: isDarkMode ? greyColorDark : whiteColor, // body background
      appBar: AppBar(
        backgroundColor: isDarkMode ? greyColorDark : whiteColor, // AppBar background
        elevation: 0,
        automaticallyImplyLeading: false, // removes default back button space
        titleSpacing: 0,
        centerTitle: false,
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: pathS/5),
              Image.asset(
                'assets/images/dashboard-icons/left-arrow.png',
                width: pathS / 4.5,
                height: pathS / 4.5,
                color: isDarkMode ? whiteColor : greyColor6,
              ),
              SizedBox(width: pathS / 20),
              Text(
                'GMD_se_bolo'.tr(),
                style: TextStyle(
                  color: isDarkMode ? whiteColor : greyColor6,
                  fontSize: pathS / 5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : url == null
          ? Center(child: Text("Unable to load chatbot"))
          : InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          // You can add background color for webview if needed:
          // use `useShouldOverrideUrlLoading: true` for more control
        ),
      ),
    );
  }

}

// SafeArea(
// child: Padding(
// padding: EdgeInsets.all(12.0),
// child: Row(
// children: [
// GestureDetector(
// onTap: () => Navigator.pop(context),
// child: Row(
// children: [
// Image.asset(
// 'assets/images/dashboard-icons/left-arrow.png',
// width: pathS/4,
// height: pathS/4,
// color: isDarkMode ? whiteColor : greyColor6,
// ),
// SizedBox(width: 8),
// Text(
// 'GMD_se_bolo'.tr(),
// style: TextStyle(
// color: isDarkMode ? whiteColor : greyColor6,
// fontSize: pathS/5,
// fontWeight: FontWeight.w500,
// fontFamily: 'Roboto',
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// ),
// ),
