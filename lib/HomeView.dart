
// import 'dart:html';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/SharedClasses/APIHelper.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/MyTabBarView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/UserAuthViews/LoginViewError.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/ThemeProvider.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  HomeView(
      {
    super.key,
    // required this.username,
    // required this.onTabSelected
  });

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {

  bool showLoaderView = false;
  String assetsImagePath = "assets/images/Dashboard-icons/profile-icon.png";
  String exclamationImage = isDarkMode ? "assets/images/Dashboard-icons/exclamation-icon.png" : "assets/images/Dashboard-icons/exclamation-red.png";
  String imagePath = '';
  bool isAttendanceMarked = true;
String attendanceTime = '06:12';
  String dutyInTime = '8 Hrs Morning';
String companyName = 'IL & FS Environmental Infrastructure & Services Limited';
String unit = 'DLE UNT 12345';
String department = 'Maingate SS';
  String dutyTime = '10:00';
  String dutyTimeAM_PM = 'AM';

  Color dutyInBgColor = redBgcolor;
  Color dutyInFontColor = whiteFontColor;
  Color dutyInShadowColor = Colors.black.withOpacity(0.2);


  Color dutyOutBgColor = isDarkMode? greyBgcolor:whiteBGColor;
  Color dutyOutFontColor = isDarkMode? darkGreyFontColor:lightGreyFontColor;
  Color dutyOutShadowColor = Colors.transparent;

  String shift = 'shift_a_txt'.tr();

  String userName = 'Rajkumar Singh';
  String degination = 'ASSISTANT ASSESSMENT MANAGER | ABC124563';
  String description = '10 Years with SIS';
  String areaOfficeName = 'Samant Kumar Jaiswal';

  String presentDays = "10.625";
  String leaves = '3';
  String extraDays = '11';


  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: themeProvider.themeData,
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
                      top: paddingTop,
                      child: Container(
                        width: logicalWidth,
                        height: pathS/1.2,
                        color: isDarkMode?whiteFontColor:Colors.transparent, // Set white background color here
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
                                    image: AssetImage("assets/images/icons/logo@3x.png"),
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
                                    image: AssetImage("assets/images/icons/icon@3x.png"),
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
                      top: paddingTop+pathS/1.2,
                      left: paddingLeft,
                      child: Container(
                        width: logicalWidth,
                        height: pathS/1.2,
                        color: isDarkMode ?  redBgcolor:pinkBgcolor,
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
                                    image: AssetImage(isDarkMode ? "assets/images/Dashboard-icons/exclamation-icon.png" : "assets/images/Dashboard-icons/exclamation-red.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: pathS/5),
                              Text(
                                'attendance_not_marked'.tr(),
                                style: TextStyle(
                                  color: isDarkMode ? whiteFontColor:redFontcolor,
                                  fontSize: pathS / 5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.left,


                              ),

                            ],
                          ),
                        ),
                      ),
                    ),//Attendance not marked
                    if(isAttendanceMarked) Positioned(
                      top: paddingTop+pathS/1.2,
                      left: paddingLeft,
                      child: Container(
                        width: logicalWidth,
                        height: pathS/1.2,
                        color: isDarkMode ?  darkGreenBGColor:greenBgColor,
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
                                      color: isDarkMode ? whiteFontColor:darkGreenFontColor,
                                      fontSize: pathS / 3,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.left,


                                  ),
                                  Text(
                                    'hours'.tr() +"     "+ 'minutes'.tr(),
                                    style: TextStyle(
                                      color: isDarkMode ? whiteFontColor:lightGreyFontColor,
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
                                    color: isDarkMode ? whiteFontColor:darkGreenFontColor,
                                    fontSize: pathS / 5,
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
                    ),//Attendance marked

                    Padding(
                      padding: EdgeInsets.only(left: 0, top: paddingTop +pathS/1.2+pathS/1.2), // Adjust top and left as needed

                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screenWidth,
                          height: pathS/5,

                        ),
                        Container(
                          height: screenHeight- 4.1*pathS/1.2-paddingTop-paddingBottom,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [

                                Container(
                                  width: screenWidth-2.5*marginValue,
                                  height: pathL*2.8,
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(pathS/8),
                                    color: isDarkMode?darkTileBgcolor:Colors.white,
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
                                                      color: isDarkMode ?  darkGreenBGColor:greenBgColor,
                                                    ),
                                                    child:Padding(
                                                      padding: EdgeInsets.only(left: pathS/5, top: pathS/5,right: pathS/5,bottom: pathS/30), // Adjust top and left as needed
                                                      child: Text(
                                                        'current_duty_txt'.tr(),
                                                        style: TextStyle(
                                                          color: isDarkMode ?  darkGreyFontColor:darkGreenFontColor,
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
                                                      color: isDarkMode ?  darkGreenBGColor:greenBgColor,
                                                    ),
                                                    child:Padding(
                                                      padding: EdgeInsets.only(left: pathS/5, top: pathS/5,right: pathS/8,bottom: pathS/30), // Adjust top and left as needed
                                                      child: Text(
                                                        dutyInTime,
                                                        style: TextStyle(
                                                          color: isDarkMode ?  darkGreyFontColor:darkGreenFontColor,
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
                                                  companyName,
                                                  style: TextStyle(
                                                    color: isDarkMode ?  whiteFontColor:darkGreyFontColor,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),

                                              Text(
                                                unit,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteFontColor:darkGreyFontColor,
                                                  fontSize: pathS / 5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                department,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteFontColor:darkGreyFontColor,
                                                  fontSize: pathS / 5,
                                                  fontWeight: FontWeight.normal,
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
                                                    color: isDarkMode ?  whiteFontColor:darkGreyFontColor,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    dutyTime,
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteFontColor:darkGreyFontColor,
                                                      fontSize: pathS / 1.5,
                                                      fontWeight: FontWeight.normal,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(width: pathS/15),
                                                  Text(
                                                    dutyTimeAM_PM,
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteFontColor:darkGreyFontColor,
                                                      fontSize: pathS / 5,
                                                      fontWeight: FontWeight.normal,
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
                                                      fontWeight: FontWeight.bold,
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
                                                    'duty_out'.tr(),
                                                    style: TextStyle(
                                                      color: dutyOutFontColor,
                                                      fontSize: pathS / 4.5,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(height: pathS/5),
                                          Container(
                                            width: screenWidth,
                                            height: 0.5,
                                            color: isDarkMode? whiteBGColor:lightGreyFontColor,
                                          ),
                                          SizedBox(height: pathS/5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              GestureDetector(
                                                onTap: (){

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
                                                              image: AssetImage("assets/images/Dashboard-icons/location-on.png"),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: pathS/6),

                                                        Text(
                                                          'location_on_map'.tr(),
                                                          style: TextStyle(
                                                            color: isDarkMode ?  redFontcolor:redFontcolor,
                                                            fontSize: pathS / 3.8,
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
                                  height: pathL*2,
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(pathS/8),
                                    color: isDarkMode?darkTileBgcolor:Colors.white,
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
                                                      color: isDarkMode ?  darkYellowBgcolor:yellowBgcolor,
                                                    ),
                                                    child:Padding(
                                                      padding: EdgeInsets.only(left: pathS/5, top: pathS/5,right: pathS/5,bottom: pathS/10), // Adjust top and left as needed
                                                      child: Text(
                                                        'next_duty'.tr(),
                                                        style: TextStyle(
                                                          color: isDarkMode ? darkGreyFontColor:yellowFontcolor,
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
                                                      color: isDarkMode ?  darkYellowBgcolor:yellowBgcolor,
                                                    ),
                                                    child:Padding(
                                                      padding: EdgeInsets.only(left: pathS/5, top: pathS/5,right: pathS/8,bottom: pathS/30), // Adjust top and left as needed
                                                      child: Text(
                                                        shift,
                                                        style: TextStyle(
                                                          color: isDarkMode ? darkGreyFontColor:yellowFontcolor,
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
                                                  companyName,
                                                  style: TextStyle(
                                                    color: isDarkMode ?  whiteFontColor:darkGreyFontColor,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),

                                              Text(
                                                unit,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteFontColor:darkGreyFontColor,
                                                  fontSize: pathS / 5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                department,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteFontColor:darkGreyFontColor,
                                                  fontSize: pathS / 5,
                                                  fontWeight: FontWeight.normal,
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
                                                    color: isDarkMode ?  whiteFontColor:darkGreyFontColor,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    dutyTime,
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteFontColor:darkGreyFontColor,
                                                      fontSize: pathS / 1.5,
                                                      fontWeight: FontWeight.normal,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    dutyTimeAM_PM,
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteFontColor:darkGreyFontColor,
                                                      fontSize: pathS / 5,
                                                      fontWeight: FontWeight.normal,
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
                                  height: pathL*2.3,
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(pathS/8),
                                    color: isDarkMode?darkTileBgcolor:Colors.white,
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
                                          alignment: Alignment.center,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CachedNetworkImage(
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
                                              SizedBox(height: pathS/5),
                                              Text(
                                                userName,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteFontColor:greyFontColor,
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
                                                  color: isDarkMode ?  whiteFontColor:greyFontColor,
                                                  fontSize: pathS / 7,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: pathS/3),
                                              Text(
                                                description,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteFontColor:greyFontColor,
                                                  fontSize: pathS / 4,
                                                  fontWeight: FontWeight.w800,
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
                                            height: 0.5,
                                            color: isDarkMode? whiteBGColor:lightGreyFontColor,
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
                                                        color: isDarkMode ?  whiteFontColor:darkGreyFontColor,
                                                        fontSize: pathS /5,
                                                        fontWeight: FontWeight.normal,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      textAlign: TextAlign.start,
                                                    ),
                                                    Container(
                                                      width: pathL*1.1,
                                                      child: Text(
                                                        areaOfficeName,
                                                        style: TextStyle(
                                                          color: isDarkMode ?  whiteFontColor:greyFontColor,
                                                          fontSize: pathS / 4.5,
                                                          fontWeight: FontWeight.w700,
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
                                                                  color: Colors.black.withOpacity(0.1), // Shadow color
                                                                  blurRadius: pathS/10, // Spread of the shadow
                                                                  // spreadRadius: pathS/15, // How far the shadow extends
                                                                  offset:  Offset(-pathS/12, pathS/12),
                                                                ),
                                                              ],
                                                              image: DecorationImage(
                                                                image: AssetImage("assets/images/Dashboard-icons/mail.png"),
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
                                                                image: AssetImage("assets/images/Dashboard-icons/call.png"),
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
                                                                image: AssetImage("assets/images/Dashboard-icons/call.png"),
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

                                ),//profile summary
                                SizedBox(height: pathS/5),
                                Container(
                                  width: screenWidth-2.5*marginValue,
                                  height: pathL*1.8,
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(pathS/8),
                                    color: isDarkMode?darkTileBgcolor:Colors.white,
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
                                        padding: EdgeInsets.only(left: pathS/6, top: pathS/3), // Adjust top and left as needed
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [


                                              Text(
                                                'your_calender'.tr(),
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteFontColor:greyFontColor,
                                                  fontSize: pathS / 5,
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

                                                    },
                                                    child:  Container(
                                                      width: pathS/5,
                                                      height: pathS/5,
                                                      child: Image.asset(
                                                        'assets/images/Dashboard-icons/left-arrow.png',
                                                        color: isDarkMode ? whiteFontColor:greyFontColor,

                                                      ),
                                                    ),

                                                  ),
                                                  SizedBox(width: pathS/10),
                                                  Text(
                                                    getDateTime('MMM yyyy'),
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteFontColor:greyFontColor,
                                                      fontSize: pathS / 4.5,
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(width: pathS/10),

                                                  GestureDetector(
                                                    onTap: (){

                                                    },
                                                    child:  Container(
                                                      width: pathS/5,
                                                      height: pathS/5,
                                                      child: Image.asset(
                                                        'assets/images/Dashboard-icons/right-arrow.png',
                                                        color: isDarkMode ? whiteFontColor:greyFontColor,

                                                      ),
                                                    ),

                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: pathS/2.5),

                                              Row(
                                                children: [
                                                  Container(
                                                    width: pathS*1.5,
                                                    child: Text(
                                                      presentDays,
                                                      style: TextStyle(
                                                        color: isDarkMode ?  flurocentFontColor:darkGreenFontColor,
                                                        fontSize: pathS / 4,
                                                        fontWeight: FontWeight.w800,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: pathS*1.5,
                                                    child: Text(
                                                      leaves,
                                                      style: TextStyle(
                                                        color: isDarkMode ?  brightRedFontcolor:brightRedFontcolor,
                                                        fontSize: pathS / 4,
                                                        fontWeight: FontWeight.w800,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: pathS*1.5,
                                                    child: Text(
                                                      extraDays,
                                                      style: TextStyle(
                                                        color: isDarkMode ? whiteFontColor : greyFontColor,
                                                        fontSize: pathS / 4,
                                                        fontWeight: FontWeight.w800,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: pathS/8),

                                              Row(
                                                children: [
                                                  Container(
                                                    width: pathS*1.5,
                                                    child: Text(
                                                      'present'.tr() + '    '+ 'ApprovalPending'.tr(),
                                                      style: TextStyle(
                                                        color: isDarkMode ?  whiteFontColor:greyFontColor,
                                                        fontSize: pathS / 6,
                                                        fontWeight: FontWeight.normal,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: pathS*1.5,
                                                    child: Text(
                                                      'leave'.tr(),
                                                      style: TextStyle(
                                                        color: isDarkMode ?  whiteFontColor:greyFontColor,
                                                        fontSize: pathS / 6,
                                                        fontWeight: FontWeight.normal,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: pathS*1.5,
                                                    child: Text(
                                                      'extra_duty'.tr(),
                                                      style: TextStyle(
                                                        color: isDarkMode ?  whiteFontColor:greyFontColor,
                                                        fontSize: pathS / 6,
                                                        fontWeight: FontWeight.normal,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: pathS/2.5),

                                              Container(
                                                width: pathS*3,
                                                child: Text(
                                                  'view_details_tv'.tr(),
                                                  style: TextStyle(
                                                    color: isDarkMode ? redBgcolor : redFontcolor,
                                                    fontSize: pathS / 4,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.center,
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

                    Positioned(
                      bottom: paddingBottom,
                      left: paddingLeft,
                      child: Container(
                        width: logicalWidth,
                        height: pathS/1.2,
                        color: isDarkMode?darkTileBgcolor:Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 0,left: pathS/5,right: pathS/5), // Adjust the padding values as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [


                              Spacer(),

                              Text(
                                'other_duty_txt'.tr(),
                                style: TextStyle(
                                  color: isDarkMode ? redBgcolor:redBgcolor,
                                  fontSize: pathS / 5,
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
                                  'assets/images/Dashboard-icons/right-arrow.png',
                                  color: isDarkMode ? whiteFontColor:greyFontColor,

                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      left: pathS/1.1, // Adjust to overlap
                      bottom: paddingBottom+pathS/10,
                      child: Image.asset(
                        'assets/images/Dashboard-icons/profile1.png',
                        width: pathS/1.5, // Adjust as needed
                        height: pathS/1.5,// Adjust as needed
                      ),
                    ),
                    Positioned(
                      left: pathS/1.8, // Adjust to overlap
                      bottom: paddingBottom+pathS/10,
                      child: Image.asset(
                        'assets/images/Dashboard-icons/profile2.png',
                        width: pathS/1.5, // Adjust as needed
                        height: pathS/1.5, // Adjust as needed
                      ),
                    ),
                    Positioned(
                      left: pathS/5,
                      bottom: paddingBottom+pathS/10,
                      child: Image.asset(
                        'assets/images/Dashboard-icons/profile.png',
                        width: pathS/1.5, // Adjust as needed
                        height: pathS/1.5,// Adjust as needed
                      ),
                    ),

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
  }




}