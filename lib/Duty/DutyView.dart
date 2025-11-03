
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Duty/DutyDetailView.dart';
import 'package:mysis/Leaves/LeaveType.dart';
import 'package:mysis/Leaves/UserLeaves.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../CommonViews/ToastMessageView.dart';
import '../HomeView/UserAttendance.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';
import '../SharedClasses/LanguageProvider.dart';
import 'DutyLeaveDetailView.dart';

class DutyView extends StatefulWidget {

  const DutyView(
      {
        super.key,
      });


  @override
  DutyViewState createState() => DutyViewState();
}

class DutyViewState extends State<DutyView> {

  bool showLoaderView = false;

  Color calendarBgColor = Colors.white;


  List<Color>  calendarColorsLight = [greenColor1,pinkColor,yellowColor1,greenColor6,greyColor2,orangeColor];
  List<Color>  calendarColorsDark = [greenColor1,pinkColor,yellowColor1,greenColor6,greyColor1,orangeColor];

  Color calendarDayTextColor = isDarkMode ? whiteColor : greyColor6;
  BoxShape calendarBoxShape = BoxShape.circle;

  List<int> shortDuties = [0];


  List <UserAttendance> userAttendance = [];

  List <UserLeaves> userLeaves = [];
  List <LeaveType> leaveType = [];

  Color dutyColor = Color(0xFFCAF5DD);
  Color unSyncedDataColor = yellowColor1;

  Color approvedLeaveColor = greenColor6;
  Color appliedLeaveColor = greyColor1;

  Color fixedDutyOffColor = Color(0xFFCAF5DD);
  Color shortDutyColor = Color(0xFFCAF5DD);
  bool isNoData = false;
  bool isNotSyncedData = false;

  DateTime focusedDay = DateTime.now();

  String loaderMessage = '';

  bool showToastMessageView = false;
  String toastMessage = '';


  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    double dotSize = pathS/6;
    calendarDayTextColor = isDarkMode ? whiteColor : greyColor6;
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

                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).padding.left, top: MediaQuery.of(context).padding.top + pathS/1.2), // Adjust top and left as needed

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth,
                            height: pathS/3,

                          ),
                          SingleChildScrollView(
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
                                          focusedDay = DateTime(
                                            focusedDay.year,
                                            focusedDay.month - 1,
                                          );

                                        });
                                        updateDataRelatedFags(focusedDay);
                                      },
                                      child:  SizedBox(
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
                                      DateFormat.yMMM(selectedLocale).format(focusedDay),
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
                                          focusedDay = DateTime(
                                            focusedDay.year,
                                            focusedDay.month + 1,
                                          );

                                        });
                                        updateDataRelatedFags(focusedDay);
                                      },
                                      child:  SizedBox(
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
                                SizedBox(height: pathS/2),

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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: dotSize,
                                                        width: dotSize,

                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: dutyColor,
                                                        ),
                                                      ),
                                                      SizedBox(width: pathS/8),
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
                                                  SizedBox(height: pathS/8),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: dotSize,
                                                        width: dotSize,

                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: shortDutyColor,
                                                        ),
                                                      ),
                                                      SizedBox(width: pathS/8),
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
                                                  SizedBox(height: pathS/8),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: dotSize,
                                                        width: dotSize,

                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: fixedDutyOffColor,
                                                        ),
                                                      ),
                                                      SizedBox(width: pathS/8),
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

                                                ],
                                              ),



                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: dotSize,
                                                        width: dotSize,

                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: unSyncedDataColor,
                                                        ),
                                                      ),
                                                      SizedBox(width: pathS/8),
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
                                                  SizedBox(height: pathS/8),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: dotSize,
                                                        width: dotSize,

                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: appliedLeaveColor,
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
                                                  SizedBox(height: pathS/8),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: dotSize,
                                                        width: dotSize,

                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: approvedLeaveColor,
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


                                                ],
                                              ),


                                            ],
                                          ),

                                        ),
                                      ),


                                    ],
                                  ),

                                ),//calendar colors tiles

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
                                              focusedDay: focusedDay,
                                              rowHeight: pathS / 1.5,
                                              firstDay: DateTime.now().subtract(Duration(days: 36500)),
                                              lastDay: DateTime.now().add(Duration(days: 36500)),
                                              calendarFormat: CalendarFormat.month,
                                              locale: selectedLocale,
                                              calendarBuilders: CalendarBuilders(
                                                defaultBuilder: (context, day, events) {
                                                  // Get duty count for the day
                                                  double dutyCount = getDutyCountForDay(day); // your custom method

                                                  return Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.all(pathS / 12),
                                                        decoration: BoxDecoration(
                                                          color: getBackgroundColor(day),
                                                          shape: calendarBoxShape,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '${day.day}',
                                                            style: TextStyle(
                                                              color: calendarDayTextColor,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: pathS / 6,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      if (dutyCount > 1 )
                                                        Positioned(
                                                          top: 4,
                                                          right: 4,
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                                            decoration: BoxDecoration(
                                                              color: Colors.white, // White background
                                                              border: Border.all(color: redColor3, width: 1), // Red border
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: Text(
                                                              '$dutyCount',
                                                              style: TextStyle(
                                                                color: redColor3, // Red text
                                                                fontSize: pathS / 8,
                                                                fontWeight: FontWeight.w700,
                                                                fontFamily: 'Roboto',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              daysOfWeekStyle: DaysOfWeekStyle(
                                                weekdayStyle: TextStyle(color: isDarkMode ? whiteColor : greyColor6),
                                                weekendStyle: TextStyle(color: isDarkMode ? whiteColor : greyColor6),
                                              ),
                                              onDaySelected: (selectedDay, focusedDay) {
                                                List<UserAttendance> selectedAttendance = getAttendanceForDate(selectedDay);
                                                List<UserLeaves> selectedLeaves = getLeaveForDate(selectedDay);

                                                if (selectedAttendance.isNotEmpty || selectedLeaves.isNotEmpty) {
                                                  onLoadDutyDetails(selectedDay, selectedAttendance, selectedLeaves);
                                                }
                                              },
                                            ),

                                          ),

                                        ),
                                      ),


                                    ],
                                  ),

                                ),//calendar summary
                              ],
                            ),
                          )

                        ],
                      ),
                    ),

                    Positioned(
                      bottom: MediaQuery.of(context).padding.bottom + pathS/5  ,
                      child: GestureDetector(
                        onTap: (){
                          onTapSync();
                        },
                        child: Visibility(
                          visible: isNotSyncedData,
                          child: Container(
                            // width: pathL*1.3,
                            // height: pathS / 1.5,
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
                            child: Padding(
                              padding:  EdgeInsets.only(left: pathS/3,right: pathS/3,top: pathS/8,bottom: pathS/8),
                              child: Text(
                                'sync_now'.tr().toUpperCase(),
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor:whiteColor,
                                  fontSize: pathS / 5.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    LoaderView(isVisible: showLoaderView, message: loaderMessage),
                    ToastMessageView(isVisible: showToastMessageView, message: toastMessage),

                  ],
                )
            ),
          ),
        );
      },
    );
  }

  void initialSetup() {
    getAttendanceTableData();

    getLeaveTypeTableData();
    getUserLeaveTableData();

  }

  Future<void> updateDataRelatedFags(DateTime dateTime) async {
    List<UserAttendance> unSyncAttendanceData = await getUnSyncedAttendanceForMonth(dateTime);

    List<UserLeaves> unSyncLeavesData = await getUnSyncedLeavesForMonth(dateTime);


      if(unSyncAttendanceData.isNotEmpty || unSyncLeavesData.isNotEmpty){
        setState(() {
          isNotSyncedData = true;
        });
      }
      else{
        setState(() {
          isNotSyncedData = false;
        });
      }


  }

  Color getBackgroundColor(DateTime date) {
    printInDebug('calender $date');
    calendarDayTextColor = isDarkMode ? whiteColor : greyColor6;
    calendarBoxShape = BoxShape.circle;


    List<UserAttendance> selectedDateAttendance = getAttendanceForDate(date);
    List<UserAttendance> selectedDateUnSyncedAttendance = selectedDateAttendance.isNotEmpty ? getUnSyncAttendanceForDate(selectedDateAttendance) : [];
    // List<UserAttendance> selectedDateShortAttendance = selectedDateAttendance.isNotEmpty ? getShortLeaveAttendanceForDate(selectedDateAttendance) : [];

    List<UserLeaves> selectedDateLeave = userLeaves.isNotEmpty ?  getLeaveForDate(date) : [];

    List<UserLeaves> selectedDateUnSyncedLeave = selectedDateLeave.isNotEmpty ? getUnSyncedLeaveOnDate(selectedDateLeave):[];
    List<UserLeaves> selectedDateAppliedLeave = selectedDateLeave.isNotEmpty ? getAppliedLeaveOnDate(selectedDateLeave) : [];
    List<UserLeaves> selectedDateApprovedLeave = selectedDateLeave.isNotEmpty ? getApprovedLeaveOnDate(selectedDateLeave) : [];
    List<UserLeaves> selectedDateWeeklyOffLeave = selectedDateLeave.isNotEmpty ? getWeeklyOffLeaveOnDate(selectedDateLeave) : [];

    double dutyCount = getDutyCountForDay(date); // your custom method


    if (selectedDateUnSyncedAttendance.isNotEmpty || selectedDateUnSyncedLeave.isNotEmpty) {
       calendarDayTextColor  = brownColor;
        return unSyncedDataColor;
    }
    else if(dutyCount <1 && dutyCount > 0){
      calendarDayTextColor  = redColor3;
      return shortDutyColor;
    }
     else if (dutyCount >=1) {
      // Return red for days 1, 2, 3, 4
      // calendarBoxShape = BoxShape.rectangle;
      calendarDayTextColor  = greenColor6;
      return dutyColor;
    }

    else if (selectedDateApprovedLeave.isNotEmpty) {
      // Return red for days 1, 2, 3, 4
      calendarBoxShape = BoxShape.circle;
      calendarDayTextColor  = whiteColor;
      return approvedLeaveColor;
    }
    else if (selectedDateAppliedLeave.isNotEmpty ) {
      // Return red for days 1, 2, 3, 4
      calendarBoxShape = BoxShape.circle;
      calendarDayTextColor  = greyColor6;
      return appliedLeaveColor;
    }
    else if (selectedDateWeeklyOffLeave.isNotEmpty ) {
      // Return red for days 1, 2, 3, 4
      // calendarBoxShape = BoxShape.rectangle;
      calendarDayTextColor  = Colors.white;
      return fixedDutyOffColor;
    }
    // else if (selectedDateShortAttendance.isNotEmpty) {
    //   // Return red for days 1, 2, 3, 4
    //   // calendarBoxShape = BoxShape.rectangle;
    //   calendarDayTextColor  = whiteColor;
    //   return shortDutyColor;
    // }
    else {
      // Return default color for other days
      calendarBoxShape = BoxShape.circle;
      return Colors.transparent;
    }


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

    final attendance = userAttendances
        .where((data) =>
    data.deleted == 0)
        .toList();

    if(attendance.isNotEmpty) {
      setState(() {
        userAttendance = attendance;
      });
      updateDataRelatedFags(focusedDay);
    }
    else{

    }

  }
  List<UserAttendance> getAttendanceForDate(DateTime currentDate){

    final calenderDateData = userAttendance
        .where((data) =>
    data.shiftStartDate.year == currentDate.year && data.shiftStartDate.month == currentDate.month &&  data.shiftStartDate.day == currentDate.day )
        .toList();

    return calenderDateData;
  }
  List<UserAttendance> getUnSyncAttendanceForDate(List<UserAttendance> attendance){

    final calenderDateData = attendance
        .where((data) =>
    data.dirtyFlag == 1)
        .toList();

    return calenderDateData;
  }
  List<UserAttendance> getShortLeaveAttendanceForDate(List<UserAttendance> attendance) {
    return attendance.where((data) {
      if (data.finalEndTime != null ) {
        // Parse shiftHrs from String to Duration
        Duration? shiftDuration = _parseShiftHours(data.shiftHrs);
        if (shiftDuration != null) {
          return data.finalEndTime!.difference(data.finalStartTime) < shiftDuration;
        }
      }
      return false; // Exclude invalid data
    }).toList();
  }

// Helper method to parse "HH:mm:ss" into a Duration
  Duration? _parseShiftHours(String shiftHrs) {
    try {
      List<String> parts = shiftHrs.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      int seconds = int.parse(parts[2]);
      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }

  Future<void> getLeaveTypeTableData() async {
    final leave = await DatabaseHelper.instance.getAllRecords<LeaveType>(
      keyTableLeaveType,
          (map) => LeaveType.fromMap(map),
    );

    if(leave.isEmpty){
      onLoadLeaveData();
    }else{
      leaveType  = leave;
      updateLeaveColors(leave);

    }

  }
  void onLoadLeaveData() {


    // setState(() {
    //   showLoaderView = true;
    // });
    Map <String,String> inputData = {

    };

    APIHelper.instance.getData(leaveTypeMasterApi,inputData, (data) {

      // setState(() {
      //   showLoaderView = false;
      // });

      if(data.isNotEmpty){
        if (kDebugMode) {
          print(data);
        }
        List<LeaveType> leaveTypeData = data.map((json) => LeaveType.fromJson(json)).toList();

        if(leaveTypeData.isNotEmpty) {
          leaveType  = leaveTypeData;
          updateLeaveColors(leaveType);
          syncLeaveTypeData(leaveType);
        }

      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });
    }
    );

  }
  Future<void> syncLeaveTypeData(List<LeaveType> leaveType) async {
    await DatabaseHelper.instance.replaceTableData<LeaveType>(keyTableLeaveType, leaveType, (leaveType) =>
        leaveType.toMap());
  }
  void updateLeaveColors(List<dynamic> leaveData) {
    for (var leave in leaveData) {
      switch (leave.leaveId) {
        case 100:
          dutyColor = _getColorFromHex(leave.colorCode);
          break;
        // case 0:
        //   unSyncedDataColor = _getColorFromHex(leave.colorCode);
        //   break;
        // case 0:
        //   approvedLeaveColor = _getColorFromHex(leave.colorCode);
        //   break;
        // case 0:
        //   appliedLeaveColor = _getColorFromHex(leave.colorCode);
        //   break;
        case 6:
          fixedDutyOffColor = _getColorFromHex(leave.colorCode);
          break;
        case 103:
            shortDutyColor = _getColorFromHex(leave.colorCode);
            break;
        // case 0:
        //   pastColor = _getColorFromHex(leave.colorCode);
        //   break;

        // Add cases for other LEAVE_TYPEs if needed
        default:
          break;
      }
    }
  }
  Color _getColorFromHex(String hexColor) {
    // Ensure the hex code starts with # and is valid
    if (hexColor.startsWith('#')) {
      hexColor = hexColor.substring(1);
    }
    return Color(int.parse('FF$hexColor', radix: 16));
  }


  Future<void> getUserLeaveTableData() async {
    final userLeavesList = await DatabaseHelper.instance.getAllRecords<UserLeaves>(
      keyTableUserLeave,
          (map) => UserLeaves.fromMap(map),
    );

      final leaves = userLeavesList
          .where((data) =>
      data.deleted == 0 && data.canceled == 0)
          .toList();

        if(leaves.isNotEmpty){
          setState(() {
            userLeaves = leaves;
          });
          updateDataRelatedFags(focusedDay);
        }

    onLoadUserLeavesData();
  }
  void onLoadUserLeavesData() {


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

        List<UserLeaves> userLeavesData = data.map((json) => UserLeaves.fromJson(json)).toList();


        for (var data in userLeavesData) {
          printInDebug('leaves server Data');
          data.toMap().forEach((i, j) {
            printInDebug('$i : $j');
          });
        }

        if(userLeavesData.isNotEmpty) {
          syncUserLeavesData(userLeavesData);
        }


      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

    }
    );

  }
  Future<void> syncUserLeavesData(List<UserLeaves> userLeaves) async {

    await DatabaseHelper.instance.updateOrDeleteTableData<UserLeaves>(
        keyTableUserLeave,
        userLeaves,
        'id',
            (userLeaves) => userLeaves.toMap()
    );

  }

  List<UserLeaves> getLeaveForDate(DateTime selectedDate) {
    final calendarDateData = userLeaves.where((data) {
      // Compare only the date part (year, month, day) of the selectedDate and leave dates
      return (data.leaveStartDate.year < selectedDate.year ||
          (data.leaveStartDate.year == selectedDate.year &&
              data.leaveStartDate.month < selectedDate.month) ||
          (data.leaveStartDate.year == selectedDate.year &&
              data.leaveStartDate.month == selectedDate.month &&
              data.leaveStartDate.day <= selectedDate.day)) &&
          (data.leaveEndDate.year > selectedDate.year ||
              (data.leaveEndDate.year == selectedDate.year &&
                  data.leaveEndDate.month > selectedDate.month) ||
              (data.leaveEndDate.year == selectedDate.year &&
                  data.leaveEndDate.month == selectedDate.month &&
                  data.leaveEndDate.day >= selectedDate.day));
    }).toList();

    return calendarDateData;
  }
  List<UserLeaves> getUnSyncedLeaveOnDate(List<UserLeaves> leave){

    final calenderDateData = leave
        .where((data) =>
    data.dirtyFlag == 1)
        .toList();

    return calenderDateData;
  }
  List<UserLeaves> getAppliedLeaveOnDate(List<UserLeaves> leave){

    final calenderDateData = leave
        .where((data) =>
    data.leaveStatus == keyPendingLeave && data.dirtyFlag == 0 && data.leaveId != 6)
        .toList();

    return calenderDateData;
  }
  List<UserLeaves> getApprovedLeaveOnDate(List<UserLeaves> leave){

    final calenderDateData = leave
        .where((data) =>
    data.leaveStatus == keyApprovedLeave && data.dirtyFlag == 0 &&  data.leaveId != 6)
        .toList();

    return calenderDateData;
  }
  List<UserLeaves> getWeeklyOffLeaveOnDate(List<UserLeaves> leave){

    final calenderDateData = leave
        .where((data) =>
    data.leaveId == 6 && data.dirtyFlag == 0 )
        .toList();

    return calenderDateData;
  }

  void onLoadDutyDetails(DateTime selectedDate,List<UserAttendance> selectedAttendance, List<UserLeaves> selectedLeave ){



    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DutyDetailView(
              selectedDateAttendance: selectedAttendance,
              userAttendance: userAttendance,
              selectedDateLeave: selectedLeave,
              userLeaves: userLeaves,
              selectedDate: selectedDate,

            ),
        )
    );

  }
  void onLoadLeaveDetails(DateTime selectedDate, List<UserLeaves> selectedDateLeave){

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DutyLeaveDetailView(
            selectedDateLeave: selectedDateLeave,
            userLeaves: userLeaves,
            selectedDate: selectedDate,

          ),
        )
    );

  }

  Future<void> onTapSync() async {
    final userAttendance = await DatabaseHelper.instance.getAllRecords<UserAttendance>(
      keyTableUserAttendance,
          (map) => UserAttendance.fromMap(map),
    );


    // Filter the records based on the conditions
    final unSyncAttendance = userAttendance.where((attendance) {
      return attendance.dirtyFlag == 1 ;
    }).toList();

    List<Map<String, dynamic>> unSyncedAttendance =
    unSyncAttendance.map((e) => e.toJson()).toList();


    if(unSyncedAttendance.isNotEmpty) {
      uploadAttendance(unSyncedAttendance);
    }
    else{
      onTapLeaveSync();
    }


  }
  Future<void> uploadAttendance(dynamic attendance) async {

    setState(() {
      loaderMessage = 'trying_to_sync'.tr();
      showLoaderView = true;
    });
    APIHelper.instance.postAllData(userAttendancePostApi, attendance, (responseData) {
      setState(() {
        showLoaderView = false;
      });

      if (responseData.isNotEmpty) {
        showToastView('sync_complete'.tr());

        // Parse the response list directly
        List<dynamic> attendanceList = responseData;

        for (var attendanceRecord in attendanceList) {
          // Parse each attendance record
          Map<String, dynamic> attendance = {
            "id": attendanceRecord['ID'] ?? '',
            "dirtyFlag": 0,
          };
          updateUserAttendanceTable(attendance);

          onTapLeaveSync();

        }
      }
      else {
        // Handle empty response
        printInDebug('Response data is empty.');

      }
    },
          (error) {
        setState(() {
          showLoaderView = true;
        });
        // Handle error
        printInDebug('Error: $error');
      },
    );
  }
  Future<void> onTapLeaveSync() async {
    final userLeaves = await DatabaseHelper.instance.getAllRecords<UserLeaves>(
      keyTableUserLeave,
          (map) => UserLeaves.fromMap(map),
    );

    // Filter the records based on the conditions
    final unSyncLeaves = userLeaves.where((data) {
      return data.dirtyFlag == 1 ;
    }).toList();

    List<Map<String, dynamic>> jsonList =
    unSyncLeaves.map((e) => e.toJson()).toList();


    uploadLeaves(jsonList);
  }
  Future<void> uploadLeaves(dynamic attendance) async {

    setState(() {
      loaderMessage = 'trying_to_sync'.tr();
      showLoaderView = true;
    });
    APIHelper.instance.postAllData(userLeavesPostApi, attendance, (responseData) {
      setState(() {
        showLoaderView = false;
      });

      if (responseData.isNotEmpty) {
        showToastView('sync_complete'.tr());

        // Parse the response list directly
        List<dynamic> attendanceList = responseData;

        for (var attendanceRecord in attendanceList) {
          // Parse each attendance record
          Map<String, dynamic> attendance = {
            "id": attendanceRecord['ID'] ?? '',
            "dirtyFlag": 0,
          };
          updateUserLeavesTable(attendance);
        }
      }
      else {
        // Handle empty response
        printInDebug('Response data is empty.');

      }
    },
          (error) {
        setState(() {
          showLoaderView = true;
        });
        // Handle error
        printInDebug('Error: $error');
      },
    );
  }
  Future<void> updateUserAttendanceTable(Map <String,dynamic> attendance) async{
    await DatabaseHelper.instance.updateTableColumns(
        keyTableUserAttendance,
        attendance,
        'id'
    );

  }
  Future<void> updateUserLeavesTable(Map <String,dynamic> leaves) async{
    await DatabaseHelper.instance.updateTableColumns(
        keyTableUserLeave,
        leaves,
        'id'
    );

  }

  Future<List<UserAttendance>> getUnSyncedAttendanceForMonth(DateTime dateTime) async {


    // Filter the records based on the conditions
    final unSyncAttendance = userAttendance.where((attendance) {
      return attendance.dirtyFlag == 1 &&
          attendance.shiftStartDate.year == dateTime.year &&
          attendance.shiftStartDate.month == dateTime.month ;
    }).toList();



    return unSyncAttendance;

  }
  Future<List<UserLeaves>> getUnSyncedLeavesForMonth(DateTime dateTime) async {


    // Filter the records based on the conditions
    final unSyncLeaves = userLeaves.where((leave) {
      return leave.dirtyFlag == 1 &&
          leave.leaveStartDate.year == dateTime.year &&
          leave.leaveStartDate.month == dateTime.month ;
    }).toList();



    return unSyncLeaves;

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

  double getDutyCountForDay(DateTime day) {
    List<UserAttendance> attendance = getAttendanceForDate(day);
    if (attendance.isEmpty) return 0;
    double total = 0;
    for (var att in attendance) {
      total += att.dutyCount; // or att.dutyFraction
    }
    return total;
  }

}