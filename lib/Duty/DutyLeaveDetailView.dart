import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';

import '../CommonViews/LoaderView.dart';
import '../CommonViews/ToastMessageView.dart';
import '../Leaves/UserLeaves.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';


class DutyLeaveDetailView extends StatefulWidget {

  final List<UserLeaves> selectedDateLeave;
  final List<UserLeaves> userLeaves;
  final DateTime selectedDate;

  const DutyLeaveDetailView({
    super.key,
    required this.selectedDateLeave,
    required this.userLeaves,
    required this.selectedDate,
  });


  @override
  DutyLeaveDetailViewState createState() => DutyLeaveDetailViewState();
}

class DutyLeaveDetailViewState extends State<DutyLeaveDetailView>{

  late List<UserLeaves> selectedDayLeaves;
  late List<UserLeaves> unSyncDayLeaves;


  bool isUnSyncedData = false;

  DateTime focusedDay = DateTime.now();


  bool showLoaderView = false;
  String loaderMessage = '';

  bool showToastMessageView = false;
  String toastMessage = '';

  @override
  void initState() {
    selectedDayLeaves = widget.selectedDateLeave;

    focusedDay = widget.selectedDate;

    unSyncDayLeaves = getCalendarLeavesUnSyncData(selectedDayLeaves);
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
                          'txt_duty'.tr(),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: pathS+paddingTop),
                    Text(
                      DateFormat('EEEE',selectedLocale).format(focusedDay),
                      style: TextStyle(
                        color: isDarkMode ?  whiteColor:greyColor3,
                        fontSize: pathS /5.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: pathS/8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              focusedDay = DateTime(
                                focusedDay.year,
                                focusedDay.month ,
                                focusedDay.day -1,
                              );
                              selectedDayLeaves = getCalendarLeavesData(focusedDay);
                              unSyncDayLeaves = getCalendarLeavesUnSyncData(selectedDayLeaves);

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
                          DateFormat('d MMM',selectedLocale).format(focusedDay),
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
                              focusedDay = DateTime(
                                focusedDay.year,
                                focusedDay.month ,
                                focusedDay.day +1,

                              );
                              selectedDayLeaves = getCalendarLeavesData(focusedDay);
                              unSyncDayLeaves = getCalendarLeavesUnSyncData(selectedDayLeaves);

                            });

                          },
                          child:  SizedBox(
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
                    SizedBox(height: pathS/1.5),
                    SizedBox(
                      height: screenHeight - 1.8*pathL,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: selectedDayLeaves.map((leave) {
                            return  Column(
                              children: [
                                Container(
                                  width: screenWidth-2.5*marginValue,
                                  // height: pathL*2.8,
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
                                  child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Column(
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
                                                        'assets/images/icons/unsync.png',
                                                        color: isDarkMode ?  brownColor:brownColor,

                                                      ),
                                                    ),
                                                    SizedBox(width: pathS/8),
                                                    Text(
                                                      'unsynced_data'.tr(),
                                                      style: TextStyle(
                                                        color: isDarkMode ?  brownColor:brownColor,
                                                        fontSize: pathS /6.5,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: pathS/5),
                                          Padding(
                                            padding: EdgeInsets.only(left: pathS/4,bottom: pathS/4), // Adjust top and left as needed
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Padding(
                                                  padding:  EdgeInsets.only(right: pathS/4),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'leave_reason'.tr(),
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor7,
                                                              fontSize: pathS / 5.5,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                          SizedBox(width: pathS/8),
                                                          Text(
                                                            leave.leaveTypeName,
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor7,
                                                              fontSize: pathS / 5,
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.start,
                                                          ),

                                                        ],
                                                      ),
                                                      SizedBox(height: pathS/16),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'leave_date'.tr(),
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor7,
                                                              fontSize: pathS / 5.5,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                          SizedBox(width: pathS/8),
                                                          Text(
                                                            leave.formattedLeaves,
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor7,
                                                              fontSize: pathS / 5,
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: pathS/16),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'leave_status'.tr(),
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor7,
                                                              fontSize: pathS / 5.5,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                          SizedBox(width: pathS/8),
                                                          Text(
                                                            getLeaveStatusMessage(leave.leaveStatus),
                                                            style: TextStyle(
                                                              color: isDarkMode ?  whiteColor:greyColor7,
                                                              fontSize: pathS / 5,
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),

                                ),//duty in out
                                SizedBox(height: pathS/8),
                              ],
                            );
                          }).toList(),
                        ),
                      ),

                    ),

                  ],
                ),

                Center(
                  child: Visibility(
                    visible: selectedDayLeaves.isEmpty,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'no_data'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor:greyColor6,
                            fontSize: pathS /4,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            'no_calendar_data'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? greyColor1:greyColor3,
                              fontSize: pathS /5,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom +pathS/12,
                  child: GestureDetector(
                    onTap: (){
                      onTapLeaveSync();
                    },
                    child: Visibility(
                      visible: unSyncDayLeaves.isNotEmpty,
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

                LoaderView(isVisible: showLoaderView, message: loaderMessage),
                ToastMessageView(isVisible: showToastMessageView, message: toastMessage),

              ],
            ),
          ),



        ],
      ),
    );
  }

  String getLeaveStatusMessage(int status){
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

  Future<void> onTapLeaveSync() async {
    final userLeaves = await DatabaseHelper.instance.getAllRecords<UserLeaves>(
      keyTableUserLeave,
          (map) => UserLeaves.fromMap(map),
    );

    // Filter the records based on the conditions
    final unSyncLeaves = userLeaves.where((data) {
      return data.dirtyFlag == 1 ;
    }).toList();

    List<Map<String, dynamic>> jsonList =
    unSyncLeaves.map((e) => e.toJson()).toList();


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

  List<UserLeaves> getCalendarLeavesData(DateTime currentDate) {
    final calendarDateData = widget.userLeaves.where((data) {
      // Check if the currentDate falls within the leave period
      return (data.leaveStartDate.isBefore(currentDate) ||
          data.leaveStartDate.isAtSameMomentAs(currentDate)) &&
          (data.leaveEndDate.isAfter(currentDate) ||
              data.leaveEndDate.isAtSameMomentAs(currentDate));
    }).toList();

    return calendarDateData;
  }
  List<UserLeaves> getCalendarLeavesUnSyncData(List<UserLeaves> leave){

    final calenderDateData = leave
        .where((data) =>
    data.dirtyFlag == 1)
        .toList();

    return calenderDateData;
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
