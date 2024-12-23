
// import 'dart:html';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/HomeView/DutyAlertView.dart';
import 'package:mysis/HomeView/UserRoaster.dart';
import 'package:mysis/Profile/ProfileView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/SharedClasses/LanguageProvider.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';

import '../Profile/UserProfile.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';
import '../SharedClasses/NetworkConnectivity.dart';
import 'OthersDutyView.dart';
import 'ScanCardView.dart';

class HomeView extends StatefulWidget {
  final Function(int) onTabSelected;
  HomeView(
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
  bool isAttendanceMarked = false;
  String attendanceTime = '06:12';
  String dutyShiftName = '8 Hrs Morning';
  String siteName = 'IL & FS Environmental Infrastructure & Services Limited';
  String unitCode = 'DLE UNT 12345';
  String postName = 'Maingate SS';
  String currentDutyStartTime = '19:00:00';
  String postGeoLocation = '';
  DateTime dutyTime = DateTime.now();


  Color dutyInBgColor = redColor3;
  Color dutyInFontColor = whiteColor;
  Color dutyInShadowColor = Colors.black.withOpacity(0.2);


  Color dutyOutBgColor = isDarkMode? greyColor5:greyColor1;
  Color dutyOutFontColor = isDarkMode? greyColor7:greyColor4;
  Color dutyOutShadowColor = Colors.transparent;

  String shift = 'shift_a_txt'.tr();

  String userName = 'Rajkumar Singh';
  String degination = 'ASSISTANT ASSESSMENT MANAGER | ABC124563';
  String description = '';
  String areaOfficeName = '';

  String presentDays = "10.625";
  String leaves = '53.235';
  String extraDays = '11.245';

  DateTime _focusedDay = DateTime.now();


  Map source = {ConnectivityResult.none: false};
  NetworkConnectivity connection = NetworkConnectivity.instance;
  bool isInternet = true;

  List <UserProfile> userProfile = [];

  List <UserRoaster> userRoasters = [];


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

                   if(!isAttendanceMarked) Positioned(
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
                    if(isAttendanceMarked) Positioned(
                      top: MediaQuery.of(context).padding.top+pathS/1.2,
                      left: paddingLeft,
                      child: Container(
                        width: logicalWidth,
                        height: pathS/1.2,
                        color: isDarkMode ?  greenColor5:greenColor1,
                        child: Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 0,left: pathS/5,right: pathS/5), // Adjust the padding values as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    attendanceTime,
                                    style: TextStyle(
                                      color: isDarkMode ? whiteColor:greenColor6,
                                      fontSize: pathS / 3,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.left,


                                  ),
                                  Text(
                                    'hours'.tr() +"     "+ 'minutes'.tr(),
                                    style: TextStyle(
                                      color: isDarkMode ? whiteColor:greyColor4,
                                      fontSize: pathS / 6,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.left,


                                  ),
                                ],
                              ),


                              SizedBox(width: pathS/5),
                              Container(
                                width: 1.85*pathL,
                                child: Text(
                                  'attendance_marked'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ? whiteColor:greenColor6,
                                    fontSize: pathS / 5.5,
                                    fontWeight: FontWeight.w500,
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
                          height: pathS/5,

                        ),
                        Container(
                          height: screenHeight- 4.2*pathS/1.2-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
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
                                SizedBox(height: pathS/5),

                                //current day duty ui
                                Container(
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
                                                      color: isDarkMode ?  greenColor5:greenColor1,
                                                    ),
                                                    child:Padding(
                                                      padding: EdgeInsets.only(left: pathS/5, top: pathS/10,right: pathS/5,bottom: pathS/10), // Adjust top and left as needed
                                                      child: Text(
                                                        'current_duty_txt'.tr(),
                                                        style: TextStyle(
                                                          color: isDarkMode ?  greyColor7:greenColor6,
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
                                                      color: isDarkMode ?  greenColor5:greenColor1,
                                                    ),
                                                    child:Padding(
                                                      padding: EdgeInsets.only(left: pathS/5, top: pathS/10,right: pathS/8,bottom: pathS/10), // Adjust top and left as needed
                                                      child: Text(
                                                        dutyShiftName,
                                                        style: TextStyle(
                                                          color: isDarkMode ?  greyColor7:greenColor6,
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
                                                    formatInHrs(currentDutyStartTime,"h:mm"),
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
                                                    formatInHrs(currentDutyStartTime,"a").toUpperCase(),

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
                                                onTap: (){

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ScanCardView(),
                                                    ),
                                                  );

                                                },
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
                                                    'duty_in'.tr(),
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
                                                onTap: (){


                                                },
                                                child: Container(
                                                  width: pathL,
                                                  height: pathS / 1.5,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: isDarkMode? greyColor5:greyColor1,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
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
                                                    'duty_out'.tr(),
                                                    style: TextStyle(
                                                      color: isDarkMode? greyColor7:greyColor4,
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
                                SizedBox(height: pathS/5),
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
                                                      color: isDarkMode ?  yellowColor2:yellowColor1,
                                                    ),
                                                    child:Padding(
                                                      padding: EdgeInsets.only(left: pathS/5, top: pathS/10,right: pathS/5,bottom: pathS/10), // Adjust top and left as needed
                                                      child: Text(
                                                        'next_duty'.tr(),
                                                        style: TextStyle(
                                                          color: isDarkMode ? greyColor7:brownColor,
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
                                                      color: isDarkMode ?  yellowColor2:yellowColor1,
                                                    ),
                                                    child:Padding(
                                                      padding: EdgeInsets.only(left: pathS/5, top: pathS/10,right: pathS/8,bottom: pathS/10), // Adjust top and left as needed
                                                      child: Text(
                                                        shift,
                                                        style: TextStyle(
                                                          color: isDarkMode ? greyColor7:brownColor,
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
                                                    color: isDarkMode ?  greyColor1:greyColor4,
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
                                                  color: isDarkMode ?  whiteColor:greyColor7,
                                                  fontSize: pathS / 5.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                postName,
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
                                                    DateFormat('hh:mm',selectedLocale).format(dutyTime),
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
                                                    DateFormat('a',selectedLocale).format(dutyTime),
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

                                ),//next duty
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
                                                    degination,
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
                                      builder: (context) => OthersDutyView(),
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


  void initialSetup() {

    onLoadProfileData();
    getProfileTableData();

    onLoadRoasterData();
    getRoasterTableData();

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

    userProfiles.forEach((profile) {
      printInDebug('profile ID: ${profile.id}');
      printInDebug('profile emp name: ${profile.empName}');
    });

    showDataOnUI(userProfiles.first);

  }
  void showDataOnUI(UserProfile userProfile){

    setState(() {


      imagePath = userProfile.profileImageUrl;

      userName = userProfile.empName;
      degination = userProfile.serviceName;


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

        List <UserProfile> userProfile = [];

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
    final userRoasters = await DatabaseHelper.instance.getAllRecords<UserRoaster>(
      keyTableUserRoster,
          (map) => UserRoaster.fromMap(map),
    );

    userRoasters.forEach((profile) {
      printInDebug('profile ID: ${profile.id}');
      printInDebug('profile emp name: ${profile.siteName}');
    });


    updateCurrentDayUI(userRoasters);

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
        roasters.forEach((profile) {
          printInDebug('profile ID: ${profile.id}');
          printInDebug('profile emp name: ${profile.siteName}');
        });




        userRoasters = roasters;

        syncUserRoasterData(userRoasters);

      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

    }
    );

  }
  Future<void> syncUserRoasterData(   List <UserRoaster> userRoaster) async {
    await DatabaseHelper.instance.replaceTableData<UserRoaster>(keyTableUserRoster, userRoasters, (userRoasters) =>
        userRoasters.toMap());
  }

  void updateCurrentDayUI(List<UserRoaster> userRoasters) {
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Filter roster data for today
    List<UserRoaster> todaysRoster = userRoasters
        .where((roster) => roster.rosterDate == todayDate)
        .toList();


    if (todaysRoster.isNotEmpty) {
       UserRoaster roaster = todaysRoster.first;
      setState(() {

         dutyShiftName = roaster.shiftName;
         siteName = roaster.siteName;
         unitCode = roaster.unitCode;
         postName = roaster.postName;
         currentDutyStartTime = roaster.startTime;

         postGeoLocation = roaster.geoLocation;
      });

    }
  }


}