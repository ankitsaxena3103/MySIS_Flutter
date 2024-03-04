
// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import '../CommonViews/ToastMessageView.dart';


class CancelRequestView extends StatelessWidget {

  final String reason ;
  final String date ;

  final void Function(int) callBack;



  CancelRequestView({
    required this.callBack, required this.reason, required this.date,
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

                                      Text(
                                        'are_you_sure_you_want_to_cancel_leave'.tr(),
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /4,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: pathS),
                                      Text(
                                        date,
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /2.5,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: pathS/8),
                                      Text(
                                        'reason_for_leaves_txt'.tr() + ' ' + '$reason',
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /5.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                      SizedBox(height: pathS/8),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'approved_leaves'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ?  greenColor6:greenColor6,
                                              fontSize: pathS /5.5,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(width: pathS/12),
                                          Image.asset(
                                            'assets/images/icons/status-done.png',
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: pathS/2),
                                      GestureDetector(
                                        onTap: (){
                                          callBack(1);

                                        },
                                        child: Container(
                                          width: pathL*1.5,
                                          height: pathS / 2,
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
                                            'yes_i_want_to_cancel'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:whiteColor,
                                              fontSize: pathS / 4.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

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





