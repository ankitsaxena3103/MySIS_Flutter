import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/SharedClasses/LanguageProvider.dart';
import 'package:provider/provider.dart';

import '../SharedClasses/ThemeProvider.dart';

class SalaryView extends StatefulWidget {
  @override
  SalaryViewState createState() => SalaryViewState();
}

class SalaryViewState extends State<SalaryView>{

bool noData = true;

DateTime _focusedDay = DateTime.now();
Color calendarDaysColor = isDarkMode ? whiteColor : greyColor6;
BoxShape calendarBoxShape = BoxShape.circle;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  bool showLoaderView = false;

  bool isAlertVisible = false;
  String alertHeader = 'Error!';
  String alertMessage = 'There is an  internal error.';

  bool showToastMessageView = false;
  String toastMessage = '';


  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    double gap = pathS/8;
    return Consumer2<LanguageProvider, ThemeProvider>(
      builder: (context, languageProvider, themeProvider, child) {
        return Material(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                width: logicalWidth,
                height: logicalHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: isDarkMode? backgroundGradientDark : backgroundGradient,
                  // border: Border.all(color: Colors.lightBlue.shade300, width: pathS/18),
                  // borderRadius: BorderRadius.circular(pathS/15),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
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
                              'salary_slip'.tr(),
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
                        Container(
                          width: screenWidth,

                        ),
                        SizedBox(height: pathS),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  _focusedDay = DateTime(
                                    _focusedDay.year-1,
                                    // _focusedDay.month - 1,
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
                              DateFormat.y(selectedLocale).format(_focusedDay),
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
                                    _focusedDay.year +1,
                                    // _focusedDay.month + 1,
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
                          height: screenHeight-pathS*1.2-paddingTop-paddingBottom,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: buildPastMonthItems(_focusedDay.year),
                          ),
                        ),

                      ],
                    ),

                    LoaderView(isVisible: showLoaderView, message: 'Loading...'),

                    ToastMessageView(isVisible: showToastMessageView, message: toastMessage),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

  }


  Widget buildMonthItem(int month, int year) {

// Create a DateTime object with the given month name and year
    DateTime dateTime = DateTime(year, month);

    return Padding(
      padding:  EdgeInsets.only(bottom: pathS/10),
      child: GestureDetector(
        onTap: () {

        },
        child: Container(
          width: 1.7*pathL,
          height: pathS/1.8,
          decoration:  BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(pathS/10),
            color: isDarkMode ? greyColor6:whiteColor,
            boxShadow: [
              BoxShadow(
                color:    shadowColor ,// Shadow color
                blurRadius: pathS/10, // Spread of the shadow
                // spreadRadius: pathS/15, // How far the shadow extends
                offset:  Offset(-pathS/25, pathS/12),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: pathS/4,right: pathS/4), // Adjust top and left as needed
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.MMMM(selectedLocale).format(dateTime),
                      style: TextStyle(
                        color: isDarkMode ? redColor1:redColor3,
                        fontSize: pathS / 5,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),

        ),
      ),
    );

  }


List<Widget> buildPastMonthItems(int currentYear) {

  List<String> monthNames = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER',
  ];
  List<int> monthIndex = [
    1,
   2,
   3,
    4,
   5,
  6,
    7,
    8,
    9,
    10,
    11,
    12,
  ];

  int currentMonthIndex = DateTime.now().month;
  int currentYearIndex = DateTime.now().year;

  int endIndex = 12;

  if(currentYear > currentYearIndex){
    endIndex = 0;
  }

  if(currentYear == currentYearIndex){
    endIndex = currentMonthIndex-1;
  }


  return monthIndex.take(endIndex).map((monthIndex) {
    return buildMonthItem(monthIndex, currentYear);
  }).toList();
}




  void initialSetup() {}


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
}
