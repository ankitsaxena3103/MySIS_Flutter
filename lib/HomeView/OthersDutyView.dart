
// import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/Profile/UserProfile.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/SharedClasses/LanguageProvider.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';

import '../Profile/UnitDutyPost.dart';
import '../Profile/UnitShiftDetail.dart';
import '../Profile/UserPosting.dart';
import 'ScanCardView.dart';

class OthersDutyView extends StatefulWidget {
  final UserProfile userProfile;
  final String attendanceMode;
  final List<UnitDutyPost> unitDutyPosts;
  final List<UnitShiftDetail> unitShiftDetails;
  final List<UserPosting> userPostings;

  const OthersDutyView(
      {
        super.key,
        required this.userProfile,
        required this.attendanceMode,
        required this.unitDutyPosts,
        required this.unitShiftDetails,
        required this.userPostings,
        // required this.username,
      });

  @override
  OthersDutyViewState createState() => OthersDutyViewState();
}

class OthersDutyViewState extends State<OthersDutyView> {

  bool showLoaderView = false;
  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String exclamationImage = isDarkMode ? "assets/images/dashboard-icons/exclamation-icon.png" : "assets/images/dashboard-icons/exclamation-red.png";
  String imagePath = '';
  bool isAttendanceMarked = false;
  String attendanceTime = '06:12';
  String dutyInTime = '8 Hrs Morning';
  String companyName = 'IL & FS Environmental Infrastructure & Services Limited';
  String unit = 'DLE UNT 12345';
  String department = 'Maingate SS';
  String dutyTime = '10:00';
  String dutyTimeAM_PM = 'AM';

  Color dutyInBgColor = redColor3;
  Color dutyInFontColor = whiteColor;
  Color dutyInShadowColor = Colors.black.withOpacity(0.2);


  Color dutyOutBgColor = isDarkMode? greyColor5:greyColor1;
  Color dutyOutFontColor = isDarkMode? greyColor7:greyColor4;
  Color dutyOutShadowColor = Colors.transparent;

  String shift = 'shift_a_txt'.tr();

  String userName = 'Rajkumar Singh';
  String degination = 'ASSISTANT ASSESSMENT MANAGER | ABC124563';
  String description = '10 Years with SIS';
  String areaOfficeName = 'Samant Kumar Jaiswal';

  String presentDays = "10.625";
  String leaves = '3';
  String extraDays = '11';

  DateTime _focusedDay = DateTime.now();



  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    double leftOffset = pathL/1.25;
    double topOffset = paddingTop + screenHeight/2 - pathL*1.2;
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
                  alignment: Alignment.center,
                  children: [
                    // Left Arrow
                    Positioned(
                      top: MediaQuery.of(context).padding.top+pathS/12,
                      left: paddingLeft +pathS/3,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Container(
                              width: pathS/5,
                              height: pathS/2,
                              child: Image.asset(
                                'assets/images/dashboard-icons/left-arrow.png',
                                color: isDarkMode ?  whiteColor:greyColor6,

                              ),

                            ),
                            SizedBox(width: pathS/8),
                            Text(
                              'other_duty_txt'.tr(),
                              style: TextStyle(
                                color: isDarkMode ?  whiteColor:greyColor6,
                                fontSize: pathS / 5,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Roboto',
                              ),
                              textAlign: TextAlign.center,
                            ),

                          ],
                        ),
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'other_duty_txt'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor:greyColor6,
                            fontSize: pathS / 4,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: pathS/1.8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScanCardView(
                                        userProfile: widget.userProfile,
                                        attendanceMode: widget.attendanceMode,
                                      unitDutyPosts: widget.unitDutyPosts,
                                      unitShiftDetails: widget.unitShiftDetails,
                                      userPostings: widget.userPostings,
                                      attendanceStatus: keyAttendanceStatusDutyIn,
                                    ),
                                  ),
                                );

                              },
                              child: Container(
                                width: pathL,
                                height: pathS / 1.5,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isDarkMode ? redColor3:redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                                  borderRadius: BorderRadius.circular(pathS/3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor, // Shadow color
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScanCardView(
                                      userProfile: widget.userProfile,
                                      attendanceMode: widget.attendanceMode,
                                      unitDutyPosts: widget.unitDutyPosts,
                                      unitShiftDetails: widget.unitShiftDetails,
                                      userPostings: widget.userPostings,
                                      attendanceStatus: keyAttendanceStatusDutyOut,
                                    ),
                                  ),
                                );


                              },
                              child: Container(
                                width: pathL,
                                height: pathS / 1.5,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isDarkMode ? redColor3:redColor3,                       // border: Border.all(color: Colors.yellow, width: pathS/18),
                                  borderRadius: BorderRadius.circular(pathS/3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor, // Shadow color
                                      blurRadius: pathS/10, // Spread of the shadow
                                      // spreadRadius: pathS/15, // How far the shadow extends
                                      offset:  Offset(-pathS/12, pathS/12),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'duty_out'.tr(),
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: pathS / 4.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),


                    // Text
                    Positioned(
                      left: leftOffset+2*pathS/1.5,
                      top: topOffset,
                      child: Image.asset(
                        'assets/images/dashboard-icons/profile1.png',
                        width: pathS,
                        height: pathS,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      left: leftOffset+pathS/1.5, // Adjust as needed
                      top: topOffset,
                      child: Image.asset(
                        'assets/images/dashboard-icons/profile2.png',
                        width: pathS,
                        height: pathS,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      left: leftOffset, // Adjust as needed
                      top: topOffset,
                      child: Image.asset(
                        'assets/images/dashboard-icons/profile.png',
                        width: pathS,
                        height: pathS,
                        fit: BoxFit.fill,
                      ),
                    ),




                    // LoaderView
                    LoaderView(isVisible: showLoaderView, message: 'Loading...'),
                  ],
                ),


            ),
          ),
        );
      },
    );
  }


  void initialSetup() {
  }




}