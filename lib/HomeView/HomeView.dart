
// import 'dart:html';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysis/HomeView/DutyAlertView.dart';
import 'package:mysis/HomeView/ScanUnitShiftView.dart';
import 'package:mysis/HomeView/UserAttendance.dart';
import 'package:mysis/HomeView/UserRoaster.dart';
import 'package:mysis/Profile/ProfileView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/SharedClasses/LanguageProvider.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:mysis/UserAuthViews/LoginView.dart';
import 'package:provider/provider.dart';

import '../Profile/UnitDutyPost.dart';
import '../Profile/UnitShiftDetail.dart';
import '../Profile/UserPosting.dart';
import '../Profile/UserProfile.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';
import '../SharedClasses/NetworkConnectivity.dart';
import 'OthersDutyView.dart';

class HomeView extends StatefulWidget {
  final Function(int) onTabSelected;
  const HomeView(
      {
    super.key,
    // required this.username,
    required this.onTabSelected
  });

  @override
  HomeViewState createState() => HomeViewState();
}


class HomeViewState extends State<HomeView> {

  bool showLoaderView = false;
  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String exclamationImage = isDarkMode ? "assets/images/dashboard-icons/exclamation-icon.png" : "assets/images/dashboard-icons/exclamation-red.png";
  String imagePath = '';
  bool todayDutyInMarked = false;
  bool todayDutyOutMarked = false;

  String dutyInHourBannner = '';
  String dutyInBtnText = 'duty_in'.tr();
  String dutyOutBtnText = 'duty_out'.tr();

  String dutyShiftName = '';
  String siteName = '';
  String unitCode = '';
  String postName = '';
  String currentDutyStartTime = '';
  String postGeoLocation = '';
  List<UserRoaster> todaysRoster = [];
  List<UserRoaster> monthlyRosters = [];

  List<UserAttendance> todayAttendance = [];

  DateTime dutyTime = DateTime.now();

  Color dutyInBgColor = redColor3;
  Color dutyInFontColor = whiteColor;
  Color dutyInShadowColor = Colors.black.withOpacity(0.2);
  bool isDutyInTapEnabled = true;

  Color dutyOutBgColor = isDarkMode? greyColor5:greyColor1;
  Color dutyOutFontColor = isDarkMode? greyColor7:greyColor4;
  Color dutyOutShadowColor = Colors.transparent;
  bool isDutyOutTapEnabled = false;

  String shift = 'shift_a_txt'.tr();

  String userName = '';
  String designation = '';
  String description = '';
  String areaOfficeName = '';

  String presentDays = "";
  String leaves = '';
  String extraDays = '';

  DateTime _focusedDay = DateTime.now();


  Map source = {ConnectivityResult.none: false};
  NetworkConnectivity connection = NetworkConnectivity.instance;
  bool isInternet = true;

  List <UserProfile> userProfile = [];

  List <UserRoaster> userRoasters = [];

  List <UserAttendance> userAttendance = [];

  List<UserPosting> userPostings = [];
  List<UnitDutyPost> unitDutyPosts = [];
  List<UnitShiftDetail> unitShiftDetails = [];

  Timer? dutyOutTimer;
  Timer? dutyInTimer;


  @override
  Widget build(BuildContext context) {
    calculateSizes(context);

    return Consumer2<LanguageProvider, ThemeProvider>(
      builder: (context, languageProvider, themeProvider, child) {
        return MaterialApp(
          // theme: themeProvider.themeData,
          home: Scaffold(
            body: Container(
                width: logicalWidth,
                height: logicalHeight,
                decoration: BoxDecoration(
                  gradient: isDarkMode ? backgroundGradientDark : backgroundGradient,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).padding.top,
                      child: Container(
                        width: logicalWidth,
                        height: pathS/1.2,
                        color: isDarkMode?whiteColor:Colors.transparent, // Set white background color here
                        child: Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 0,left: pathS/5,right: pathS/5), // Adjust the padding values as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: pathL,
                                height: pathS / 1.5,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/icons/logo.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: pathS / 1.45,
                                height: pathS / 1.5,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/icons/icon.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),//header logo

                   if(!todayDutyInMarked ) Positioned(
                      top: MediaQuery.of(context).padding.top+pathS/1.2,
                      left: paddingLeft,
                      child: Container(
                        width: logicalWidth,
                        height: pathS/1.2,
                        color: isDarkMode ?  redColor3:pinkColor,
                        child: Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 0,left: pathS/5,right: pathS/5), // Adjust the padding values as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                height: pathS / 1.55,
                                width: pathS / 1.55,
                                imageUrl: imagePath,
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundImage: AssetImage(assetsImagePath),
                                  backgroundColor: Colors.white,
                                ),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  backgroundImage: AssetImage(assetsImagePath),
                                  backgroundColor: Colors.white,
                                ),
                                imageBuilder: (context, imageProvider) => CircleAvatar(
                                  backgroundImage: imageProvider,
                                  backgroundColor: Colors.white,
                                ),
                              ),

                              SizedBox(width: pathS/5),
                              Container(
                                width: pathS / 3,
                                height: pathS / 3.1,
                                decoration:  BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: AssetImage(isDarkMode ? "assets/images/dashboard-icons/exclamation-icon.png" : "assets/images/dashboard-icons/exclamation-red.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: pathS/5),
                              Container(
                                width: 1.7*pathL,

                                child: Text(
                                  'attendance_not_marked'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ? whiteColor:redColor2,
                                    fontSize: pathS / 5.5,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.left,


                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),//Attendance not marked
                    if(todayDutyInMarked ) Positioned(
                      top: MediaQuery.of(context).padding.top+pathS/1.2,
                      left: paddingLeft,
                      child: Container(
                        width: logicalWidth,
                        height: pathS/1.2,
                        color: isDarkMode ?  greenColor2:greenColor1,
                        child: Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 0,left: pathS/3,right: pathS/5), // Adjust the padding values as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Padding(
                                padding: EdgeInsets.only(top: pathS/10), // Adjust the padding values as needed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dutyInHourBannner,
                                      style: TextStyle(
                                        color: isDarkMode ? greenColor6:greenColor6,
                                        fontSize: pathS / 3.8,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(width: pathS/20),
                                        Text(
                                          'HR',
                                          style: TextStyle(
                                            color: isDarkMode ? greyColor6:greyColor6,
                                            fontSize: pathS / 7,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(width: pathS/5),
                                        Text(
                                           'MIN',
                                          style: TextStyle(
                                            color: isDarkMode ? greyColor6:greyColor6,
                                            fontSize: pathS / 7,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: pathS/5),
                              SizedBox(
                                child: Text(
                                  'attendance_marked'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ? greenColor6:greenColor6,
                                    fontSize: pathS / 5.5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.left,


                                ),
                              ),



                            ],
                          ),
                        ),
                      ),
                    ),//Attendance marked

                    Padding(
                      padding: EdgeInsets.only(left: 0, top: MediaQuery.of(context).padding.top +pathS/1.2+pathS/1.2), // Adjust top and left as needed

                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screenWidth,
                          height: 1,

                        ),
                        SizedBox(
                          height: screenHeight- 4*pathS/1.2 -marginValue,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Visibility(
                                  visible: !isInternet,
                                  child: Container(
                                    width: screenWidth-2.5*marginValue,
                                    // height: pathL*2.3,
                                    decoration:  BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(pathS/8),
                                      color: isDarkMode?greyColor8:Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: shadowColor, // Shadow color
                                          blurRadius: pathS/10, // Spread of the shadow
                                          // spreadRadius: pathS/15, // How far the shadow extends
                                          offset:  Offset(-pathS/12, pathS/12),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      // alignment: Alignment.topLeft,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: pathS/3, top: pathS/3,bottom: pathS/3,right:pathS/3), // Adjust top and left as needed
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: isDarkMode ? whiteColor:greyColor1,
                                                    // boxShadow: [
                                                    //   BoxShadow(
                                                    //     color: shadowColor, // Shadow color
                                                    //     blurRadius: pathS/10, // Spread of the shadow
                                                    //     // spreadRadius: pathS/15, // How far the shadow extends
                                                    //     offset:  Offset(-pathS/20, pathS/20),
                                                    //   ),
                                                    // ],

                                                  ),
                                                  child: Padding(
                                                    padding:  EdgeInsets.all(pathS/6),
                                                    child: Icon(
                                                      Icons.wifi_off,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: pathS/5),
                                                // Text(
                                                //   ''.tr(),
                                                //   style: TextStyle(
                                                //     color: isDarkMode ?  whiteColor:greyColor6,
                                                //     fontSize: pathS / 4.5,
                                                //     fontWeight: FontWeight.w700,
                                                //     fontFamily: 'Roboto',
                                                //   ),
                                                //   textAlign: TextAlign.center,
                                                // ),
                                                // SizedBox(height: pathS/10),
                                                Text(
                                                  'no_internet'.tr(),
                                                  style: TextStyle(
                                                    color: isDarkMode ?  whiteColor:greyColor6,
                                                    fontSize: pathS / 5.5,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),


                                      ],
                                    ),

                                  ),
                                ),//internet
                                // SizedBox(height: pathS/5),

                                //current day duty ui
                                if(todaysRoster.isNotEmpty)Container(
                                  width: screenWidth-2.5*marginValue,
                                  height: pathL*2.8,
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(pathS/8),
                                    color: isDarkMode?greyColor8:Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1), // Shadow color
                                        blurRadius: pathS/10, // Spread of the shadow
                                        // spreadRadius: pathS/15, // How far the shadow extends
                                        offset:  Offset(-pathS/12, pathS/12),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: pathS/4, top: pathS/4), // Adjust top and left as needed
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.circular(pathS / 15),
                                                      color: isDarkMode ?  greenColor1:greenColor1,
                                                    ),
                                                    child:Padding(
                                                      padding: EdgeInsets.only(left: pathS/5, top: pathS/10,right: pathS/5,bottom: pathS/10), // Adjust top and left as needed
                                                      child: Text(
                                                        'current_duty_txt'.tr(),
                                                        style: TextStyle(
                                                          color: isDarkMode ?  greenColor6:greenColor6,
                                                          fontSize: pathS / 5.5,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(pathS / 15), // Adjust as needed
                                                        bottomLeft: Radius.circular(pathS / 15), // Adjust as needed
                                                      ),
                                                      color: isDarkMode ?  greenColor1:greenColor1,
                                                    ),
                                                    child:Padding(
                                                      padding: EdgeInsets.only(left: pathS/5, top: pathS/10,right: pathS/8,bottom: pathS/10), // Adjust top and left as needed
                                                      child: Text(
                                                        dutyShiftName,
                                                        style: TextStyle(
                                                          color: isDarkMode ?  greenColor6:greenColor6,
                                                          fontSize: pathS / 5.5,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: pathS / 5),
                                              Padding(
                                                padding: EdgeInsets.only(right: pathS/5), // Adjust top and left as needed
                                                child: Text(
                                                  siteName,
                                                  style: TextStyle(
                                                    color: isDarkMode ?  greyColor1:greyColor5,
                                                    fontSize: pathS / 5.5,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),

                                              Text(
                                                unitCode,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor6,
                                                  fontSize: pathS / 5.5,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                postName,
                                                style: TextStyle(
                                                  color: isDarkMode ?  greyColor1:greyColor5,
                                                  fontSize: pathS / 5.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(height: pathS/5),

                                              SizedBox(
                                                width: screenWidth-2.5*marginValue,
                                                child: Text(
                                                  getDateTime('EEEE d MMM'),
                                                  style: TextStyle(
                                                    color: isDarkMode ?  greyColor1:greyColor4,
                                                    fontSize: pathS / 5.5,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    getFormattedTime(currentDutyStartTime,"h:mm"),
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteColor:greyColor7,
                                                      fontSize: pathS / 1.6,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(width: pathS/8),
                                                  Text(
                                                    getFormattedTime(currentDutyStartTime,"a").toUpperCase(),

                                                    style: TextStyle(
                                                      color: isDarkMode ?  greyColor1:greyColor4,
                                                      fontSize: pathS / 5.5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: pathS/2),

                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: isDutyInTapEnabled
                                                    ? () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ScanUnitShiftView(
                                                          userProfile: userProfile.first,
                                                          attendanceMode: keyAttendanceModeSelf,
                                                        unitDutyPosts: unitDutyPosts,
                                                        unitShiftDetails: unitShiftDetails,
                                                        userPostings: userPostings,
                                                        attendanceStatus: keyAttendanceStatusDutyIn,

                                                      ),
                                                    ),
                                                  );
                                                }
                                                    : null,
                                                // Disable tap if isTapEnabled is false
                                                child: Container(
                                                  width: pathL,
                                                  height: pathS / 1.5,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: dutyInBgColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                                                    borderRadius: BorderRadius.circular(pathS/3),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: dutyInShadowColor, // Shadow color
                                                        blurRadius: pathS/10, // Spread of the shadow
                                                        // spreadRadius: pathS/15, // How far the shadow extends
                                                        offset:  Offset(-pathS/12, pathS/12),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                  dutyInBtnText,
                                                    style: TextStyle(
                                                      color: dutyInFontColor,
                                                      fontSize: pathS / 4.5,
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: pathS/5),
                                              GestureDetector(
                                                  onTap: isDutyOutTapEnabled ?  () {
                                                      Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ScanUnitShiftView(
                                                              userProfile: userProfile.first,
                                                              attendanceMode: keyAttendanceModeSelf,
                                                            unitDutyPosts: unitDutyPosts,
                                                            unitShiftDetails: unitShiftDetails,
                                                            userPostings: userPostings,
                                                            attendanceStatus: keyAttendanceStatusDutyOut,
                                                          ),
                                                           ),
                                                         );
                                                      }
                                                          : null,
                                                child: Container(
                                                  width: pathL,
                                                  height: pathS / 1.5,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: dutyOutBgColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                                                    borderRadius: BorderRadius.circular(pathS/3),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: dutyOutShadowColor, // Shadow color
                                                        blurRadius: pathS/10, // Spread of the shadow
                                                        // spreadRadius: pathS/15, // How far the shadow extends
                                                        offset:  Offset(-pathS/12, pathS/12),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    dutyOutBtnText,
                                                    style: TextStyle(
                                                      color: dutyOutFontColor,
                                                      fontSize: pathS / 4.5,
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(height: pathS/5),
                                          Container(
                                            width: screenWidth,
                                            height:  pathS/80,
                                            color: isDarkMode? greyColorDark:greyColor2,
                                          ),
                                          SizedBox(height: pathS/5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              GestureDetector(
                                                onTap: (){
                                                  List<String> activeDayList = postGeoLocation.split(',').map((e) => e.trim()).toList();

                                                  double lat = double.parse(activeDayList[1]); // Latitude
                                                  double lng = double.parse(activeDayList[0]); // Longitude

                                                  launchGoogleMap(lat, lng);

                                                },
                                                child: Container(

                                                  child:Padding(
                                                    padding: EdgeInsets.only(left: pathS/10,right: pathS/8,top: pathS/20,bottom: pathS/4), // Adjust top and left as needed
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: pathS/3,
                                                          width: pathS/4,
                                                          decoration: BoxDecoration(
                                                            // shape: BoxShape.circle,
                                                            image: DecorationImage(
                                                              image: AssetImage("assets/images/dashboard-icons/location-on.png"),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: pathS/6),

                                                        Text(
                                                          'location_on_map'.tr(),
                                                          style: TextStyle(
                                                            color: isDarkMode ?  redColor1:redColor3,
                                                            fontSize: pathS / 4.5,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: 'Roboto',

                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),

                                ),//duty in out
                                if(todaysRoster.isNotEmpty)SizedBox(height: pathS/5),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: monthlyRosters.map((monthlyRoaster) {
                                    return  Column(
                                      children: [
                                        Container(
                                          width: screenWidth-2.5*marginValue,
                                          // height: pathL*2,
                                          decoration:  BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(pathS/8),
                                            color: isDarkMode?greyColor8:Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1), // Shadow color
                                                blurRadius: pathS/10, // Spread of the shadow
                                                // spreadRadius: pathS/15, // How far the shadow extends
                                                offset:  Offset(-pathS/12, pathS/12),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            alignment: Alignment.topLeft,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: pathS/4, top: pathS/4), // Adjust top and left as needed
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.rectangle,
                                                              borderRadius: BorderRadius.circular(pathS / 15),
                                                              color: isDarkMode ?  yellowColor1:yellowColor1,
                                                            ),
                                                            child:Padding(
                                                              padding: EdgeInsets.only(left: pathS/5, top: pathS/10,right: pathS/5,bottom: pathS/10), // Adjust top and left as needed
                                                              child: Text(
                                                                'next_duty'.tr(),
                                                                style: TextStyle(
                                                                  color: isDarkMode ? brownColor:brownColor,
                                                                  fontSize: pathS / 5.5,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: 'Roboto',
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.rectangle,
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(pathS / 15), // Adjust as needed
                                                                bottomLeft: Radius.circular(pathS / 15), // Adjust as needed
                                                              ),
                                                              color: isDarkMode ?  yellowColor1:yellowColor1,
                                                            ),
                                                            child:Padding(
                                                              padding: EdgeInsets.only(left: pathS/5, top: pathS/10,right: pathS/8,bottom: pathS/10), // Adjust top and left as needed
                                                              child: Text(
                                                                monthlyRoaster.shiftName,
                                                                style: TextStyle(
                                                                  color: isDarkMode ? brownColor:brownColor,
                                                                  fontSize: pathS / 5.5,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: 'Roboto',
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: pathS / 5),
                                                      Padding(
                                                        padding: EdgeInsets.only(right: pathS/5), // Adjust top and left as needed
                                                        child: Text(
                                                          style: TextStyle(
                                                            color: isDarkMode ?  greyColor1:greyColor4,
                                                            fontSize: pathS / 5.5,
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: 'Roboto',
                                                          ),
                                                          monthlyRoaster.siteName,
                                                          textAlign: TextAlign.start,
                                                        ),
                                                      ),

                                                      Text(
                                                        monthlyRoaster.unitCode,
                                                        style: TextStyle(
                                                          color: isDarkMode ?  whiteColor:greyColor7,
                                                          fontSize: pathS / 5.5,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      Text(
                                                      '${monthlyRoaster.postName} -${monthlyRoaster.qrId.substring(monthlyRoaster.qrId.length - 4)}',
                                                        style: TextStyle(
                                                          color: isDarkMode ?  greyColor1:greyColor4,
                                                          fontSize: pathS / 5.5,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      SizedBox(height: pathS/5),

                                                      Container(
                                                        width: screenWidth-2.5*marginValue,
                                                        child: Text(
                                                          getFormattedDateTime(monthlyRoaster.rosterDate,"yyyy-MM-dd","EEEE d MMM"),

                                                          style: TextStyle(
                                                            color: isDarkMode ?  greyColor1:greyColor4,
                                                            fontSize: pathS / 5.5,
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: 'Roboto',
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),

                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            getFormattedTime(monthlyRoaster.startTime,"h:mm"),
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor6,
                                                              fontSize: pathS / 1.5,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          SizedBox(width: pathS/8),
                                                          Text(
                                                            getFormattedTime(monthlyRoaster.startTime,"a").toUpperCase(),

                                                            style: TextStyle(
                                                              color: isDarkMode ?  greyColor1:greyColor4,
                                                              fontSize: pathS / 5.5,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: pathS/5),

                                                    ],
                                                  ),
                                                ),
                                              ),


                                            ],
                                          ),

                                        ),
                                        SizedBox(height: pathS/8),
                                      ],
                                    );
                                  }).toList(),
                                ),//next duties
                                SizedBox(height: pathS/5),
                                Container(
                                  width: screenWidth-2.5*marginValue,
                                  // height: pathL*2.3,
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(pathS/8),
                                    color: isDarkMode?greyColor8:Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1), // Shadow color
                                        blurRadius: pathS/10, // Spread of the shadow
                                        // spreadRadius: pathS/15, // How far the shadow extends
                                        offset:  Offset(-pathS/12, pathS/12),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    // alignment: Alignment.topLeft,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: pathS/4, top: pathS/3,bottom: pathS/3), // Adjust top and left as needed
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap:(){
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ProfileView(),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(

                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: whiteColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: shadowColor, // Shadow color
                                                            blurRadius: pathS/10, // Spread of the shadow
                                                            // spreadRadius: pathS/15, // How far the shadow extends
                                                            offset:  Offset(-pathS/20, pathS/20),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: CachedNetworkImage(
                                                          height: pathS *1.2,
                                                          width: pathS *1.2,
                                                          imageUrl: imagePath,
                                                          placeholder: (context, url) => CircleAvatar(
                                                            backgroundImage: AssetImage(assetsImagePath),
                                                            backgroundColor: Colors.white,
                                                          ),
                                                          errorWidget: (context, url, error) => CircleAvatar(
                                                            backgroundImage: AssetImage(assetsImagePath),
                                                            backgroundColor: Colors.white,
                                                          ),
                                                          imageBuilder: (context, imageProvider) => CircleAvatar(
                                                            backgroundImage: imageProvider,
                                                            backgroundColor: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: pathS/5),
                                                  Text(
                                                    userName,
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteColor:greyColor6,
                                                      fontSize: pathS / 4.5,
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: pathS/10),
                                                  Text(
                                                    designation,
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteColor:greyColor6,
                                                      fontSize: pathS / 6.5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: pathS/3),
                                                  Text(
                                                    description,
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteColor:greyColor6,
                                                      fontSize: pathS / 4.5,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [

                                              Container(
                                                width: screenWidth,
                                                height: 1,
                                                color: isDarkMode? greyColorDark:greyColor2,
                                              ),//line
                                              SizedBox(height: pathS/5),
                                              Padding(
                                                padding: EdgeInsets.only(left: pathS/4,right: pathS/12,top: pathS/20,bottom: pathS/4), // Adjust top and left as needed

                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [

                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,

                                                      children: [
                                                        Text(
                                                          'your_area_officer'.tr(),
                                                          style: TextStyle(
                                                            color: isDarkMode ?  greyColor1:greyColor4,
                                                            fontSize: pathS /5.5,
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: 'Roboto',
                                                          ),
                                                          textAlign: TextAlign.start,
                                                        ),
                                                        Container(
                                                          width: pathL*1.1,
                                                          child: Text(
                                                            areaOfficeName,
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor6,
                                                              fontSize: pathS / 5,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(width: pathS/5),
                                                    Spacer(),
                                                    Container(

                                                      child:Padding(
                                                        padding: EdgeInsets.only(left: pathS/10,right: pathS/8,bottom: pathS/6), // Adjust top and left as needed
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: (){

                                                              },
                                                              child: Container(
                                                                height: pathS/2,
                                                                width: pathS/2,
                                                                decoration: BoxDecoration(
                                                                  // shape: BoxShape.circle,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: shadowColor, // Shadow color
                                                                      blurRadius: pathS/10, // Spread of the shadow
                                                                      // spreadRadius: pathS/15, // How far the shadow extends
                                                                      offset:  Offset(-pathS/12, pathS/12),
                                                                    ),
                                                                  ],
                                                                  image: DecorationImage(
                                                                    image: AssetImage("assets/images/dashboard-icons/mail.png"),
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            SizedBox(width: pathS/6),
                                                            GestureDetector(
                                                              onTap: (){

                                                              },
                                                              child: Container(
                                                                height: pathS/2,
                                                                width: pathS/2,
                                                                decoration: BoxDecoration(
                                                                  // shape: BoxShape.circle,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors.black.withOpacity(0.1), // Shadow color
                                                                      blurRadius: pathS/10, // Spread of the shadow
                                                                      // spreadRadius: pathS/15, // How far the shadow extends
                                                                      offset:  Offset(-pathS/12, pathS/12),
                                                                    ),
                                                                  ],
                                                                  image: DecorationImage(
                                                                    image: AssetImage("assets/images/dashboard-icons/call.png"),
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: pathS/6),
                                                            GestureDetector(
                                                              onTap: (){

                                                              },
                                                              child: Container(
                                                                height: pathS/2,

                                                                width: pathS/2,
                                                                decoration: BoxDecoration(
                                                                  // shape: BoxShape.circle,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors.black.withOpacity(0.1), // Shadow color
                                                                      blurRadius: pathS/10, // Spread of the shadow
                                                                      // spreadRadius: pathS/15, // How far the shadow extends
                                                                      offset:  Offset(-pathS/12, pathS/12),
                                                                    ),
                                                                  ],
                                                                  image: DecorationImage(
                                                                    image: AssetImage("assets/images/dashboard-icons/whatsApp.png"),
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),



                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              )


                                            ],
                                          ),
                                        ],
                                      ),


                                    ],
                                  ),

                                ),//profile summary
                                SizedBox(height: pathS/5),
                                Container(
                                  width: screenWidth-2.5*marginValue,
                                  // height: pathL*1.8,
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(pathS/8),
                                    color: isDarkMode?greyColor8:Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1), // Shadow color
                                        blurRadius: pathS/10, // Spread of the shadow
                                        // spreadRadius: pathS/15, // How far the shadow extends
                                        offset:  Offset(-pathS/12, pathS/12),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only( top: pathS/3,bottom: pathS/3), // Adjust top and left as needed
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [


                                              Text(
                                                'your_calender'.tr(),
                                                style: TextStyle(
                                                  color: isDarkMode ?  greyColor1:greyColor4,
                                                  fontSize: pathS / 5.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: pathS/10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState(() {
                                                        _focusedDay = DateTime(
                                                          _focusedDay.year,
                                                          _focusedDay.month - 1,
                                                        );
                                                      });
                                                    },
                                                    child:  Container(
                                                      width: pathS/5,
                                                      height: pathS/5,
                                                      child: Image.asset(
                                                        'assets/images/dashboard-icons/left-arrow.png',
                                                        color: isDarkMode ? whiteColor:greyColor6,

                                                      ),
                                                    ),

                                                  ),
                                                  SizedBox(width: pathS/10),
                                                  Text(
                                                    DateFormat.yMMMM(selectedLocale).format(_focusedDay),
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteColor:greyColor6,
                                                      fontSize: pathS / 4.5,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(width: pathS/10),

                                                  GestureDetector(
                                                    onTap: (){
                                                      setState(() {
                                                        _focusedDay = DateTime(
                                                          _focusedDay.year,
                                                          _focusedDay.month + 1,
                                                        );
                                                      });
                                                    },
                                                    child:  Container(
                                                      width: pathS/5,
                                                      height: pathS/5,
                                                      child: Image.asset(
                                                        'assets/images/dashboard-icons/right-arrow.png',
                                                        color: isDarkMode ? whiteColor:greyColor6,

                                                      ),
                                                    ),

                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: pathS/2.5),

                                              Padding(
                                                padding:  EdgeInsets.only(left: pathS/4,right: pathS/4),

                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: pathS*1.5,
                                                      child: Text(
                                                        presentDays,
                                                        style: TextStyle(
                                                          color: isDarkMode ?  greenColor3:greenColor6,
                                                          fontSize: pathS / 3,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: pathS*1.1,
                                                      child: Text(
                                                        leaves,
                                                        style: TextStyle(
                                                          color: isDarkMode ?  redColor2:redColor2,
                                                          fontSize: pathS / 3,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: pathS*1.1,
                                                      child: Text(
                                                        extraDays,
                                                        style: TextStyle(
                                                          color: isDarkMode ? whiteColor : greyColor6,
                                                          fontSize: pathS / 3,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: pathS/8),

                                              Padding(
                                                padding:  EdgeInsets.only(left: pathS/4,right: pathS/4),

                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: pathS*1.5,
                                                      child: Text(
                                                        'present'.tr() + '    '+ 'ApprovalPending'.tr(),
                                                        style: TextStyle(
                                                          color: isDarkMode ?  greyColor1:greyColor4,
                                                          fontSize: pathS / 6,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: pathS*1.1,

                                                      child: Text(
                                                        'leave'.tr(),
                                                        style: TextStyle(
                                                          color: isDarkMode ?  greyColor1:greyColor4,
                                                          fontSize: pathS / 6,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: pathS,
                                                      child: Text(
                                                        'extra_duty'.tr(),
                                                        style: TextStyle(
                                                          color: isDarkMode ?  greyColor1:greyColor4,
                                                          fontSize: pathS / 6,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: pathS/2.5),

                                              GestureDetector(
                                                onTap: (){
                                                  widget.onTabSelected(1);
                                                },
                                                child: Container(
                                                  width: pathS*3,
                                                  child: Text(
                                                    'view_details_tv'.tr(),
                                                    style: TextStyle(
                                                      color: isDarkMode ? redColor1 : redColor3,
                                                      fontSize: pathS / 4,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),


                                    ],
                                  ),

                                ),//calendar summary
                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          bottom: MediaQuery.of(context).padding.bottom,
                          left: paddingLeft,
                          child: Container(
                            width: logicalWidth,
                            height: pathS/1.1,
                            decoration: BoxDecoration(
                              color: isDarkMode?greyColor8:greyColor,

                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor, // Shadow color
                                  blurRadius: pathS/15, // Spread of the shadow
                                  // spreadRadius: pathS/15, // How far the shadow extends
                                  offset:  Offset(-pathS/12, -pathS/15),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 0, bottom: 0,left: pathS/5,right: pathS/5), // Adjust the padding values as needed
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                    MaterialPageRoute(
                                      builder: (context) => OthersDutyView(
                                          userProfile: userProfile.first,
                                          attendanceMode: keyAttendanceModeOther,
                                        unitDutyPosts: unitDutyPosts,
                                        unitShiftDetails: unitShiftDetails,
                                        userPostings: userPostings,

                                      ),
                                      ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    Spacer(),

                                    Text(
                                      'other_duty_txt'.tr(),
                                      style: TextStyle(
                                        color: isDarkMode ? redColor1:redColor3,
                                        fontSize: pathS / 4.5,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.left,


                                    ),
                                    SizedBox(width: pathS/8),
                                    Container(
                                      width: pathS/5,
                                      height: pathS/5,
                                      child: Image.asset(
                                        'assets/images/dashboard-icons/right-arrow.png',
                                        color: isDarkMode ? whiteColor:greyColor6,

                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: pathS/1.1, // Adjust to overlap
                          bottom:MediaQuery.of(context).padding.bottom+pathS/10,
                          child: Image.asset(
                            'assets/images/dashboard-icons/profile1.png',
                            width: pathS/1.5, // Adjust as needed
                            height: pathS/1.5,// Adjust as needed
                          ),
                        ),
                        Positioned(
                          left: pathS/1.8, // Adjust to overlap
                          bottom: MediaQuery.of(context).padding.bottom+pathS/10,
                          child: Image.asset(
                            'assets/images/dashboard-icons/profile2.png',
                            width: pathS/1.5, // Adjust as needed
                            height: pathS/1.5, // Adjust as needed
                          ),
                        ),
                        Positioned(
                          left: pathS/5,
                          bottom: MediaQuery.of(context).padding.bottom+pathS/10,
                          child: Image.asset(
                            'assets/images/dashboard-icons/profile.png',
                            width: pathS/1.5, // Adjust as needed
                            height: pathS/1.5,// Adjust as needed
                          ),
                        ),
                      ],
                    ),

                    // Visibility(
                    //   visible: true,
                    //   child: DutyAlertView(),
                    // ),

                    LoaderView(isVisible: showLoaderView, message: 'Loading...'),

                  ],
                )
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // Future.delayed(Duration(milliseconds: 3), () {
    //   onLoadDutyAlert();
    // });

    initialSetup();
    connection.myStream.listen((_source) {
      source = _source;
      onConnectionChange();
    });
  }


  void initialSetup() {

    // onLoadRoasterData();
    getRoasterTableData();

    // onLoadAttendanceData();
    getAttendanceTableData();

    // onLoadProfileData();
    getProfileTableData();

    getPostingTableData();

  }

    void onConnectionChange(){

      bool isConnected = true;

      switch (source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          isConnected = true;
          break;
        case ConnectivityResult.wifi:
          isConnected = true;
          break;
        case ConnectivityResult.none:
        default:
          isConnected = false;
      }

      printInDebug('connection status = ${source.keys.toList()[0]}');


      if(isInternet != isConnected){
        setState(() {
          isInternet = isConnected;
        });
      }


    }
    void onLoadDutyAlert(){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DutyAlertView(dutyTime: DateTime.now(),shift: shift,place: unitCode,location: postName),
        ),
      );
    }

  Future<void> getProfileTableData() async {
    final userProfiles = await DatabaseHelper.instance.getAllRecords<UserProfile>(
      keyTableUserProfile,
          (map) => UserProfile.fromMap(map),
    );

    for (var data in userProfiles) {
      printInDebug('userProfiles Data');
      data.toMap().forEach((i, j) {
        printInDebug('$i : $j');
      });

    }

   if( userProfiles.isNotEmpty){
     userProfile = userProfiles;
     showDataOnUI(userProfiles.first);
   }else{
     onLoadProfileData();
   }


  }
  void showDataOnUI(UserProfile userProfile){

    setState(() {


      imagePath = userProfile.profileImageUrl;

      userName = userProfile.empName;
      designation = userProfile.serviceName;


      final joiningDate = userProfile.joiningDate; // Assuming this is a DateTime object
      final currentDate = DateTime.now();

// Calculate the difference in years
      final yearsWithSIS = currentDate.year - joiningDate.year;

// Adjust for incomplete years
      final isBeforeAnniversary = (currentDate.month < joiningDate.month) ||
          (currentDate.month == joiningDate.month && currentDate.day < joiningDate.day);

      final actualYearsWithSIS = isBeforeAnniversary ? yearsWithSIS - 1 : yearsWithSIS;

// Assign description
      description = '$actualYearsWithSIS ${'sis_years'.tr()} ${'with_sis'.tr()}';

      areaOfficeName = userProfile.empName;

    });
  }
  void onLoadProfileData() {


    // setState(() {
    //   showLoaderView = true;
    // });
    Map <String,String> inputData = {

    };

    APIHelper.instance.getData(profileApi,inputData, (data) {

      // setState(() {
      //   showLoaderView = false;
      // });
      if(data.isNotEmpty){


        print(data);
        List<UserProfile> userProfiles = data.map((json) => UserProfile.fromJson(json)).toList();
        userProfiles.forEach((profile) {
          printInDebug('profile ID: ${profile.id}');
          printInDebug('profile emp name: ${profile.empName}');
        });

        showDataOnUI(userProfiles.first);

        // List <UserProfile> userProfile = [];

        userProfile = userProfiles;

        syncUserProfileData(userProfile);

      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

    }
    );

  }
  Future<void> syncUserProfileData(   List <UserProfile> userProfile) async {
    await DatabaseHelper.instance.replaceTableData<UserProfile>(keyTableUserProfile, userProfile, (userProfile) =>
        userProfile.toMap());
  }

  Future<void> getRoasterTableData() async {
    final roasterData = await DatabaseHelper.instance.getAllRecords<UserRoaster>(
      keyTableUserRoster,
          (map) => UserRoaster.fromMap(map),
    );



    for (var data in roasterData) {
        printInDebug('Roaster Data');
        data.toMap().forEach((i, j) {
          printInDebug('$i : $j');
        });

    }


    if(roasterData.isNotEmpty){
      userRoasters = roasterData;
      updateCurrentDayUI(roasterData);
      updateNextDaysUI(roasterData);

    }else{
      // onLoadRoasterData();
    }
    onLoadRoasterData();
  }
  void onLoadRoasterData() {


    // setState(() {
    //   showLoaderView = true;
    // });
    Map <String,String> inputData = {

    };

    APIHelper.instance.getData(userRosterApi,inputData, (data) {

      // setState(() {
      //   showLoaderView = false;
      // });
      if(data.isNotEmpty){

        List<UserRoaster> roasters = data.map((json) => UserRoaster.fromJson(json)).toList();


        for (var data in roasters) {
          printInDebug('Roaster Data');
          data.toMap().forEach((i, j) {
            printInDebug('$i : $j');
          });

        }

        userRoasters = roasters;

        syncUserRoasterData(userRoasters);
        updateCurrentDayUI(userRoasters);
        updateNextDaysUI(userRoasters);

      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

      String errorCode = error['code'] ?? '';
      // if(errorCode == '401'){
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => LoginView(),
      //     ),
      //   );
      // }
    }
    );

  }
  Future<void> syncUserRoasterData(   List <UserRoaster> userRoaster) async {

    await DatabaseHelper.instance.updateOrDeleteTableData<UserRoaster>(
        keyTableUserRoster,
        userRoaster,
        'id',
        (userRoaster) => userRoaster.toMap()
    );
  }
  void updateCurrentDayUI(List<UserRoaster> roasters) {
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Filter roster data for today
    todaysRoster = roasters
        .where((roster) => roster.rosterDate == todayDate && roster.deleted == 0
    )
        .toList();


    if (todaysRoster.isNotEmpty) {
       UserRoaster roaster = todaysRoster.first;
      setState(() {

         dutyShiftName = roaster.shiftName;
         siteName = roaster.siteName;
         unitCode = roaster.unitCode;
         postName = '${roaster.postName} -${roaster.qrId.substring(roaster.qrId.length - 4)}';
         currentDutyStartTime = roaster.startTime;

         postGeoLocation = roaster.geoLocation;
      });

       startDutyInCheck(roaster);
       startDutyOutCheck(roaster);
    }
  }
  void updateNextDaysUI(List<UserRoaster> roasters) {
    DateTime todayDate = DateTime.now();

    // Filter roster data for dates greater than today
    monthlyRosters = roasters
        .where((roster) {
      // Parse rosterDate into DateTime for comparison
      DateTime rosterDate = DateTime.parse(roster.rosterDate);
      return rosterDate.isAfter(todayDate) && roster.deleted == 0;
    })
        .toList();

    // Sort the filtered rosters in ascending order by rosterDate
    monthlyRosters.sort((a, b) {
      DateTime dateA = DateTime.parse(a.rosterDate);
      DateTime dateB = DateTime.parse(b.rosterDate);
      return dateA.compareTo(dateB); // Ascending order
    });

    print("Monthly Rosters greater than today (sorted):");
    for (var roster in monthlyRosters) {
      print(roster.rosterDate);
    }
  }


  Future<void> getPostingTableData() async {

    userPostings = await DatabaseHelper.instance.getAllRecords<UserPosting>(
      keyTableUserPosting,
          (map) => UserPosting.fromMap(map),
    );

    for (var data in userPostings) {
      printInDebug('userPostings Data');
      data.toMap().forEach((i, j) {
        printInDebug('$i : $j');
      });

    }

    unitDutyPosts = await DatabaseHelper.instance.getAllRecords<UnitDutyPost>(
      keyTableUnitDutyPost,
          (map) => UnitDutyPost.fromMap(map),
    );

    unitShiftDetails = await DatabaseHelper.instance.getAllRecords<UnitShiftDetail>(
      keyTableUnitShiftDetail,
          (map) => UnitShiftDetail.fromMap(map),
    );

    if(userPostings.isNotEmpty && unitDutyPosts.isNotEmpty && unitShiftDetails.isNotEmpty) {
      print('All duty related data fetched');
    }else{
      onLoadUserPostingData();
    }


  }
  void onLoadUserPostingData() {
    // setState(() {
    //   showLoaderView = true;
    // });

    Map <String, String> inputData = {
    };

    APIHelper.instance.getUserData(userPostingApi, inputData, (data) {

      // setState(() {
      //   showLoaderView = false;
      // });

      if (data.isNotEmpty) {
        if (data.containsKey('UserPosting')) {
          final List<dynamic> dataList = data['UserPosting'];
          setState(() {
            userPostings = dataList.map((json) => UserPosting.fromJson(json)).toList();
          });
          userPostings.forEach((profile) {
            printInDebug('userPosting ID: ${profile.id}');
            printInDebug('userPosting  name: ${profile.siteName}');
          });

          syncUserPostingData();

        }
        if (data.containsKey('UnitDutyPost')) {
          final List<dynamic> dataList = data['UnitDutyPost'];
          unitDutyPosts = dataList.map((json) => UnitDutyPost.fromJson(json)).toList();
          unitDutyPosts.forEach((profile) {
            printInDebug('UnitDutyPost ID: ${profile.id}');
            printInDebug('UnitDutyPost  name: ${profile.postName}');
          });

          syncUnitDutyPostData();
        }
        if (data.containsKey('UnitShiftDetail')) {
          final List<dynamic> dataList = data['UnitShiftDetail'];
          unitShiftDetails = dataList.map((json) => UnitShiftDetail.fromJson(json)).toList();
          unitShiftDetails.forEach((profile) {
            printInDebug('UnitShiftDetail ID: ${profile.id}');
            printInDebug('UnitShiftDetail  name: ${profile.shiftName}');
          });

          syncUnitShiftDetailData();


        }

      }
    }, (error) {
      // setState(() {
      //   showLoaderView = false;
      // });
      setState(() {
        // isAlertVisible = true;
        // alertMessage = '$error';
      });
    });
  }
  Future<void> syncUnitShiftDetailData() async {
    await DatabaseHelper.instance.replaceTableData<UnitShiftDetail>(keyTableUnitShiftDetail, unitShiftDetails, (unitShiftDetail) =>
        unitShiftDetail.toMap());

  }
  Future<void> syncUnitDutyPostData() async {
    await DatabaseHelper.instance.replaceTableData<UnitDutyPost>(keyTableUnitDutyPost, unitDutyPosts, (unitDutyPosts) =>
        unitDutyPosts.toMap());

  }
  Future<void> syncUserPostingData() async {
    await DatabaseHelper.instance.replaceTableData<UserPosting>(
        keyTableUserPosting,
        userPostings,
        (userPosting) => userPosting.toMap());

  }


  Future<void> getAttendanceTableData() async {
    final userAttendances = await DatabaseHelper.instance.getAllRecords<UserAttendance>(
      keyTableUserAttendance,
          (map) => UserAttendance.fromMap(map),
    );

    for (var data in userAttendances) {
        printInDebug('Attendance Data');
        data.toMap().forEach((i, j) {
          printInDebug('$i : $j');
        });

    }

    if(userAttendances.isNotEmpty) {
      userAttendance = userAttendances;
      updateDutyInOutAttendance(userAttendances);
    }
    else{
      // onLoadAttendanceData();
    }

    // onLoadAttendanceData();

  }
  void onLoadAttendanceData() {


    // setState(() {
    //   showLoaderView = true;
    // });
    Map <String,String> inputData = {

    };

    APIHelper.instance.getData(userAttendanceApi,inputData, (data) {

      // setState(() {
      //   showLoaderView = false;
      // });

      if(data.isNotEmpty){

        List<UserAttendance> dataList = data.map((json) => UserAttendance.fromJson(json)).toList();
        for (var data in dataList) {
          printInDebug(' ID: ${data.id}');
          printInDebug(' name: ${data.siteName}');
        }

        userAttendance = dataList;
        updateDutyInOutAttendance(userAttendance);
        syncUserAttendanceData(userAttendance);

      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

    }
    );

  }
  Future<void> syncUserAttendanceData(   List <UserAttendance> userAttendance) async {
    await DatabaseHelper.instance.updateOrDeleteTableData<UserAttendance>(
        keyTableUserAttendance,
        userAttendance,
        'id',
        (userAttendance) => userAttendance.toMap()
    );
  }

  void updateDutyInOutAttendance(List<UserAttendance> attendance) {
    DateTime todayDate = DateTime.now();
    DateTime startOfDay = DateTime(todayDate.year, todayDate.month, todayDate.day);

    // Filter today's attendance records
    // List<UserAttendance> todayAttendance = attendance
    //     .where((data) =>
    // data.shiftStartDate.isAtSameMomentAs(startOfDay) ||
    //     data.shiftStartDate.isAfter(startOfDay)
    // )
    //     .toList();

    List<UserAttendance> todayAttendance = [];

    if (attendance.any((data) => data.dutyStatus == keyAttendanceStatusDutyIn && data.deleted == 0)) {
      // Get all records for the date of the latest 'DUTY_IN' where deleted == 0
      DateTime latestDutyInDate = attendance
          .where((data) => data.dutyStatus == keyAttendanceStatusDutyIn && data.deleted == 0)
          .map((data) => data.shiftStartDate)
          .reduce((a, b) => a.isAfter(b) ? a : b); // Find the latest date
      todayAttendance = attendance
          .where((data) =>
      data.shiftStartDate.isAtSameMomentAs(latestDutyInDate) &&
          data.deleted == 0)
          .toList();
    } else if (attendance.any((data) => data.dutyStatus == keyAttendanceStatusDutyOut && data.deleted == 0)) {
      // Get all records for the current date where deleted == 0
      todayAttendance = attendance
          .where((data) =>
      (data.shiftStartDate.isAtSameMomentAs(startOfDay) ||
          data.shiftStartDate.isAfter(startOfDay)) &&
          data.deleted == 0)
          .toList();
    }

    if (todayAttendance.isNotEmpty) {
      todayDutyInMarked = true;

      // Accumulate total duration for all marked attendances
      Duration totalDutyDuration = Duration.zero;

      for (final userAttendance in todayAttendance) {
        DateTime endTime = userAttendance.actEndTime ?? DateTime.now();
        totalDutyDuration += endTime.difference(userAttendance.actStartTime);
      }

      setState(() {
        // Convert the total accumulated duration into hours and minutes
        final totalMinutes = totalDutyDuration.inMinutes;
        final adjustedHour = (totalMinutes ~/ 60) % 24; // Hours (mod 24 to prevent overflow)
        final adjustedMinute = totalMinutes % 60; // Minutes

        // Format the result as HH:mm
        final dutyDuration =
            '${adjustedHour.toString().padLeft(2, '0')}: ${adjustedMinute.toString().padLeft(2, '0')}';
        dutyInHourBannner = dutyDuration;

        // Update dutyIn button text
        dutyInBtnText = todayAttendance.isNotEmpty
            ? "${'duty_in'.tr()} ${DateFormat('h:mm').format(todayAttendance.first.actStartTime)} ${DateFormat('a').format(todayAttendance.first.actStartTime).toUpperCase()}"
            : 'duty_in'.tr();
      });

      disableDutyIn();
      stopDutyInCheck();
      enableDutyOut();
    }

    if (todayAttendance.isNotEmpty && todayAttendance.first.actEndTime != null) {
      todayDutyOutMarked = true;
      dutyOutBtnText =
      "${'duty_out'.tr()} ${DateFormat('h:mm').format(todayAttendance.first.actEndTime!)} ${DateFormat('a').format(todayAttendance.first.actEndTime!).toUpperCase()}";
      disableDutyOut();
      stopDutyOutCheck();
    }
  }

  void startDutyInCheck(UserRoaster roaster) {
    // Cancel any existing timer
    dutyInTimer?.cancel();

    // Start a single periodic timer to check duty conditions
    dutyInTimer = Timer.periodic(Duration(seconds: 60), (Timer timer) {
      updateDutyInRoaster(roaster);
    });
  }
  void updateDutyInRoaster(UserRoaster roaster){

    if(!todayDutyInMarked) {
      Timer.periodic(Duration(seconds: 60), (Timer timer) {
        if (DateTime.now().isAfter(roaster.dutyStartEnableTime) && DateTime.now().isBefore(roaster.dutyStartDisableTime) && !todayDutyInMarked) {
          enableDutyIn();
        } else {
          disableDutyIn();
        }
      });
    } else {
      disableDutyIn();
      dutyInTimer?.cancel(); // Cancel the timer if conditions are not met
    }

}
  void stopDutyInCheck() {
    // Cancel the timer when no longer needed
    dutyInTimer?.cancel();
  }

  void startDutyOutCheck(UserRoaster roaster) {
    // Cancel any existing timer
    dutyOutTimer?.cancel();

    // Start a single periodic timer to check duty conditions
    dutyOutTimer = Timer.periodic(Duration(seconds: 60), (Timer timer) {
      updateDutyOutRoaster(roaster);
    });
  }
  void updateDutyOutRoaster(UserRoaster roaster) {
    if (todayDutyInMarked && !todayDutyOutMarked) {
      if (DateTime.now().isAfter(roaster.dutyStartEnableTime) &&
          DateTime.now().isBefore(roaster.dutyEndDisableTime) && todayDutyInMarked && !todayDutyOutMarked) {
        enableDutyOut();
      }
      else {
        disableDutyOut();
      }
    } else {
      disableDutyOut();
      dutyOutTimer?.cancel(); // Cancel the timer if conditions are not met
    }
  }
  void stopDutyOutCheck() {
    // Cancel the timer when no longer needed
    dutyOutTimer?.cancel();
  }

  void enableDutyIn(){
    setState(() {
      dutyInBgColor =  redColor3;
      dutyInFontColor =  whiteColor;
      dutyInShadowColor =  Colors.black.withOpacity(0.2);
      isDutyInTapEnabled =  true;
    });


  }
  void disableDutyIn(){

    setState(() {
      dutyInBgColor =  isDarkMode? greyColor5:greyColor1;
      dutyInFontColor =    isDarkMode? greyColor7:greyColor4 ;
      dutyInShadowColor =   Colors.transparent ;
      isDutyInTapEnabled =  false ;
    });

  }
  void enableDutyOut(){
    setState(() {
      dutyOutBgColor =   redColor3 ;
      dutyOutFontColor =  whiteColor ;
      dutyOutShadowColor =   Colors.black.withOpacity(0.2);
      isDutyOutTapEnabled =  true ;
    });


  }
  void disableDutyOut(){
    setState(() {
      dutyOutBgColor =  isDarkMode? greyColor5:greyColor1;
      dutyOutFontColor =  isDarkMode? greyColor7:greyColor4;
      dutyOutShadowColor =   Colors.transparent;
      isDutyOutTapEnabled =  false;
    });

  }

}