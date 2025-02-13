import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/SelectShiftView.dart';
import 'package:mysis/HomeView/UserAttendance.dart';
import 'package:mysis/Profile/UnitDutyPost.dart';
import 'package:mysis/Profile/UserPosting.dart';
import 'package:mysis/Profile/UserProfile.dart';

import '../CommonViews/AlertPopupView.dart';
import '../Profile/UnitShiftDetail.dart';

class ScanUnitShiftView extends StatefulWidget {

  final UserProfile userProfile;
  final String attendanceMode;
  final List<UnitDutyPost> unitDutyPosts;
  final List<UnitShiftDetail> unitShiftDetails;
  final List<UserPosting> userPostings;
  final String attendanceStatus;
  final UserAttendance? userAttendance;

  const ScanUnitShiftView(
      {
        super.key,
        required this.userProfile,
        required this.attendanceMode,
        required this.unitDutyPosts,
        required this.unitShiftDetails,
        required this.userPostings,
        required this.attendanceStatus,
         this.userAttendance,


      });
  @override
  ScanUnitShiftViewState createState() => ScanUnitShiftViewState();
}

class ScanUnitShiftViewState extends State<ScanUnitShiftView>{
  Key locationScannerKey = UniqueKey();

  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String imagePath = '';
  bool noData = true;

  String name  = '';
  String position  = '';

 late UnitDutyPost selectedUnitDutyPost;
  late UserPosting selectedUserPosting;

  late List<UnitShiftDetail> matchingShiftDetails;
  String latLong  = '';
  DateTime dutyDateTime = DateTime.now();

  // late List<UserPosting> userPostings;

  late  MobileScannerController locationScannerController;


  bool showAlert = false;
  String alertHeader = '';
  String alertMessage = '';

  @override
  void initState() {

    locationScannerController = MobileScannerController();
    getCurrentLocation();
    onLoadUpdateUI();
    super.initState();

  }

  @override
  void dispose() {
    locationScannerController.dispose();
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
              color: greyColor6
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top:MediaQuery.of(context).padding.top,
                  child: Container(
                    width: screenWidth,
                    // height: pathS / 1.2,
                    decoration: BoxDecoration(
                      color: isDarkMode ? greyColor6 : whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: pathS / 10,
                          offset: Offset(-pathS / 12, pathS / 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: paddingLeft + pathS / 4, right: paddingRight + pathS / 3,top: pathS/5,bottom: pathS/5),
                      child: Column(
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CachedNetworkImage(
                                height: pathS / 1.55,
                                width: pathS / 1.55,
                                imageUrl: imagePath,
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundImage: AssetImage(assetsImagePath),
                                  backgroundColor: Colors.white,
                                ),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  backgroundImage: AssetImage(assetsImagePath),
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
                                      Text(
                                        name,
                                        style: TextStyle(
                                          color: isDarkMode ? whiteColor : greyColor6,
                                          fontSize: pathS / 5,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        position,
                                        style: TextStyle(
                                          color: isDarkMode ? whiteColor : greyColor6,
                                          fontSize: pathS / 6.5,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
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
                          SizedBox(height: pathS/5),
                          Container(
                            height: 1,
                            color: isDarkMode ? greyColorDark : greyColor2,
                          ),
                          SizedBox(height: pathS/5),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/home/unit-location.png',
                                height: pathS/1.5,
                                width: pathS/1.5,
                                color: isDarkMode ? redColor1 : redColor3,
                              ),
                              SizedBox(width: pathS/5),
                              Expanded(
                                child: Text(
                                  'qr_code_scan_location'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ? whiteColor : greyColor6,
                                    fontSize: pathS / 5.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.left,

                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),

                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: pathL),
                    Container(
                      alignment: Alignment.center,
                      width: pathL * 2,
                      height: pathL * 2,
                      decoration: BoxDecoration(
                        color: isDarkMode ? greyColor7 : whiteColor,
                        borderRadius: BorderRadius.circular(pathS / 8),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode ? shadowColor : shadowColor,
                            blurRadius: pathS / 10,
                            offset: Offset(-pathS / 12, pathS / 12),
                          ),
                        ],
                      ),
                      child: MobileScanner(
                        key: locationScannerKey, // Assign the unique key
                        controller: locationScannerController,
                        onDetect: (barcodeCapture) {
                          for (final barcode in barcodeCapture.barcodes) {
                            debugPrint('Barcode found: ${barcode.rawValue}');
                            getUnitPostData(barcode.rawValue!);
                          }
                        },
                        fit: BoxFit.cover, // Ensure the scanner fills the container
                        placeholderBuilder: (context, constraints) {
                          return Center(
                            child: Text('Initializing camera...'),
                          );
                        },
                        errorBuilder: (context, error, child) {
                          debugPrint('Barcode found: ${error.errorCode}');

                          return Center(
                            child: Text(
                                'Error: ${error.errorCode}'
                            ),
                          );
                        },
                      ),
                    ),



                  ],
                ),

                Visibility(
                  visible: showAlert,
                  child: AlertPopupView(
                      header: alertHeader,
                      message: alertMessage,
                      cancelBtn: '',
                      okBtn: 'ok'.tr(),
                      callBack: (value){
                        setState(() {
                          showAlert = false;
                        });
                      }
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }



  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.best, // Adjust accuracy as needed
          distanceFilter: 10, // Optional: Minimum distance between updates in meters
        ),
      );

      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      latLong = '${position.latitude},${position.longitude}';
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> scanBarcode() async {

    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scan button
      'Cancel', // Text for the cancel button
      true, // Wait for the result before returning
      ScanMode.BARCODE, // Specify the type of scan (BARCODE or QR)
    );

    getUnitPostData(barcodeScanRes);


  }

  Future<void> getUnitPostData(String qrId) async {
    // // Filter the records based on the provided qrId
    for (var data in widget.unitDutyPosts) {
      printInDebug('widget ID: ${data.id}');
      printInDebug('widget post name: ${data.postName}');
    }
   final unitDutyPost = widget.unitDutyPosts.where((post) => post.qrId == qrId).toList();

    if (unitDutyPost.isEmpty) {
      printInDebug('No records found for qrId: $qrId');
    } else {
      selectedUnitDutyPost = unitDutyPost.first;

      getUserPosting(unitDutyPost.first.unitCode);
      for (var data in unitDutyPost) {
        printInDebug(' ID: ${data.id}');
        printInDebug(' post name: ${data.postName}');
      }
    }
  }

  Future<void> getUnitShiftDetails(String unitCode) async {
    // Fetch all UnitShiftDetail records
    // final unitShiftDetails = await DatabaseHelper.instance.getAllRecords<UnitShiftDetail>(
    //   keyTableUnitShiftDetail,
    //       (map) => UnitShiftDetail.fromMap(map),
    // );

    // Get the current time
    DateTime now = DateTime.now();

    // Extract the current time in terms of hours, minutes, and seconds
    TimeOfDay currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    // Filter the records based on the conditions
    matchingShiftDetails = widget.unitShiftDetails.where((shift) {
      // Parse start and end times as TimeOfDay
      TimeOfDay startTime = _parseTimeOfDay(shift.startTime);
      TimeOfDay endTime = _parseTimeOfDay(shift.endTime);

      // Parse shift start before and end after durations
      Duration shiftStartBeforeDuration = _parseShiftDuration(shift.shiftStartBefore);
      Duration shiftEndAfterDuration = _parseShiftDuration(shift.dutyInBefore);

      // Adjust start and end times
      TimeOfDay adjustedStartTime = _adjustTimeOfDay(startTime, shiftStartBeforeDuration);
      TimeOfDay adjustedEndTime = _adjustTimeOfDay(endTime, shiftEndAfterDuration);

      // Check if current time is within the adjusted time range
      return shift.unitCode == unitCode &&
          _isTimeBetween(currentTime, adjustedStartTime, adjustedEndTime);
    }).toList();

    // Check the results
    if (matchingShiftDetails.isEmpty) {
      printInDebug('No shifts found for UNIT_CODE: $unitCode and current time: $currentTime');

      setState(() {
        alertHeader = 'alert'.tr();
        alertMessage = 'other_mark_shift_not_allowed1'.tr();
        showAlert = true;
      });

    } else {
      onLoadSelectShift();
      for (var shift in matchingShiftDetails) {
        printInDebug('Shift ID: ${shift.id}');
        printInDebug('Shift Name: ${shift.shiftName}');
      }
    }
  }

// Helper function to parse TimeOfDay from "HH:mm:ss" string
  TimeOfDay _parseTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

// Helper function to adjust TimeOfDay by a Duration
// Helper function to adjust TimeOfDay by a Duration
  TimeOfDay _adjustTimeOfDay(TimeOfDay time, Duration adjustmentDuration) {
    final adjustmentMinutes = adjustmentDuration.inMinutes; // Convert Duration to int (minutes)
    final totalMinutes = time.hour * 60 + time.minute - adjustmentMinutes;
    final adjustedHour = (totalMinutes ~/ 60) % 24;
    final adjustedMinute = totalMinutes % 60;
    return TimeOfDay(hour: adjustedHour, minute: adjustedMinute);
  }

// Helper function to check if a time is within a range
  bool _isTimeBetween(TimeOfDay current, TimeOfDay start, TimeOfDay end) {
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    if (startMinutes <= endMinutes) {
      // Normal case: Start and end are on the same day
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } else {
      // Overnight case: Start is before midnight, end is after midnight
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }
  }

// Helper function to parse "HH:mm:ss" to Duration
  Duration _parseShiftDuration(String shiftDuration) {
    List<String> parts = shiftDuration.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }

  Future<void> getUserPosting(String unitCode) async {
    // Fetch all UnitShiftDetail records
    // final userPostingData = await DatabaseHelper.instance.getAllRecords<UserPosting>(
    //   keyTableUserPosting,
    //       (map) => UserPosting.fromMap(map),
    // );

    // Filter the records based on the conditions
   final userPostings = widget.userPostings.where((userPosting) {
      return userPosting.unitCode == unitCode ;
    }).toList();

    // Check the results
    if (userPostings.isEmpty) {
      printInDebug('No userPostings found for UNIT_CODE: $unitCode ');
    } else {
      selectedUserPosting = userPostings.first;
      getUnitShiftDetails(userPostings.first.unitCode);
      for (var posting in userPostings) {
        printInDebug('posting ID: ${posting.id}');
        printInDebug('posting Name: ${posting.siteName}');
      }
    }
  }

  void onLoadSelectShift(){

    printInDebug('load shift');

    locationScannerController.dispose();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectShiftView(
          userProfile: widget.userProfile,
          unitDutyPost: selectedUnitDutyPost,
          unitShiftDetail: matchingShiftDetails,
          userPosting: selectedUserPosting,
          attendanceMode: widget.attendanceMode,
          attendanceStatus: widget.attendanceStatus,
          latLong: latLong,
          dutyDateTime:  dutyDateTime.toIso8601String(),
          userAttendance: widget.userAttendance,
        ),
      ),
    )
        .then((val) {
      printInDebug('back from confirm profile');
      setState(() {
        locationScannerController = MobileScannerController();
      });
      locationScannerKey = UniqueKey(); // Force widget to reload
    });

  }

  void onLoadUpdateUI(){

    imagePath = widget.userProfile.profileImageUrl;
    name = widget.userProfile.empName;
    position = widget.userProfile.symbol;

  }


}
