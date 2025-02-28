import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/AlertPopupView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/ScanUnitShiftView.dart';
import 'package:mysis/HomeView/UserAttendance.dart';
import 'package:mysis/Profile/UserProfile.dart';

import '../Profile/UnitDutyPost.dart';
import '../Profile/UnitShiftDetail.dart';
import '../Profile/UserPosting.dart';
import '../SharedClasses/DatabaseHelper.dart';

class ConfirmProfileView extends StatefulWidget {

  final UserProfile userProfile;
  final String attendanceMode;
  final List<UnitDutyPost> unitDutyPosts;
  final List<UnitShiftDetail> unitShiftDetails;
  final List<UserPosting> userPostings;
  final String attendanceStatus;


  const ConfirmProfileView({
    super.key,
    required this.userProfile,
    required this.attendanceMode,
    required this.unitDutyPosts,
    required this.unitShiftDetails,
    required this.userPostings,
    required this.attendanceStatus
  });



  @override
  ConfirmProfileViewState createState() => ConfirmProfileViewState();
}

class ConfirmProfileViewState extends State<ConfirmProfileView>{

  String profileImage = "assets/images/dashboard-icons/profile-icon.png";
  String profileUrl = '';
  String name  = '';
  String position  = '';


  bool showAlert = false;
  String alertHeader = '';
  String alertMessage = '';


  @override
  void initState() {

    onLoadUpdateUI();
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
              gradient: isDarkMode ? backgroundGradientDark:backgroundGradient ,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [

                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  right: paddingRight+pathS/3,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context,true);
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
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'confirm_guard_profile'.tr(),
                      style: TextStyle(
                        color: isDarkMode ? whiteColor:greyColor6,
                        fontSize: pathS / 4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: pathS/3),
                    Container(
                      alignment: Alignment.center,
                      width:pathL*2,
                      height: pathL*2,
                      decoration: BoxDecoration(
                        color:  isDarkMode ? greyColor6:whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                        borderRadius: BorderRadius.circular(pathS/8),
                        boxShadow: [
                          BoxShadow(
                            color:  isDarkMode ? greyColor8:shadowColor,
                            blurRadius: pathS/15, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(-pathS/25, pathS/12),
                          ),
                        ],
                      ),
                      child:CachedNetworkImage(
                        // height: pathS /3,
                        // width: pathS /3,
                        imageUrl: profileUrl,
                        placeholder: (context, url) =>  Image.asset(
                          profileImage,
                          fit: BoxFit.contain,

                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          profileImage,
                          fit: BoxFit.contain,

                        ),
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          fit: BoxFit.cover, // Adjust the fit as needed
                        ),
                      ),
                    ),
                    SizedBox(height: pathS/3),
                    Text(
                      name,
                      style: TextStyle(
                        color: isDarkMode ? whiteColor:greyColor6,
                        fontSize: pathS / 4,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Text(
                      position,
                      style: TextStyle(
                        color: isDarkMode ? whiteColor:greyColor6,
                        fontSize: pathS / 5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: pathS),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: pathL,
                            height: pathS / 1.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                              borderRadius: BorderRadius.circular(pathS/3),
                              border: Border.all(color: redColor3, width:1),
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
                              'txt_cancel'.tr(),
                              style: TextStyle(
                                color: redColor3,
                                fontSize: pathS / 4,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: pathS/3),
                        GestureDetector(
                          onTap: (){
                            onTapConfirm();
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
                                  color: Colors.transparent, // Shadow color
                                  blurRadius: pathS/10, // Spread of the shadow
                                  // spreadRadius: pathS/15, // How far the shadow extends
                                  offset:  Offset(-pathS/12, pathS/12),
                                ),
                              ],
                            ),
                            child: Text(
                              'confirm'.tr(),
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: pathS / 4,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto'
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void onLoadUpdateUI(){

    profileUrl = widget.userProfile.profileImageUrl;
    name = widget.userProfile.empName;
    position = widget.userProfile.symbol;

  }

  Future<void> onTapConfirm() async {
    if (widget.attendanceStatus == keyAttendanceStatusDutyOut) {
      final attendance = await DatabaseHelper.instance.getAllRecords<UserAttendance>(
        keyTableUserAttendance,
            (map) => UserAttendance.fromMap(map),
      );

      List<UserAttendance> todayAttendance = [];

      final dutyInRecords = attendance.where(
            (data) => data.dutyStatus == keyAttendanceStatusDutyIn && data.deleted == 0,
      );

      if (dutyInRecords.isNotEmpty) {
        DateTime latestDutyInDate = dutyInRecords
            .map((data) => data.shiftStartDate)
            .reduce((a, b) => a.isAfter(b) ? a : b);

        todayAttendance = dutyInRecords
            .where((data) => data.shiftStartDate.isAtSameMomentAs(latestDutyInDate))
            .toList();

        printInDebug('$latestDutyInDate');

      }


      if (todayAttendance.isNotEmpty) {
        printInDebug(todayAttendance.first.dutyStatus);

        onLoadScanUnitShift(todayAttendance.first);
      }
      else {
      //show error that no duty marked
        setState(() {
          alertHeader = 'alert'.tr();
          alertMessage = 'already_puch_duty_in'.tr();
          showAlert = true;
        });
      }
    }
    else{
      onLoadScanUnitShift(null);
    }




  }
  void onLoadScanUnitShift(UserAttendance? userAttendance){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanUnitShiftView(
          userProfile: widget.userProfile,
          attendanceMode: widget.attendanceMode,
          unitDutyPosts: widget.unitDutyPosts,
          unitShiftDetails: widget.unitShiftDetails,
          userPostings: widget.userPostings,
          attendanceStatus: widget.attendanceStatus,
          userAttendance: userAttendance,

        ),
      ),
    );
  }

}
