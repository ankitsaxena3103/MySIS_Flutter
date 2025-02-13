import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Leaves/LeaveType.dart';
import 'package:mysis/Leaves/UserLeaves.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';
import 'LeaveAppliedView.dart';

class SelectLeaveReason extends StatefulWidget {
final  int noOfLeaveApplied ;
final List<DateTime> appliedLeavesDate;
  const SelectLeaveReason({
    super.key, required this.noOfLeaveApplied, required this.appliedLeavesDate,
  });

  @override
  SelectLeaveReasonState createState() => SelectLeaveReasonState();
}

class SelectLeaveReasonState extends State<SelectLeaveReason> {
  TextEditingController txtEnterPIN= TextEditingController(text: "");

  bool showLoaderView = false;

  bool isAlertVisible = false;
  String alertHeader = 'Error!';
  String alertMessage = 'There is an  internal error.';

  bool showToastMessageView = false;
  String toastMessage = '';

  int selectedIndex = -1;

  List<LeaveType> leaveTypes = [];
   LeaveType? selectedLeave;

  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Material(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                width: logicalWidth,
                height: logicalHeight,
                alignment: Alignment.center,
                color: greyColor6,

                child: Stack(
                  alignment: Alignment.center,
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

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth,
                        ),//fake container for width only


                        Container(
                          width: screenWidth-2.5*marginValue,
                          // height: pathL,
                          decoration:  BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(pathS/8),
                            color: isDarkMode?greyColor7:whiteColor,
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
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:  EdgeInsets.only(top: pathS/4,bottom: pathS/3),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      Text(
                                        '${widget.noOfLeaveApplied}'  " "+ 'days'.tr(),
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /5,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(height: pathS/5),
                                      Text(
                                        widget.noOfLeaveApplied == 1 ? getLeaveAppliedDate(widget.appliedLeavesDate.first) :
                                        '${getLeaveAppliedDate(widget.appliedLeavesDate.first)} - ${getLeaveAppliedDate(widget.appliedLeavesDate.last)}',
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /3,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(height: pathS/5),
                                      Container(

                                        width: screenHeight - 2.5*marginValue,
                                        color: isDarkMode ?  greyColor3:greyColor,
                                        child: Padding(
                                          padding:  EdgeInsets.only(left : pathS/4,top: pathS/5,bottom: pathS/5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'leave_reason'.tr(),
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor6,
                                                  fontSize: pathS /4,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              SizedBox(height: pathS/5),
                                              RadioButtonGroup(
                                                items: leaveTypes,
                                                selectedId: selectedIndex,
                                                callback: (int index) {
                                                  setState(() {
                                                    selectedIndex = index;
                                                  });
                                                  selectedLeave = leaveTypes[index];

                                                },
                                              ),



                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: pathS/3),
                                      GestureDetector(
                                        onTap: (){

                                          onTapConfirm();
                                        },
                                        child: Container(
                                          width: pathL,
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
                                            'confirm'.tr(),
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


                      ],
                    ),


                    LoaderView(isVisible: showLoaderView, message: 'Loading...'),
                    Visibility(
                      visible: isAlertVisible,
                      child: CustomAlertView(
                          callBack: (int val) {
                            if (val == 0) {
                              setState(() {
                                isAlertVisible = false;
                              });
                            } else {
                              makePhoneCall(phoneNo);
                            }
                          },
                          header: alertHeader,
                          message: alertMessage,
                          cancelButtonTitle: 'OK',
                          okButtonTitle: ''),
                    ),
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

  void initialSetup() {
    getLeaveTypeTableData();
  }

  String getLeaveAppliedDate(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }
  void showToastView(String message) {
    setState(() {
      toastMessage = message;
      showToastMessageView = true;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showToastMessageView = false;
      });
    });
  }

  void onTapConfirm(){

    if(selectedLeave == null ){
      showToastView('select_your_reason_for_leave'.tr());
      return;
    }

    createLeave();
  }

  void createLeave(){

    Map <String, dynamic> leave = createLeavesData();

    // Convert JSON to UserAttendance object
    UserLeaves appliedLeave = UserLeaves.fromJson(leave);

    // Create a list of UserAttendance objects
    List<UserLeaves> appliedLeaves = [appliedLeave];

    // Call the sync function
    syncUserLeavesData(
      appliedLeaves,
      'id',
    );

    onLoadLeaveApplied();
    List<dynamic> attendanceList = appliedLeaves;

    uploadLeaves(attendanceList);

  }
  Map <String, dynamic> createLeavesData(){

    String newUuid = Uuid().v4();

    String startDate = DateFormat('yyyy-MM-dd').format(widget.appliedLeavesDate.first);
    String endDate = DateFormat('yyyy-MM-dd').format(widget.appliedLeavesDate.last);

    Map <String, dynamic> leaves = {
    "ID": newUuid,
    "REGNO": regNo,
    "LEAVE_TYPE": selectedLeave!.leaveId,
    "LEAVE_STATUS": 0,
    "LEAVE_START_DATE": startDate,
    "LEAVE_END_DATE": endDate,
    "CANCLED": 0,
    "DELETED": 0,
    "DATE_MODIFIED": DateTime.now().toIso8601String(),
    "ACTION_TAKEN": 0,
    "APPROVED_ON": null,
    "ACTION_TAKEN_ON": null,
    "ADMIN_REMARKS": "",
    "DIRTY_FLAG": 1,
    "LEAVE_TYPE_NAME": selectedLeave!.leaveType,
    "LEAVE_TYPE_SYMBOL": selectedLeave!.leaveCode

    };

    printInDebug('Leave Data');
    leaves.forEach((key, value) {
      printInDebug('$key : $value');
    });

    return leaves;

  }

  Future<void> syncUserLeavesData(
      List<UserLeaves> userLeaves,
      String field,
      ) async {
    await DatabaseHelper.instance.insertTableData<UserLeaves>(
      keyTableUserLeave,
      userLeaves,
          (data) => data.toMap(),
    );
    for (var data in userLeaves) {
      printInDebug('Leaves Data');
      data.toMap().forEach((i, j) {
        printInDebug('$i : $j');
      });
      printInDebug('Inserted ${userLeaves.length} records into $keyTableUserLeave');

    }
  }

  Future<void> uploadLeaves(dynamic data) async {
    APIHelper.instance.postAllData(userLeavesPostApi, data, (responseData) {
      if (responseData.isNotEmpty) {
        // Parse the response list directly
        List<dynamic> leavesList = responseData;

        for (var data in leavesList) {
          // Parse each attendance record
          Map<String, dynamic> leaves = {
            "id": data['ID'] ?? '',
            "dirtyFlag": 0,
          };
          updateUserLeavesTable(leaves);
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
  Future<void> updateUserLeavesTable(Map <String,dynamic> leaves) async{
    await DatabaseHelper.instance.updateTableColumns(
        keyTableUserLeave,
        leaves,
        'id'
    );

  }

  void onLoadLeaveApplied(){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeaveAppliedView(leaveDays: widget.noOfLeaveApplied, appliedLeave: widget.appliedLeavesDate,reason: selectedLeave!.leaveType),
      ),
    );
  }


  Future<void> getLeaveTypeTableData() async {
    final leaves = await DatabaseHelper.instance.getAllRecords<LeaveType>(
      keyTableLeaveType,
          (map) => LeaveType.fromMap(map),
    );

    if(leaves.isEmpty){
      onLoadLeaveData();
    }else{
      getLeaveReasons(leaves);
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
        List<LeaveType> leaveTypes = data.map((json) => LeaveType.fromJson(json)).toList();


        getLeaveReasons(leaveTypes);

        syncLeaveTypeData(leaveTypes);

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
  void getLeaveReasons(List<LeaveType> leaves){
    setState(() {
      leaveTypes = leaves
          .where((data) =>
      data.forSelf == 1 &&  data.visible == 1 && widget.noOfLeaveApplied <= data.maxDays
      )
          .toList();
    });
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
    final size = pathS/5;
    controlSize = pathS/3;

    return Padding(
      padding: EdgeInsets.only(bottom: pathS/8),
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
            Container(
              height: pathS/3,
              child: Text(
                name,
                style: TextStyle(
                  color: isDarkMode ? whiteColor:greyColor6,
                  fontSize: size,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}

class RadioButtonGroup extends StatelessWidget {
  final List<LeaveType> items;
  final int selectedId;
  final Function(int) callback;

  RadioButtonGroup({
    required this.items,
    required this.selectedId,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final leaveType = entry.value;

        return RadioButton(
          id: index,
          callback: radioGroupCallback,
          selectedID: selectedId,
          name: leaveType.leaveType, // Assuming leaveType has a 'leaveType' field
        );
      }).toList(),
    );

  }

  void radioGroupCallback(int id) {
    callback(id);
  }
}