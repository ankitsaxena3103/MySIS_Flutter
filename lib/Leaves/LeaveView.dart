import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Leaves/ApplyLeaveView.dart';
import 'package:mysis/Leaves/LeaveType.dart';

import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';
import 'LeaveApplicationStatusView.dart';
import 'LeaveRecordsView.dart';
import 'UserLeaves.dart';

class LeaveView extends StatefulWidget {
  const LeaveView({super.key});

  @override
  LeaveViewState createState() => LeaveViewState();
}

class LeaveViewState extends State<LeaveView>{

bool noData = false;

List <UserLeaves> userLeaves = [];

  @override
  void initState() {

    getLeaveTypeTableData();
    onLoadUserLeavesData();
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
              ],
            ),
          ),



        ],
      ),
    );
  }

Future<void> getLeaveTypeTableData() async {
  final leave = await DatabaseHelper.instance.getAllRecords<LeaveType>(
    keyTableLeaveType,
        (map) => LeaveType.fromMap(map),
  );

  if(leave.isEmpty){
    onLoadLeaveData();
  }

}
void onLoadLeaveData() {


  // setState(() {
  //   showLoaderView = true;
  // });
  Map <String,String> inputData = {

  };

  APIHelper.instance.getData(leaveTypeMasterApi,inputData, (data) {

    // setState(() {
    //   showLoaderView = false;
    // });

    if(data.isNotEmpty){
      if (kDebugMode) {
        print(data);
      }
      List<LeaveType> leaveType = data.map((json) => LeaveType.fromJson(json)).toList();

      syncLeaveTypeData(leaveType);

    }

  },(error){
    // setState(() {
    //   showLoaderView = false;
    // });

  }
  );

}
Future<void> syncLeaveTypeData(List<LeaveType> leaveType) async {
  await DatabaseHelper.instance.replaceTableData<LeaveType>(keyTableLeaveType, leaveType, (leaveType) =>
      leaveType.toMap());
}

Future<void> getUserLeaveTableData() async {
  final userLeavesData = await DatabaseHelper.instance.getAllRecords<UserLeaves>(
    keyTableUserLeave,
        (map) => UserLeaves.fromMap(map),
  );

      final leaves = userLeavesData
          .where((data) =>
      data.deleted == 0 && data.canceled == 0)
          .toList();

      if(leaves.isNotEmpty){
        userLeaves = leaves;
      }

      onLoadUserLeavesData();
}
void onLoadUserLeavesData() {


  // setState(() {
  //   showLoaderView = true;
  // });
  Map <String,String> inputData = {

  };

  APIHelper.instance.getData(userLeavesApi,inputData, (data) {

    // setState(() {
    //   showLoaderView = false;
    // });

    if(data.isNotEmpty){

      List<UserLeaves> userLeavesData = data.map((json) => UserLeaves.fromJson(json)).toList();


      for (var data in userLeaves) {
        printInDebug('leaves server Data');
        data.toMap().forEach((i, j) {
          printInDebug('$i : $j');
        });
      }

      if(userLeavesData.isNotEmpty){
        syncUserLeavesData(userLeavesData);

      }

      final leaves = userLeavesData
          .where((data) =>
      data.deleted == 0 && data.canceled == 0)
          .toList();

      if(leaves.isEmpty){
        userLeaves = leaves;
      }


    }

  },(error){
    // setState(() {
    //   showLoaderView = false;
    // });

  }
  );

}
Future<void> syncUserLeavesData(List<UserLeaves> userLeaves) async {

  await DatabaseHelper.instance.updateOrDeleteTableData<UserLeaves>(
      keyTableUserLeave,
      userLeaves,
      'id',
      (userLeaves) => userLeaves.toMap()
  );

}


  void onLoadApplyLeave(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyLeaveView(userLeaves: userLeaves),
      ),
    );
  }
  void onLoadLeaveStatus(){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LeaveApplicationStatusView(),
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
