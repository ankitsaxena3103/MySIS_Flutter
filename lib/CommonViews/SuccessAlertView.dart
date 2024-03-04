
// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import '../CommonViews/ToastMessageView.dart';


class SuccessAlertView extends StatelessWidget {

final String message ;
  final void Function(int) callBack;


  SuccessAlertView({
    required this.callBack, required this.message,
  });

  DateTime _focusedDay = DateTime.now();
  Color calendarDaysColor = isDarkMode ? whiteColor : greyColor6;
  BoxShape calendarBoxShape = BoxShape.circle;


  DateTime dateSelected = DateTime.now();

  bool showToastMessageView = false;
  String toastMessage = '';

  @override
  void initState() {
    initialSetup();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callBack(0);
      },
      child: Container(
        width: logicalWidth,
        height: logicalHeight,
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Container(

              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).padding.top+pathS/12,
                    right: paddingRight,
                    child: GestureDetector(
                      onTap: (){
                        callBack(0);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: pathS/3,
                            height: pathS/3,
                            child: Image.asset(
                              'assets/images/home/cross.png',
                              color: isDarkMode ?  whiteColor:whiteColor,

                            ),

                          ),

                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [


                      Container(
                        width: screenWidth-2.5*marginValue,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [

                              Container(
                                width: screenWidth-2.5*marginValue,
                                // height: pathL,
                                decoration:  BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(pathS/8),
                                  color: isDarkMode?greyColor6:whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1), // Shadow color
                                      blurRadius: pathS/10, // Spread of the shadow
                                      // spreadRadius: pathS/15, // How far the shadow extends
                                      offset:  Offset(-pathS/12, pathS/12),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:  EdgeInsets.only(top: pathS/2,bottom: pathS/1.5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [

                                      Container(
                                        width: pathS/1.2,
                                        height: pathS/1.2,
                                        child: Image.asset(
                                          'assets/images/dashboard-icons/tick.png',

                                        ),
                                      ),
                                      SizedBox(height: pathS/8),
                                      Text(
                                        message,
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /5.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                    ],
                                  ),
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
  Widget build1(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callBack(0);
      },
      child: Container(
        width: logicalWidth,
        height: logicalHeight,
        color: Colors.black.withOpacity(0.7),
        child: Container(
          child: Center(
            child: Container(
                child: Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).padding.top+pathS/12,
                      right: paddingRight +pathS/3,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Container(
                              width: pathS/3,
                              height: pathS/3,
                              child: Image.asset(
                                'assets/images/home/cross.png',
                                color: isDarkMode ?  whiteColor:whiteColor,

                              ),

                            ),

                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: screenWidth-2.5*marginValue,
                      // height: pathL,
                      decoration:  BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(pathS/8),
                        color: isDarkMode?greyColor6:whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // Shadow color
                            blurRadius: pathS/10, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(-pathS/12, pathS/12),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(top: pathS/3,bottom: pathS/3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            Container(
                              width: pathS/1.2,
                              height: pathS/1.2,
                              child: Image.asset(
                                'assets/images/dashboard-icons/tick.png',

                              ),
                            ),
                            SizedBox(height: pathS/8),
                            Text(
                              message,
                              style: TextStyle(
                                color: isDarkMode ?  whiteColor:greyColor6,
                                fontSize: pathS /5.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                              textAlign: TextAlign.center,
                            ),

                          ],
                        ),
                      ),
                    ),

                    ToastMessageView(isVisible: showToastMessageView, message: toastMessage),

                  ],
                )

            ),
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





