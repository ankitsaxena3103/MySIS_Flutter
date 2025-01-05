
import 'dart:core';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';


const String baseUrl = 'mysis.sisersys.com:8446';
const String authenticateApi = '/api/guardApp/Auth/isValidUser';
const String profileApi = '/api/guardApp/Auth/UserProfile';
const String tokenApi = '/api/guardApp/Auth/GenerateToken';
const String userPostingApi = '/api/guardApp/Auth/UserPosting';
const String contactSISApi = '/api/guardApp/Auth/ContactSIS';
const String userRosterApi = '/api/guardApp/Auth/UserRoster';
const String userNotificationApi = '/api/guardApp/Auth/UserNotification';
const String userAttendanceApi = '/api/guardApp/Auth/UserAttendance';
const String userAttendancePostApi = '/api/guardApp/Post/PostUserAttendance';


const keyTableUserProfile = 'UserProfile';
const keyTableUserPosting = 'UserPosting';
const keyTableUnitShiftDetail = 'UnitShiftDetail';
const keyTableUnitDutyPost = 'UnitDutyPost';
const keyTableContactSIS = 'ContactSIS';
const keyTableUserRoster = 'UserRoster';
const keyTableUserNotification = 'UserNotification';
const keyTableUserAttendance = 'UserAttendance';

const keyAttendanceModeSelf = 'DEVICE';
const keyAttendanceModeOther = 'OTHER_DUTY';

const keyAttendanceStatusDutyIn = 'DUTY_IN';
const keyAttendanceStatusDutyOut = 'DUTY_OUT';


String phoneNo = '';
String token = '';
String userId = '';

String userName = '';
String designation = '';

int selectedServiceId = 0;

bool isDarkMode = false;
String selectedLocale = 'en-US';
String selectedLanguageCode = 'en';

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

  marginValue = screenWidth < 500 ? 13 : 100 ;
  pathL = (screenWidth - (marginValue * 2)) / 2.5;
  pathS = pathL / 2;


}

// final double pathX = pathL;
// final double pathY = (screenHeight) / 2 + pathL + pathS / 2;

const keyUserToken = "token";
const keyUserName = "name";
const keyUserID = "userID";

const keyPIN = 'PIN';
const keyPwd = 'pwd';



List<TextStyle> PINTextStyle(Color color, int fieldCount) {
  return List.generate(
    fieldCount, // Adjust the number of fields as needed
        (index) => TextStyle(
      color: color,
      fontSize: pathS/4,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
    ),
  );
}

void printInDebug(String msg){
  if (kDebugMode){
    print(msg);
  }
}

void makePhoneCall(String phoneNumber) async {
  // String phone = "http://www.example.com" ;
  // final Uri url = Uri.parse(phone);
  // const number = phoneNumber; //set the number here

  bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  printInDebug('$res');

}

void shareOnWhatsApp(String appLink) async {
  String content = 'MySIS App:';
  SocialShare.shareWhatsapp(content);

}

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

int getDiffrenceInSeconds(String time1, String time2){

  // Parse time strings into DateTime objects
  DateTime dateTime1 = DateFormat('h:mm a').parse(time1);
  DateTime dateTime2 = DateFormat('h:mm a').parse(time2);

  // Calculate the difference in seconds
  return  (dateTime2.difference(dateTime1)).inSeconds;


}

int getDiffrenceInMinutes(String time1, String time2){

  // Parse time strings into DateTime objects
  DateTime dateTime1 = DateFormat('h:mm a').parse(time1);
  DateTime dateTime2 = DateFormat('h:mm a').parse(time2);

  // Calculate the difference in seconds
  return  (dateTime2.difference(dateTime1)).inMinutes;


}

String formatTime(String timeString, String format) {
  String  convertedTime = timeString;
  try {
    // Parse the input time string as a time-only format
    final DateFormat inputFormat = DateFormat('HH:mm:ss');
    final DateTime parsedTime = inputFormat.parse(timeString);

    // Format it into "HH:mm"
    final DateFormat outputFormat = DateFormat(format);
    return outputFormat.format(parsedTime);
  } catch (e) {
    // Return the original time if parsing fails
    return convertedTime;
  }


}

String getFormattedTime(String timeString, String format) {
  String  convertedTime = timeString;
  try {
    // Parse the input time string as a time-only format
    final DateFormat inputFormat = DateFormat('HH:mm');
    final DateTime parsedTime = inputFormat.parse(timeString);

    // Format it into "HH:mm"
    final DateFormat outputFormat = DateFormat(format);
    return outputFormat.format(parsedTime);
  } catch (e) {
    // Return the original time if parsing fails
    return convertedTime;
  }


}



String getFormattedDateTime(String timeString, String inputFormat, String outputFormat) {
  String convertedTime = timeString;
  try {
    // Parse the input time string as a time-only format
    final DateFormat inputDateFormat = DateFormat(inputFormat);
    final DateTime parsedTime = inputDateFormat.parse(timeString);

    // Format it into "HH:mm"
    final DateFormat outputDateFormat = DateFormat(outputFormat);
    return outputDateFormat.format(parsedTime);
  } catch (e) {
    // Return the original time if parsing fails
    return convertedTime;
  }
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

void launchGoogleMap(double lat, double lng){
  final googleMapUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
  Uri web = Uri.parse(googleMapUrl);
  launchUrl(web);
}


const Color redColor1 = Color.fromRGBO(235, 74, 77, 1);
const Color redColor2 = Color.fromRGBO(255, 0, 4, 1);
const Color redColor3 = Color.fromRGBO(195, 50, 53, 1);

const Color pinkColor = Color.fromRGBO(255, 235, 235, 1);

const Color yellowColor = Color.fromRGBO(252, 244, 200, 1);
const Color yellowColor1 = Color.fromRGBO(246, 242, 126, 1);
const Color yellowColor2 = Color.fromRGBO(255, 214, 0, 1);

const Color brownColor = Color.fromRGBO(170, 123, 12, 1);

const Color greenColor1 =Color.fromRGBO(202, 245, 221, 1);
const Color greenColor2 =Color.fromRGBO(202, 245, 221, 1);
const Color greenColor3 = Color.fromRGBO(0, 239, 192, 1);
const Color greenColor4 =Color.fromRGBO(35, 221, 117, 1);
const Color greenColor5 =Color.fromRGBO(35, 221, 117, 1);
const Color greenColor6 =Color.fromRGBO(17, 154, 77, 1);

const Color whiteColor =Color.fromRGBO(255, 255, 255, 1);

const Color shadowColor = Color.fromRGBO(0, 0, 0, 0.15);

const Color greyColor =Color.fromRGBO(245, 245, 245, 1);
const Color greyColor1 =Color.fromRGBO(218, 218, 218, 1);
const Color greyColor2 =Color.fromRGBO(51, 51, 51, 0.2);
const Color greyColor3 =Color.fromRGBO(51, 51, 51, 0.6);
const Color greyColor4 =Color.fromRGBO(51, 51, 51, 0.7);
const Color greyColor5 = Color.fromRGBO(96, 96, 96, 1);
const Color greyColor6 =Color.fromRGBO(51, 51, 51, 1);
const Color greyColor8 = Color.fromRGBO(53, 53, 53, 1);
const Color greyColor7 =Color.fromRGBO(22, 22, 22, 1);
const Color greyColorDark = Color.fromRGBO(0, 0, 0, 1);


const Color orangeColor = Color.fromRGBO(251, 151, 5, 1);
const Color orangeColor1 = Color.fromRGBO(248, 116, 0, 1);






