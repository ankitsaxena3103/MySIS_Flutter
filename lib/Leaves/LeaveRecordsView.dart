

import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Leaves/ApplyLeaveView.dart';
import 'package:mysis/Leaves/CancelRequestView.dart';
import 'package:mysis/Leaves/UserLeaves.dart';

import '../CommonViews/SuccessAlertView.dart';
import '../SharedClasses/DatabaseHelper.dart';

class LeaveRecordsView extends StatefulWidget {
  const LeaveRecordsView({super.key});

  @override
  LeaveRecordsViewState createState() => LeaveRecordsViewState();
}

class LeaveRecordsViewState extends State<LeaveRecordsView>{

  bool isNoData = false;
  bool isUnSyncedData = true;

  bool isSucces  = false;
  bool isCancel = false;
  String leaveReason = '';
  String leaveDate = '';

  List<UserLeaves> userLeaves = [];

  @override
  void initState() {
    getUserLeaveTableData();
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    isNoData = userLeaves.isNotEmpty ? false : true;

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

                Column(
                  children: [
                    SizedBox(height: pathL),
                    SizedBox(
                      height: screenHeight -pathL,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: userLeaves.map((leave) {
                            return   Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: screenWidth - 2*marginValue,
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
                                        SizedBox(height: pathS/5),

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
                                                        '${leave.leaveTypeName} ${leave.leaveCount} ${'day'.tr()}',
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

                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: pathS/8),
                                              Text(
                                                leave.formattedLeaves,
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


                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: pathS/5),

                              ],
                            );
                          }).toList(),
                        ),
                      ),

                    ),
                  ],
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

    final filteredLeave = leaves.where((leave) =>
        leave.canceled == 0 && leave.deleted == 0
    ).toList();

    filteredLeave.sort((a, b) => a.leaveStartDate.compareTo(b.leaveStartDate));

    if(filteredLeave.isNotEmpty) {
      setState(() {
        userLeaves = filteredLeave;
      });


    }



  }


  String getAssetImage(int status){

    if(status == 0){
      return 'assets/images/icons/status-pending.png';
    }
    if(status == 1) {
      return 'assets/images/icons/status-done.png';
    }
    if(status == 2) {
      return 'assets/images/icons/status-rejected.png';
    }

    return 'assets/images/icons/status-pending.png';
  }

  void onLoadApplyLeave(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyLeaveView(userLeaves: userLeaves,),
      ),
    );
  }
  void onLoadLeaveStatus(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyLeaveView(userLeaves: userLeaves,),
      ),
    );
  }
  void onLoadLeaveHistory(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyLeaveView(userLeaves: userLeaves,),
      ),
    );
  }

  Color getStatusColor(int status){
    Color statusColor = greyColor6;

    if(status == 0){
      statusColor = isDarkMode ? orangeColor:orangeColor1;
    }

    if(status == 1){
      statusColor = isDarkMode ? greenColor5:greenColor6;
    }

    if(status == 2){
      statusColor = isDarkMode ? redColor1:redColor3;
    }

    return statusColor;
  }

  String getStatusMessage(int status){
    String statusMessage = '';

    if(status == 0){
      statusMessage = 'pending'.tr();
    }

    if(status == 1){
      statusMessage = 'approved'.tr();
    }

    if(status == 2){
      statusMessage = 'rejected'.tr();
    }

    return statusMessage;
  }


}
