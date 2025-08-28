
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mysis/CommonViews/LocationAlertPopupView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/EscortDuty/EscortDuty.dart';
import 'package:mysis/HomeView/SelectShiftView.dart';
import 'package:mysis/HomeView/UserAttendance.dart';
import 'package:mysis/Profile/UnitDutyPost.dart';
import 'package:mysis/Profile/UserPosting.dart';
import 'package:mysis/Profile/UserProfile.dart';

import '../CommonViews/AlertPopupView.dart';
import '../CommonViews/LoaderView.dart';
import '../Profile/UnitShiftDetail.dart';
import '../SharedClasses/DatabaseHelper.dart';
import 'SubmitDutyView.dart';

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

  String attendanceMode = '';
  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String imagePath = '';
  bool noData = true;
  bool showAlert = false;
  String alertHeader = '';
  String alertMessage = '';
  String cancelBtnTitle = '';
  String okBtnTitle = 'ok'.tr();


  bool showLocationAlert = false;
  String locationAlertHeader = '';
  String locationAlertMessage = '';
  String locationCancelBtnTitle = '';
  String locationOkBtnTitle = 'ok'.tr();
  String locationOtherBtnTitle = 'check_on_map'.tr().toUpperCase();
  String locationLatLng = '';

  String name  = '';
  String position  = '';

  bool showMarkEscortDuty = false;
  String escortDutyUnitCode = '';

 late UnitDutyPost selectedUnitDutyPost;
  late UserPosting selectedUserPosting;
   UnitShiftDetail? dutyInShiftDetail;

  late List<UnitShiftDetail> matchingShiftDetails;
  String deviceLatLong  = '';
  DateTime dutyDateTime = DateTime.now();

  // late List<UserPosting> userPostings;

  late  MobileScannerController locationScannerController;

  List<EscortDuty> approvedEscortDuty = [];

  bool showLoaderView = false;

  String retryMethod = '';

  @override
  void initState() {

    attendanceMode = widget.attendanceMode;
    updateEscortDutyUI();
    locationScannerController = MobileScannerController();
    updateLocationData();
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
                          color: shadowColor,
                          blurRadius: pathS / 15,
                          offset: Offset(-0, pathS / 12),
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
                              if(showMarkEscortDuty)GestureDetector(
                                onTap: (){
                                  onTapMarkEscortDuty();
                                },
                                child: Container(
                                  height: pathS / 1.8,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:   isDarkMode ? redColor1 : redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                                    borderRadius: BorderRadius.circular(pathS/3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: shadowColor, // Shadow color
                                        blurRadius: pathS/15, // Spread of the shadow
                                        // spreadRadius: pathS/15, // How far the shadow extends
                                        offset:  Offset(-pathS/12, pathS/12),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding:  EdgeInsets.only(left: pathS/5,right: pathS/5),
                                    child: Text(
                                      'mark_escort_duty'.tr(),
                                      style: TextStyle(
                                        color:  isDarkMode ? whiteColor : whiteColor,
                                        fontSize: pathS / 5,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
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
                            break;
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



                  ],
                ),

                Visibility(
                  visible: showAlert,
                  child: AlertPopupView(
                      header: alertHeader,
                      message: alertMessage,
                      cancelBtn: cancelBtnTitle,
                      okBtn: okBtnTitle,
                      callBack: (value){
                        setState(() {
                          showAlert = false;
                        });

                        if(value == 0 && cancelBtnTitle == 'Cancel'.tr()){
                          Navigator.pop(context);
                        }
                        if(value == 0 && cancelBtnTitle == 'ignore'.tr()){
                          onTapIgnoreAndSubmit();
                        }
                        if(value == 1 && okBtnTitle == 'refresh'.tr()){
                          onTapRefreshAndRetry();
                        }
                      }
                  ),
                ),
                Visibility(
                  visible: showLocationAlert,
                  child: LocationAlertPopupView(
                      header: locationAlertHeader,
                      message: locationAlertMessage,
                      cancelBtn: locationCancelBtnTitle,
                      okBtn: locationOkBtnTitle,
                      otherBtnTitle: locationOtherBtnTitle,
                      latLong: locationLatLng,
                      callBack: (value){
                        setState(() {
                          showLocationAlert = false;
                        });

                        if(value == 0 && locationCancelBtnTitle == 'Cancel'.tr()){
                          Navigator.pop(context);
                        }
                        if(value == 0 && locationCancelBtnTitle == 'ignore'.tr()){
                          onTapIgnoreAndSubmit();
                        }
                        if(value == 1 && locationOkBtnTitle == 'refresh'.tr()){
                          onTapRefreshAndRetry();
                        }
                      }
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

  Future<void> updateEscortDutyUI() async {


    if(widget.userAttendance != null && widget.attendanceMode == keyAttendanceModeEscortDuty){
      escortDutyUnitCode = widget.userAttendance!.unitCode;
      setState(() {
        showMarkEscortDuty = true;
      });
      return;
    }

    approvedEscortDuty =  await getApprovedEscortDuty(DateTime.now());

    if(approvedEscortDuty.isNotEmpty ) {
      escortDutyUnitCode = approvedEscortDuty.first.unitCode;
      if( widget.attendanceMode == keyAttendanceModeOther){
        setState(() {
          showMarkEscortDuty = true;
        });
      }
      if(widget.attendanceMode == keyAttendanceModeSelf && widget.unitDutyPosts.isNotEmpty){

        final dutyEscortDuty = approvedEscortDuty.where((data) {
          return    data.unitCode == widget.unitDutyPosts.first.unitCode;
        }).toList();

        if(dutyEscortDuty.isNotEmpty){
          setState(() {
            showMarkEscortDuty = true;
          });
        }
      }
    }

  }
  void onLoadUpdateUI(){

    imagePath = widget.userProfile.profileImageUrl;
    name = widget.userProfile.empName;
    position = widget.userProfile.symbol;

  }

  void onTapMarkEscortDuty(){
    getUnitPostDataByUnit(escortDutyUnitCode);
  }
  Future<void> updateLocationData() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.best, // Adjust accuracy as needed
          distanceFilter: 10, // Optional: Minimum distance between updates in meters
        ),
      );

      printInDebug('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      deviceLatLong = '${position.latitude},${position.longitude}';
    } catch (e) {
      printInDebug('Error: $e');
    }
  }

  Future<void> scanBarcode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );

    if (result != null && result is String) {
      getUnitPostData(result); // Use scanned result
    }
  }

  Future<void> getUnitPostData(String qrId) async {

   final unitDutyPost = widget.unitDutyPosts.where((post) => post.qrId == qrId).toList();

    if (unitDutyPost.isEmpty) {
      showPopupAlert('alert'.tr(), 'no_data_available'.tr());
    } else {
      selectedUnitDutyPost = unitDutyPost.first;
      getUserPosting(unitDutyPost.first.unitCode);

    }
  }
  Future<void> getUnitPostDataByUnit(String unitCode) async {

    attendanceMode = keyAttendanceModeEscortDuty;
    final unitDutyPost = widget.unitDutyPosts.where((post) => post.unitCode == unitCode).toList();

    if (unitDutyPost.isEmpty) {
      showPopupAlert('alert'.tr(), 'no_unit_duty_post'.tr());
    }
    else {
      selectedUnitDutyPost = unitDutyPost.first;
      getUserPosting(unitDutyPost.first.unitCode);

    }
  }
  Future<void> getUserPosting(String unitCode) async {

    final userPostings = widget.userPostings.where((userPosting) {
      return userPosting.unitCode == unitCode ;
    }).toList();

    if (userPostings.isEmpty) {
      showPopupAlert('alert'.tr(), 'no_user_post'.tr());
    }
    else {
      selectedUserPosting = userPostings.first;
      if(widget.attendanceStatus == keyAttendanceStatusDutyIn) {
        getUnitShiftDetails(userPostings.first.unitCode);
      }

      if(widget.attendanceStatus == keyAttendanceStatusDutyOut && widget.userAttendance != null) {

        getUnitShiftDetailsById(widget.userAttendance!.shiftId);

      }
    }
  }
  Future<void> getUnitShiftDetails(String unitCode) async {
    DateTime now = DateTime.now();
    TimeOfDay currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    // Fetching extra duties count and total duty minutes done
    int doubleDutyCount = await DatabaseHelper.instance.countMonthExtraDuties(
        regNo, dutyDateTime.month, dutyDateTime.year);

    int dutyDoneMints = await DatabaseHelper.instance.getTotalDutyMinutes(
        regNo, dutyDateTime.day, dutyDateTime.month, dutyDateTime.year);

    bool dutyHrs12Allowed = true;

    // Restriction: No shifts allowed if doubleDutyCount >= 2 and total duty minutes >= 720
    if (doubleDutyCount >= 2 && dutyDoneMints >= 720) {
      showPopupAlert('alert'.tr(), 'other_mark_shift_not_allowed1'.tr());
      return; // Stop execution if not allowed
    }

    // Restriction: 12-hour shifts not allowed if doubleDutyCount >= 2 and some duty minutes are already done
    if (doubleDutyCount >= 2 && dutyDoneMints > 0 && dutyDoneMints < 720) {
      dutyHrs12Allowed = false;
    }

    // Filter shifts based on time, unitCode, and duty hours condition
    matchingShiftDetails = widget.unitShiftDetails.where((shift) {
      TimeOfDay startTime = _parseTimeOfDay(shift.startTime);
      TimeOfDay endTime = _parseTimeOfDay(shift.endTime);

      Duration shiftStartBeforeDuration = _parseShiftDuration(shift.shiftStartBefore);
      Duration shiftEndAfterDuration = _parseShiftDuration(shift.dutyInBefore);

      TimeOfDay adjustedStartTime = _adjustTimeOfDay(startTime, shiftStartBeforeDuration);
      TimeOfDay adjustedEndTime = _adjustTimeOfDay(endTime, shiftEndAfterDuration);

      // Convert shift.dutyHrs to double safely
      double dutyHours = double.tryParse(shift.dutyHrs) ?? 0.0;

      // Check if shift is within the allowed time range and unit
      bool isValidTime = _isTimeBetween(currentTime, adjustedStartTime, adjustedEndTime);
      bool isValidUnit = shift.unitCode == unitCode;

      // Restrict 12-hour shifts if dutyHrs12Allowed is false
      bool isValidShift = dutyHrs12Allowed || dutyHours < 12.0;

      return isValidTime && isValidUnit && isValidShift;
    }).toList();

    // Handle shift availability
    if (matchingShiftDetails.isEmpty) {
      showPopupAlert('alert'.tr(), 'other_mark_shift_not_allowed1'.tr());
    } else {
      loadSelectShiftView();
    }
  }

  Future<void> getUnitShiftDetails1(String unitCode) async {

    DateTime now = DateTime.now();
    TimeOfDay currentTime = TimeOfDay(hour: now.hour, minute: now.minute);


    int doubleDutyCount =  await DatabaseHelper.instance.countMonthExtraDuties(regNo, dutyDateTime.month,dutyDateTime.year);

    int dutyDoneMints =  await DatabaseHelper.instance.getTotalDutyMinutes(regNo,dutyDateTime.day, dutyDateTime.month,dutyDateTime.year);

    matchingShiftDetails = widget.unitShiftDetails.where((shift) {

      TimeOfDay startTime = _parseTimeOfDay(shift.startTime);
      TimeOfDay endTime = _parseTimeOfDay(shift.endTime);

      Duration shiftStartBeforeDuration = _parseShiftDuration(shift.shiftStartBefore);
      Duration shiftEndAfterDuration = _parseShiftDuration(shift.dutyInBefore);

      TimeOfDay adjustedStartTime = _adjustTimeOfDay(startTime, shiftStartBeforeDuration);
      TimeOfDay adjustedEndTime = _adjustTimeOfDay(endTime, shiftEndAfterDuration);

      return shift.unitCode == unitCode
          && _isTimeBetween(currentTime, adjustedStartTime, adjustedEndTime);
    }).toList();


      if (matchingShiftDetails.isEmpty) {
         showPopupAlert('alert'.tr(), 'other_mark_shift_not_allowed1'.tr());
      } else {
        loadSelectShiftView();
      }
  }

  Future<void> getUnitShiftDetailsById(String shiftId) async {

    DateTime now = DateTime.now();
    TimeOfDay currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    dutyInShiftDetail = widget.unitShiftDetails.firstWhere(
          (shift) {
        TimeOfDay startTime = _parseTimeOfDay(shift.startTime);
        TimeOfDay endTime = _parseTimeOfDay(shift.endTime);

        Duration shiftStartBeforeDuration = _parseShiftDuration(shift.shiftStartBefore);
        Duration shiftEndAfterDuration = _parseShiftDuration(shift.dutyInBefore);

        TimeOfDay adjustedStartTime = _adjustTimeOfDay(startTime, shiftStartBeforeDuration);
        TimeOfDay adjustedEndTime = _adjustTimeOfDay(endTime, shiftEndAfterDuration);

        return shift.shiftId == shiftId &&
            _isTimeBetween(currentTime, adjustedStartTime, adjustedEndTime);
      },
    );

    if (dutyInShiftDetail == null && widget.attendanceStatus == keyAttendanceStatusDutyOut) {
      showPopupAlert('alert'.tr(), 'other_mark_shift_not_allowed1'.tr());
    } else {
      loadSubmitDutyView();
    }
  }
  Future<List<EscortDuty>> getApprovedEscortDuty(DateTime selectedDate) async {

    List<EscortDuty> escortDutyAllData = await DatabaseHelper.instance.getAllRecords<EscortDuty>(
      keyTableEscortDuty,
          (map) => EscortDuty.fromMap(map),
    );

    final escortDutyApprovedData = escortDutyAllData.where((data) {
      // Compare only the date part (year, month, day) of the selectedDate and leave dates
      return    (data.startDate.year < selectedDate.year ||
          (data.startDate.year == selectedDate.year &&
              data.startDate.month < selectedDate.month) ||
          (data.startDate.year == selectedDate.year &&
              data.startDate.month == selectedDate.month &&
              data.startDate.day <= selectedDate.day)) &&
          (data.endDate.year > selectedDate.year ||
              (data.endDate.year == selectedDate.year &&
                  data.endDate.month > selectedDate.month) ||
              (data.endDate.year == selectedDate.year &&
                  data.endDate.month == selectedDate.month &&
                  data.endDate.day >= selectedDate.day)) &&
          data.status == keyApprovedEscortDuty;
    }).toList();


    for (var data in escortDutyApprovedData) {
      printInDebug('escortDutyApproved Data');
      data.toMap().forEach((i, j) {
        printInDebug('$i : $j');
      });

    }

    return escortDutyApprovedData;
  }
  TimeOfDay _parseTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
  TimeOfDay _adjustTimeOfDay(TimeOfDay time, Duration adjustmentDuration) {
    final adjustmentMinutes = adjustmentDuration.inMinutes; // Convert Duration to int (minutes)
    final totalMinutes = time.hour * 60 + time.minute - adjustmentMinutes;
    final adjustedHour = (totalMinutes ~/ 60) % 24;
    final adjustedMinute = totalMinutes % 60;
    return TimeOfDay(hour: adjustedHour, minute: adjustedMinute);
  }
  bool _isTimeBetween(TimeOfDay current, TimeOfDay start, TimeOfDay end) {
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    if (startMinutes <= endMinutes) {
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } else {
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }
  }
  Duration _parseShiftDuration(String shiftDuration) {
    List<String> parts = shiftDuration.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }

  bool checkDutyLocation(UnitDutyPost dutyPost, String currentLatLng, String retryCall){

    printInDebug('test');

    bool locationVerified = false;

    List<String> activeDayList = currentLatLng.isNotEmpty ? currentLatLng.split(',').map((e) => e.trim()).toList() : ['0.0','0.0'];
    double currentLat = double.parse(activeDayList[0]) ; // Latitude
    double currentLng = double.parse(activeDayList[1]); // Longitude

    printInDebug('${dutyPost.isGeoFenceAllow}');

    if(dutyPost.isGeoFenceAllow == 1){
      printInDebug('${dutyPost.isGeoFenceAllow}');
      locationVerified = false;
      if(currentLat > 0.0 && currentLng > 0.0){
        int currentDistance = getDistanceFromDuty(dutyPost.geoLocation, currentLatLng);
        if(currentDistance <= dutyPost.allowDistance){
          locationVerified = true;
        }
        else{
          locationVerified = false;
          String message = '${'your_location'.tr()}: $currentLatLng\n${'distance_from_post'.tr()}: $currentDistance ${'meter'.tr()}' ;
          showLocationPopupAlert(
              'not_allow_range_location'.tr(),
              message,
              currentLatLng,
              cancelText:'Cancel'.tr(),
            okText: 'refresh'.tr(),

          );
        }

      }
      else{
        locationVerified = false;
        showPopupAlert(
            'device_location'.tr(),
            'not_allow_range_location'.tr(),
            cancelText:dutyPost.ignoreBlankLocation == 1 ? 'ignore'.tr() : 'Cancel'.tr(),
            okText:'refresh'.tr(),

        );
      }

    }
    else{
      locationVerified = true;
    }

    retryMethod = !locationVerified ? retryCall : '';
    return locationVerified;

  }
  Future<void> onTapIgnoreAndSubmit() async {

    if(retryMethod == 'SelectShiftView'){
      loadSelectShiftView( ignoreAndSubmit: true);
    }

    if(retryMethod == 'SubmitDutyView'){
      loadSubmitDutyView(ignoreAndSubmit: true);
    }


  }

  Future<void> onTapRefreshAndRetry() async {

    setState(() {
      showLoaderView = true;
    });

    await updateLocationData();

    Future.delayed(Duration(seconds: 2), (){
        if(retryMethod == 'SelectShiftView'){
          loadSelectShiftView();
        }

        if(retryMethod == 'SubmitDutyView'){
          loadSubmitDutyView();
        }

        setState(() {
          showLoaderView = false;
        });
    });




  }

  void showPopupAlert(String header, String message, {String cancelText = '', String okText = ''} ){
    setState(() {
      alertHeader = header;
      alertMessage = message;
      showAlert = true;
      cancelBtnTitle = cancelText;
      okBtnTitle =  okText.isNotEmpty ? okText : 'ok'.tr();

    });
  }

  void showLocationPopupAlert(String header, String message,String latLng, {String cancelText = '', String okText = ''} ){
    setState(() {
      locationAlertHeader = header;
      locationAlertMessage = message;
      showLocationAlert = true;
      locationCancelBtnTitle = cancelText;
      locationOkBtnTitle =  okText.isNotEmpty ? okText : 'ok'.tr();
      locationLatLng = latLng;

    });
  }


  void loadSelectShiftView({bool ignoreAndSubmit = false}){

    if(!ignoreAndSubmit) {
      if (!checkDutyLocation(selectedUnitDutyPost, deviceLatLong, 'SelectShiftView')) {
        return;
      }
    }

    locationScannerController.dispose();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectShiftView(
          userProfile: widget.userProfile,
          unitDutyPost: selectedUnitDutyPost,
          unitShiftDetail: matchingShiftDetails,
          userPosting: selectedUserPosting,
          attendanceMode: attendanceMode,
          attendanceStatus: widget.attendanceStatus,
          latLong: deviceLatLong,
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
  void loadSubmitDutyView({bool ignoreAndSubmit = false}){

    if(!ignoreAndSubmit){
     if(!checkDutyLocation(selectedUnitDutyPost, deviceLatLong, 'SubmitDutyView')){
      return;
    }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitDutyView(
          userProfile: widget.userProfile,
          unitDutyPost: selectedUnitDutyPost,
          unitShiftDetail: dutyInShiftDetail!,
          userPosting: selectedUserPosting,
          attendanceMode: widget.attendanceMode,
          attendanceStatus: widget.attendanceStatus,
          latLong: deviceLatLong,
          dutyDateTime: dutyDateTime.toIso8601String(),
          userAttendance: widget.userAttendance,

        ),
      ),
    );
  }


}


class BarcodeScannerPage extends StatelessWidget {
  const BarcodeScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: MobileScanner(
        // allowDuplicates: false,
        // key: locationScannerKey, // Assign the unique key
        // controller: locationScannerController,
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final String? code = barcode.rawValue;
          if (code != null) {
            Navigator.pop(context, code); // Return scanned result
          }
        },
      ),
    );
  }
}
