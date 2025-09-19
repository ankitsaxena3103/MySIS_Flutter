
// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:mysis/SharedClasses/LanguageProvider.dart';

import 'SelectLeaveReasonViewHelp.dart';


class ApplyLeaveViewHelp extends StatefulWidget {

  ApplyLeaveViewHelp(
      {
        super.key,
      });


  @override
  ApplyLeaveViewHelpState createState() => ApplyLeaveViewHelpState();
}

class ApplyLeaveViewHelpState extends State<ApplyLeaveViewHelp> {

  bool showLoaderView = false;

  Color dutyInBgColor = redColor1;
  Color dutyInFontColor = whiteColor;
  Color dutyInShadowColor = Colors.black.withOpacity(0.2);


  Color dutyOutBgColor = isDarkMode? greyColor5:greyColor1;
  Color dutyOutFontColor = isDarkMode? greyColor7:greyColor4;
  Color dutyOutShadowColor = Colors.transparent;




  DateTime _focusedDay = DateTime.now();
  Color calendarDaysColor = isDarkMode ? whiteColor : greyColor6;
  BoxShape calendarBoxShape = BoxShape.circle;


  List<DateTime> leaveApplied = [];

String leaveFrom = 'DD/MM/YYYY';
String leaveTo = 'DD/MM/YYYY';


  List<String> daysItems = ['single_day'.tr(), 'multiple_day'.tr()];
  int selectedIndex = 0;
  bool showToastMessageView = false;
  String toastMessage = '';
  int numberOfLeavesApplied = 0;

  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
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
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).padding.top+pathS/12,
                      left: paddingLeft +pathS/3,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
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
                              'apply_for_leave'.tr(),
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


                    Padding(
                      padding: EdgeInsets.only(left: 0, top: MediaQuery.of(context).padding.top +pathS), // Adjust top and left as needed

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          SizedBox(
                            width: screenWidth,

                          ),

                          Container(
                            // height: screenHeight- 1.9*pathS-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [

                                  Padding(
                                    padding:  EdgeInsets.only(left: paddingLeft+pathS/5,bottom: pathS/3),
                                    child:  RadioButtonGroup(
                                      items: daysItems,
                                      selectedId: selectedIndex,
                                      callback: (int index) {
                                        setState(() {
                                          selectedIndex = index;
                                          leaveFrom = 'DD/MM/YYYY';
                                          leaveTo = 'DD/MM/YYYY';
                                          leaveApplied = [];
                                          numberOfLeavesApplied = 0;

                                        });

                                      },
                                    ),

                                  ),

                                  Padding(
                                    padding:  EdgeInsets.only(left: paddingLeft+pathS/4.5,right: paddingRight+pathS/4.5),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: pathL*1.15 ,
                                              child: Text(
                                                'from'.tr(),
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor6,
                                                  fontSize: pathS /5.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: pathL*1.15,
                                              height: pathS/1.2,
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
                                              child: Text(
                                                leaveFrom,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor4,
                                                  fontSize: pathS /5.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(height: pathS/2),
                                          ],

                                        ),

                                        Spacer(),
                                        Column(
                                          children: [
                                            Container(
                                              width: pathL*1.15 ,
                                              child: Text(
                                                'to'.tr(),
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor6,
                                                  fontSize: pathS /5.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: pathL*1.15 ,
                                              height: pathS/1.2,
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
                                              child: Text(
                                                leaveTo,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor4,
                                                  fontSize: pathS /5.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(height: pathS/2),
                                          ],

                                        ),
                                      ],


                                    ),
                                  ),


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
                                            color: isDarkMode ? whiteColor:greyColor4,

                                          ),
                                        ),

                                      ),
                                      SizedBox(width: pathS/5),
                                      Text(
                                        DateFormat.yMMMM(selectedLocale).format(_focusedDay),
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /4,
                                          fontWeight: FontWeight.w500,
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
                                            color: isDarkMode ? whiteColor:greyColor4,

                                          ),
                                        ),

                                      ),
                                    ],
                                  ),
                                  SizedBox(height: pathS/5),
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
                                                  setState(() {
                                                    if (focusedDay.isBefore(DateTime.now()) || focusedDay.isAtSameMomentAs(DateTime.now())) {
                                                      showToastView('Date_Not_Allowed'.tr());
                                                      return; // Do nothing if focusedDay is before or equal to current date
                                                    }


                                                    if (selectedIndex == 0) {
                                                      // Single Day selection
                                                      leaveFrom = getDateTime(focusedDay);
                                                      leaveTo = leaveFrom;
                                                      leaveApplied = [focusedDay];
                                                      numberOfLeavesApplied = 1;
                                                    }
                                                    else {
                                                      // Multiple Day selection
                                                      if (leaveApplied.isEmpty || leaveApplied.length == 2) {
                                                        // Start a new selection
                                                        leaveFrom = getDateTime(focusedDay);
                                                        leaveTo = 'DD/MM/YYYY'; // Placeholder for the leaveTo date
                                                        leaveApplied = [focusedDay];
                                                        numberOfLeavesApplied = 0;
                                                      }
                                                      else if (leaveApplied.length == 1 && leaveApplied.first.isBefore(focusedDay)) {
                                                        // Complete the selection

                                                        leaveTo = getDateTime(focusedDay);
                                                        leaveApplied.add(focusedDay);
                                                        numberOfLeavesApplied = leaveApplied.last.difference(leaveApplied.first).inDays + 1;

                                                      }
                                                    }


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
                                  SizedBox(height: pathS/3),


                                ],
                              ),
                            ),
                          )


                        ],
                      ),
                    ),

                    Positioned(
                      bottom: paddingBottom+pathS/12,
                        child:GestureDetector(
                          onTap: (){
                            onTapRasiseRequest();

                          },
                          child: Container(
                            width: pathL*1.2,
                            height: pathS / 1.7,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:  isDarkMode ? redColor3:redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                              borderRadius: BorderRadius.circular(pathS/3),
                              boxShadow: [
                                BoxShadow(
                                  color:  shadowColor,
                                  blurRadius: pathS/10, // Spread of the shadow
                                  // spreadRadius: pathS/15, // How far the shadow extends
                                  offset:  Offset(-pathS/12, pathS/12),
                                ),
                              ],
                            ),
                            child: Text(
                              'raise_request'.tr(),
                              style: TextStyle(
                                color: isDarkMode ? whiteColor:whiteColor,
                                fontSize: pathS / 4.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ),

                    Container(
                      width: logicalWidth,
                      height: logicalHeight,
                      color: Colors.black.withOpacity(0.8),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 0, top: MediaQuery.of(context).padding.top +pathS), // Adjust top and left as needed

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          SizedBox(
                            width: screenWidth,

                          ),

                          Container(
                            // height: screenHeight- 1.9*pathS-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
                            child: Column(
                              children: [

                                Padding(
                                  padding:  EdgeInsets.only(left: paddingLeft+pathS/5,bottom: pathS/3),
                                  child:  RadioButtonGroup(
                                    items: daysItems,
                                    selectedId: selectedIndex,
                                    callback: (int index) {
                                      setState(() {
                                        selectedIndex = index;
                                        leaveFrom = 'DD/MM/YYYY';
                                        leaveTo = 'DD/MM/YYYY';
                                        leaveApplied = [];
                                        numberOfLeavesApplied = 0;

                                      });

                                    },
                                  ),

                                ),

                                Padding(
                                  padding:  EdgeInsets.only(left: paddingLeft+pathS/4.5,right: paddingRight+pathS/4.5),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: pathL*1.15 ,
                                            child: Text(
                                              'from'.tr(),
                                              style: TextStyle(
                                                color: isDarkMode ?  whiteColor:greyColor6,
                                                fontSize: pathS /5.5,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto',
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: pathL*1.15,
                                            height: pathS/1.2,
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
                                            child: Text(
                                              leaveFrom,
                                              style: TextStyle(
                                                color: isDarkMode ?  whiteColor:greyColor4,
                                                fontSize: pathS /5.5,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(height: pathS/2),
                                        ],

                                      ),

                                      Spacer(),
                                      Column(
                                        children: [
                                          Container(
                                            width: pathL*1.15 ,
                                            child: Text(
                                              'to'.tr(),
                                              style: TextStyle(
                                                color: isDarkMode ?  whiteColor:greyColor6,
                                                fontSize: pathS /5.5,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto',
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: pathL*1.15 ,
                                            height: pathS/1.2,
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
                                            child: Text(
                                              leaveTo,
                                              style: TextStyle(
                                                color: isDarkMode ?  whiteColor:greyColor4,
                                                fontSize: pathS /5.5,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(height: pathS/2),
                                        ],

                                      ),
                                    ],


                                  ),
                                ),


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
                                          color: isDarkMode ? whiteColor:greyColor4,

                                        ),
                                      ),

                                    ),
                                    SizedBox(width: pathS/5),
                                    Text(
                                      DateFormat.yMMMM(selectedLocale).format(_focusedDay),
                                      style: TextStyle(
                                        color: isDarkMode ?  whiteColor:greyColor6,
                                        fontSize: pathS /4,
                                        fontWeight: FontWeight.w500,
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
                                          color: isDarkMode ? whiteColor:greyColor4,

                                        ),
                                      ),

                                    ),
                                  ],
                                ),
                                SizedBox(height: pathS/5),
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
                                                setState(() {
                                                  if (focusedDay.isBefore(DateTime.now()) || focusedDay.isAtSameMomentAs(DateTime.now())) {
                                                    showToastView('Date_Not_Allowed'.tr());
                                                    return; // Do nothing if focusedDay is before or equal to current date
                                                  }


                                                  if (selectedIndex == 0) {
                                                    // Single Day selection
                                                    leaveFrom = getDateTime(focusedDay);
                                                    leaveTo = leaveFrom;
                                                    leaveApplied = [focusedDay];
                                                    numberOfLeavesApplied = 1;
                                                  }
                                                  else {
                                                    // Multiple Day selection
                                                    if (leaveApplied.isEmpty || leaveApplied.length == 2) {
                                                      // Start a new selection
                                                      leaveFrom = getDateTime(focusedDay);
                                                      leaveTo = 'DD/MM/YYYY'; // Placeholder for the leaveTo date
                                                      leaveApplied = [focusedDay];
                                                      numberOfLeavesApplied = 0;
                                                    }
                                                    else if (leaveApplied.length == 1 && leaveApplied.first.isBefore(focusedDay)) {
                                                      // Complete the selection

                                                      leaveTo = getDateTime(focusedDay);
                                                      leaveApplied.add(focusedDay);
                                                      numberOfLeavesApplied = leaveApplied.last.difference(leaveApplied.first).inDays + 1;

                                                    }
                                                  }


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
                                SizedBox(width: pathS/3),
                                Image.asset(
                                  'assets/images/sync/tapx.png',
                                  width: pathS/2.2,
                                  height: pathS/1.4,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: pathL,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white.withOpacity(0.2),width: 1),
                                color:Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(pathS/8),
                                boxShadow: [
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: pathS/2, right: pathS/2, top: pathS/5, bottom: pathS/5),
                                child: Text(
                                  'Select your date for leave',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: pathS/4.5,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
        );
      },
    );

  }

  Color getBackgroundColor(DateTime date) {
    printInDebug('$date');
    calendarDaysColor = isDarkMode ? whiteColor : greyColor6;
    calendarBoxShape = BoxShape.circle;

    if (leaveApplied.isNotEmpty && (leaveApplied.first.isBefore(date) || leaveApplied.first.isAtSameMomentAs(date)) && (leaveApplied.last.isAfter(date) || leaveApplied.last.isAtSameMomentAs(date))) {
      // Return red for days within the leaveApplied range
      calendarBoxShape = BoxShape.circle;
      calendarDaysColor = whiteColor;
      return redColor3;
    }
    else {
      // Return default color for other days
      calendarBoxShape = BoxShape.circle;
      return Colors.transparent;
    }


  }
  void initialSetup() {

  }

  String getDateTime(DateTime focusedDay) {
    return DateFormat('dd/MM/yyyy').format(focusedDay);
  }
  void showToastView(String message) {
    setState(() {
      showToastMessageView = true;
      toastMessage = message;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showToastMessageView = false;
      });
    });
  }

  onTapRasiseRequest(){
    if(selectedIndex == 0 && leaveApplied.length != 1){
      showToastView('select_your_date_for_leave'.tr());
      return;
    }
    if(selectedIndex == 1 && leaveApplied.length != 2){
      showToastView('select_your_date_for_leave'.tr());
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectLeaveReasonHelp(leaveDays: numberOfLeavesApplied, appliedLeave: leaveApplied,),
      ),
    );
  }

}







class RadioButton extends StatelessWidget {
  final int id;
  final Function(int) callback;
  final int selectedID;
  late double controlSize;
  final Color color;
  final double textSize;
  final String name;

  RadioButton({
    required this.id,
    required this.callback,
    required this.selectedID,
    this.controlSize = 28,
    this.color = Colors.white,
    this.textSize = 14,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final size = pathS/5.5;
    controlSize = pathS/4;

    return Padding(
      padding: EdgeInsets.only(right: 1),
      child: GestureDetector(
        onTap: () {
          callback(id);
        },
        child: Row(

          children: [

            Icon(
              selectedID == id ? Icons.radio_button_checked : Icons.radio_button_off,
              size: controlSize,
              color: isDarkMode ? whiteColor:greyColor3,
            ),
            SizedBox(width: pathS/8),
            Container(
              // width: pathL,
              child: Text(
                name,
                style: TextStyle(
                  color: isDarkMode ? whiteColor:greyColor6,
                  fontSize: size,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}

class RadioButtonGroup extends StatelessWidget {
  final List<String> items;
  final int selectedId;
  final Function(int) callback;

  RadioButtonGroup({
    required this.items,
    required this.selectedId,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final name = entry.value;

        return Expanded(
          child: RadioButton(
            id: index,
            callback: radioGroupCallback,
            selectedID: selectedId,
            name: name,
          ),
        );
      }).toList(),
    );
  }

  void radioGroupCallback(int id) {
    callback(id);
  }
}