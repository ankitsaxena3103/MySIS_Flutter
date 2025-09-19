import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/EnterManuallyView.dart';
import 'package:permission_handler/permission_handler.dart';

import '../CommonViews/LoaderView.dart';
import '../CommonViews/ToastMessageView.dart';
import '../Profile/UnitDutyPost.dart';
import '../Profile/UnitShiftDetail.dart';
import '../Profile/UserPosting.dart';
import '../Profile/UserProfile.dart';
import '../SharedClasses/APIHelper.dart';
import 'ConfirmProfileView.dart';
import 'Model/EmployeeRoasterDetail.dart';

class ScanCardView extends StatefulWidget {
  final UserProfile userProfile;
  final String attendanceMode;
  final List<UnitDutyPost> unitDutyPosts;
  final List<UnitShiftDetail> unitShiftDetails;
  final List<UserPosting> userPostings;
  final String attendanceStatus;


  const ScanCardView({
    super.key,
    required this.userProfile,
    required this.attendanceMode,
    required this.unitDutyPosts,
    required this.unitShiftDetails,
    required this.userPostings,
    required this.attendanceStatus
  });

  @override
  ScanCardViewState createState() => ScanCardViewState();
}

class ScanCardViewState extends State<ScanCardView>{

  Key scannerKey = UniqueKey();
  bool noData = true;
  bool showLoaderView = false;
  bool showToastMessageView = false;
  String toastMessage = '';

  late  MobileScannerController mobileNoScannerController;

  @override
  void initState() {
    mobileNoScannerController = MobileScannerController(
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal,
      returnImage: false,
    );    super.initState();

  }

  @override
  void dispose() {
    mobileNoScannerController.dispose();
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
              // gradient: isDarkMode ? backgroundGradientDark : backgroundGradientDark ,
              color:  greyColor8,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top:MediaQuery.of(context).padding.top,
                  child: Container(
                    width: screenWidth,
                    height: pathS / 1.2,
                    decoration: BoxDecoration(
                      color: isDarkMode ? greyColor8 : whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: pathS / 15,
                          offset: Offset(-0, pathS / 15),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: paddingLeft + pathS / 4, right: paddingRight + pathS / 3),
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
                                'scan_qr_code'.tr(),
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 5.5,
                                  fontWeight: FontWeight.w400,
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


                Container(
                  alignment: Alignment.center,
                  width:pathL*2,
                  height: pathL*2,
                  decoration: BoxDecoration(
                    color:  isDarkMode ? greyColorDark:whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                    borderRadius: BorderRadius.circular(pathS/15),
                    boxShadow: [
                      BoxShadow(
                        color:  isDarkMode ? greyColor6:shadowColor,
                        blurRadius: pathS/10, // Spread of the shadow
                        // spreadRadius: pathS/15, // How far the shadow extends
                        offset:  Offset(-pathS/12, pathS/12),
                      ),
                    ],
                  ),
                  child:MobileScanner(
                    key: scannerKey, // Assign the unique key
                    controller: mobileNoScannerController,
                    onDetect: (barcodeCapture) {
                      for (final barcode in barcodeCapture.barcodes) {
                        String? rawValue = barcode.rawValue;

                        if (rawValue != null && rawValue.isNotEmpty) {
                          if (rawValue.startsWith('\n')) {
                            rawValue = rawValue.substring(1);
                          }

                          List<String> lines = rawValue.split('\n');

                          if (lines.length >= 2) {
                            String secondLine = lines[1].trim(); // this will be PAT069548
                            debugPrint('Second Line: $secondLine');

                            if (widget.userProfile.mobile == secondLine || widget.userProfile.regNo == secondLine) {
                              onUserScannedId(secondLine);
                            } else {
                              onUserScannedData(secondLine);
                            }
                          }
                        }
                      }
                    },

                    fit: BoxFit.cover, // Ensure the scanner fills the container
                    placeholderBuilder: (context, constraints) {
                      return Center(
                        child: Text(
                            'camera_init'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, child) {
                      if (error is MobileScannerException &&
                          error.errorCode == MobileScannerErrorCode.permissionDenied) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'error_camera_init'.tr(),
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 5.5,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              SizedBox(height: pathS / 8),
                              ElevatedButton(
                                onPressed: () async {
                                  final status = await Permission.camera.request();
                                  if (status.isGranted) {
                                    mobileNoScannerController.start(); // restart scanner
                                  } else if (status.isPermanentlyDenied) {
                                    await openAppSettings(); // open phone settings
                                  }
                                },
                                child: Text(
                                    'permission_ensure'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ? redColor1:redColor3,
                                    fontSize: pathS / 5.5,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // fallback for other errors
                      return Center(
                        child: Text(
                          'error_camera_init'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      );
                    },

                  ),

                ),

                Positioned(
                  bottom: 0,

                  child: GestureDetector(
                    onTap: (){


                    },
                    child: Container(
                      width: screenWidth,
                      height: pathS / 1.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDarkMode ? greyColor6:whiteColor,

                        // border: Border.all(color: Colors.yellow, width: pathS/18),
                        // borderRadius: BorderRadius.circular(pathS/3),

                      ),

                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom,
                  child: GestureDetector(
                    onTap: (){
                      // Navigator.pop(context);
                      onLoadManualEntry();

                    },
                    child: Container(
                      width: screenWidth,
                      height: pathS / 1.3,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDarkMode ? greyColor6:whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: pathS / 15,
                            offset: Offset(-0, -pathS / 15),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            'not_able_scan'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? whiteColor:greyColor6,
                              fontSize: pathS / 5,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          SizedBox(width: pathS/8),
                          GestureDetector(
                            onTap: (){
                              // Navigator.pop(context);
                              onLoadManualEntry();

                            },
                            child: Text(
                              'enter_Manually'.tr(),
                              style: TextStyle(
                                color: isDarkMode ? redColor1:redColor3,
                                fontSize: pathS / 4.8,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                LoaderView(isVisible: showLoaderView, message: ''),
                ToastMessageView(isVisible: showToastMessageView, message: toastMessage),


              ],
            ),
          ),



        ],
      ),
    );
  }

  Future<void> _openSettings() async {
    await openAppSettings();
  }
  void onUserScannedId(String myId){
    printInDebug(myId);
    if(widget.userProfile.mobile == myId || widget.userProfile.regNo == myId) {
      loadConfirmScreen(
         widget.userProfile,
        widget.attendanceMode,
        widget.unitDutyPosts,
        widget.unitShiftDetails,
        widget.userPostings,
        widget.attendanceStatus,
      );
    }else{

    }
  }

  void onUserScannedData(String scannedData){
    //dispose once done scanning
    // mobileNoScannerController.dispose();
    printInDebug(scannedData);
    onLoadEmployeeRoasterData(scannedData);

  }

  void onLoadEmployeeRoasterData(String userId) {


    setState(() {
      showLoaderView = true;
    });
    Map <String,String> inputData = {
      "regNo": userId,
      "dutyMode":widget.attendanceStatus,
    };

    APIHelper.instance.getUserData(employeeRoasterApi,inputData, (data) {

      setState(() {
        showLoaderView = false;
      });

      if(data.isNotEmpty){

        final employeeRoaster = EmployeeRoasterDetail.fromJson(data);
        // Example usage:
        printInDebug(employeeRoaster.employeeDetail.first.empName);
        printInDebug(employeeRoaster.employeeAttendance.first.shiftName);
        loadConfirmScreen(
          employeeRoaster.employeeDetail.first,
          widget.attendanceMode,
          employeeRoaster.unitDutyPost,
          employeeRoaster.unitShiftDetail,
          employeeRoaster.userPosting,
          widget.attendanceStatus,
        );
      }

    },(error){
      setState(() {
        showLoaderView = false;

        print('test $error');
        String msg = error['ErrorMessage'] ?? 'invalid_credentials_sign_IN'.tr();
        showToastView(msg);

      });

    }
    );

  }

  void loadConfirmScreen(UserProfile userProfile, String attendanceMode, List<UnitDutyPost> unitDutyPosts, List<UnitShiftDetail> unitShiftDetails, List<UserPosting> userPostings, String attendanceStatus,){
    mobileNoScannerController.dispose();
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
    )
        .then((val) {
        printInDebug('back from confirm profile');
        setState(() {
          mobileNoScannerController = MobileScannerController(
            detectionSpeed: DetectionSpeed.noDuplicates,
            facing: CameraFacing.back,
          );
        });
        scannerKey = UniqueKey(); // Force widget to reload
    });
  }

  void onLoadManualEntry(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EnterManuallyView(
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
