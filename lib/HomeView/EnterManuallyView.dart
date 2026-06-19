import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/ConfirmProfileView.dart';
import 'package:mysis/HomeView/ScanCardView.dart';
import 'package:mysis/HomeView/UserAttendance.dart';

import '../CommonViews/AlertPopupView.dart';
import '../CommonViews/LoaderView.dart';
import '../CommonViews/ToastMessageView.dart';
import '../Profile/UnitDutyPost.dart';
import '../Profile/UnitShiftDetail.dart';
import '../Profile/UserPosting.dart';
import '../Profile/UserProfile.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';
import 'Model/EmployeeRoasterDetail.dart';
import 'SimpleTextField.dart';

class EnterManuallyView extends StatefulWidget {
  final UserProfile userProfile;
  final String attendanceMode;
  final List<UnitDutyPost> unitDutyPosts;
  final List<UnitShiftDetail> unitShiftDetails;
  final List<UserPosting> userPostings;
  final String attendanceStatus;

  const EnterManuallyView({
    super.key,
    required this.userProfile,
    required this.attendanceMode,
    required this.unitDutyPosts,
    required this.unitShiftDetails,
    required this.userPostings,
    required this.attendanceStatus,
  });

  @override
  EnterManuallyViewState createState() => EnterManuallyViewState();
}

class EnterManuallyViewState extends State<EnterManuallyView> {
  bool noData = true;

  TextEditingController txtUserId = TextEditingController(text: "");

  bool showLoaderView = false;

  bool showToastMessageView = false;
  String toastMessage = '';

  Color nextBgColor = isDarkMode ? greyColor6 : greyColor2;
  Color nextFontColor = isDarkMode ? greyColor7 : greyColor3;
  Color nextShadowColor = Colors.transparent;

  String lblErrorMsg = '';
  bool isTapEnabled = false;

  String lblUserIdHintMsg = 'enter_mobile_no'.tr();
  String lblUserIdHintText = 'ex_mobile'.tr();

  String btnNext = 'next'.tr();
  String usingSlef = 'Using Self'.tr();

  bool showAlert = false;
  String alertHeader = '';
  String alertMessage = '';

  Color lineBorderColor = isDarkMode ? greyColorDark : greyColor5;

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
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient:
                  isDarkMode ? backgroundGradientDark : backgroundGradient,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  child: Container(
                    width: screenWidth,
                    height: pathS / 1.2,
                    decoration: BoxDecoration(
                      color: isDarkMode ? greyColor8 : whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          // Shadow color
                          blurRadius: pathS / 10,
                          // Spread of the shadow
                          // spreadRadius: pathS/15, // How far the shadow extends
                          offset: Offset(-pathS / 12, pathS / 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: paddingLeft + pathS / 4,
                          right: paddingRight + pathS / 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: pathS / 1.5,
                                height: pathS / 1.2,
                                child: Image.asset(
                                  'assets/images/home/card-icon.png',
                                  color: isDarkMode ? whiteColor : redColor3,
                                ),
                              ),
                              SizedBox(width: pathS / 5),
                              Text(
                                'enter_Manually'.tr(),
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 5,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
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
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth - 2.5 * marginValue,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(pathS / 8),
                        color: isDarkMode ? greyColor6 : whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: pathS / 10,
                            offset: Offset(-pathS / 12, pathS / 12),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: pathS / 4,
                              top: pathS / 3,
                              bottom: pathS / 3,
                              right: pathS / 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                lblUserIdHintMsg,
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 6.5,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.center,
                              ),

                              SimpleUnderLineTextField(
                                isDarkMode: isDarkMode,
                                txtUserId: txtUserId,
                                onUserIdChange: (data) {
                                  onUserIdChange(data);
                                },
                                lineBorderColor: lineBorderColor,
                              ),

                              // TextField(
                              //   onChanged: (value) {
                              //     txtUserId.text = value;
                              //     onUserIdChange(value);
                              //   },
                              //   controller: txtUserId,
                              //   keyboardType: TextInputType.streetAddress,
                              //   decoration:  InputDecoration(
                              //     // hintText: '${'name'.tr()}*', // Placeholder text
                              //     contentPadding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                              //
                              //     hintStyle: TextStyle(
                              //       color: isDarkMode ? greyColor1 : greyColor3,
                              //       fontSize: pathS/4,
                              //       fontWeight: FontWeight.normal,
                              //     ),
                              //     // border: InputBorder.none,
                              //   ),
                              //   style: TextStyle(
                              //     color: isDarkMode ? whiteColor : greyColor4,
                              //     fontSize: pathS/4,
                              //     fontWeight: FontWeight.normal,
                              //   ),
                              // ),
                              SizedBox(height: pathS / 8),
                              Text(
                                lblUserIdHintText,
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 6.5,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: pathS / 5),
                    Container(
                      width: screenWidth - 4 * marginValue,
                      child: Text(
                        lblErrorMsg,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 0, 0, 1),
                          fontSize: pathS / 7,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Positioned(
                    bottom: MediaQuery.of(context).padding.bottom + pathS + 50,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            txtUserId.text = widget.userProfile.regNo;

                            onUserIdChange(txtUserId.text);
                            // setState(() {
                            //   txtUserId.text=widget.userProfile.regNo;
                            //   nextBgColor = Color.fromRGBO(195, 50, 30, 1);
                            //   nextFontColor = Colors.white;
                            //   nextShadowColor = Colors.black.withOpacity(0.2);
                            //   lineBorderColor = Color.fromRGBO(51, 51, 51, 0.5);
                            //   lblErrorMsg = '';
                            //   isTapEnabled = true;
                            // });// Enable tap
                          },
                          child: Container(
                            width: pathL,
                            height: pathS / 1.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(195, 50, 30, 1),
                              // border: Border.all(color: Colors.yellow, width: pathS/18),
                              borderRadius: BorderRadius.circular(pathS / 3),
                              boxShadow: [
                                BoxShadow(
                                  color: nextShadowColor,
                                  // Shadow color
                                  blurRadius: pathS / 10,
                                  // Spread of the shadow
                                  // spreadRadius: pathS/15, // How far the shadow extends
                                  offset: Offset(-pathS / 12, pathS / 12),
                                ),
                              ],
                            ),
                            child: Text(
                              usingSlef,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: pathS / 4.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('OR'),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            isTapEnabled
                                ? await onTapNext()
                                : null; // Disable tap if isTapEnabled is false
                          },
                          child: Container(
                            width: pathL,
                            height: pathS / 1.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: nextBgColor,
                              // border: Border.all(color: Colors.yellow, width: pathS/18),
                              borderRadius: BorderRadius.circular(pathS / 3),
                              boxShadow: [
                                BoxShadow(
                                  color: nextShadowColor,
                                  // Shadow color
                                  blurRadius: pathS / 10,
                                  // Spread of the shadow
                                  // spreadRadius: pathS/15, // How far the shadow extends
                                  offset: Offset(-pathS / 12, pathS / 12),
                                ),
                              ],
                            ),
                            child: Text(
                              btnNext,
                              style: TextStyle(
                                color: nextFontColor,
                                fontSize: pathS / 4.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Positioned(
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: screenWidth,
                      height: pathS / 1.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDarkMode ? greyColor8 : greyColor,
                        // borderRadius: BorderRadius.circular(pathS/3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            // Shadow color
                            blurRadius: pathS / 10,
                            // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset: Offset(-pathS / 12, pathS / 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom,
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.pop(context);
                      onLoadScanEntry();
                    },
                    child: Container(
                      width: screenWidth,
                      height: pathS / 1.4,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDarkMode ? greyColor8 : greyColor,
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            // Shadow color
                            blurRadius: pathS / 15,
                            // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset: Offset(-pathS / 15, -pathS / 15),
                          ),
                        ],
                      ),
                      child: Text(
                        'scan_qr_code'.tr(),
                        style: TextStyle(
                          color: isDarkMode ? redColor1 : redColor3,
                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                          fontSize: pathS / 4.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: showAlert,
                  child: AlertPopupView(
                      header: alertHeader,
                      message: alertMessage,
                      cancelBtn: '',
                      okBtn: 'ok'.tr(),
                      callBack: (value) {
                        setState(() {
                          showAlert = false;
                        });
                      }),
                ),
                LoaderView(isVisible: showLoaderView, message: ''),
                ToastMessageView(
                    isVisible: showToastMessageView, message: toastMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onUserIdChange1(String userid) {
    print('onUserIdChange1....userid.....$userid');
    debugPrint('USERID="$userid" LENGTH=${userid.length}');

    final mobileNoRegExp = RegExp(r'^\d{10}$'); // 10-digit mobile number
    final sisIdRegExp = RegExp(r'^SIS\d{7}$'); // SIS followed by exactly 7 numeric characters
    final otherIdRegExp = RegExp(r'^(?!SIS)[A-Z]{3}\d{6}$'); // Exclude SIS and match 3 uppercase letters followed by 6 digits


    if (mobileNoRegExp.hasMatch(userid) ||
        sisIdRegExp.hasMatch(userid) ||
        otherIdRegExp.hasMatch(userid)) {
      setState(() {
        nextBgColor = Color.fromRGBO(195, 50, 30, 1);
        nextFontColor = Colors.white;
        nextShadowColor = Colors.black.withOpacity(0.2);
        lineBorderColor = Color.fromRGBO(51, 51, 51, 0.5);
        lblErrorMsg = '';
        isTapEnabled = true; // Enable tap
        if (userid.length >= 10) {
          FocusScope.of(context).unfocus();
        }
      });
    } else {
      setState(() {
        nextBgColor = Color.fromRGBO(51, 51, 51, 0.2);
        nextFontColor = Color.fromRGBO(51, 51, 51, 0.6);
        nextShadowColor = Colors.transparent;
        lineBorderColor = Color.fromRGBO(255, 0, 0, 1);
        lblErrorMsg = 'enter_mobile_no'.tr();
        isTapEnabled = false; // Disable tap
      });
    }
  }

  void onUserIdChange(String userid) {
    final mobileNoRegExp = RegExp(r'^\d{10}$'); // 10-digit mobile number
    final sisIdRegExp =
        RegExp(r'^DTS\d{7}$'); // SIS followed by exactly 7 numeric characters
    final otherIdRegExp = RegExp(
        r'^(?!SIS)[A-Z]{3}\d{6}$'); // Exclude SIS and match 3 uppercase letters followed by 6 digits

    if (mobileNoRegExp.hasMatch(userid) ||
        sisIdRegExp.hasMatch(userid) ||
        otherIdRegExp.hasMatch(userid)) {
      setState(() {
        nextBgColor = isDarkMode ? redColor1 : redColor3;
        nextFontColor = Colors.white;
        nextShadowColor = shadowColor;
        lblErrorMsg = '';
        lineBorderColor = isDarkMode ? greyColorDark : greyColor5;
        isTapEnabled = true; // Enable tap
        if (userid.length >= 10) {
          FocusScope.of(context).unfocus();
        }
      });
    } else {
      setState(() {
        nextBgColor = isDarkMode ? greyColor8 : greyColor2;
        nextFontColor = isDarkMode ? greyColor7 : greyColor3;
        nextShadowColor = Colors.transparent;
        lblErrorMsg = 'enter_mobile_no'.tr();
        lineBorderColor = isDarkMode ? redColor3 : redColor1;
      });
    }
  }

  void onTapConfirm() {
    if (txtUserId.text.isEmpty) {
      // showToastView("All fields are required");
      return;
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => VerifyOTPView(),
    //   ),
    // );
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

  void onLoadScanEntry() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScanCardView(
          userProfile: widget.userProfile,
          attendanceMode: widget.attendanceMode,
          unitDutyPosts: widget.unitDutyPosts,
          unitShiftDetails: widget.unitShiftDetails,
          userPostings: widget.userPostings,
          attendanceStatus: widget.attendanceStatus,
        ),
      ),
    );
  }

  Future<void> onTapNext() async {
    printInDebug(txtUserId.text);
    if (widget.userProfile.mobile == txtUserId.text ||
        widget.userProfile.regNo == txtUserId.text) {
      List<UserAttendance> attendanceList = await attendanceMarkedToday();
      if (attendanceList.isNotEmpty &&
          widget.attendanceStatus == keyAttendanceStatusDutyIn) {
        UserAttendance attendance = attendanceList.first;
        final String punchTime = getFormattedDateTime(
          DateFormat('dd-MMM-yyyy HH:mm').format(attendance.actStartTime),
          'dd-MMM-yyyy HH:mm',
          'dd-MM-yyyy HH:mm',
        );
        setState(() {
          alertHeader = 'duty_mark_in_already'.tr();
          alertMessage =
              '${'unit_name'.tr()}  ${attendance.siteName}\n\n${'shift_name'.tr()}  ${attendance.shiftName}\n\n${'punch_Time'.tr()}  ${DateFormat('hh:mm:ss').format(attendance.actStartTime)}';
          showAlert = true;
        });
      } else {
        loadConfirmScreen(
          widget.userProfile,
          widget.attendanceMode,
          widget.unitDutyPosts,
          widget.unitShiftDetails,
          widget.userPostings,
          widget.attendanceStatus,
        );
      }
    } else {
      // call API to show data
      onLoadEmployeeRoasterData(txtUserId.text);
    }
  }

  Future<List<UserAttendance>> attendanceMarkedToday() async {
    List<UserAttendance> todayAttendance = [];

    final attendance =
        await DatabaseHelper.instance.getAllRecords<UserAttendance>(
      keyTableUserAttendance,
      (map) => UserAttendance.fromMap(map),
    );

// Filter for entries with dutyStatus == keyAttendanceStatusDutyIn and deleted == 0
    final dutyInRecords = attendance.where(
      (data) =>
          data.dutyStatus == keyAttendanceStatusDutyIn && data.deleted == 0,
    );

// Check if there are any valid records
    if (dutyInRecords.isNotEmpty) {
      // Find the latest shiftStartDate among the filtered records
      DateTime latestDutyInDate = dutyInRecords
          .map((data) => data.shiftStartDate)
          .reduce((a, b) => a.isAfter(b) ? a : b);

      // Get the records that match the latest shiftStartDate
      todayAttendance = dutyInRecords
          .where(
              (data) => data.shiftStartDate.isAtSameMomentAs(latestDutyInDate))
          .toList();
    }

    return todayAttendance;
  }

  void onLoadEmployeeRoasterData(String userId) {
    setState(() {
      showLoaderView = true;
    });
    Map<String, String> inputData = {
      "regNo": userId,
      "dutyMode": widget.attendanceStatus,
    };

    APIHelper.instance.getUserData(employeeRoasterApi, inputData, (data) {
      setState(() {
        showLoaderView = false;
      });

      if (data.isNotEmpty) {
        final employeeRoaster = EmployeeRoasterDetail.fromJson(data);
        // Example usage:
        printInDebug(employeeRoaster.employeeDetail.first.empName);

        loadConfirmScreen(
          employeeRoaster.employeeDetail.first,
          widget.attendanceMode,
          employeeRoaster.unitDutyPost,
          employeeRoaster.unitShiftDetail,
          employeeRoaster.userPosting,
          widget.attendanceStatus,
        );
      }
    }, (error) {
      setState(() {
        showLoaderView = false;
        print('test $error');
        String msg =
            error['ErrorMessage'] ?? 'invalid_credentials_sign_IN'.tr();
        showToastView(msg);
      });
    });
  }

  void loadConfirmScreen(
    UserProfile userProfile,
    String attendanceMode,
    List<UnitDutyPost> unitDutyPosts,
    List<UnitShiftDetail> unitShiftDetails,
    List<UserPosting> userPostings,
    String attendanceStatus,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmProfileView(
          userProfile: userProfile,
          attendanceMode: attendanceMode,
          unitDutyPosts: unitDutyPosts,
          unitShiftDetails: unitShiftDetails,
          userPostings: userPostings,
          attendanceStatus: attendanceStatus,
        ),
      ),
    );
  }
}
