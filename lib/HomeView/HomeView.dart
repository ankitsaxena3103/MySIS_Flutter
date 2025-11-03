
import 'dart:async';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysis/HomeView/ScanUnitShiftView.dart';
import 'package:mysis/HomeView/UserAttendance.dart';
import 'package:mysis/HomeView/UserRoaster.dart';
import 'package:mysis/Leaves/UserLeaves.dart';
import 'package:mysis/Profile/ProfileView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/SharedClasses/LanguageProvider.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../CommonViews/AlertPopupView.dart';
import '../Notifications/UserNotification.dart';
import '../Profile/UnitDutyPost.dart';
import '../Profile/UnitShiftDetail.dart';
import '../Profile/UserPosting.dart';
import '../Profile/UserProfile.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';
import '../SharedClasses/NetworkConnectivity.dart';
import 'Model/DutyCard.dart';
import 'OthersDutyView.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'route_observer.dart'; // <- import the file

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

class HomeViewState extends State<HomeView>with RouteAware {

  List<GlobalKey> notificationPageKeys = [];

  bool showLoaderView = false;
  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String exclamationImage = isDarkMode ? "assets/images/dashboard-icons/exclamation-icon.png" : "assets/images/dashboard-icons/exclamation-red.png";
  String imagePath = '';
  bool todayDutyInMarked = true;
  // bool todayDutyOutMarked = false;

  String dutyInHourBanner = '';
  String dutyInBtnText = 'duty_in'.tr();
  String dutyOutBtnText = 'duty_out'.tr();

  // String dutyShiftName = '';
  // String siteName = '';
  // String unitCode = '';
  // String postName = '';
  // String currentDutyStartTime = '';
  // String postGeoLocation = '';

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
  String areaOfficerName = '';
  String areaOfficeContact = '';

  String approvalPendingCount = "0";
  String leaveCount = '0';
  String approvalDoneCount = '0';

  DateTime dutyTime = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Map source = {ConnectivityResult.none: false};
  NetworkConnectivity connection = NetworkConnectivity.instance;
  bool isInternet = true;

  bool showAlert = false;
  String alertHeader = '';
  String alertMessage = '';
  String cancelBtnTitle = '';
  String okBtnTitle = 'ok'.tr();


  List<UserRoaster> todayRoster = [];
  List<UserRoaster> monthlyRosters = [];
  List<UserAttendance> todayUserAttendance = [];
  List<UnitDutyPost> todayUnitDutyPost = [];

  List <UserProfile> userProfile = [];
  List <UserRoaster> userRoasters = [];
  List <UserAttendance> userAttendance = [];

  List<UserPosting> userPostings = [];
  List<UnitDutyPost> unitDutyPosts = [];
  List<UnitShiftDetail> userShiftDetailsData = [];


  List <UserLeaves> userLeaves = [];
  List<UserNotification> userNotifications = [];

  List<UserNotification> topNotificationsPage = [];
  List<UserNotification> htmlBottomBodyNotifications = [];

  UserNotification? popUpNotificationPageData;
  List<double> topNotificationPageHeight = [pathL*2.2];
  late PageController _pageController;
  int pageIndex = 0;

  Timer? dutyOutTimer;
  Timer? dutyInTimer;

  List<DutyCard> userDutyCard = [];
  late PageController cardPageController;
  int cardIndex = 0;
  int cardSelectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // Called when returning to HomeScreen from any pushed screen
    initialSetup(); // fetch latest data
  }
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _pageController.dispose();
    cardPageController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    cardPageController = PageController(initialPage: cardSelectedIndex);
    _pageController = PageController(initialPage: 0);

    super.initState();
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
                                  height: pathS / 1.6,
                                  width: pathS / 1.6,
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
                                SizedBox(
                                  width: 1.7*pathL,

                                  child: Text(
                                    'attendance_not_marked'.tr(),
                                    style: TextStyle(
                                      color: isDarkMode ? whiteColor:redColor2,
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
                                        dutyInHourBanner,
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
                              height: screenHeight - 4*pathS/1.2 ,
                              child: Padding(
                                padding:  EdgeInsets.only(top: pathS/6,bottom: pathS/4),
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
                                     if(!isInternet) SizedBox(height: pathS/5),


                                      if (userDutyCard.isNotEmpty)
                                        Column(
                                          children: [
                                            SizedBox(
                                              width: screenWidth - 3 * marginValue,
                                              height: screenWidth - 2 * marginValue,
                                              child: PageView.builder(
                                                controller: cardPageController,
                                                onPageChanged: (index) {
                                                  setState(() {
                                                    cardIndex = index; // ✅ this updates the selected dot
                                                  });
                                                },
                                                itemCount: userDutyCard.length,
                                                itemBuilder: (context, index) {
                                                  return buildDutyCard(userDutyCard[index]);
                                                },
                                              ),
                                            ),
                                            SizedBox(height: pathS/8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: List.generate(
                                                userDutyCard.length,
                                                    (index) => GestureDetector(
                                                    onTap: () => animateDutyCardPageToIndex(index),
                                                    child:buildDutyCardsDot(index)),
                                              ),
                                            ),
                                            SizedBox(height: pathS/8),
                                          ],
                                        ),

                                      if(userDutyCard.isNotEmpty)SizedBox(height: pathS/5),

                                      if (topNotificationsPage.isNotEmpty)
                                        SizedBox(
                                          width: screenWidth,
                                          height: topNotificationPageHeight[pageIndex],
                                          child: PageView.builder(
                                            controller: _pageController,
                                            onPageChanged: (index) {
                                              setState(() {
                                                pageIndex = index;
                                              });
                                            },
                                            itemCount: topNotificationsPage.length,
                                            itemBuilder: (context, index) {
                                              return topNotificationPage(index);
                                            },
                                          ),
                                        ),

                                      if(topNotificationsPage.isNotEmpty)Column(
                                        children: [
                                          SizedBox(height: pathS/8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: List.generate(
                                              topNotificationsPage.length,
                                                  (index) => GestureDetector(
                                                  onTap: () => animatePageIndex(index),
                                                  child:buildDot(index)),
                                            ),
                                          ),
                                          SizedBox(height: pathS/8),
                                        ],
                                      ),


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

                                                            SizedBox(
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
                                                  padding: EdgeInsets.only(top: pathS/3,bottom:pathS/3), // Adjust top and left as needed
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
                                                                  areaOfficerName,
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
                                                          Padding(
                                                            padding: EdgeInsets.only(left: pathS/10,right: pathS/8,bottom: pathS/6), // Adjust top and left as needed
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: (){
                                                                    sendSMS(areaOfficeContact, "");
                                                                  },
                                                                  child: Container(
                                                                    height: pathS/1.8,
                                                                    width: pathS/1.8,
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      boxShadow: [
                                                                        
                                                                        BoxShadow(
                                                                          color: Colors.black.withOpacity(0.3),  // Shadow color
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

                                                                SizedBox(width: pathS/8),
                                                                GestureDetector(
                                                                  onTap: (){
                                                                    printInDebug(areaOfficeContact);
                                                                    makePhoneCall(areaOfficeContact);

                                                                  },
                                                                  child: Container(
                                                                    height: pathS/1.8,
                                                                    width: pathS/1.8,
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.black.withOpacity(0.3), // Shadow color
                                                                          blurRadius: pathS/10, // Spread of the shadow
                                                                          // spreadRadius: pathS/15, // How far the shadow extends
                                                                          offset:  Offset(-pathS/12, pathS/12),
                                                                        ),
                                                                      ],
                                                                      image: DecorationImage(
                                                                        image: AssetImage("assets/images/dashboard-icons/call.png"),
                                                                        fit: BoxFit.cover
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(width: pathS/8),
                                                                GestureDetector(
                                                                  onTap: (){
                                                                    shareOnWhatsApp(areaOfficeContact);
                                                                  },
                                                                  child:Container(
                                                                    height: pathS / 1.8,
                                                                    width: pathS / 1.8,
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: redColor3,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.black.withOpacity(0.3), // Shadow color
                                                                          blurRadius: pathS / 10, // Spread of the shadow
                                                                          offset: Offset(-pathS / 12, pathS / 12),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child: Center( // Center the image inside the container
                                                                      child: Image.asset(
                                                                        'assets/images/home/whatsapp.png',
                                                                        width: pathS /3,  // Set width explicitly
                                                                        height: pathS /3, // Set height explicitly
                                                                        fit: BoxFit.contain, // Ensure the image fits within its box
                                                                      ),
                                                                    ),
                                                                  ),

                                                                ),

                                                              ],
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
                                                              updateCalendarData(_focusedDay);

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
                                                              updateCalendarData(_focusedDay);
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
                                                              approvalPendingCount,
                                                              style: TextStyle(
                                                                color: isDarkMode ?  greenColor3:greenColor6,
                                                                fontSize: pathS / 3,
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: 'Roboto',
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: pathS*1.1,
                                                            child: Text(
                                                              leaveCount,
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
                                                              approvalDoneCount,
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
                                                          SizedBox(
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
                                                      child: SizedBox(
                                                        width: pathS*3,
                                                        child: Text(
                                                          'view_details_tv'.tr().toUpperCase(),
                                                          style: TextStyle(
                                                            color: isDarkMode ? redColor1 : redColor3,
                                                            fontSize: pathS / 4.5,
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
                              height: pathS/1.2,
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
                                    onTapOtherDuty();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      Spacer(),

                                      Text(
                                        'other_duty_txt'.tr().toUpperCase(),
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
                              width: pathS/1.6, // Adjust as needed
                              height: pathS/1.6,// Adjust as needed
                            ),
                          ),
                          Positioned(
                            left: pathS/1.8, // Adjust to overlap
                            bottom: MediaQuery.of(context).padding.bottom+pathS/10,
                            child: Image.asset(
                              'assets/images/dashboard-icons/profile2.png',
                              width: pathS/1.6, // Adjust as needed
                              height: pathS/1.6, // Adjust as needed
                            ),
                          ),
                          Positioned(
                            left: pathS/5,
                            bottom: MediaQuery.of(context).padding.bottom+pathS/10,
                            child: Image.asset(
                              'assets/images/dashboard-icons/profile.png',
                              width: pathS/1.6, // Adjust as needed
                              height: pathS/1.6,// Adjust as needed
                            ),
                          ),
                        ],
                      ),//other duty

                      // Visibility(
                      //   visible: true,
                      //   child: DutyAlertView(),
                      // ),

                      Visibility(
                        visible: showAlert,
                        child: AlertPopupView(
                            header: alertHeader,
                            message: alertMessage,
                            cancelBtn: cancelBtnTitle,
                            okBtn: okBtnTitle,
                            callBack: (value){
                              setState(() {
                                showAlert = false;
                              });

                            }
                        ),
                      ),
                      LoaderView(isVisible: showLoaderView, message: ''),

                    ],
                  )
              ),
            ),
          );
        },
      );
  }

  Widget topNotificationPage(int index) {
    updatePageHeight(notificationPageKeys[index],index);
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              key: notificationPageKeys[index],
              width: screenWidth - 2.5 * marginValue,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(pathS / 8),
                color: isDarkMode ? greyColor8 : whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow color
                    blurRadius: pathS / 10, // Spread of the shadow
                    offset: Offset(-pathS / 12, pathS / 12),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: pathS / 6,),
                child: SingleChildScrollView(

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (index < topNotificationsPage.length)
                        _buildHtmlWeb(topNotificationsPage[index].message, topNotificationsPage[index].actionUrl),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget buildDutyCardsDot(int index) {
    return Container(
      margin: EdgeInsets.all(pathS/20),
      width: cardIndex == index ? 12.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: cardIndex == index ? isDarkMode? redColor1: redColor3 : greyColor4,
      ),
    );
  }
  Widget buildDot(int index) {
    return Container(
      margin: EdgeInsets.all(pathS/20),
      width: pageIndex == index ? 12.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: pageIndex == index ? isDarkMode? redColor1: redColor3 : greyColor4,
      ),
    );
  }
  Widget buildDutyCard(DutyCard card) {
    final String dutyShiftName     = card.shiftName;
    final String siteName          = card.siteName ?? '';
    final String unitCode          = card.unitCode ?? '';
    final String postName          = card.postName ?? '';
    final String dutyInBtnText     = card.dutyInButtonText ?? '';
    final String dutyOutBtnText    = card.dutyOutButtonText  ?? '';
    final String postGeoLocation   = card.geoLocation ?? '';
    final bool isDutyInTapEnabled  = (card.dutyInButtonEnable ?? 0) == 1;
    final bool isDutyOutTapEnabled = (card.dutyOutButtonEnable ?? 0) == 1;
    String currentDutyStartTime = card.shiftStartTime ;

    // 🎨 Colors & shadows based on enable/disable
    Color dutyInBgColor     = isDutyInTapEnabled ? redColor3 : (isDarkMode ? greyColor5 : greyColor1);
    Color dutyInFontColor   = isDutyInTapEnabled ? whiteColor : (isDarkMode ? greyColor7 : greyColor4);
    Color dutyInShadowColor = isDutyInTapEnabled ? Colors.black.withOpacity(0.2) : Colors.transparent;

    Color dutyOutBgColor     = isDutyOutTapEnabled ? redColor3 : (isDarkMode ? greyColor5 : greyColor1);
    Color dutyOutFontColor   = isDutyOutTapEnabled ? whiteColor : (isDarkMode ? greyColor7 : greyColor4);
    Color dutyOutShadowColor = isDutyOutTapEnabled ? Colors.black.withOpacity(0.2) : Colors.transparent;
    debugPrint('''
        ---- Duty Card Info ----
        
        Shift Name         : $dutyShiftName
        Site Name          : $siteName
        Unit Code          : $unitCode
        Post Name          : $postName
        Duty In Button     : $dutyInBtnText (Enabled: $isDutyInTapEnabled)
        Duty Out Button    : $dutyOutBtnText (Enabled: $isDutyOutTapEnabled)
        Post Geo Location  : $postGeoLocation
        Duty Start Time : $currentDutyStartTime
        Duty end Time : ${card.shiftEndTime}
        Duty start Enable  time : ${card.dutyStartEnableTime}
         Duty start Disable  time : ${card.dutyStartDisableTime}
         Duty end Disable  time : ${card.dutyEndDisableTime}

        -------------------------
       ''');


    return Container(
      width: screenWidth - 2.5 * marginValue,
      height: pathL * 2.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(pathS / 8),
        color: isDarkMode ? greyColor8 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: pathS / 10,
            offset: Offset(-pathS / 12, pathS / 12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Padding(
            padding: EdgeInsets.only(left: pathS / 4, top: pathS / 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // ----- Current Duty Label -----
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(pathS / 15),
                        color: greenColor1,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: pathS / 5,
                        vertical: pathS / 10,
                      ),
                      child: Text(
                        card.cardTitle ?? '',
                        style: TextStyle(
                          color: greenColor6,
                          fontSize: pathS / 5.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    Spacer(),
                    // ----- Shift Name -----
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(pathS / 15),
                        ),
                        color: greenColor1,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: pathS / 5,
                        vertical: pathS / 10,
                      ),
                      child: Text(
                        dutyShiftName,
                        style: TextStyle(
                          color: greenColor6,
                          fontSize: pathS / 5.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: pathS / 5),

                Text(siteName,
                    style: TextStyle(
                        color: isDarkMode ? greyColor1 : greyColor5,
                        fontSize: pathS / 5.5,
                        fontWeight: FontWeight.w500)),

                Text(unitCode,
                    style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 5.5,
                        fontWeight: FontWeight.w600)),

                Text(postName,
                    style: TextStyle(
                        color: isDarkMode ? greyColor1 : greyColor5,
                        fontSize: pathS / 5.5,
                        fontWeight: FontWeight.w500)),

                SizedBox(height: pathS / 5),

                Center(
                  child: Text(
                    getDateTime('EEEE d MMM'),
                    style: TextStyle(
                      color: isDarkMode ? greyColor1 : greyColor4,
                      fontSize: pathS / 5.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // ----- Start Time -----
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getFormattedTime(currentDutyStartTime,"h:mm"),
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor7,
                        fontSize: pathS / 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: pathS / 8),
                    Text(
                      getFormattedTime(currentDutyStartTime,"a").toUpperCase(),
                      style: TextStyle(
                        color: isDarkMode ? greyColor1 : greyColor4,
                        fontSize: pathS / 5.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: pathS / 2),
              ],
            ),
          ),

          // ===== Bottom Section =====
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Duty In
                  if (card.dutyInOutButtonShow != null && card.dutyInOutButtonShow == 1)
                    GestureDetector(
                      onTap: isDutyInTapEnabled
                          ? () => onTapDutyIn(card.shiftId) // ✅ Pass shiftId inside a closure
                          : null,
                      child: Container(
                        width: pathL * 1.1,
                        height: pathS / 1.6,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: dutyInBgColor,
                          borderRadius: BorderRadius.circular(pathS / 3),
                          boxShadow: [
                            BoxShadow(
                              color: dutyInShadowColor,
                              blurRadius: pathS / 10,
                              offset: Offset(-pathS / 12, pathS / 12),
                            ),
                          ],
                        ),
                        child: Text(
                          dutyInBtnText,
                          style: TextStyle(
                            color: dutyInFontColor,
                            fontSize: pathS / 4.8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                  SizedBox(width: pathS / 8),

                  // Duty Out
                 if(card.dutyInOutButtonShow != null && card.dutyInOutButtonShow == 1) GestureDetector(
                   onTap: isDutyOutTapEnabled
                       ? () => onTapDutyOut(card.shiftId) // ✅ Pass shiftId inside a closure
                       : null,
                   child: Container(
                      width: pathL * 1.1,
                      height: pathS / 1.6,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: dutyOutBgColor,
                        borderRadius: BorderRadius.circular(pathS / 3),
                        boxShadow: [
                          BoxShadow(
                            color: dutyOutShadowColor,
                            blurRadius: pathS / 10,
                            offset: Offset(-pathS / 12, pathS / 12),
                          ),
                        ],
                      ),
                      child: Text(
                        dutyOutBtnText,
                        style: TextStyle(
                          color: dutyOutFontColor,
                          fontSize: pathS / 4.9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: pathS / 5),

              Container(
                width: screenWidth,
                height: pathS / 80,
                color: isDarkMode ? greyColorDark : greyColor2,
              ),
              SizedBox(height: pathS / 5),

              // Location Button
              GestureDetector(
                onTap: () {
                  final parts = postGeoLocation.split(',');
                  if (parts.length == 2) {
                    final lat = double.tryParse(parts[1].trim());
                    final lng = double.tryParse(parts[0].trim());
                    if (lat != null && lng != null) {
                      launchGoogleMap(lat, lng);
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/dashboard-icons/location-on.png",
                      height: pathS / 3,
                      width: pathS / 4,
                    ),
                    SizedBox(width: pathS / 6),
                    Text(
                      'location_on_map'.tr(),
                      style: TextStyle(
                        color: isDarkMode ? redColor1 : redColor3,
                        fontSize: pathS / 4.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: pathS / 4),

            ],
          ),
        ],
      ),
    );
  }
  void animatePageIndex(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  void animateDutyCardPageToIndex(int index) {
      setState(() {cardIndex = index;});
      cardPageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  void updatePageHeight(GlobalKey key, int index){
    Future.delayed(Duration(milliseconds: 1),(){
    if(key == null)return;
      RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        topNotificationPageHeight[index] = renderBox.size.height;
      });
    });
  }
  Widget _buildHtmlWeb(String htmlBody, String actionUrl) {
    return GestureDetector(
      onTap: () async {
        if (actionUrl.isNotEmpty) {
          final Uri url = Uri.parse(actionUrl);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        }
      },
      child: Html(
        data: htmlBody, // Pass cleaned HTML
        style: {
          "h1": Style(
            color:  isDarkMode ? redColor1 : redColor3,
          ),
          "h2": Style(
            // color:  isDarkMode ? redColor1 : redColor3,
          ),
          "p": Style(
            color: isDarkMode ? whiteColor : greyColor7,
            // fontSize: FontSize(16),
            // fontWeight: FontWeight.w500,
            // fontFamily: 'Roboto',
          ),
        },
      ),
    );
  }

  Future<void> initialSetup() async {

    await getNotificationTableData();
    await getRoasterViewData();
    await getAttendanceTableData();
    await getProfileTableData();
    await getPostingTableData();
    await getUserLeavesTableData();

  }

  Future<void> loadServerData() async {
    await onLoadNotificationData();
    await onLoadAttendanceData();
    await onLoadRoasterData();
    await onLoadUserPostingData();
    await onLoadProfileData();
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

  Future<void>  onLoadNotificationData() async{
    // setState(() {
    //   showLoaderView = true;
    // });
    Map <String,String> inputData = {

    };

    APIHelper.instance.getData(userNotificationApi,inputData, (data) async {

      // setState(() {
      //   showLoaderView = false;
      // });

      if(data.isNotEmpty){
        List<UserNotification> notificationData = data.map((json) => UserNotification.fromJson(json)).toList();
        await syncUserNotificationData(notificationData);

      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

    }
    );

  }
  Future<void> onLoadAttendanceData() async {
    // setState(() {
    //   showLoaderView = true;
    // });
    Map <String,String> inputData = {

    };

    APIHelper.instance.getData(userAttendanceApi,inputData, (data) async {

      // setState(() {
      //   showLoaderView = false;
      // });

      if(data.isNotEmpty){

        List<UserAttendance> dataList = data.map((json) => UserAttendance.fromJson(json)).toList();
        for (var data in dataList) {
          printInDebug(' ID: ${data.id}');
          printInDebug(' name: ${data.siteName}');
        }

        // final undeletedAttendance = dataList
        //     .where((data) =>
        // data.deleted == 0)
        //     .toList();

        // if(undeletedAttendance.isNotEmpty){
        //   userAttendance = undeletedAttendance;
        //   updateDutyInOutAttendance(userAttendance);
        //   updateCalendarDataAttendance(_focusedDay);
        // }

        if(dataList.isNotEmpty) {

          await syncUserAttendanceData(dataList);

        }
      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

    }
    );

  }
  Future<void> onLoadProfileData() async{


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

        List<UserProfile> userProfiles = data.map((json) => UserProfile.fromJson(json)).toList();
        for (var profile in userProfiles) {
          printInDebug('profile ID: ${profile.id}');
          printInDebug('profile emp name: ${profile.empName}');
          printInDebug('profile manager mob: ${profile.managerMobile}');

        }

        if(userProfiles.isNotEmpty) {
          // showProfileDataOnUI(userProfiles.first);
          //
          // userProfile = userProfiles;

          syncUserProfileData(userProfiles);
        }else{
          printInDebug('data is empty');
        }

        // List <UserProfile> userProfile = [];



      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

    }
    );

  }
  Future<void> onLoadUserPostingData() async{
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

          final userPostings = dataList.map((json) => UserPosting.fromJson(json)).toList();
          syncUserPostingData(userPostings);

        }
        if (data.containsKey('UnitDutyPost')) {
          final List<dynamic> dataList = data['UnitDutyPost'];
          final unitDutyPosts = dataList.map((json) => UnitDutyPost.fromJson(json)).toList();

          syncUnitDutyPostData(unitDutyPosts);
        }
        if (data.containsKey('UnitShiftDetail')) {
          final List<dynamic> dataList = data['UnitShiftDetail'];
          final unitShiftDetailData = dataList.map((json) => UnitShiftDetail.fromJson(json)).toList();
          final filteredUnitShiftDetails = unitShiftDetailData.where((data) => data.deleted == 0).toList();

          final Set<String> shiftIds = {};
          userShiftDetailsData = filteredUnitShiftDetails.where((data) {
            if (shiftIds.contains(data.shiftId)) {
              return false;
            } else {
              shiftIds.add(data.shiftId);
              return true;
            }
          }).toList();
          syncUnitShiftDetailData(userShiftDetailsData);
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
  Future<void> onLoadRoasterData() async {

    Map <String,String> inputData = {};

    APIHelper.instance.getData(userRosterApi,inputData, (data) {

      if(data.isNotEmpty){

        List<UserRoaster> roasters = data.map((json) => UserRoaster.fromJson(json)).toList();

        // userRoasters = roasters;

        syncUserRoasterData(roasters);
        // updateNextDaysRoasterUI(userRoasters);


      }

    },(error){

    }
    );

  }

  Future<void> syncUserNotificationData(List<UserNotification> userNotificationData) async {

    // Update multiple rows using a generic update function
    await DatabaseHelper.instance.updateTableData<UserNotification>(
      keyTableUserNotification,
      userNotificationData,
      'id',
          (data) => data.toMap(),

    );
    await getNotificationTableData();

  }
  Future<void> syncUserAttendanceData(   List <UserAttendance> userAttendance) async {
    await DatabaseHelper.instance.updateOrDeleteTableData<UserAttendance>(
        keyTableUserAttendance,
        userAttendance,
        'id',
            (userAttendance) => userAttendance.toMap()
    );

    await getRoasterViewData();
    await getAttendanceTableData();

  }
  Future<void> syncUserProfileData(   List <UserProfile> userProfile) async {
    await DatabaseHelper.instance.replaceTableData<UserProfile>(keyTableUserProfile, userProfile, (userProfile) =>
        userProfile.toMap());

    await getProfileTableData();
  }
  Future<void> syncUnitShiftDetailData( List<UnitShiftDetail> userShiftDetailsData) async {
    await DatabaseHelper.instance.replaceTableData<UnitShiftDetail>(keyTableUnitShiftDetail, userShiftDetailsData, (unitShiftDetail) =>
        unitShiftDetail.toMap());

    await getPostingTableData();
  }
  Future<void> syncUnitDutyPostData( List<UnitDutyPost> unitDutyPosts) async {
    await DatabaseHelper.instance.replaceTableData<UnitDutyPost>(keyTableUnitDutyPost, unitDutyPosts, (unitDutyPosts) =>
        unitDutyPosts.toMap());

    await getPostingTableData();
  }
  Future<void> syncUserPostingData(List<UserPosting> userPostings) async {
    await DatabaseHelper.instance.replaceTableData<UserPosting>(
        keyTableUserPosting,
        userPostings,
            (userPosting) => userPosting.toMap());

    await getPostingTableData();
  }
  Future<void> syncUserRoasterData(List <UserRoaster> userRoaster) async {

    await DatabaseHelper.instance.updateOrDeleteTableData<UserRoaster>(
        keyTableUserRoster,
        userRoaster,
        'id',
            (userRoaster) => userRoaster.toMap()
    );

    await getRoasterViewData();
  }
  Future<void> getNotificationTableData() async {
    List<UserNotification> userNotificationTableData = await DatabaseHelper.instance.getAllRecords<UserNotification>(
      keyTableUserNotification,
          (map) => UserNotification.fromMap(map),
    );

    if(userNotificationTableData.isEmpty){
         // onLoadNotificationData();
      return;
    }

    DateTime dateTimeNow = DateTime.now();
    final notification = userNotificationTableData
        .where((data) =>
    (data.expiryDate.year >= dateTimeNow.year
        && data.expiryDate.month >= dateTimeNow.month
        && data.expiryDate.day >= dateTimeNow.day && data.deleted == 0)
    ).toList();

    final htmlPageNotification = notification
        .where((data) =>
    (data.isHtmlPage  == true && data.messageType == 5 && data.readStatus == false)
    ) .toList();

    final htmlBody1NotificationData = notification
        .where((data) =>
    (data.isHtmlBody  == true  && data.messageType == 1 && data.readStatus == false)
    ) .toList();

    final htmlBody2NotificationData = notification
        .where((data) =>
    (data.isHtmlBody  == true && data.messageType == 2 && data.readStatus == false)
    ) .toList();

    final imageNotification = notification
        .where((data) =>
    (data.isImageUrl  == true && data.readStatus == false )
    ) .toList();

    if(htmlPageNotification.isNotEmpty){
      loadWebViewPopup(context, htmlPageNotification.first.message,htmlPageNotification.first);
    }

    if(htmlBody1NotificationData.isNotEmpty){
      setState(() {
        topNotificationsPage = htmlBody1NotificationData;
        notificationPageKeys = List.generate(
          topNotificationsPage.length,
              (index) => GlobalKey(),
        );

        topNotificationPageHeight = List.generate(
          topNotificationsPage.length,
              (index) => pathL*2.2,
        );

      });
    }

    if(htmlBody2NotificationData.isNotEmpty){
      setState(() {
        htmlBottomBodyNotifications = htmlBody2NotificationData;
      });
    }


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
     showProfileDataOnUI(userProfiles.first);
   }else{
     await onLoadProfileData();
   }

  }
  void showProfileDataOnUI(UserProfile userProfile){

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

      areaOfficerName = userProfile.managerName;
      areaOfficeContact = userProfile.managerMobile;

    });
  }

  Future<void> getRoasterViewData() async {

    // final roasterData = await DatabaseHelper.instance.getAllRecords<UserRoaster>(
    //   keyTableUserRoster,
    //       (map) => UserRoaster.fromMap(map),
    // );

    final roasterData = await DatabaseHelper.instance.fetchRosterFromView();

    if(roasterData.isNotEmpty){
      userRoasters = roasterData;
      updateCurrentDayRoasterUI(roasterData);
      updateNextDaysRoasterUI(roasterData);

    }
    else{
     await onLoadRoasterData();
    }
  }
  Future<List<UnitDutyPost>> getTodayRosterUnitShiftData() async {

    return unitDutyPosts.where(
            (data) => data.unitCode == todayRoster.first.unitCode
    ).toList();

  }
  Future<void> updateCurrentDayRoasterUI(List<UserRoaster> roasters) async {
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Filter roster data for today
    todayRoster = roasters
        .where((roster) => roster.rosterDate == todayDate && roster.deleted == 0
    )
        .toList();


    if (todayRoster.isNotEmpty) {
      final dutyCards = DutyCardMapper.fromUserRoaster(todayRoster);
      final result = DutyCardProcessor.process(dutyCards);

      if (result.isValid) {
        final cards = result.cards;
        setState(() {
          userDutyCard = cards;
        });
        for (var card in cards) {
          debugPrint('${card.cardTitle} -> ${card.shiftName}');
        }
      } else {
        debugPrint('Error: ${result.error}');
      }

      final activeIndex = userDutyCard.indexWhere((c) => c.isCurrentOrAvailable == true);
      if (activeIndex != -1) {
        // ✅ Active Duty found → set as default
        cardIndex = activeIndex;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          cardPageController.jumpToPage(activeIndex);
        });
      }


    }else{
     await onLoadRoasterData();
    }
  }
  void updateNextDaysRoasterUI(List<UserRoaster> roasters) {
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

    final userPostingsData = await DatabaseHelper.instance.getAllRecords<UserPosting>(
      keyTableUserPosting,
          (map) => UserPosting.fromMap(map),
    );
     userPostings = userPostingsData.where(
             (data) => data.deleted == 0).toList();

   final unitDutyPostsData = await DatabaseHelper.instance.getAllRecords<UnitDutyPost>(
      keyTableUnitDutyPost,
          (map) => UnitDutyPost.fromMap(map),
    );
    unitDutyPosts = unitDutyPostsData.where(
            (data) => data.deleted == 0).toList();

    final unitShiftDetailData = await DatabaseHelper.instance.getAllRecords<UnitShiftDetail>(
      keyTableUnitShiftDetail,
          (map) => UnitShiftDetail.fromMap(map),
    );
    final filteredUnitShiftDetails = unitShiftDetailData.where((data) => data.deleted == 0).toList();

    final Set<String> shiftIds = {};
    userShiftDetailsData = filteredUnitShiftDetails.where((data) {
      if (shiftIds.contains(data.shiftId)) {
        return false;
      } else {
        shiftIds.add(data.shiftId);
        return true;
      }
    }).toList();

    if(userPostingsData.isEmpty || unitDutyPostsData.isEmpty || unitShiftDetailData.isEmpty) {
     await onLoadUserPostingData();
    }else{
      printInDebug('All duty related data fetched');
    }

  }

  Future<void> getAttendanceTableData() async {
    final userAttendanceData = await DatabaseHelper.instance.getAllRecords<UserAttendance>(
      keyTableUserAttendance,
          (map) => UserAttendance.fromMap(map),
    );

    if(userAttendanceData.isEmpty){
     await onLoadAttendanceData();
      return;
    }
    final undeletedAttendance = userAttendanceData
        .where((data) =>
        data.deleted == 0)
        .toList();

    if(undeletedAttendance.isNotEmpty) {
      userAttendance = undeletedAttendance;
      updateDutyInOutAttendance(userAttendance);
      updateCalendarDataAttendance(_focusedDay);
    }

  }
  void updateDutyInOutAttendance(List<UserAttendance> attendance) {
    DateTime todayDate = DateTime.now();
    DateTime startOfDay = DateTime(todayDate.year, todayDate.month, todayDate.day);

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
      todayUserAttendance = todayAttendance;

      Duration totalDutyDuration = Duration.zero;

      for (final userAttendance in todayAttendance) {

        DateTime endTime = userAttendance.actEndTime ??
            (userAttendance.shiftEndTime.isBefore(DateTime.now())
                ? userAttendance.shiftEndTime
                : DateTime.now());
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

        setState(() {
          todayDutyInMarked =  true;
          dutyInHourBanner = dutyDuration;
        });

      });

    }
    else{
      setState(() {
        todayDutyInMarked =  false;
        dutyInHourBanner = '';
      });

    }

  }

  Future<void> getUserLeavesTableData() async {
    var userLeavesList = await DatabaseHelper.instance.getAllRecords<UserLeaves>(
      keyTableUserLeave,
          (map) => UserLeaves.fromMap(map),
    );

    for (var data in userLeavesList) {
      printInDebug('Leaves Data');
      data.toMap().forEach((i, j) {
        printInDebug('$i : $j');
      });

    }


    final leaves = userLeavesList
        .where((data) =>
    data.deleted == 0 && data.canceled == 0)
        .toList();

    if(leaves.isNotEmpty) {
      userLeaves = leaves;
      updateCalendarDataLeaves(_focusedDay);
    }
    else{
      onLoadLeavesData();
    }


  }
  void onLoadLeavesData() {


    // setState(() {
    //   showLoaderView = true;
    // });
    Map <String,String> inputData = {

    };

    APIHelper.instance.getData(userLeavesApi,inputData, (data) {

      // setState(() {
      //   showLoaderView = false;
      // });

      if(data.isNotEmpty){

        List<UserLeaves> dataList = data.map((json) => UserLeaves.fromJson(json)).toList();
        for (var data in dataList) {
          printInDebug(' ID: ${data.id}');
          printInDebug(' leaveTypeName: ${data.leaveTypeName}');
        }

        if(dataList.isNotEmpty) {
          syncUserLeavesData(dataList);
        }
        final leaves = dataList
            .where((data) =>
        data.deleted == 0 && data.canceled == 0)
            .toList();

        if(leaves.isNotEmpty){
            userLeaves = leaves;
            updateCalendarDataLeaves(_focusedDay);
          }



      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

    }
    );

  }
  Future<void> syncUserLeavesData(   List <UserLeaves> userLeaves) async {
    await DatabaseHelper.instance.updateOrDeleteTableData<UserLeaves>(
        keyTableUserLeave,
        userLeaves,
        'id',
            (userLeaves) => userLeaves.toMap()
    );


  }

  Future<void> updateCalendarData(DateTime date) async {

  updateCalendarDataAttendance(date);
  updateCalendarDataLeaves(date);

  }
  Future<void> updateCalendarDataAttendance(DateTime date) async {

    final pendingAttendance = userAttendance
        .where((data) =>
    (data.shiftStartDate.year == date.year  &&
        data.shiftStartDate.month == date.month &&
        data.isApproved == keyPendingAttendance && data.deleted == 0)

    )
        .toList();

    final approvedAttendance = userAttendance
        .where((data) =>
    (data.shiftStartDate.year == date.year  &&
        data.shiftStartDate.month == date.month &&
        data.isApproved == keyApprovedAttendance && data.deleted == 0)
    )
        .toList();

    setState(() {
      approvalPendingCount = pendingAttendance.isNotEmpty ? '${pendingAttendance.length}' : '0';
      approvalDoneCount = approvedAttendance.isNotEmpty ? '${approvedAttendance.length}' : '0';
    });

  }
  Future<void> updateCalendarDataLeaves(DateTime date) async {

    final approvedLeaves = userLeaves.where((data) => (data.leaveStatus < keyRejectedLeave)).toList();

    final approvedLeaveCount = leaveCountForMonth(approvedLeaves, date.year, date.month);

    setState(() {
       leaveCount = '$approvedLeaveCount';
    });

  }
  int leaveCountForMonth(List<UserLeaves> leaves, int year, int month) {

     for (var data in leaves) {
      printInDebug('leaves approve Data');
      data.toMap().forEach((i, j) {
        printInDebug('$i : $j');
      });

    }

    int leaveDaysCount = 0;

    for (var leave in leaves) {
      // Check if the leave overlaps with the given month and year
      DateTime startDate = leave.leaveStartDate;
      DateTime endDate = leave.leaveEndDate;

      if (startDate.year == year && startDate.month == month ||
          endDate.year == year && endDate.month == month ||
          (startDate.year < year || (startDate.year == year && startDate.month < month)) &&
              (endDate.year > year || (endDate.year == year && endDate.month > month))) {
        // Calculate the start and end dates within the month
        DateTime monthStart = DateTime(year, month, 1);
        DateTime monthEnd = DateTime(year, month + 1, 1).subtract(const Duration(days: 1));

        DateTime actualStart = startDate.isBefore(monthStart) ? monthStart : startDate;
        DateTime actualEnd = endDate.isAfter(monthEnd) ? monthEnd : endDate;

        // Add the number of days within the month
        leaveDaysCount += actualEnd.difference(actualStart).inDays + 1;
      }
    }

    return leaveDaysCount;
  }



  Future<void> onTapDutyIn(String shiftId) async {
    if(! await isGPSAndAppLocationEnabled()){
      setState(() {
        alertHeader = '';
        alertMessage = 'no_gps'.tr();
        showAlert = true;
        cancelBtnTitle = '';
        okBtnTitle =   'ok'.tr();
      });
       openMySISAppSettings();
      return;
    }
    if(! await isWifiOrMobileDataConnected()){
      setState(() {
        alertHeader = '';
        alertMessage = 'no_wi_fi'.tr();
        showAlert = true;
        cancelBtnTitle = '';
        okBtnTitle =   'ok'.tr();
      });
       // openAppSettings() ;
      return;
    }


    final shiftDetail = await getUnitShiftDetailsById(shiftId,keyAttendanceStatusDutyIn);

    if (shiftDetail == null) {
      return;
    }

    loadScanUnitShiftView(
      keyAttendanceModeSelf,
      keyAttendanceStatusDutyIn,
      null,
      shiftDetail,
    );
  }
  Future<void> onTapOtherDuty() async {
    if(! await isGPSAndAppLocationEnabled()){
      setState(() {
        alertHeader = '';
        alertMessage = 'no_gps'.tr();
        showAlert = true;
        cancelBtnTitle = '';
        okBtnTitle =   'ok'.tr();
      });

      return;
    }
    if(! await isWifiOrMobileDataConnected()){
      setState(() {
        alertHeader = '';
        alertMessage = 'no_wi_fi'.tr();
        showAlert = true;
        cancelBtnTitle = '';
        okBtnTitle =   'ok'.tr();
      });
      return;
    }

    loadOthersDutyView();

  }
  Future<UnitShiftDetail?> getUnitShiftDetailsByIdNew(String shiftId, String attendanceStatus) async {
    DateTime now = DateTime.now();
    TimeOfDay currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    final matches = userShiftDetailsData.where((shift) {
      final startTime = _parseTimeOfDay(shift.startTime);
      final endTime = _parseTimeOfDay(shift.endTime);

      final shiftStartBeforeDuration = _parseShiftDuration(shift.shiftStartBefore);
      final shiftEndAfterDuration = _parseShiftDuration(shift.dutyInBefore);

      final adjustedStartTime = _adjustTimeOfDay(startTime, shiftStartBeforeDuration);
      final adjustedEndTime = _adjustTimeOfDay(endTime, -shiftEndAfterDuration);

      // --- Debug prints ---
      debugPrint('--- Shift Debug ---');
      debugPrint('shiftId: ${shift.shiftId}, comparing with: $shiftId');
      debugPrint('StartTime: $startTime, EndTime: $endTime');
      debugPrint('ShiftStartBefore: $shiftStartBeforeDuration, DutyInBefore: $shiftEndAfterDuration');
      debugPrint('AdjustedStartTime: $adjustedStartTime, AdjustedEndTime: $adjustedEndTime');
      debugPrint('CurrentTime: $currentTime');
      debugPrint('IsTimeBetween: ${_isTimeBetween(currentTime, adjustedStartTime, adjustedEndTime)}');


      return shift.shiftId == shiftId &&
          _isTimeBetween(currentTime, adjustedStartTime, adjustedEndTime);
    }).toList();

    if (matches.isEmpty) {
      if (attendanceStatus == keyAttendanceStatusDutyOut) {
        showPopupAlert('alert'.tr(), 'other_mark_shift_not_allowed1'.tr());
      }
      else {
        showPopupAlert('alert'.tr(), 'no_shift_found'.tr());
      }
      return null;
    }
    else{
      return matches.first;
    }

  }

  Future<UnitShiftDetail?> getUnitShiftDetailsById(String shiftId, String attendanceStatus) async {
    DateTime now = DateTime.now();
    TimeOfDay currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    final matches = userShiftDetailsData.where((shift) {
      final startTime = _parseTimeOfDay(shift.startTime);
      final endTime = _parseTimeOfDay(shift.endTime);

      final shiftStartBeforeDuration = _parseShiftDuration(shift.shiftStartBefore);
      final shiftEndAfterDuration = _parseShiftDuration(shift.dutyInBefore);

      final adjustedStartTime = _adjustTimeOfDay(startTime, shiftStartBeforeDuration);
      final adjustedEndTime = _adjustTimeOfDay(endTime, -shiftEndAfterDuration);

      // --- Debug prints ---
      debugPrint('--- Shift Debug ---');
      debugPrint('shiftId: ${shift.shiftId}, comparing with: $shiftId');
      debugPrint('StartTime: $startTime, EndTime: $endTime');
      debugPrint('ShiftStartBefore: $shiftStartBeforeDuration, DutyInBefore: $shiftEndAfterDuration');
      debugPrint('AdjustedStartTime: $adjustedStartTime, AdjustedEndTime: $adjustedEndTime');
      debugPrint('CurrentTime: $currentTime');
      debugPrint('IsTimeBetween: ${_isTimeBetween(currentTime, adjustedStartTime, adjustedEndTime)}');


      return shift.shiftId == shiftId &&
          _isTimeBetween(currentTime, adjustedStartTime, adjustedEndTime);
    }).toList();

    if (matches.isEmpty) {
      if (attendanceStatus == keyAttendanceStatusDutyOut) {
        showPopupAlert('alert'.tr(), 'other_mark_shift_not_allowed1'.tr());
      }
      else {
        showPopupAlert('alert'.tr(), 'no_shift_found'.tr());
      }
      return null;
    }
    else{
      return matches.first;
    }

  }
  Future<void> onTapDutyOut(String shiftId) async {
    if(! await isGPSAndAppLocationEnabled()){
      setState(() {
        alertHeader = '';
        alertMessage = 'no_gps'.tr();
        showAlert = true;
        cancelBtnTitle = '';
        okBtnTitle =   'ok'.tr();
      });
      openMySISAppSettings();
      return;
    }
    if(! await isWifiOrMobileDataConnected()){
      setState(() {
        alertHeader = '';
        alertMessage = 'no_wi_fi'.tr();
        showAlert = true;
        cancelBtnTitle = '';
        okBtnTitle =   'ok'.tr();
      });
      openMySISAppSettings() ;
      return;
    }

    final shiftDetail = await getUnitShiftDetailsById(shiftId,keyAttendanceStatusDutyOut);


    if (shiftDetail == null) {
      return;
    }
    loadScanUnitShiftView(keyAttendanceModeSelf,keyAttendanceStatusDutyOut,todayUserAttendance.first,shiftDetail);
  }
  Future<void> loadScanUnitShiftView(String mode, String status, UserAttendance? todayAttendance, UnitShiftDetail? selectedShiftDetail) async{
    todayUnitDutyPost = await getTodayRosterUnitShiftData();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ScanUnitShiftView(
        userProfile: userProfile.first,
        attendanceMode: mode,
        unitDutyPosts: todayUnitDutyPost,
        unitShiftDetails: userShiftDetailsData,
        userPostings: userPostings,
        attendanceStatus: status,
        userAttendance: todayAttendance,
        selectedShift: selectedShiftDetail,
      ),
    ),
  );
}

  void loadOthersDutyView(){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OthersDutyView(
        userProfile: userProfile.first,
        attendanceMode: keyAttendanceModeOther,
        unitDutyPosts: unitDutyPosts,
        unitShiftDetails: userShiftDetailsData,
        userPostings: userPostings,

      ),
    ),
  );
}

  bool checkLocation(UnitDutyPost dutyPost, String currentLatLng){

    bool locationVerified = true;

    List<String> activeDayList = currentLatLng.isNotEmpty ? currentLatLng.split(',').map((e) => e.trim()).toList() : ['0.0','0.0'];
    double currentLat = double.parse(activeDayList[1]) ; // Latitude
    double currentLng = double.parse(activeDayList[0]); // Longitude

    if(dutyPost.isGeoFenceAllow == 1){
      locationVerified = false;
      if(currentLat > 0.0 && currentLng > 0.0){
        int currentDistance = getDistanceFromDuty(dutyPost.geoLocation, currentLatLng);
        if(currentDistance <= dutyPost.allowDistance){
          locationVerified = true;
        }
        else{
          locationVerified = false;
          String message = '${'your_location'.tr()}: $currentLatLng\n ${'distance_from_post'.tr()}: $currentDistance ${'meter'.tr()}' ;
          showPopupAlert(
              'not_allow_range_location'.tr(),
              message,
          );
        }
      }
      else{
        locationVerified = false;
        showPopupAlert(
            'device_location'.tr(),
            'not_allow_range_location'.tr(),
        );
      }

    }
    else{
      locationVerified = true;
    }

    return locationVerified;

  }
  void showPopupAlert(String header, String message, {String cancelText = ''}){
    setState(() {
      alertHeader = header;
      alertMessage = message;
      showAlert = true;
      cancelBtnTitle = cancelText;

    });
  }
  TimeOfDay _parseTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
  TimeOfDay _adjustTimeOfDay(TimeOfDay time, Duration adjustmentDuration) {
    final adjustmentMinutes = adjustmentDuration.inMinutes; // Convert Duration to int (minutes)
    final totalMinutes = time.hour * 60 + time.minute - adjustmentMinutes;
    final adjustedHour = (totalMinutes ~/ 60) % 24;
    final adjustedMinute = totalMinutes % 60;
    return TimeOfDay(hour: adjustedHour, minute: adjustedMinute);
  }
  bool _isTimeBetween(TimeOfDay current, TimeOfDay start, TimeOfDay end) {
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    if (startMinutes <= endMinutes) {
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } else {
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }
  }
  Duration _parseShiftDuration(String shiftDuration) {
    List<String> parts = shiftDuration.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }


}


void loadWebViewPopup(BuildContext context, String pageUrl,UserNotification userNotification) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.9),
    pageBuilder: (context, _, __) {
      return WebViewScreen(pageUrl: pageUrl, userNotification: userNotification);
    },
  );
}

class WebViewScreen extends StatefulWidget {
  final UserNotification userNotification;
  final String pageUrl;
  const WebViewScreen({super.key, required this.pageUrl, required this.userNotification});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}
class _WebViewScreenState extends State<WebViewScreen> {
  bool _isLoading = true;
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    return WillPopScope(
      onWillPop: () async {
        // Prevent back button from closing the WebView
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(

              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                SizedBox(
                  width: screenWidth,
                  height: screenHeight ,
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri(widget.pageUrl),
                    ),

                    initialSettings: InAppWebViewSettings(
                      supportZoom: false, // Disable zoom
                      builtInZoomControls: false, // Hide zoom controls (Android)
                      displayZoomControls: false, // Hide zoom UI (Android)
                      useWideViewPort: true, // Ensure the content fits properly
                    ),

                    onWebViewCreated: (controller) {
                      // _injectJavaScript();
                      webViewController = controller;
                      webViewController.addJavaScriptHandler(
                        handlerName: "downloadPDF",
                        callback: (args) {
                          captureWebViewAsImage();
                        },
                      );
                      controller.addJavaScriptHandler(

                        handlerName: "closePopup",
                        callback: (args) async {
                          final String id = args.isNotEmpty ? args[0].toString() : "0";
                          Map<String, dynamic> notificationData = {
                            "id": id,
                            "readStatus": 1,
                            "dirtyFlag" : 1,
                            "readDate": DateTime.now().toIso8601String(), // ✅ Convert to string
                          };

                          await updateUserNotificationWebViewTable(notificationData);
                          Navigator.pop(context);
                        },
                      );
                      controller.addJavaScriptHandler(
                        handlerName: "skipPopup",
                        callback: (args) {
                          printInDebug('skio popup close');

                          Navigator.pop(context);
                        },
                      );
                    },
                    // controller.addJavaScriptHandler(
                    //   handlerName: "popClose",
                    //   callback: (args) async {
                    //     final String id = args.isNotEmpty ? args[0].toString() : "0";
                    //
                    //     // ✅ Update SQLite based on ID
                    //     await NotificationHelper.markNotificationAsRead(
                    //       id: int.parse(id),
                    //       modifiedBy: appUserId,
                    //     );
                    //
                    //     // ✅ Close WebView
                    //     Navigator.pop(context);
                    //   },
                    // ),
                    onLoadStart: (controller, url) {
                      setState(() {
                        _isLoading = true;
                      });
                    },
                    onLoadStop: (controller, url) {
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }


  void createNotification(UserNotification notification){

    Map <String, dynamic> notificationData = notification.toJson();

    UserNotification userNotification = UserNotification.fromJson(notificationData);

    List<UserNotification> data = [userNotification];

    syncUserNotificationWbViewData(data);

    List<dynamic> list = [notificationData];

    uploadNotification(list);

  }


  Future<void> uploadNotification(dynamic notification) async {
    APIHelper.instance.postAllData(userNotificationPostApi, notification, (responseData) {
      if (responseData.isNotEmpty) {

        List<dynamic> listData = responseData;

        for (var data in listData) {

          Map<String, dynamic> notificationData = {
            "id": data['ID'] ?? '',
            "dirtyFlag": 0,
          };
          updateUserNotificationWebViewTable(notificationData);
        }
      } else {
        printInDebug('Response data is empty.');
      }
    },
          (error) {
        // Handle error
        printInDebug('Error: $error');
      },
    );
  }

  Future<void> updateUserNotificationWebViewTable(Map <String,dynamic> notification) async{
    printInDebug('test popup close');

    await DatabaseHelper.instance.updateTableColumns(
        keyTableUserNotification,
        notification,
        'id'
    );

  }

  Future<void> syncUserNotificationWbViewData(List<UserNotification> userNotification) async {

      // Update multiple rows using a generic update function
      await DatabaseHelper.instance.updateTableData<UserNotification>(
        keyTableUserNotification,
        userNotification,
        'id',
            (data) => data.toMap(),

      );

    }



  Future<void> saveImageAsPDF(Uint8List imageBytes) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pw.MemoryImage(imageBytes)),
          );
        },
      ),
    );

    // Generate dynamic filename with timestamp
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String filename = "slip_$timestamp.pdf";

    // Save in Downloads folder
    final dir = await getDownloadsDirectory();
    final file = File("${dir!.path}/$filename");
    await file.writeAsBytes(await pdf.save());

    // Open PDF
    await Printing.sharePdf(bytes: await pdf.save(), filename: filename);

    print("PDF Saved: ${file.path}");
   {

  }}
  Future<void> captureWebViewAsImage() async {
    try {
      final Uint8List? screenshot = await webViewController.takeScreenshot();
      if (screenshot != null) {
        await saveImageAsPDF(screenshot);
      } else {
        print("Screenshot failed.");
      }
    } catch (e) {
      print("Error capturing screenshot: $e");
    }
  }





}

