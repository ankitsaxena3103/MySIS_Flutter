
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Profile/UnitDutyPost.dart';
import 'package:mysis/Profile/UserPosting.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';
import '../CommonViews/AlertPopupView.dart';
import '../CommonViews/ToastMessageView.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';
import '../SharedClasses/LanguageProvider.dart';
import 'EscortDuty.dart';
import 'EscortDutyAppliedView.dart';


class ApplyEscortDutyView extends StatefulWidget {

  final UnitDutyPost unitDutyPost;
  final UserPosting userPosting;


  const ApplyEscortDutyView(
      {
        super.key,
        required this.unitDutyPost,
        required this.userPosting,
      });


  @override
  ApplyEscortDutyViewState createState() => ApplyEscortDutyViewState();
}

class ApplyEscortDutyViewState extends State<ApplyEscortDutyView> {


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


  List<DateTime> dutyAppliedDates = [];

  String dutyFrom = 'DD/MM/YYYY';
  String dutyTo = 'DD/MM/YYYY';


  int selectedIndex = 1;
  bool showToastMessageView = false;
  String toastMessage = '';
  int numberOfDutiesApplied = 0;

  Color unSyncedDataColor = yellowColor1;


  Color fixedDutyOffColor = Color(0xFFCAF5DD);
  Color shortDutyColor = Color(0xFFCAF5DD);

  List<EscortDuty> escortDuties = [];


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
                      top: 0,
                      child: Container(
                        width: screenWidth,
                        height: pathS / 1.1,
                        alignment: Alignment.center,
                        color: isDarkMode ? greyColor6:whiteColor,

                      ),
                    ),

                    Positioned(
                      top: MediaQuery.of(context).padding.top+pathS/12,
                      // left: paddingLeft +pathS/3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: screenWidth,
                            height: pathS / 1.4,
                            color: isDarkMode ? greyColor6:whiteColor,

                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding:  EdgeInsets.only(left:pathS/4),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: pathS/5,
                                      height: pathS/2,
                                      child: Image.asset(
                                        'assets/images/dashboard-icons/left-arrow.png',
                                        color: isDarkMode ?  whiteColor:greyColor6,

                                      ),

                                    ),
                                    SizedBox(width: pathS/8),
                                    Text(
                                      'New_Escort_Duty'.tr(),
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
                          ),
                          Container(

                            width: MediaQuery.of(context).size.width,
                            color: isDarkMode?greyColor6:whiteColor,

                            child:  Padding(
                              padding:  EdgeInsets.only(left:pathS/1.8,top: pathS/4,bottom: pathS/4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 2*pathL,
                                    child: Text(
                                      widget.userPosting.siteName,
                                      style: TextStyle(
                                        color: isDarkMode ? whiteColor:greyColor6,
                                        fontSize: pathS/5,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(height: pathS/25),
                                  SizedBox(
                                    width: 2*pathL,
                                    child: Text(
                                      widget.unitDutyPost.address,
                                      style: TextStyle(
                                        color: isDarkMode ? whiteColor:greyColor6,
                                        fontSize: pathS/6.5,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(height: pathS/8),
                                  SizedBox(
                                    width: 2*pathL,
                                    child: Text(
                                      widget.unitDutyPost.unitCode,
                                      style: TextStyle(
                                        color: isDarkMode ? whiteColor:greyColor6,
                                        fontSize: pathS/5,
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
                        ],
                      ),
                    ),



                    Padding(
                      padding: EdgeInsets.only(left: 0, top: MediaQuery.of(context).padding.top +pathL*1.35), // Adjust top and left as needed

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
                                                dutyFrom,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor4,
                                                  fontSize: pathS /6,
                                                  fontWeight: FontWeight.normal,
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
                                                dutyTo,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor4,
                                                  fontSize: pathS /6,
                                                  fontWeight: FontWeight.normal,
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

                                                    else  if(getDutyForDate(focusedDay).isNotEmpty ){
                                                      setState(() {
                                                        alertHeader = 'alert'.tr();
                                                        alertMessage = 'duty_assign_for_day'.tr();
                                                        showAlert = true;

                                                      });

                                                    }else{
                                                      if (selectedIndex == 0) {
                                                        // Single Day selection
                                                        dutyFrom = getDateTime(focusedDay);
                                                        dutyTo = dutyFrom;
                                                        dutyAppliedDates = [focusedDay];
                                                        numberOfDutiesApplied = 1;
                                                      }
                                                      else {
                                                        // Multiple Day selection
                                                        if (dutyAppliedDates.isEmpty || dutyAppliedDates.length == 2) {
                                                          // Start a new selection
                                                          dutyFrom = getDateTime(focusedDay);
                                                          dutyTo = 'DD/MM/YYYY';
                                                          dutyAppliedDates = [focusedDay];
                                                          numberOfDutiesApplied = 0;
                                                        }
                                                        else if (dutyAppliedDates.length == 1) {
                                                          // Complete the selection

                                                          if(dutyAppliedDates.first.isBefore(focusedDay)){
                                                            dutyTo = getDateTime(focusedDay);
                                                            dutyAppliedDates.add(focusedDay);
                                                          }else{
                                                            dutyTo = dutyFrom;
                                                            dutyFrom = getDateTime(focusedDay);
                                                            dutyAppliedDates.insert(0, focusedDay);
                                                          }

                                                          numberOfDutiesApplied = dutyAppliedDates.last.difference(dutyAppliedDates.first).inDays + 1;

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
                      bottom: 0,

                      child: GestureDetector(
                        onTap: (){


                        },
                        child: Container(
                          width: screenWidth,
                          height: pathS / 1.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDarkMode ? greyColor6:whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.transparent, // Shadow color
                                blurRadius: pathS/10, // Spread of the shadow
                                // spreadRadius: pathS/15, // How far the shadow extends
                                offset:  Offset(-pathS/12, pathS/12),
                              ),
                            ],
                          ),

                        ),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).padding.bottom,

                      child: Container(
                        width: screenWidth,
                        height: pathS / 1.4,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDarkMode ? greyColor6:whiteColor,
                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                          // borderRadius: BorderRadius.circular(pathS/3),
                          boxShadow: [
                            BoxShadow(
                              color: shadowColor, // Shadow color
                              blurRadius: pathS/15, // Spread of the shadow
                              // spreadRadius: pathS/15, // How far the shadow extends
                              offset:  Offset(-1, -pathS/15),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:  EdgeInsets.only(left: pathS/4,right: pathS/4),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: pathS/5,
                                      height: pathS/2,
                                      child: Image.asset(
                                        'assets/images/dashboard-icons/left-arrow.png',
                                        color: isDarkMode ?  whiteColor:greyColor3,

                                      ),

                                    ),
                                    SizedBox(width: pathS/12),
                                    Text(
                                      'back'.tr().toUpperCase(),
                                      style: TextStyle(
                                        color: isDarkMode ?  redColor1:redColor3,
                                        fontSize: pathS / 5.5,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                  ],
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Container(
                                    decoration:  BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(pathS/4),
                                      color: isDarkMode ?  redColor1:redColor3,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25), // Shadow color
                                          blurRadius: pathS/25, // Spread of the shadow
                                          // spreadRadius: pathS/15, // How far the shadow extends
                                          offset:  Offset(-pathS/48, pathS/18),
                                        ),
                                      ],
                                    ),

                                    child: GestureDetector(
                                      onTap: (){
                                        onTapSubmit();
                                      },
                                      child: Padding(
                                        padding:  EdgeInsets.only(left:pathS/4,right: pathS/4,top: pathS/12,bottom: pathS/15),
                                        child: Text(
                                          'submit'.tr().toUpperCase(),
                                          style: TextStyle(
                                            color: isDarkMode ?  whiteColor:whiteColor,
                                            fontSize: pathS / 5.5,
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
                            ],
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
                          }
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


  Color getBackgroundColor(DateTime date) {
    printInDebug('calender $date');
    calendarDaysTextColor = isDarkMode ? whiteColor : greyColor6;
    calendarBoxShape = BoxShape.circle;

    List<EscortDuty> selectedDateDuty = escortDuties.isNotEmpty ?  getDutyForDate(date) : [];

    if(selectedDateDuty.isNotEmpty){

      Color bgColor =  greyColor6;
      calendarDaysTextColor = Colors.black;
      calendarBoxShape = BoxShape.circle;
      return bgColor;
    }

    else  if (dutyAppliedDates.isNotEmpty &&
        (dutyAppliedDates.first.isBefore(date) || dutyAppliedDates.first.isAtSameMomentAs(date))
        && (dutyAppliedDates.last.isAfter(date) || dutyAppliedDates.last.isAtSameMomentAs(date))) {
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

  List<EscortDuty> getDutyForDate(DateTime selectedDate) {
    final calendarDateData = escortDuties.where((data) {
      return (data.startDate.year < selectedDate.year ||
          (data.startDate.year == selectedDate.year &&
              data.startDate.month < selectedDate.month) ||
          (data.startDate.year == selectedDate.year &&
              data.startDate.month == selectedDate.month &&
              data.startDate.day <= selectedDate.day)) &&
          (data.endDate.year > selectedDate.year ||
              (data.endDate.year == selectedDate.year &&
                  data.endDate.month > selectedDate.month) ||
              (data.endDate.year == selectedDate.year &&
                  data.endDate.month == selectedDate.month &&
                  data.endDate.day >= selectedDate.day));
    }).toList();

    return calendarDateData;
  }
  List<EscortDuty> getUnSyncedDutyOnDate(List<EscortDuty> duty){

    final calenderDateData = duty
        .where((data) =>
    data.dirtyFlag == 1)
        .toList();

    return calenderDateData;
  }


  void onTapSubmit(){
printInDebug('msg');
    if(dutyAppliedDates.length != 2){
      showToastView('duty_dates'.tr());

      return;
    }

    createDuty();
  }

  void createDuty(){

    Map <String, dynamic> duty = createDutiesData();

    // Convert JSON to UserAttendance object
    EscortDuty appliedDuty = EscortDuty.fromJson(duty);

    // Create a list of UserAttendance objects
    List<EscortDuty> appliedDuties = [appliedDuty];

    // Call the sync function
    syncEscortDutyData(
      appliedDuties,
      'id',
    );

    Navigator.of(context).popUntil((route) => route.isFirst);
    Future.delayed(Duration(milliseconds: 3),(){
      loadThanks();
    });

    List<dynamic> data = appliedDuties;

    uploadDuty(data);

  }
  Map <String, dynamic> createDutiesData(){

    String newUuid = Uuid().v4();

    String startDate = DateFormat('yyyy-MM-dd').format(dutyAppliedDates.first);
    String endDate = DateFormat('yyyy-MM-dd').format(dutyAppliedDates.last);

    Map <String, dynamic> duty = {
      "ID": newUuid,
      'UNIT_CODE': widget.userPosting.unitCode,
      'START_DATE': startDate,
      'END_DATE': endDate,
      'STATUS': 0,
      'REGNO': regNo,
      'CREATED_ON': DateTime.now().toIso8601String(),
      'DATE_MODIFIED': DateTime.now().toIso8601String(),
      'DELETED': 0,
      'DIRTY_FLAG': 1,
      'UPDATED_AT':DateTime.now().toIso8601String(),

    };

    printInDebug('Duty Data');
    duty.forEach((key, value) {
      printInDebug('$key : $value');
    });

    return duty;

  }

  Future<void> syncEscortDutyData(
      List<EscortDuty> escortDuties,
      String field,
      ) async {
    await DatabaseHelper.instance.insertTableData<EscortDuty>(
      keyTableEscortDuty,
      escortDuties,
          (data) => data.toMap(),
    );
    for (var data in escortDuties) {
      printInDebug('EscortDuty Data');
      data.toMap().forEach((i, j) {
        printInDebug('$i : $j');
      });
      printInDebug('Inserted ${escortDuties.length} records into $keyTableEscortDuty');

    }
  }

  Future<void> uploadDuty(dynamic data) async {
    APIHelper.instance.postAllData(escortDutyPostApi, data, (responseData) {
      if (responseData.isNotEmpty) {
        // Parse the response list directly
        List<dynamic> list = responseData;

        for (var data in list) {
          // Parse each attendance record
          Map<String, dynamic> duties = {
            "id": data['ID'] ?? '',
            "dirtyFlag": 0,
          };
          updateEscortDutyTable(duties);
        }
      } else {
        // Handle empty response
        printInDebug('Response data is empty.');
      }
    },
          (error) {
        // Handle error
        printInDebug('Error: $error');
      },
    );
  }
  Future<void> updateEscortDutyTable(Map <String,dynamic> duties) async{
    await DatabaseHelper.instance.updateTableColumns(
        keyTableEscortDuty,
        duties,
        'id'
    );

  }



  void loadThanks(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EscortDutyAppliedView(
          escortDutyDays: numberOfDutiesApplied,
          appliedDutyDates: dutyAppliedDates,
          userPosting: widget.userPosting,
          unitDutyPost: widget.unitDutyPost,
        ),
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