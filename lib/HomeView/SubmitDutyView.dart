import 'dart:convert';
import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/ThanksDutyView.dart';
import 'package:mysis/Profile/UnitDutyPost.dart';
import 'package:mysis/Profile/UnitShiftDetail.dart';
import 'package:mysis/Profile/UserPosting.dart';
import 'package:mysis/Profile/UserProfile.dart';
import 'package:mysis/SharedClasses/DatabaseHelper.dart';
import 'package:uuid/uuid.dart';

import '../CommonViews/AlertPopupView.dart';
import '../CommonViews/LoaderView.dart';
import '../CommonViews/ToastMessageView.dart';
import '../SharedClasses/APIHelper.dart';
import 'UserAttendance.dart';

class SubmitDutyView extends StatefulWidget {

  final UserAttendance? userAttendance;

  final UserProfile userProfile;
  final UnitDutyPost unitDutyPost;
  final UnitShiftDetail unitShiftDetail;
  final UserPosting userPosting;
  final String attendanceMode;
  final String attendanceStatus;

  final String latLong;
  final String dutyDateTime;

  const SubmitDutyView(
      {
        super.key,
        required this.userProfile,
        required this.unitDutyPost,
        required this.unitShiftDetail,
        required this.userPosting,
        required this.attendanceMode,
        required this.attendanceStatus,
        required this.latLong,
        required this.dutyDateTime,
        this.userAttendance,
      });
  @override
  SubmitDutyViewState createState() => SubmitDutyViewState();
}

class SubmitDutyViewState extends State<SubmitDutyView>{
  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String imagePath = '';
  String name  = '';
  String position  = '';

  bool noData = true;
  String imageData = '';
  List<Widget> containers = [];

  int selectedIndex = -1;
  String profileImage = 'assets/images/home/profile.png';
  String profileUrl = '';

  bool showToastMessageView = false;
  String toastMessage = '';

  String alertHeader = '';
  String alertMessage = '';
  bool showAlert = false;
  bool showLoaderView = false;

  String attendanceImagePath = "";


  @override
  void initState() {
    onLoadUpdateUI();
    initialSetup();
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
              gradient: isDarkMode ? backgroundGradientDark : backgroundGradient ,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top:MediaQuery.of(context).padding.top,
                  child: Container(
                    width: screenWidth,

                    decoration: BoxDecoration(
                      color: isDarkMode ? greyColor8 : whiteColor,
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
                      padding: EdgeInsets.only(left: paddingLeft + pathS / 4, right: paddingRight + pathS / 3,top: pathS/5,bottom: pathS/5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                height: pathS / 1.5,
                                width: pathS / 1.5,
                                imageUrl: profileUrl,
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundImage: AssetImage(profileImage),
                                  backgroundColor: Colors.white,
                                ),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  backgroundImage: AssetImage(profileImage),
                                  backgroundColor: Colors.white,
                                ),
                                imageBuilder: (context, imageProvider) => CircleAvatar(
                                  backgroundImage: imageProvider,
                                  backgroundColor: Colors.white,
                                ),
                              ),

                              SizedBox(width: pathS/5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: pathL*1.7,
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 4.5,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Container(
                                        width:pathL*1.5,
                                        child: Text(
                                          position,
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 6.5,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),

                                    ],
                                  ),

                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: pathS / 3,
                                  height: pathS / 3,
                                  child: Image.asset(
                                    'assets/images/home/cross.png',
                                    color: isDarkMode ? whiteColor : greyColor6,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Column(
                            children: containers,
                          ),


                          Padding(
                            padding:  EdgeInsets.only(left: pathS/5,top: pathS/25),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Image.asset(
                                  'assets/images/icons/location.png',
                                  height: pathS/3,
                                  width: pathS/3,
                                  color: isDarkMode ? redColor1 :redColor3,

                                ),
                                SizedBox(width: pathS/5),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              // width: pathL * 1.5,
                                              child: Text(
                                                '${widget.userPosting.siteName}\n(${widget.userPosting.unitCode})',
                                                style: TextStyle(
                                                  color: isDarkMode ? whiteColor : greyColor6,
                                                  fontSize: pathS / 4.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  widget.unitDutyPost.postName,
                                                  style: TextStyle(
                                                    color: isDarkMode ? whiteColor : greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Spacer(),
                                                Container(
                                                  // width: pathS,
                                                  height: pathS / 2.5,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: isDarkMode ? greenColor6 : greenColor1,
                                                    borderRadius: BorderRadius.circular(pathS / 12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color:  shadowColor,
                                                        blurRadius: pathS/45, // Spread of the shadow
                                                        // spreadRadius: pathS/15, // How far the shadow extends
                                                        offset:  Offset(-pathS/45, pathS/45),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:  EdgeInsets.only(left: pathS/8,right: pathS/8),
                                                    child: Text(
                                                      widget.unitShiftDetail.shiftName,
                                                      style: TextStyle(
                                                        color: isDarkMode ? greyColor7 : greenColor6,
                                                        fontSize: pathS / 5,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      textAlign: TextAlign.center,
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
                                ),




                    ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: pathL+ paddingTop),

                    Container(
                      alignment: Alignment.center,
                      width: pathL * 2,
                      height: pathL * 2,
                      decoration: BoxDecoration(
                        color: isDarkMode ? greyColor6 : whiteColor,
                        borderRadius: BorderRadius.circular(pathS / 8),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: pathS / 10, // Spread of the shadow
                            offset: Offset(-pathS / 12, pathS / 12),
                          ),
                        ],
                      ),
                      child: ClipRect(
                        child: imageData.isNotEmpty
                            ? Image.memory(
                          base64Decode(imageData),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                            : Center(
                          child: GestureDetector(
                            onTap: (){
                              capturePhoto();
                            },
                            child: Icon(
                              Icons.camera_alt, // Camera icon as placeholder
                              size: pathS/2,      // Adjust size of the icon
                              color: Colors.grey, // Adjust color for better contrast
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: pathS*1.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            capturePhoto();
                          },
                          child: Container(
                            width: pathL,
                            height: pathS / 1.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isDarkMode ? greyColor6:whiteColor,
                              // border: Border.all(color: Colors.yellow, width: pathS/18),
                              borderRadius: BorderRadius.circular(pathS/3),
                              border: Border.all(
                                  color: isDarkMode ? redColor1:redColor3,

                                  width:1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.transparent, // Shadow color
                                  blurRadius: pathS/10, // Spread of the shadow
                                  // spreadRadius: pathS/15, // How far the shadow extends
                                  offset:  Offset(-pathS/12, pathS/12),
                                ),
                              ],
                            ),
                            child: Text(
                              'txt_retake'.tr(),
                              style: TextStyle(
                                color: isDarkMode ? redColor1:redColor3,

                                fontSize: pathS / 4.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: pathS/3),
                        GestureDetector(
                          onTap: (){
                            onTapSubmit();

                          },
                          child: Container(
                            width: pathL,
                            height: pathS / 1.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                              borderRadius: BorderRadius.circular(pathS/3),
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor, // Shadow color
                                  blurRadius: pathS/15, // Spread of the shadow
                                  // spreadRadius: pathS/15, // How far the shadow extends
                                  offset:  Offset(-pathS/15, pathS/15),
                                ),
                              ],
                            ),
                            child: Text(
                              'submit'.tr(),
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: pathS / 4.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),

               ToastMessageView(isVisible: showToastMessageView, message: toastMessage),
                Visibility(
                  visible: showAlert,
                  child: AlertPopupView(
                      header: alertHeader,
                      message: alertMessage,
                      cancelBtn: '',
                      okBtn: 'ok'.tr(),
                      callBack:(val){
                        setState(() {
                          showAlert = false;
                        });
                      },

                  ),
                ),
                LoaderView(isVisible: showLoaderView, message: ''),

              ],
            ),
          ),

        ],
      ),
    );
  }

  void initialSetup(){
    for (int i = 0; i < 5; i++) {
      containers.add(
        Padding(
          padding:  EdgeInsets.only(left: pathS/3,top: pathS/30),
          child: Container(
            alignment: Alignment.centerLeft,
            height: pathS / 20,
            width: pathS / 35,
            color: isDarkMode ? whiteColor : greyColor3,
          ),
        ),
      );
    }
  }


  void onLoadUpdateUI(){

    profileUrl = widget.userProfile.profileImageUrl;
    name = '${widget.userProfile.empName}\n(${widget.userProfile.regNo})';
    position = '${widget.userProfile.serviceName} (${widget.userProfile.rank})';

  }

  Future<void> capturePhoto() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        attendanceImagePath = (pickedFile?.path)!;
        printInDebug(attendanceImagePath);

        setState(() {
          imagePath = pickedFile.path;
          imageData = base64Encode(imageBytes);
        });
      } else {
        printInDebug("No image selected.");
      }
    } catch (e) {
      printInDebug("Error capturing photo: $e");
    }
  }

  void onTapSubmit(){

  if(imageData.isEmpty){
    showToastView('please_select_shift'.tr());
    // return;
  }

  createAttendance();

  }

  void createAttendance(){

    Map <String, dynamic> dutyAttendance = widget.attendanceStatus == keyAttendanceStatusDutyIn ? getDutyInAttendance() : getDutyOutAttendance();

    UserAttendance userAttendance = UserAttendance.fromJson(dutyAttendance);
    List<UserAttendance> attendanceData = [userAttendance];
     syncUserAttendanceData(attendanceData, widget.attendanceStatus, );
    loadThanksScreen(userAttendance);

    List<dynamic> attendanceList = [dutyAttendance];
    uploadAttendance(attendanceList);

  }

  Map <String, dynamic> getDutyInAttendance(){

    String newUuid = Uuid().v4();
    uploadAttendanceImage(attendanceImagePath, newUuid,widget.attendanceStatus);
    List<String> parts = widget.unitShiftDetail.dutyHrs.split(":");
    int shiftMin =  (int.parse(parts[0]) * 60) + int.parse(parts[1]);
    String dutyDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.dutyDateTime));
    Map <String, dynamic> dutyInAttendance = {
      "ID": newUuid,
      "REGNO":  widget.userProfile.regNo ,
      "UNIT_CODE": widget.unitDutyPost.unitCode,
      "SITE_NAME": widget.userPosting.siteName,
      "DUTY_POST_ID": widget.unitDutyPost.id,
      "DUTY_POST_NAME": widget.unitDutyPost.postName,
      "SHIFT_ID": widget.unitShiftDetail.shiftId,
      "SHIFT_NAME": widget.unitShiftDetail.shiftName,
      "SHIFT_START_DATE": createDutyDate(widget.unitShiftDetail,DateTime.parse(widget.dutyDateTime)),
      "SHIFT_START_TIME": DateTime.parse("$dutyDate ${widget.unitShiftDetail.startTime}").toIso8601String(),
      "SHIFT_END_TIME": DateTime.parse("$dutyDate ${widget.unitShiftDetail.endTime}").toIso8601String(),
      "ACT_START_TIME": widget.dutyDateTime,
      "ACT_END_TIME":  null,
      "FINAl_START_TIME": DateTime.parse(widget.dutyDateTime).isAfter(DateTime.parse("$dutyDate ${widget.unitShiftDetail.startTime}"))
          ? widget.dutyDateTime
          : DateTime.parse("$dutyDate ${widget.unitShiftDetail.startTime}").toIso8601String(),
      "FINAL_END_TIME": null,
      "APPROVED_HR": 0,
      "REJECTED_HR": 0,
      "DUTY_COUNT": 0.0,
      "DUTY_IN_LAT_LNG": widget.latLong,
      "DUTY_OUT_LAT_LNG":  "",
      "DELETED": 0,
      "IS_ABSENT": false,
      "IS_APPROVED": 0,
      "ATTENDANCE_MODE": widget.attendanceMode,
      "DUTY_RANK": widget.userPosting.dutyRank,
      "DUTY_STATUS": widget.attendanceStatus,
      "CREATED_ON": DateTime.now().toIso8601String(),
      "EMP_RANK": widget.userProfile.rank,
      "DUTY_RANK_NAME": widget.userPosting.dutyRankName,
      "SHIFT_HRS": widget.unitShiftDetail.dutyHrs,
      "SHIFT_MIN": shiftMin,
      "DIRTY_FLAG": 1
    };

    return dutyInAttendance;

  }
  Map <String, dynamic> getDutyOutAttendance(){

    UserAttendance dutyInAttendance = widget.userAttendance!;

    uploadAttendanceImage(attendanceImagePath, dutyInAttendance.id,dutyInAttendance.dutyStatus);
    String formattedDutyDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.dutyDateTime));
    String formattedDutyStartDate = DateFormat('yyyy-MM-dd').format(dutyInAttendance.shiftStartDate);

    Map <String, dynamic> dutyOutAttendance = {
      "ID": dutyInAttendance.id,
      "REGNO": dutyInAttendance.regNo,
      "UNIT_CODE": dutyInAttendance.unitCode,
      "SITE_NAME": dutyInAttendance.siteName,
      "DUTY_POST_ID": dutyInAttendance.dutyPostId,
      "DUTY_POST_NAME": dutyInAttendance.dutyPostName,
      "SHIFT_ID": dutyInAttendance.shiftId,
      "SHIFT_NAME":dutyInAttendance.shiftName,
      "SHIFT_START_DATE": formattedDutyStartDate,
      "SHIFT_START_TIME": dutyInAttendance.shiftStartTime.toIso8601String(),
      "SHIFT_END_TIME": dutyInAttendance.shiftEndTime.toIso8601String(),
      "ACT_START_TIME": dutyInAttendance.actStartTime.toIso8601String(),
      "ACT_END_TIME":  widget.dutyDateTime,
      "FINAl_START_TIME": dutyInAttendance.finalStartTime.toIso8601String(),
      "FINAL_END_TIME":  DateTime.parse(widget.dutyDateTime).isAfter(DateTime.parse("$formattedDutyDate ${widget.unitShiftDetail.endTime}"))
          ?  DateTime.parse("$formattedDutyDate ${widget.unitShiftDetail.endTime}").toIso8601String() : widget.dutyDateTime,
      "APPROVED_HR": 0,
      "REJECTED_HR": 0,
      "DUTY_COUNT": 0.0,
      "DUTY_IN_LAT_LNG": dutyInAttendance.dutyInLatLng,
      "DUTY_OUT_LAT_LNG":  widget.latLong ,
      "DELETED": 0,
      "IS_ABSENT": false,
      "IS_APPROVED": 0,
      "ATTENDANCE_MODE": widget.attendanceMode,
      "DUTY_RANK": dutyInAttendance.dutyRank,
      "DUTY_STATUS": widget.attendanceStatus,
      "CREATED_ON": DateTime.now().toIso8601String(),
      "EMP_RANK": dutyInAttendance.empRank,
      "DUTY_RANK_NAME": dutyInAttendance.dutyRankName,
      "SHIFT_HRS": dutyInAttendance.shiftHrs,
      "SHIFT_MIN": dutyInAttendance.shiftMin,
      "DIRTY_FLAG": 1
    };

    for (var entry in dutyOutAttendance.entries) {
      printInDebug('${entry.key} : ${entry.value}');
    }


    return dutyOutAttendance;

  }


  Future<void> uploadAttendance(dynamic attendance) async {
    APIHelper.instance.postAllData(userAttendancePostApi, attendance, (responseData) {
        if (responseData.isNotEmpty) {
          // Parse the response list directly
          List<dynamic> attendanceList = responseData;

          for (var attendanceRecord in attendanceList) {
            // Parse each attendance record
            Map<String, dynamic> attendance = {
              "id": attendanceRecord['ID'] ?? '',
              "dirtyFlag": 0,
            };
            updateUserAttendanceTable(attendance);
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

  Future<void> uploadAttendanceImage(String filePath, String id, String dutyInOutType) async {

    if(attendanceImagePath.isEmpty){
      return;
    }

    setState(() {
      showLoaderView = true;
    });

    Map <String,String> inputData = {
      'parentType' : dutyInOutType,
      'parentID': id,
      'fileDescription':'attendance photo',
      'file':filePath,
    };

    APIHelper.instance.postImage(uploadImageApi, inputData, (responseData) {
      if (responseData.isNotEmpty) {
        // Parse the response list directly

        Map<String, dynamic> data = responseData;

        final String message = data['message'] ?? '';

      }
      else {
        // Handle empty response
        printInDebug('Response data is empty.');
      }
      setState(() {showLoaderView = false;});
    },
          (error) {
        // Handle error
        setState(() {
          showLoaderView = false;
        });
        printInDebug('Error: $error');
      },
    );
  }
  Future<void> updateUserAttendanceTable(Map <String,dynamic> attendance) async{
  await DatabaseHelper.instance.updateTableColumns(
      keyTableUserAttendance,
      attendance,
      'id'
  );

}

  Future<void> syncUserAttendanceData(List<UserAttendance> userAttendance, String mode,) async {
    if (mode == keyAttendanceStatusDutyIn) {
      await DatabaseHelper.instance.insertTableData<UserAttendance>(
        keyTableUserAttendance,
        userAttendance,
            (attendance) => attendance.toMap(),
      );

      printInDebug('Inserted ${userAttendance.length} records into $keyTableUserAttendance');

    }
    else if (mode == keyAttendanceStatusDutyOut) {
      // Update multiple rows using a generic update function
      await DatabaseHelper.instance.updateTableData<UserAttendance>(
        keyTableUserAttendance,
        userAttendance,
        'id',
            (attendance) => attendance.toMap(),

      );
        printInDebug('Updated ${userAttendance.length} records in $keyTableUserAttendance');

    }
  }

  void loadThanksScreen(UserAttendance attendance){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThanksDutyView(
          userProfile: widget.userProfile,
          unitDutyPost: widget.unitDutyPost,
          unitShiftDetail: widget.unitShiftDetail,
          imageData: imageData,
          userPosting: widget.userPosting,
          latLong: widget.latLong,
          userAttendance: attendance,


        ),
      ),
    );
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
  String? createDutyDate(UnitShiftDetail shiftDetail,DateTime dutyMarkDateTime) {
    final startParts = shiftDetail.startTime.split(':').map(int.parse).toList();
    final endParts = shiftDetail.endTime.split(':').map(int.parse).toList();

    DateTime baseDate = DateTime(dutyMarkDateTime.year, dutyMarkDateTime.month, dutyMarkDateTime.day);

    final shiftStartDuration = _parseDuration(shiftDetail.shiftStartBefore);
    final dutyStartTimeToday = baseDate.add(Duration(hours: startParts[0], minutes: startParts[1], seconds: startParts[2]))
        .subtract(shiftStartDuration);

    final dutyInDuration = _parseDuration(shiftDetail.dutyInBefore);
    final dutyEndTimeToday = baseDate.add(Duration(hours: endParts[0], minutes: endParts[1], seconds: endParts[2]))
        .subtract(dutyInDuration);

    if (dutyMarkDateTime.isAfter(dutyStartTimeToday) && dutyMarkDateTime.isBefore(dutyEndTimeToday)) {

      return DateFormat('yyyy-MM-dd').format(baseDate); // Attendance for today
    }

    // If not today, check yesterday's window
    final dutyStartTimeYesterday = dutyStartTimeToday.subtract(const Duration(days: 1));
    final dutyEndTimeYesterday = dutyEndTimeToday.subtract(const Duration(days: 1));

    if (dutyMarkDateTime.isAfter(dutyStartTimeYesterday) && dutyMarkDateTime.isBefore(dutyEndTimeYesterday)) {
      return DateFormat('yyyy-MM-dd').format(baseDate.subtract(const Duration(days: 1))); // Attendance for yesterday
    }

    // If not today or yesterday, check tomorrow's window
    final dutyStartTimeTomorrow = dutyStartTimeToday.add(const Duration(days: 1));
    final dutyEndTimeTomorrow = dutyEndTimeToday.add(const Duration(days: 1));

    if (dutyMarkDateTime.isAfter(dutyStartTimeTomorrow) && dutyMarkDateTime.isBefore(dutyEndTimeTomorrow)) {
    return DateFormat('yyyy-MM-dd').format(baseDate.add(const Duration(days: 1))); // Attendance for yesterday
    }

    // If none of the windows match, return null
    printInDebug('Duty marking window is not valid.');
    return null;
  }
  Duration _parseDuration(String durationString) {
    final parts = durationString.split(':').map(int.parse).toList();
    return Duration(hours: parts[0], minutes: parts[1], seconds: parts[2]);
  }


}

