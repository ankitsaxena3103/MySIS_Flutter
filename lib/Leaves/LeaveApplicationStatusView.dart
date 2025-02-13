

import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Leaves/ApplyLeaveView.dart';
import 'package:mysis/Leaves/CancelRequestView.dart';
import 'package:mysis/Leaves/UserLeaves.dart';

import '../CommonViews/LoaderView.dart';
import '../CommonViews/SuccessAlertView.dart';
import '../CommonViews/ToastMessageView.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';

class LeaveApplicationStatusView extends StatefulWidget {
  const LeaveApplicationStatusView({super.key});

  @override
  LeaveApplicationStatusViewState createState() => LeaveApplicationStatusViewState();
}

class LeaveApplicationStatusViewState extends State<LeaveApplicationStatusView>{

  bool isNoData = false;
  bool isUnSyncedData = true;

  bool isSucces  = false;
  bool isCancel = false;
  String leaveReason = '';
  String leaveDate = '';

  List<UserLeaves> userLeaves = [];


  late List<UserLeaves> selectedDayLeaves;
  late List<UserLeaves> unSyncDayLeaves;

  bool isNotSyncedData = false;

  DateTime focusedDay = DateTime.now();

  bool showLoaderView = false;
  String loaderMessage = '';

  bool showToastMessageView = false;
  String toastMessage = '';

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
                                        Visibility(
                                          visible: leave.dirtyFlag == 1 ? true : false,
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
                                                  SizedBox(
                                                    width:pathS/3,
                                                    height: pathS/3,
                                                    child: Image.asset(
                                                        'assets/images/icons/unsync.png'
                                                    ),
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
                                                    Container(
                                                      alignment: Alignment.centerRight,
                                                      width: pathL,
                                                      child: Text(
                                                        getStatusMessage(leave.leaveStatus) ,
                                                        style: TextStyle(
                                                          color: getStatusColor(leave.leaveStatus),
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
                                                        getAssetImage(leave.leaveStatus),
                                                        width: pathS/4,
                                                        height: pathS/4,

                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: pathS/5),
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

                                        SizedBox(height: pathS/8),
                                        Visibility(
                                          visible: leave.leaveStatus == 1 ? true : false,
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
                                                    leaveReason = leave.leaveTypeName;
                                                    leaveDate = leave.formattedLeaves;

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
                                SizedBox(height: pathS/5),

                              ],
                            );
                          }).toList(),
                        ),
                      ),

                    ),
                  ],
                ),

                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom +pathS/12,
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
                            'sync_now'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? whiteColor:whiteColor,
                              fontSize: pathS / 5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
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

                LoaderView(isVisible: showLoaderView, message: loaderMessage),
                ToastMessageView(isVisible: showToastMessageView, message: toastMessage),

              ],
            ),
          ),



        ],
      ),
    );
  }


  Future<void> onTapSync() async {


    List<Map<String, dynamic>> jsonList =
    unSyncDayLeaves.map((e) => e.toJson()).toList();


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
  Future<void> updateUserLeavesTable(Map <String,dynamic> leaves) async{
    await DatabaseHelper.instance.updateTableColumns(
        keyTableUserLeave,
        leaves,
        'id'
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

      if(leaves.isNotEmpty) {
        // Filter roster data for today
        final thisMonthLeaves = leaves
            .where((leave) =>
        leave.dateModified.year == DateTime
            .now()
            .year && // Same year
            leave.dateModified.month == DateTime
                .now()
                .month && // Same month
            leave.deleted == 0 && leave.canceled == 0) // Not deleted
            .toList();

         unSyncDayLeaves = leaves
            .where((leave) =>
            leave.deleted == 0 && leave.canceled == 0 && leave.dirtyFlag == 1) // Not deleted
            .toList();

        if(thisMonthLeaves.isNotEmpty){
          setState(() {
            userLeaves = thisMonthLeaves;
          });
        }
        if(unSyncDayLeaves.isNotEmpty){
          setState(() {
            isNotSyncedData = true;
          });
        }

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
      return 'assets/images/icons/status-pending.png';

      // return 'assets/images/icons/status-rejected.png';
    }

    return 'assets/images/icons/status-pending.png';
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
