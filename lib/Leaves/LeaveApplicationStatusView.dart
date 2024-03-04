

import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Leaves/ApplyLeaveView.dart';
import 'package:mysis/Leaves/CancelRequestView.dart';

import '../CommonViews/SuccessAlertView.dart';

class LeaveApplicationStatusView extends StatefulWidget {
  @override
  LeaveApplicationStatusViewState createState() => LeaveApplicationStatusViewState();
}

class LeaveApplicationStatusViewState extends State<LeaveApplicationStatusView>{

  bool isNoData = false;
  bool isUnsyncedData = true;

  bool isSucces  = false;
  bool isCancel = false;
  String leaveReason = '';
  String leaveDate = '';

  List <Map> leaves = [
    {
      'status' : 'in_progress',
      'reason' : 'Family Reason',
      'leaveDate' : '25 Feb - 26 Feb',
      'noOfDays' : '2'
    },
    {
      'status' : 'pending',
      'reason' : 'Personal Reason',
      'leaveDate' : '25 Feb - 24 Mar',
      'noOfDays' : '28 Days'
    },
    {
      'status' : 'approved',
      'reason' : 'Personal Reason',
      'leaveDate' : '25 Feb - 24 Mar',
      'noOfDays' : '28'
    },

  ];

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
    isNoData = leaves.length > 0 ? false : true;

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
                          'leave_application_status'.tr(),
                          style: TextStyle(
                            color: isDarkMode ?  whiteColor:greyColor6,
                            fontSize: pathS / 5,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.left,
                        ),

                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isNoData,
                  child: Padding(
                    padding:  EdgeInsets.all(pathS/2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'no_leave_status'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
                            fontSize: pathS / 4,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: pathS/12),
                        Text(
                          'no_leave_available'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor3,
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
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+pathS/1.5),
                  child: ListView.builder(
                    itemCount: leaves.length, // Change this to the number of times you want to repeat the top column
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:  EdgeInsets.only(bottom: pathS/5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: screenWidth - 2*marginValue,
                              // height: pathS/1.2,
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
                              child: Padding(
                                padding:  EdgeInsets.only(bottom: pathS/4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: true,
                                      child: Container(
                                        width: screenWidth-2*marginValue,
                                        height: pathS/2.5,
                                        decoration: BoxDecoration(
                                          color: yellowColor1,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(pathS/8),
                                            topRight: Radius.circular(pathS/8),
                                          ),
                                        ),
                                        child: Padding(
                                          padding:  EdgeInsets.only(left: pathS/4),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                  'assets/images/icons/unsync.png'
                                              ),
                                              SizedBox(width: pathS/8),
                                              Text(
                                                'unsynced_data'.tr(),
                                                style: TextStyle(
                                                  color: isDarkMode ?  redColor2:redColor2,
                                                  fontSize: pathS /6.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: pathS/4),

                                    Padding(
                                      padding:  EdgeInsets.only(left: pathS/4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:  EdgeInsets.only(right: pathS/4),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  width: pathL,
                                                  child: Text(
                                                    leaves[index]['reason'] + '  ' + leaves[index]['noOfDays'] +' '+ 'day'.tr(),
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteColor:greyColor6,
                                                      fontSize: pathS /6.5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                // SizedBox(width: pathS/8),
                                                // Text(
                                                //   '2' +' '+ 'day'.tr() ,
                                                //   style: TextStyle(
                                                //     color: isDarkMode ?  whiteColor:greyColor6,
                                                //     fontSize: pathS /6.5,
                                                //     fontWeight: FontWeight.normal,
                                                //     fontFamily: 'Roboto',
                                                //   ),
                                                //   textAlign: TextAlign.left,
                                                // ),
                                                Spacer(),
                                                Container(
                                                  alignment: Alignment.centerRight,
                                                  width: pathL,
                                                  child: Text(
                                                    '${leaves[index]['status']}'.tr() ,
                                                    style: TextStyle(
                                                      color: getStatusColor('${leaves[index]['status']}'),
                                                      fontSize: pathS /6.5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                                SizedBox(width: pathS/12),
                                                Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Image.asset(
                                                    getAssetImage('${leaves[index]['status']}'),
                                                    width: pathS/4,
                                                    height: pathS/4,

                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: pathS/5),
                                          Text(
                                            '${leaves[index]['leaveDate']}',
                                            style: TextStyle(
                                              color: isDarkMode ?  whiteColor:greyColor6,
                                              fontSize: pathS /3.5,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: pathS/8),
                                    Visibility(
                                      visible: '${leaves[index]['status']}' == 'approved',
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 1,
                                            color: isDarkMode ? greyColorDark:greyColor2,
                                          ),
                                          SizedBox(height: pathS/5),
                                          GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                isCancel = true;
                                                leaveReason = 'Personal Reason';
                                                leaveDate = '25 Feb - 25 Mar';

                                              });

                                            },
                                            child: Container(
                                              width: pathL*1.3,
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
                                                'cancel_request'.tr(),
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


                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                ),


                Visibility(
                  visible: isCancel,
                  child: CancelRequestView(
                    callBack: (int val){
                      setState(() {
                        isCancel = false;
                      });

                      if(val == 1){
                        setState(() {
                          isSucces = true;
                        });

                      }

                    },
                    reason: leaveReason,
                    date: leaveDate,

                  ),
                ),
                Visibility(
                  visible: isSucces,
                  child: SuccessAlertView(
                    callBack: (int val) {
                      setState(() {
                        isSucces = false;

                      });
                    },

                    message: 'leave_cancellation_request_sent'.tr(),),
                ),
              ],
            ),
          ),



        ],
      ),
    );
  }

  String getAssetImage(String status){
    if(status == 'approved') {
      return 'assets/images/icons/status-done.png';
    }
    if(status == 'rejected') {
      return 'assets/images/icons/status-rejected.png';
    }
    else{
      return 'assets/images/icons/status-pending.png';
    }
  }

  void onLoadApplyLeave(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyLeaveView(),
      ),
    );
  }
  void onLoadLeaveStatus(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyLeaveView(),
      ),
    );
  }
  void onLoadLeaveHistory(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyLeaveView(),
      ),
    );
  }

  Color getStatusColor(String status){
    Color statusColor = greyColor6;

    if(status == 'in_progress'){
      statusColor = isDarkMode ? orangeColor:orangeColor1;
    }
    if(status == 'approved'){
      statusColor = isDarkMode ? greenColor5:greenColor6;
    }

    if(status == 'pending'){
      statusColor = isDarkMode ? whiteColor:greyColor6;
    }
    if(status == 'rejected'){
      statusColor = isDarkMode ? redColor1:redColor3;
    }
    if(status == 'completed'){
      statusColor = isDarkMode ? greenColor5:greenColor6;
    }

    return statusColor;
  }

}
