import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/SubmitDutyView.dart';
import 'package:mysis/Profile/UnitDutyPost.dart';
import 'package:mysis/Profile/UnitShiftDetail.dart';
import 'package:mysis/Profile/UserProfile.dart';

import '../CommonViews/ToastMessageView.dart';
import '../Profile/UserPosting.dart';
import 'UserAttendance.dart';

class SelectShiftView extends StatefulWidget {

  final UserProfile userProfile;
  final UnitDutyPost unitDutyPost;
  final List<UnitShiftDetail> unitShiftDetail;
  final UserPosting userPosting;
  final String attendanceMode;
  final String attendanceStatus;

  final String latLong;
  final String dutyDateTime;
  final UserAttendance? userAttendance;

  const SelectShiftView(
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
        this.userAttendance
      });
  @override
  SelectShiftViewState createState() => SelectShiftViewState();
}

class SelectShiftViewState extends State<SelectShiftView>{
  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String imagePath = '';
  bool noData = true;
  List<Widget> containers = [];
  int selectedIndex = -1;
  bool showToastMessageView = false;
  String toastMessage = '';
  String name  = '';
  String position  = '';


  late UnitShiftDetail selectedShift;


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
    calculateSizes(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
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

                Column(
                  children: [
                    SizedBox(height: paddingTop),

                    Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: isDarkMode ? greyColor8 : whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor, // Shadow color
                            blurRadius: pathS/10, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(-pathS/12, pathS/12),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: paddingLeft + pathS / 4, right: paddingRight + pathS / 3,top: pathS/5,bottom: pathS/5),
                        child: SizedBox(
                          width: screenWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Row(
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
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                name,
                                                style: TextStyle(
                                                  color: isDarkMode ? whiteColor : greyColor6,
                                                  fontSize: pathS / 4.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
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
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.centerRight,
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width:pathL*2,
                                                  child: Text(
                                                   // '${widget.userPosting.siteName}\n(${widget.userPosting.unitCode})\n${widget.unitDutyPost.address}',
                                                    '${widget.userPosting.siteName}\n(${widget.userPosting.unitCode})',
                                                    style: TextStyle(
                                                      color: isDarkMode ? whiteColor : greyColor6,
                                                      fontSize: pathS / 5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Container(
                                                  // width:pathL*2,
                                                  child: Text(
                                                    widget.unitDutyPost.postName,
                                                    style: TextStyle(
                                                      color: isDarkMode ? whiteColor : greyColor6,
                                                      fontSize: pathS / 5,
                                                      fontWeight: FontWeight.w300,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.left,
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
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: pathS/1.8),
                    Text(
                      'select_shift'.tr(),
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 4.5,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: pathS/2.5),
                    SizedBox(
                      height: 2.5*pathL,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RadioButtonGroup(
                              items: widget.unitShiftDetail,
                              selectedId: selectedIndex,
                              callback: (int index) {
                                setState(() {
                                  selectedIndex = index;
                                });
                                selectedShift = widget.unitShiftDetail[index];


                              },
                            ),

                          ],
                        ),
                      ),
                    ),

                  ],
                ),

                Positioned(
                  bottom: paddingBottom+pathS/2,
                  child: Row(
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
                            'txt_cancel'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? redColor1:redColor3,
                              fontSize: pathS / 4.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: pathS/3),
                      GestureDetector(
                        onTap: (){
                          onTapProceed();
                        },
                        child: Container(
                          width: pathL,
                          height: pathS / 1.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDarkMode ? redColor1:redColor3,
                            // border: Border.all(color: Colors.yellow, width: pathS/18),
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
                            'txt_proceed'.tr(),
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: pathS / 4.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ToastMessageView(isVisible: showToastMessageView, message: toastMessage),
                
              ],
            ),
          ),



        ],
      ),
    );
  }

void initialSetup(){
  for (int i = 0; i < 4; i++) {
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

    imagePath = widget.userProfile.profileImageUrl;
    name = '${widget.userProfile.empName}\n(${widget.userProfile.regNo})';
    position = '${widget.userProfile.serviceName} (${widget.userProfile.rank})';

  }

  void onTapProceed(){

    if(selectedIndex <  0){
      showToastView('please_select_shift'.tr());
      return;
    }

    loadSubmitView();
  }


  void loadSubmitView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitDutyView(
          userProfile: widget.userProfile,
          unitDutyPost: widget.unitDutyPost,
          unitShiftDetail: selectedShift,
          userPosting: widget.userPosting,
          attendanceMode: widget.attendanceMode,
          attendanceStatus: widget.attendanceStatus,
          latLong: widget.latLong,
          dutyDateTime: widget.dutyDateTime,
          userAttendance: widget.userAttendance,

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



class RadioButton extends StatelessWidget {
  final int id;
  final Function(int) callback;
  final int selectedID;
  late double controlSize;
  final Color color;
  final double textSize;
  final String name;
  final String time;

  RadioButton({
    required this.id,
    required this.callback,
    required this.selectedID,
    this.controlSize = 28,
    this.color = Colors.white,
    this.textSize = 14,
    required this.name, required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final size = pathS/5;
    controlSize = pathS/4;

    return Padding(
      padding: EdgeInsets.only(bottom: pathS/8),
      child: GestureDetector(
        onTap: () {
          callback(id);
        },
        child:Container(

          width: screenWidth-2.5*marginValue,

          decoration:  BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(pathS/8),
            color: isDarkMode?greyColor6:whiteColor,
            border: Border.all(
                color: selectedID == id ? (isDarkMode ? redColor1:redColor3) : Colors.transparent,
                width: pathS/80
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Shadow color
                blurRadius: pathS/10, // Spread of the shadow
                // spreadRadius: pathS/15, // How far the shadow extends
                offset:  Offset(-pathS/12, pathS/12),
              ),
            ],
          ),

          child:  Padding(
            padding:  EdgeInsets.all(pathS/4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: pathS,
                  child: Text(
                    name,
                    style: TextStyle(
                      color: isDarkMode ? whiteColor:greyColor6,
                      fontSize: size,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(width: pathS/8),
                Text(
                  time,
                  style: TextStyle(
                    color: isDarkMode ? whiteColor:greyColor6,
                    fontSize: size,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: pathS/8),

                Container(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    selectedID == id ? Icons.radio_button_on: Icons.radio_button_off,
                    size: controlSize,
                    color: isDarkMode ? redColor1:redColor3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



}

class RadioButtonGroup extends StatelessWidget {
  final List<UnitShiftDetail> items;
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
      children: items.asMap().map((index, item) {
        final indexNo = index;
        final name = item.shiftName;
        final time = '${getFormattedDateTime(item.startTime, 'hh:mm:ss', 'hh:mm a')} - ${getFormattedDateTime(item.endTime, 'hh:mm:ss', 'hh:mm a')}';

        return MapEntry(
          index,
          RadioButton(
            id: indexNo,
            callback: callback,
            selectedID: selectedId,
            name: name,
            time: time,
          ),
        );
      }).values.toList(), // Convert MapEntry values to a list
    );
  }

}
