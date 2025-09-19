
// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../CommonViews/AlertPopupView.dart';
import '../CommonViews/ToastMessageView.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';
import '../SharedClasses/LanguageProvider.dart';
import 'LeaveType.dart';
import 'SelectLeaveReasonView.dart';
import 'UserLeaves.dart';


class ApplyLeaveView extends StatefulWidget {

  final List<UserLeaves> userLeaves;
  const ApplyLeaveView(
      {
        super.key,
        required this.userLeaves,
      });


  @override
  ApplyLeaveViewState createState() => ApplyLeaveViewState();
}

class ApplyLeaveViewState extends State<ApplyLeaveView> {


  bool showLoaderView = false;

  Color dutyInBgColor = redColor1;
  Color dutyInFontColor = whiteColor;
  Color dutyInShadowColor = Colors.black.withOpacity(0.2);


  Color dutyOutBgColor = isDarkMode? greyColor5:greyColor1;
  Color dutyOutFontColor = isDarkMode? greyColor7:greyColor4;
  Color dutyOutShadowColor = Colors.transparent;


  bool showAlert = false;
  String alertHeader = '';
  String alertMessage = '';


  DateTime _focusedDay = DateTime.now();
  Color calendarDaysTextColor = isDarkMode ? whiteColor : greyColor6;
  BoxShape calendarBoxShape = BoxShape.circle;


  List<DateTime> leaveApplied = [];

String leaveFrom = 'DD/MM/YYYY';
String leaveTo = 'DD/MM/YYYY';


  List<String> daysItems = ['single_day'.tr(), 'multiple_day'.tr()];
  int selectedIndex = 0;
  bool showToastMessageView = false;
  String toastMessage = '';
  int numberOfLeavesApplied = 0;

  Color unSyncedDataColor = yellowColor1;

  Color approvedLeaveColor = greenColor6;
  Color appliedLeaveColor = greyColor1;

  Color fixedDutyOffColor = Color(0xFFCAF5DD);
  Color shortDutyColor = Color(0xFFCAF5DD);

   List<UserLeaves> userLeaves = [];
  List<LeaveType> leavesType = [];


  @override
  void initState() {

    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    DateTime now = DateTime.now();
    calendarDaysTextColor = isDarkMode ? whiteColor : greyColor6;
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
                                        DateFormat.yMMM(selectedLocale).format(_focusedDay),
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
                                                            color: calendarDaysTextColor,
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
                                                      setState(() {
                                                        alertHeader = 'alert'.tr();
                                                        alertMessage = 'Date_Not_Allowed'.tr();
                                                        showAlert = true;

                                                      });
                                                      return; // Do nothing if focusedDay is before or equal to current date
                                                    }

                                                   else  if(getLeaveForDate(focusedDay).isNotEmpty ){
                                                     setState(() {
                                                       alertHeader = 'alert'.tr();
                                                       alertMessage = 'leave_assign_for_day'.tr();
                                                       showAlert = true;

                                                     });

                                                    }else{
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
                                                        else if (leaveApplied.length == 1) {
                                                          // Complete the selection

                                                          if(leaveApplied.first.isBefore(focusedDay)){
                                                            leaveTo = getDateTime(focusedDay);
                                                            leaveApplied.add(focusedDay);
                                                          }else{
                                                            leaveTo = leaveFrom;
                                                            leaveFrom = getDateTime(focusedDay);
                                                            leaveApplied.insert(0, focusedDay);
                                                          }
                                                          numberOfLeavesApplied = leaveApplied.last.difference(leaveApplied.first).inDays + 1;

                                                        }
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
                            onTapRaiseRequest();

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

                    LoaderView(isVisible: showLoaderView, message: 'Loading...'),
                    ToastMessageView(isVisible: showToastMessageView, message: toastMessage),
                    Visibility(
                      visible: showAlert,
                      child: AlertPopupView(
                          header: alertHeader,
                          message: alertMessage,
                          cancelBtn: '',
                          okBtn: 'ok'.tr(),
                        callBack: (value){
                            setState(() {
                              showAlert = false;
                            });
                          },
                      ),
                    )

                  ],
                )
            ),
          ),
        );
      },
    );
  }

  void initialSetup() {
    getLeaveTypeTableData();
   getUserLeaveTableData();
  }

  Future<void> getLeaveTypeTableData() async {
    final leaveTypes = await DatabaseHelper.instance.getAllRecords<LeaveType>(
      keyTableLeaveType,
          (map) => LeaveType.fromMap(map)
    );

    if(leaveTypes.isNotEmpty){
     leavesType = leaveTypes;
    }

  }

  Future<void> getUserLeaveTableData() async {

    final leaves = await DatabaseHelper.instance.getAllRecords<UserLeaves>(
      keyTableUserLeave,
          (map) => UserLeaves.fromMap(map),
    );

    for (var data in leaves) {
      printInDebug('leaves Data');
      data.toMap().forEach((i, j) {
        printInDebug('$i : $j');
      });
    }

    if(leaves.isNotEmpty) {
      // Filter roster data for today
      final leaveData = leaves
          .where((leave) =>
          leave.deleted == 0 && leave.canceled == 0) // Not deleted
          .toList();

      if(leaveData.isNotEmpty){
        setState(() {
          userLeaves = leaveData;
        });
      }
    }



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

  onTapRaiseRequest(){

    if(selectedIndex == 0 && leaveApplied.length != 1){
      showToastView('select_your_date_for_leave'.tr());
      return;
    }
    if(selectedIndex == 1 && leaveApplied.length != 2){
      showToastView('select_your_date_for_leave'.tr());
      return;
    }
    if(numberOfLeavesApplied >7){
      showToastView('leave_count_valid'.tr());
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectLeaveReason(noOfLeaveApplied: numberOfLeavesApplied, appliedLeavesDate: leaveApplied,),
      ),
    );
  }

  Color getBackgroundColor(DateTime date) {
    printInDebug('calender $date');
    calendarDaysTextColor = isDarkMode ? whiteColor : greyColor6;
    calendarBoxShape = BoxShape.circle;

    List<UserLeaves> selectedDateLeave = userLeaves.isNotEmpty ?  getLeaveForDate(date) : [];

    LeaveType? selectedLeaveType = selectedDateLeave.isNotEmpty ? getLeaveTypeById(selectedDateLeave.first.leaveId): null;
    // List<UserLeaves> selectedDateUnSyncedLeave = selectedDateLeave.isNotEmpty ? getUnSyncedLeaveOnDate(selectedDateLeave):[];
    // List<UserLeaves> selectedDateAppliedLeave = selectedDateLeave.isNotEmpty ? getAppliedLeaveOnDate(selectedDateLeave) : [];
    // List<UserLeaves> selectedDateApprovedLeave = selectedDateLeave.isNotEmpty ? getApprovedLeaveOnDate(selectedDateLeave) : [];
    // List<UserLeaves> selectedDateWeeklyOffLeave = selectedDateLeave.isNotEmpty ? getWeeklyOffLeaveOnDate(selectedDateLeave) : [];
    //
    //  if ( selectedDateUnSyncedLeave.isNotEmpty) {
    // // Return red for days 1, 2, 3, 4
    //    calendarDaysColor  = brownColor;
    // return unSyncedDataColor;
    // }
    // else if (selectedDateApprovedLeave.isNotEmpty) {
    //   // Return red for days 1, 2, 3, 4
    //   calendarBoxShape = BoxShape.circle;
    //   calendarDaysColor  = whiteColor;
    //   return approvedLeaveColor;
    // }
    // else if (selectedDateAppliedLeave.isNotEmpty ) {
    //   // Return red for days 1, 2, 3, 4
    //   calendarBoxShape = BoxShape.circle;
    //   calendarDaysColor  = greyColor6;
    //   return appliedLeaveColor;
    // }
    // else if (selectedDateWeeklyOffLeave.isNotEmpty ) {
    //   // Return red for days 1, 2, 3, 4
    //   // calendarBoxShape = BoxShape.rectangle;
    //    calendarDaysColor  = Colors.white;
    //   return fixedDutyOffColor;
    // }

    if(selectedDateLeave.isNotEmpty){

      Color bgColor = selectedLeaveType!= null ?  getColorFromHex(selectedLeaveType!.colorCode) : greyColor6;
      calendarDaysTextColor =  selectedLeaveType?.leaveId == 6 ? Colors.white:Colors.black;
      calendarBoxShape = BoxShape.circle;
      return bgColor;
    }

    else  if (leaveApplied.isNotEmpty &&
         (leaveApplied.first.isBefore(date) || leaveApplied.first.isAtSameMomentAs(date))
         && (leaveApplied.last.isAfter(date) || leaveApplied.last.isAtSameMomentAs(date))) {
       // Return red for days within the leaveApplied range
       calendarBoxShape = BoxShape.circle;
       calendarDaysTextColor = whiteColor;
       return redColor3;
     }

     else {
      // Return default color for other days
      calendarBoxShape = BoxShape.circle;
      return Colors.transparent;
    }


  }

  Color getColorFromHex(String hexColor) {
    // Ensure the hex code starts with # and is valid
    if (hexColor.startsWith('#')) {
      hexColor = hexColor.substring(1);
    }
    return Color(int.parse('FF$hexColor', radix: 16));
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
    data.leaveStatus == keyPendingLeave && data.dirtyFlag == 0)
        .toList();

    return calenderDateData;
  }
  List<UserLeaves> getApprovedLeaveOnDate(List<UserLeaves> leave){

    final calenderDateData = leave
        .where((data) =>
    data.leaveStatus == keyApprovedLeave)
        .toList();

    return calenderDateData;
  }
  List<UserLeaves> getWeeklyOffLeaveOnDate(List<UserLeaves> leave){

    final calenderDateData = leave
        .where((data) =>
    data.leaveId == 6 )
        .toList();

    return calenderDateData;
  }

  LeaveType? getLeaveTypeById(int userLeaveId) {
    for (var data in leavesType) {
      if (data.leaveId == userLeaveId) {
        return data; // Return the matching LeaveType
      }
    }
    return null; // Return null if no matching LeaveType is found
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
            Text(
              name,
              style: TextStyle(
                color: isDarkMode ? whiteColor:greyColor6,
                fontSize: size,
                fontWeight: FontWeight.w500,
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