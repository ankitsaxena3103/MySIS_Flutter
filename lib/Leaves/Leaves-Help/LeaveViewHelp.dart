import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Leaves/ApplyLeaveView.dart';

import 'LeaveApplicationStatusViewHelp.dart';
import 'LeaveRecordsViewHelp.dart';

class LeaveViewHelp extends StatefulWidget {
  @override
  LeaveViewHelpState createState() => LeaveViewHelpState();
}

class LeaveViewHelpState extends State<LeaveViewHelp>{

bool noData = false;
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [

          Container(
            width: logicalWidth,
            height: logicalHeight,
            decoration:  BoxDecoration(
              shape: BoxShape.rectangle,
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
                          'txt_leaves'.tr(),
                          style: TextStyle(
                            color: isDarkMode ?  whiteColor:greyColor6,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.normal,
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
                    GestureDetector(
                      onTap: (){
                        onLoadApplyLeave();

                      },
                      child: Container(
                        width: pathL*2,
                        height: pathS / 1.5,
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
                          'apply_for_leave'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor:whiteColor,
                            fontSize: pathS / 4.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: pathS/5),
                    GestureDetector(
                      onTap: (){
                        onLoadLeaveStatus();

                      },
                      child: Container(
                        width: pathL*2,
                        height: pathS / 1.5,
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
                          'leave_application_status'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor:whiteColor,
                            fontSize: pathS / 4.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: pathS/5),
                    GestureDetector(
                      onTap: (){
                        onLoadLeaveRecord();
                      },
                      child: Container(
                        width: pathL*2,
                        height: pathS / 1.5,
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
                          'leave_records'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor:whiteColor,
                            fontSize: pathS / 4.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: noData,
                      child: Text(
                        'no_data_available'.tr(),
                        style: TextStyle(
                          color: isDarkMode ? whiteColor:greyColor6,
                          fontSize: pathS / 6.5,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),


                  ],
                ),
                Container(
                  color: Colors.black.withOpacity(0.8),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        onLoadApplyLeave();

                      },
                      child: Container(
                        width: pathL*2,
                        height: pathS / 1.5,
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
                          'apply_for_leave'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor:whiteColor,
                            fontSize: pathS / 4.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: pathS*3.33),
                        Image.asset(
                          'assets/images/sync/tapx.png',
                          width: pathS/2.2,
                          height: pathS/1.4,
                        ),
                      ],
                    ),
                    SizedBox(height: pathS),
                  ],
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
                  'Click here to Apply for leave',
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
    );
  }


  void onLoadApplyLeave(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyLeaveView(userLeaves: [],),
      ),
    );
  }
void onLoadLeaveStatus(){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LeaveApplicationStatusViewHelp(),
    ),
  );
}
void onLoadLeaveRecord(){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LeaveRecordsView(),

    ),


  );


}


}
