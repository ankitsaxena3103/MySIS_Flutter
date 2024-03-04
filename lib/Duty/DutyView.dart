
// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Duty/DutyDetailView.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../SharedClasses/LanguageProvider.dart';

class DutyView extends StatefulWidget {

  DutyView(
      {
        super.key,
      });


  @override
  DutyViewState createState() => DutyViewState();
}

class DutyViewState extends State<DutyView> {

  bool showLoaderView = false;
  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String exclamationImage = isDarkMode ? "assets/images/dashboard-icons/exclamation-icon.png" : "assets/images/dashboard-icons/exclamation-red.png";
  String imagePath = '';
  bool isAttendanceMarked = true;
  String attendanceTime = '06:12';
  String dutyInTime = '8 Hrs Morning';
  String companyName = 'IL & FS Environmental Infrastructure & Services Limited';
  String unit = 'DLE UNT 12345';
  String department = 'Maingate SS';
  String dutyTime = '10:00';
  String dutyTimeAM_PM = 'AM';

  Color dutyInBgColor = redColor1;
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

  List<Color>  calendarColorsLight = [greenColor1,pinkColor,yellowColor1,greenColor6,greyColor2,orangeColor];
  List<Color>  calendarColorsDark = [greenColor1,pinkColor,yellowColor1,greenColor6,greyColor1,orangeColor];

  Color calendarDaysColor = isDarkMode ? whiteColor : greyColor6;
  BoxShape calendarBoxShape = BoxShape.circle;

  List<int> dutyDays = [1,2,3];
  List<int> leaveTaken = [28];
  List<int> unSyncData = [5];
  List<int> leaveGranted = [7];
  List<int> leaveApplied = [7,8,9];
  List<int> weekOffs = [4,10,11,17,18,24,25];
  List<int> shortDuties = [4,6];





  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    double dotsize = pathS/6;
    DateTime now = DateTime.now();
    calendarDaysColor = isDarkMode ? whiteColor : greyColor6;
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

                    Padding(
                      padding: EdgeInsets.only(left: 0, top: MediaQuery.of(context).padding.top +pathS/1.2), // Adjust top and left as needed

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth,
                            height: pathS/3,

                          ),
                          Container(
                            // height: screenHeight- 1.9*pathS-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
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
                                      SizedBox(width: pathS/5),
                                      Text(
                                        DateFormat.yMMMM(selectedLocale).format(_focusedDay),
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /3.5,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(width: pathS/5),

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
                                  SizedBox(height: pathS/3),

                                  Container(
                                    width: screenWidth-2.5*marginValue,

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
                                          padding: EdgeInsets.only(left: pathS/4, top: pathS/4,bottom: pathS/5,right: pathS/4), // Adjust top and left as needed
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              // height: 2.5*pathL,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [

                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: dotsize,
                                                            width: dotsize,

                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: greenColor1,
                                                            ),
                                                          ),
                                                          SizedBox(width: pathS/15),
                                                          Text(
                                                            'duties'.tr(),
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor6,
                                                              fontSize: pathS /6.5,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ],
                                                      ),

                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: dotsize,
                                                            width: dotsize,

                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: pinkColor,
                                                            ),
                                                          ),
                                                          SizedBox(width: pathS/15),
                                                          Text(
                                                            'past_leaves'.tr(),
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor6,
                                                              fontSize: pathS /6.5,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ],
                                                      ),

                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: dotsize,
                                                            width: dotsize,

                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: yellowColor1,
                                                            ),
                                                          ),
                                                          SizedBox(width: pathS/15),
                                                          Text(
                                                            'unsynced_data'.tr(),
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor6,
                                                              fontSize: pathS /6.5,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: pathS/8),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: dotsize,
                                                            width: dotsize,

                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: greenColor6,
                                                            ),
                                                          ),
                                                          SizedBox(width: pathS/15),
                                                          Text(
                                                            'approved_leaves'.tr(),
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor6,
                                                              fontSize: pathS /6.5,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ],
                                                      ),


                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: dotsize,
                                                            width: dotsize,

                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: isDarkMode ? redColor1:redColor3,
                                                            ),
                                                          ),
                                                          SizedBox(width: pathS/15),
                                                          Text(
                                                            'applied_leaves'.tr(),
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor6,
                                                              fontSize: pathS /6.5,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ],
                                                      ),



                                                    ],
                                                  ),
                                                  SizedBox(height: pathS/8),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: dotsize,
                                                            width: dotsize,

                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: isDarkMode ? greyColor1:greyColor2,
                                                            ),
                                                          ),
                                                          SizedBox(width: pathS/15),
                                                          Text(
                                                            'fixed_weekly_off'.tr(),
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor6,
                                                              fontSize: pathS /6.5,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),

                                                        ],
                                                      ),

                                                     Row(
                                                       children: [
                                                         Container(
                                                           height: dotsize,
                                                           width: dotsize,

                                                           decoration: BoxDecoration(
                                                             shape: BoxShape.circle,
                                                             color: orangeColor,
                                                           ),
                                                         ),
                                                         SizedBox(width: pathS/15),
                                                         Text(
                                                           'Short_Duty'.tr(),
                                                           style: TextStyle(
                                                             color: isDarkMode ?  whiteColor:greyColor6,
                                                             fontSize: pathS /6.5,
                                                             fontWeight: FontWeight.w500,
                                                             fontFamily: 'Roboto',
                                                           ),
                                                           textAlign: TextAlign.left,
                                                         ),
                                                       ],
                                                     ),




                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ),
                                        ),


                                      ],
                                    ),

                                  ),
                                  SizedBox(height: pathS/8),
                                  Container(
                                    width: screenWidth-2.5*marginValue,
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
                                          padding: EdgeInsets.only(left: pathS/5, top: pathS/4,right: pathS/6,bottom: pathS/5), // Adjust top and left as needed
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(

                                              child: TableCalendar(

                                                headerVisible: false,
                                                focusedDay: _focusedDay,
                                                rowHeight: pathS/1.5,
                                                firstDay: DateTime.now().subtract(Duration(days: 36500)),
                                                lastDay: DateTime.now().add(Duration(days: 36500)),
                                                calendarFormat: CalendarFormat.month,
                                                locale: selectedLocale,
                                                calendarBuilders: CalendarBuilders(

                                                  defaultBuilder: (context, day, events) {
                                                    return Container(
                                                      margin: EdgeInsets.all(pathS/12),
                                                      decoration: BoxDecoration(
                                                        color: getBackgroundColor(day),
                                                        shape: calendarBoxShape,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '${day.day}',
                                                          style: TextStyle(
                                                            color: calendarDaysColor,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: pathS/6,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),

                                                daysOfWeekStyle: DaysOfWeekStyle(
                                                  // dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0],

                                                  weekdayStyle: TextStyle(
                                                    color: isDarkMode ? whiteColor:greyColor6,
                                                  ),
                                                  weekendStyle: TextStyle(
                                                    color: isDarkMode ? whiteColor:greyColor6,
                                                  ),
                                                ),

                                                onDaySelected: (selectedDay, focusedDay) {
                                                  printInDebug('selectedDay = $selectedDay');
                                                  printInDebug('focusedDay = $focusedDay');
                                                  onLoadDutyDetails();

                                                  setState(() {

                                                  });
                                                },
                                                // Other calendar properties...
                                              ),

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
                    LoaderView(isVisible: showLoaderView, message: 'Loading...'),
                  ],
                )
            ),
          ),
        );
      },
    );
  }

  String _getMonthText(DateTime dateTime) {
    return DateFormat('MMM yyyy').format(dateTime);
  }

  Color getBackgroundColor(DateTime date) {
    printInDebug('$date');
    calendarDaysColor = isDarkMode ? whiteColor : greyColor6;
    calendarBoxShape = BoxShape.circle;
    if (dutyDays.contains(date.day)) {
      // Return red for days 1, 2, 3, 4
      // calendarBoxShape = BoxShape.rectangle;
      calendarDaysColor  = greenColor6;
      return greenColor1;
    } else if (leaveTaken.contains(date.day)) {
      // Return red for days 1, 2, 3, 4
      calendarDaysColor  = redColor3;
      return pinkColor;
    }
    else if (unSyncData.contains(date.day)) {
      // Return red for days 1, 2, 3, 4
      calendarDaysColor  = brownColor;
      return yellowColor1;
    }
    else if (leaveGranted.contains(date.day)) {
      // Return red for days 1, 2, 3, 4
      calendarBoxShape = BoxShape.circle;
      calendarDaysColor  = whiteColor;
      return greenColor6;
    }
    else if (leaveApplied.contains(date.day) ) {
      // Return red for days 1, 2, 3, 4
      calendarBoxShape = BoxShape.circle;
      calendarDaysColor  = whiteColor;
      return redColor3;
    }
    else if (weekOffs.contains(date.day) ) {
      // Return red for days 1, 2, 3, 4
      // calendarBoxShape = BoxShape.rectangle;
      calendarDaysColor  = greyColor8;
      return greyColor1;
    }
    else if (shortDuties.contains(date.day)) {
      // Return red for days 1, 2, 3, 4
      // calendarBoxShape = BoxShape.rectangle;
      calendarDaysColor  = whiteColor;
      return orangeColor;
    }
    else {
      // Return default color for other days
      calendarBoxShape = BoxShape.circle;
      return Colors.transparent;
    }


  }
  void initialSetup() {
  }

  void onLoadDutyDetails(){

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DutyDetailView(),
        )
    );

  }

}