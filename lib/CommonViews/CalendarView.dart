
// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:table_calendar/table_calendar.dart';

import '../CommonViews/ToastMessageView.dart';


class CalendarView extends StatefulWidget {

  final String cancelButtonTitle;
  final String okButtonTitle;

  final void Function(int,String) callBack;


  CalendarView({
    required this.callBack,
    required this.cancelButtonTitle,
    required this.okButtonTitle,
  });

  @override
  CalendarViewState createState() => CalendarViewState();
}

class CalendarViewState extends State<CalendarView> {


  DateTime _focusedDay = DateTime.now();
  Color calendarDaysColor = isDarkMode ? whiteColor : greyColor6;
  BoxShape calendarBoxShape = BoxShape.circle;


  DateTime dateSelected = DateTime.now();

  bool showToastMessageView = false;
  String toastMessage = '';

  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callBack(0,'');
      },
      child: Container(
        width: logicalWidth,
        height: logicalHeight,
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(

              child: Stack(
                children: [

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [


                      Container(
                        color: isDarkMode ? greyColor4:whiteColor,
                        width: screenWidth-2.5*marginValue,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Container(
                                width: screenWidth-2.5*marginValue,
                                color: isDarkMode ? greyColor6 : redColor3,
                                child:Padding(
                                  padding:  EdgeInsets.only(left: pathS/4,top: pathS/4,bottom: pathS/4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('yyyy', selectedLocale).format(dateSelected),
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: pathS /5,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        DateFormat('E, MMM d', selectedLocale).format(dateSelected),
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: pathS /3,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),

                              ),

                              SizedBox(height: pathS/3),

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
                              SizedBox(height: pathS/5),
                              Container(
                                width: screenWidth-2.5*marginValue,
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

                                                dateSelected = focusedDay;


                                              });
                                            },
                                            // Other calendar properties...
                                          ),

                                        ),

                                      ),
                                    ),


                                  ],
                                ),

                              ),

                              SizedBox(height: pathS/1.5),

                              Padding(
                                padding:  EdgeInsets.only(right: pathS/3,bottom: pathS/3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        widget.callBack(0,'');
                                      },
                                      child: Text(
                                        'Cancel'.tr(),
                                        style: TextStyle(
                                          color: isDarkMode ? whiteColor : redColor3,
                                          fontSize: pathS /4,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(width: pathS/4),
                                    GestureDetector(
                                      onTap: (){
                                        widget.callBack(1, DateFormat('dd-MMM-yyyy', selectedLocale).format(dateSelected));
                                      },
                                      child: Text(
                                        'ok'.tr(),
                                        style: TextStyle(
                                          color: isDarkMode ? whiteColor : redColor3,
                                          fontSize: pathS /4,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],

                                ),
                              ),
                              //calendar summary

                            ],
                          ),
                        ),
                      )


                    ],
                  ),

                  ToastMessageView(isVisible: showToastMessageView, message: toastMessage),

                ],
              )

          ),
        ),
      ),
    );
  }

  Color getBackgroundColor(DateTime date) {
    printInDebug('$date');
    calendarDaysColor = isDarkMode ? whiteColor : greyColor6;

    if (dateSelected == date){
      return redColor3;
    }
      return Colors.transparent;
    }
  void initialSetup() {

  }

  String getDateTime(DateTime focusedDay) {
    return DateFormat('dd/MM/yyyy').format(focusedDay);
  }


  }





