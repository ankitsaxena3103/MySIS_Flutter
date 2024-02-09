
import 'dart:core';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';


// https://ciapimobile.creditinsta.com/api/User/authenticate
const String baseUrl = 'ciapimobile.creditinsta.com';
const String authenticateApi = 'api/User/authenticate';


const phoneNo = '+919311435804';
String token = '';
int userId = 0;
String userName = '';
int selectedLeadType = 1;
int selectedServiceId = 0;

bool isDarkMode = false;

String selectedLanguage = '';
// final FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
//
// // Dimensions in physical pixels (px)
// final Size size = view.physicalSize;
//
//
// final double pixelRatio = view.devicePixelRatio;
//
// Size physicalScreenSize =  view.physicalSize;
// final double physicalHeight = physicalScreenSize.height;
// final double physicalWidth =  physicalScreenSize.width;
//
// // Size in logical pixels
// final Size logicalScreenSize = physicalScreenSize / pixelRatio;
// final double logicalWidth = logicalScreenSize.width;
// final double logicalHeight = logicalScreenSize.height;
//
// // Safe area paddings in logical pixels
// final double paddingLeft = view.padding.left / pixelRatio;
// final double paddingRight = view.padding.right / pixelRatio;
// final double paddingTop = view.padding.top / pixelRatio;
// final double paddingBottom = view.padding.bottom / pixelRatio;

// final double screenWidth = logicalWidth - paddingLeft - paddingRight;
// final double screenHeight = logicalHeight - paddingTop - paddingBottom;
//
// final double marginValue = screenWidth < 600 ? 20 : 100 ;
//
// final double pathL = (screenWidth - (marginValue * 2)) / 2.5;
// final double pathS = pathL / 2;

late Size physicalScreenSize ;

late double pixelRatio ;
late double paddingLeft  ;
late double paddingRight ;
late double paddingTop ;
late double paddingBottom ;

late double logicalHeight ;
late double logicalWidth ;

// Safe area in logical pixels
late double screenWidth ;
late double screenHeight ;

late double marginValue;

late double pathL ;
late double pathS;


void calculateSizes(BuildContext context){

  physicalScreenSize = MediaQuery.of(context).size;

  pixelRatio = MediaQuery.of(context).devicePixelRatio;
  paddingLeft = MediaQuery.of(context).padding.left ;
  paddingRight = MediaQuery.of(context).padding.right;
  paddingTop = MediaQuery.of(context).padding.top;
  paddingBottom = MediaQuery.of(context).padding.bottom;

  logicalWidth = physicalScreenSize.width;

  logicalHeight = physicalScreenSize.height;
// Safe area in logical pixels
  screenWidth = logicalWidth - paddingLeft - paddingRight;
  screenHeight = logicalHeight - paddingTop - paddingBottom;

  marginValue = screenWidth < 500 ? 20 : 100 ;
  pathL = (screenWidth - (marginValue * 2)) / 2.5;
  pathS = pathL / 2;


}

// final double pathX = pathL;
// final double pathY = (screenHeight) / 2 + pathL + pathS / 2;

const keyUserToken = "token";
const keyUserName = "name";
const keyUserID = "userID";


void printInDebug(String msg){
  if (kDebugMode){
    print(msg);
  }
}

// void makePhoneCall(phoneNumber) async {
//   String url = "tel:$phoneNumber";
//
//   if (await canLaunchUrl(url as Uri)) {
//     await launchUrl(url as Uri);
//   } else {
//     throw "Could not launch $url";
//   }
// }

void makePhoneCall(String phoneNumber) async {
  // String phone = "http://www.example.com" ;
  // final Uri url = Uri.parse(phone);
  // const number = phoneNumber; //set the number here

  // bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);

}
// String getDateTime(){
//   DateTime now = DateTime.now();
//   String formattedDateTime = DateFormat('dd-MM-yyyy,HH:mm:ss').format(now);
//
//   return formattedDateTime;
//
// }

PackageInfo packageInfo = PackageInfo(
  appName: 'MySIS',
  packageName: 'com.sisindia.mysis',
  version: '1',
  buildNumber: '1',
  buildSignature: 'Unknown',
  installerStore: 'Unknown',
);

String getDateTime(String format){

  DateTime now = DateTime.now();
  String formattedDateTime = DateFormat(format).format(now);

  return formattedDateTime;

}
var backgroundGradient =  LinearGradient(
  colors: [Colors.white, Color.fromRGBO(217, 217, 217, 1)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

var backgroundGradientDark =  LinearGradient(
  colors: [Color.fromRGBO(22, 22, 22, 1), Colors.black],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

var backgroundGradientRed =  LinearGradient(
  colors: [Color.fromRGBO(195, 50, 53, 1), Colors.black],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);


const Color redBgcolor = Color.fromRGBO(235, 74, 77, 1);
const Color redFontcolor = Color.fromRGBO(195, 50, 53, 1);
const Color brightRedFontcolor = Color.fromRGBO(255, 0, 4, 1);

const Color pinkBgcolor = Color.fromRGBO(255, 235, 235, 1);

const Color yellowBgcolor = Color.fromRGBO(246, 242, 126, 1);
const Color darkYellowBgcolor = Color.fromRGBO(255, 214, 0, 1);
const Color yellowFontcolor = Color.fromRGBO(170, 123, 12, 1);

const Color greenBgColor =Color.fromRGBO(202, 245, 221, 1);
const Color greenFontColor =Color.fromRGBO(202, 245, 221, 1);
const Color flurocentFontColor = Color.fromRGBO(0, 239, 192, 1);
const Color GreenFontColor =Color.fromRGBO(35, 221, 117, 1);
const Color darkGreenBGColor =Color.fromRGBO(35, 221, 117, 1);
const Color darkGreenFontColor =Color.fromRGBO(17, 154, 77, 1);

const Color whiteFontColor =Color.fromRGBO(255, 255, 255, 1);

const Color whiteBGColor =Color.fromRGBO(218, 218, 218, 1);
const Color greyButtonBGColor =Color.fromRGBO(51, 51, 51, 0.2);
const Color greyButtonFontColor =Color.fromRGBO(51, 51, 51, 0.6);
const Color lightGreyFontColor =Color.fromRGBO(51, 51, 51, 0.7);
const Color greyBgcolor = Color.fromRGBO(96, 96, 96, 1);
const Color greyFontColor =Color.fromRGBO(51, 51, 51, 1);
const Color darkGreyFontColor =Color.fromRGBO(22, 22, 22, 1);
const Color darkTileBgcolor = Color.fromRGBO(53, 53, 53, 1);








