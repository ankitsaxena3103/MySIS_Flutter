
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';


final LocalAuthentication auth = LocalAuthentication();

const String appToken = r"$2a$11$QGo3jefJUjhG1kwyJSDKV.q7emFNRSntKuQUgo7KKOEycVnWYX0tm";

const String baseUrl = 'mysis.sisersys.com:8446';
// const String baseUrl = 'mydtss.sisersys.com:8447';
// const String baseUrl = 'mysisco.sisersys.com:8449';

// const String authenticateApi = '/api/guardApp/Auth/isValidUser';
const String profileApi = '/api/guardApp/Auth/UserProfile';
const String tokenApi = '/api/guardApp/GenerateToken';
const String userPostingApi = '/api/guardApp/Auth/UserPosting';
const String contactSISApi = '/api/guardApp/Auth/ContactSIS';
const String userRosterApi = '/api/guardApp/Auth/UserRoster';
const String userNotificationApi = '/api/guardApp/Auth/UserNotification';
const String userAttendanceApi = '/api/guardApp/Auth/UserAttendance';
const String userLeavesApi = '/api/guardApp/Auth/UserLeaves';
const String salaryApi = '/api/guardApp/Auth/Payslip';

const String leaveTypeMasterApi = '/api/guardApp/Auth/LeaveTypeMaster';
const String helpMasterApi = '/api/guardApp/Auth/HelpMaster';
const String applyLoanApi = '/api/guardApp/Auth/LoanApplication';
const String requestLoginApi = '/api/guardApp/RequestLogin';
const String validateOTPApi =  '/api/guardApp/ValidateOTP';
const String escortDutyApi =  '/api/guardApp/Auth/EscortDuty';
const String branchHierarchyApi =  '/api/guardApp/Auth/BranchHierarchy';


const String uploadImageApi = '/api/guardApp/FileUpload/upload';
const String updateProfileApi = '/api/guardApp/Post/UpdateProfile';
const String userAttendancePostApi = '/api/guardApp/Post/PostUserAttendance';
const String userLeavesPostApi = '/api/guardApp/Post/PostUserLeaveRequest';
const String escortDutyPostApi = 'api/guardApp/Post/PostEscortDutyRequest';
const String userNotificationPostApi = '/api/guardApp/Post/UpdateUserNotificationStatus';
const String postGuardReferalApi = '/api/guardApp/Post/PostGuardReferal';
const String employeeRoasterApi = 'api/guardApp/Auth/EmployeeRosterDetail';

const keyDataBaseName = 'mydtss_database.db';
const keyTableUserProfile = 'UserProfile';
const keyTableUserPosting = 'UserPosting';
const keyTableUnitShiftDetail = 'UnitShiftDetail';
const keyTableUnitDutyPost = 'UnitDutyPost';
const keyTableContactSIS = 'ContactSIS';
const keyTableUserRoster = 'UserRoster';
const keyTableUserNotification = 'UserNotification';
const keyTableUserAttendance = 'UserAttendance';
const String keyTableUserLeave = 'UserLeaves';
const String keyTableLeaveType = 'LeaveType';
const String keyTableHelpMaster = 'HelpMaster';
const String keyTableEscortDuty = 'EscortDuty';


const keyDeviceModel= "deviceModel";
const keyPlateformVersion = "plateformVersion";

// const String keyTablePostGuardReferal = 'PostGuardReferal';


const keyAttendanceModeSelf = 'DEVICE';
const keyAttendanceModeOther = 'OTHER_DUTY';
const keyAttendanceModeEscortDuty = 'ESCORT_DUTY';

const keyAttendanceStatusDutyIn = 'DUTY_IN';
const keyAttendanceStatusDutyOut = 'DUTY_OUT';

const keyPendingAttendance = 0;
const keyApprovedAttendance = 1;
const keyNotApprovedAttendance = 2;

const keyPendingEscortDuty = 0;
const keyApprovedEscortDuty = 1;
const keyRejectedEscortDuty = 2;


const keyPendingLeave = 0;
const keyApprovedLeave = 1;
const keyRejectedLeave = 2;


String phoneNo = '';
String token = '';
String regNo = '';
String currentPin = '';
String userName = '';
String designation = '';

int selectedServiceId = 0;

bool isDarkMode = false;
String selectedLocale = 'en-US';
String selectedLanguageCode = 'en';

bool isMobileInternetOn = false;
bool isMobileCarrierDetected = false;
bool isGPSEnabled = false;
bool isUserBiometricEnabled = false;

bool isForeground = false;


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
const keyMobile = 'mobile';

const keyTokenExpiryTime = "expiryTime";
const keyIsForcedLogOut = "forceLogout";
const keyBiometricEnabled = "isBiometric";



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

Future<void> sendSMS(String phoneNumber, String message) async {
  final Uri smsUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
    queryParameters: {
      'body': message,
    },
  );

  try {
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      printInDebug('No SMS app is available to handle the request.');
    }
  } catch (e) {
    printInDebug('Error launching SMS app: $e');
  }
}

void shareOnWhatsApp_old(String appLink) async {
  String content = 'MyDTSS App:';
  // SocialShare.shareWhatsapp(content);
}

void shareOnWhatsApp(String appLink) async {
  final url = 'https://wa.me/$appLink?text=Hello';

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    printInDebug('WhatsApp not installed');
  }
}


PackageInfo packageInfo = PackageInfo(
  appName: 'MyDTSS',
  packageName: 'com.sisindia.mydtss',
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


String getFormattedTimeFromDate(String timeString) {
  try {
    // Check if timeString has date part
    DateTime parsedTime;
    if (timeString.contains(' ')) {
      // e.g., "2025-10-26 08:00:00"
      parsedTime = DateTime.parse(timeString);
    } else {
      // e.g., "08:00"
      final DateFormat inputFormat = DateFormat('HH:mm');
      parsedTime = inputFormat.parse(timeString);
    }

    // Format to "hh:mm a" => 08:00 AM
    final DateFormat outputFormat = DateFormat('hh:mm a');
    return outputFormat.format(parsedTime);
  } catch (e) {
    return timeString; // fallback if parsing fails
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

void loadMyUrl(String urlString){
  Uri web = Uri.parse(urlString);
  launchUrl(web);
}

Future<String> getCurrentLocation() async {
  String currentLatLng = '';
  try {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best, // Adjust accuracy as needed
        distanceFilter: 10, // Optional: Minimum distance between updates in meters
      ),
    );

    printInDebug('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    currentLatLng = '${position.latitude},${position.longitude}';
  } catch (e) {
    printInDebug('Error: $e');
  }

  return currentLatLng;

}


int getDistanceFromDuty(String dutyLatLng, String currentLatLng) {
  int distance = 0;

  List<String> currentLatLngList = currentLatLng.isNotEmpty
      ? currentLatLng.split(',').map((e) => e.trim()).toList()
      : ['0.0', '0.0'];
  double currentLat = double.parse(currentLatLngList[0]); // Latitude
  double currentLng = double.parse(currentLatLngList[1]); // Longitude

  // Parse duty latitude and longitude
  List<String> dutyLatLngList = dutyLatLng.isNotEmpty
      ? dutyLatLng.split(',').map((e) => e.trim()).toList()
      : ['0.0', '0.0'];
  double dutyLat = double.parse(dutyLatLngList[1]); // Latitude
  double dutyLng = double.parse(dutyLatLngList[0]); // Longitude

  // Radius of the Earth in meters
  const double earthRadius = 6371000;

  // Convert degrees to radians
  double toRadians(double degree) => degree * pi / 180;

  // Haversine formula
  double dLat = toRadians(dutyLat - currentLat);
  double dLng = toRadians(dutyLng - currentLng);

  double a = pow(sin(dLat / 2), 2) +
      cos(toRadians(currentLat)) *
          cos(toRadians(dutyLat)) *
          pow(sin(dLng / 2), 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Distance in meters
  distance = (earthRadius * c).toInt();

  printInDebug('Distance from post = $distance meter');
  return distance;
}

const Color redColor1 = Color.fromRGBO(235, 74, 77, 1);
const Color redColor2 = Color.fromRGBO(255, 0, 4, 1);
const Color redColor3 = Color.fromRGBO(195, 50, 53, 1);

const Color pinkColor = Color.fromRGBO(255, 235, 235, 1);

const Color yellowColor = Color.fromRGBO(252, 250, 195, 1);
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



Future<bool> isGPSAndAppLocationEnabled() async {
  // Check if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return false;

  // Check app permission
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return false;
  }

  if (permission == LocationPermission.deniedForever) return false;

  return true; // GPS enabled and permission granted
}

void openMySISAppSettings() {
  if (Platform.isAndroid) {
    // Opens the app-specific settings page on Android
    const platform = MethodChannel('app_settings_channel');
    try {
      platform.invokeMethod('openAppSettings');
    } catch (e) {
      print("Error opening Android app settings: $e");
      // Fallback: open general settings
      // AppSettings.openMyDTSSAppSettings();
    }
  }
  else if (Platform.isIOS) {

    // Opens the app-specific settings page on iOS
    const platform = MethodChannel('app_settings_channel');
    try {
      platform.invokeMethod('openSettings');
    } catch (e) {
      print("Error opening iOS settings: $e");
    }
  }
}


Future<bool> isWifiOrMobileDataConnected() async {
  List<ConnectivityResult> connectivityResults = await Connectivity().checkConnectivity();
  printInDebug("Connectivity Results: $connectivityResults");
  return (connectivityResults.contains(ConnectivityResult.mobile) || connectivityResults.contains(ConnectivityResult.wifi));
}
// void openMobileDataSettings() {
//   if (Theme.of(context).platform == TargetPlatform.android) {
//     final intent = AndroidIntent(
//       action: 'android.settings.DATA_ROAMING_SETTINGS',
//       flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
//     );
//     intent.launch();
//   } else {
//     openMobileDataSettingsiOS();
//   }
// }
void openMobileDataSettingsiOS() {
  const platform = MethodChannel('app_settings_channel');
  platform.invokeMethod('openSettings');
}

/// Returns location permission as a readable string
Future<String> getLocationPermissionStatus() async {
  // Check current permission
  LocationPermission permission = await Geolocator.checkPermission();

  switch (permission) {
    case LocationPermission.always:
      return "Always";
    case LocationPermission.whileInUse:
      return "When In Use";
    case LocationPermission.denied:
      return "Ask"; // The user can still be prompted
    case LocationPermission.deniedForever:
      return "Never"; // User permanently denied
    default:
      return "Unknown";
  }
}

/// Returns true if precise location is enabled, false otherwise
Future<bool> isPreciseLocationEnabled() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return false;

  // Request a location with high accuracy
  LocationAccuracyStatus accuracyStatus = await Geolocator.getLocationAccuracy();

  // On Android, LocationAccuracyStatus.precise means precise location is allowed
  return accuracyStatus == LocationAccuracyStatus.precise;
}

Future<void> checkBiometricAvailability() async {
  try {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    bool isDeviceSupported = await auth.isDeviceSupported();

    printInDebug('Biometric Available: $canCheckBiometrics, Supported: $isDeviceSupported');

    if (canCheckBiometrics && isDeviceSupported) {
      authenticateWithTouchID();
    } else {

    }
  } catch (e) {
    printInDebug('Biometric check error: $e');

  }
}
Future<void> authenticateWithTouchID() async {
  try {
    bool authenticated = await auth.authenticate(
      localizedReason: "Authenticate using Touch ID",
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );

    if(authenticated) {
      ();
    }
    printInDebug('$authenticated');
  } catch (e) {
    printInDebug('auth error = $e');
  }
}
Future<Map<String,String>> getDeviceDetail() async {
  Map<String,String> deviceDetail = {};
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceDetail[keyDeviceModel] = androidInfo.model ;
    var release = androidInfo.version.release;
    var sdkInt = androidInfo.version.sdkInt;
    var manufacturer = androidInfo.manufacturer;
    deviceDetail[keyPlateformVersion] = 'Android $release (SDK $sdkInt), $manufacturer' ;
  }
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceDetail[keyDeviceModel] = iosInfo.model;
    var systemName = iosInfo.systemName;
    var version = iosInfo.systemVersion;
    var name = iosInfo.name;
    deviceDetail[keyPlateformVersion] ='$systemName $version, $name';
  }
  if (kIsWeb) {
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    deviceDetail[keyDeviceModel] = webBrowserInfo.userAgent ?? "";
    deviceDetail[keyPlateformVersion] =webBrowserInfo.appVersion ?? "";
  }

  return deviceDetail;
}

