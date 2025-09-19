import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/SharedClasses/LanguageProvider.dart';
import 'package:provider/provider.dart';

import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/ThemeProvider.dart';


import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SalaryView extends StatefulWidget {
  const SalaryView({super.key});

  @override
  _SalaryViewState createState() => _SalaryViewState();
}

class _SalaryViewState extends State<SalaryView> {
  bool showLoaderView = false;
  String htmlData = "";

  @override
  void initState() {
    super.initState();
    onLoadData();
  }

  void onLoadData() {
    setState(() {
      showLoaderView = true;
    });

    Map<String, String> inputData = {};

    APIHelper.instance.getHTMLData(
      salaryApi,
      inputData,
          (data) {
        setState(() {
          showLoaderView = false;
          htmlData = data; // Store HTML here
        });
      },
          (error) {
        setState(() {
          showLoaderView = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: logicalWidth,
        height: logicalHeight,
        decoration: BoxDecoration(
          gradient: isDarkMode ? backgroundGradientDark : backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button + Title
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: paddingLeft, vertical: pathS / 3),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      SizedBox(
                        width: pathS / 5,
                        height: pathS / 2,
                        child: Image.asset(
                          'assets/images/dashboard-icons/left-arrow.png',
                          color: isDarkMode ? Colors.white : Colors.grey,
                        ),
                      ),
                      SizedBox(width: pathS / 8),
                      Text(
                        'Salary',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.grey[800],
                          fontSize: pathS / 5.5,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // HTML Content
              Expanded(
                child: showLoaderView
                    ? Center(child: CircularProgressIndicator())
                    : InAppWebView(
                  initialData: InAppWebViewInitialData(
                    data: htmlData,
                  ),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      javaScriptEnabled: true,
                      useOnLoadResource: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
