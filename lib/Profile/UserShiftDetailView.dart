import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Profile/UnitShiftDetail.dart';
import 'package:mysis/Profile/UserPosting.dart';

import 'UnitDutyPost.dart';


class UserShiftDetailView extends StatefulWidget {

  final List<UnitDutyPost> unitDutyPosts;
  final List<UnitShiftDetail> unitShiftDetails;
  final UserPosting userPosting;

  final void Function(int) callBack;

  const UserShiftDetailView({
    super.key,
    required this.unitDutyPosts,
    required this.unitShiftDetails,
    required this.userPosting,

    required this.callBack,

  });

  @override
  UserShiftDetailViewState createState() => UserShiftDetailViewState();
}

class UserShiftDetailViewState extends State<UserShiftDetailView> {
  TextEditingController txtEnterPIN= TextEditingController(text: "");

  bool showLoaderView = false;

  bool isAlertVisible = false;
  String alertHeader = 'Error!';
  String alertMessage = 'There is an  internal error.';

  bool showToastMessageView = false;
  String toastMessage = '';

  List<String> reasonItems = ['family_emergency_txt'.tr(), 'other_reason_txt'.tr(), 'sick_txt'.tr(),'weekly_off'.tr()];
  int selectedIndex = -1;
  String selectedReason = '';

  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
        Container(
          width: logicalWidth,
          height: logicalHeight,
          color: greyColor6,

            child: Stack(
          children: [

                  Positioned(
              top: MediaQuery.of(context).padding.top+pathS/12,
              right: paddingRight +pathS/3,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  // widget.callBack(0);
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
                    SizedBox(
                      width: screenWidth,
                      height: pathS/2,
                    ),//fake container for width only

                    Container(
                      width: screenWidth-2*marginValue,
                      height: screenHeight-1.5*pathS,
                      decoration:  BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(pathS/8),
                        color: isDarkMode?greyColorDark:whiteColor,
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
                        children: [

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Container(
                                width: screenWidth - 2 * pathS / 3,
                                height: pathS * 1.2,
                                decoration: BoxDecoration(
                                  color: isDarkMode?greyColorDark:whiteColor,

                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(pathS / 8),
                                    topRight: Radius.circular(pathS / 8),
                                  ),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isDarkMode?greyColorDark:greyColor1,
                                      width: 1.0, // Set the width of the bottom border
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: pathS / 5), // Add some padding for alignment
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                                    children: [
                                      Text(
                                        widget.userPosting.siteName,
                                        style: TextStyle(
                                          color: isDarkMode ? whiteColor : greyColor7,
                                          fontSize: pathS / 5,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(height: pathS/12),
                                      Text(
                                        widget.userPosting.unitCode,
                                        style: TextStyle(
                                          color: isDarkMode ? whiteColor : greyColor7,
                                          fontSize: pathS / 5,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: screenHeight - 1.5*pathL,
                                child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: pathS/4),
                                        Padding(
                                          padding: EdgeInsets.only(left: pathS / 5), // Add some padding for alignment
                                          child: Text(
                                            'active_shifts'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor : greyColor7,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),

                                        SizedBox(height: pathS/8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: widget.unitShiftDetails.map((unitShiftDetails) {
                                            return buildUserShiftDetailContainer(
                                              unitShiftDetails,
                                            );
                                          }).toList(),
                                        ),


                                        SizedBox(height: pathS/4),
                                        Padding(
                                          padding: EdgeInsets.only(left: pathS / 5), // Add some padding for alignment
                                          child: Text(
                                            'active_posts'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor : greyColor7,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        SizedBox(height: pathS/8),

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: widget.unitDutyPosts.asMap().entries.map((entry) {
                                            int index = entry.key; // Get the index
                                            var unitDutyPost = entry.value; // Get the unitDutyPost

                                            return buildUserShiftPostContainer(
                                              unitDutyPost,
                                              index+1, // Pass the index as well
                                            );
                                          }).toList(),                                  ),

                                      ],
                                    )),
                              ),






                            ],
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
        ],
      ),
    );


  }

  Widget buildUserShiftDetailContainer(UnitShiftDetail shift){
   return Padding(
      padding: EdgeInsets.only(left: pathS / 5, right: pathS / 5), // Add some padding for alignment
      child: Column(
        children: [
          Container(
            width: screenWidth - 2 * marginValue,
            decoration: BoxDecoration(
              color: isDarkMode ? greyColor8 : whiteColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(pathS / 8),
              border: Border.all(
                color: isDarkMode ? greyColorDark : greyColor1,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(pathS / 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      // SizedBox(
                      //   width: pathL,
                      //   child: Text(
                      //     shift.unitCode,
                      //     style: TextStyle(
                      //       color: isDarkMode ? whiteColor : greyColor7,
                      //       fontSize: pathS / 5,
                      //       fontWeight: FontWeight.w500,
                      //       fontFamily: 'Roboto',
                      //     ),
                      //     textAlign: TextAlign.start,
                      //   ),
                      // ),
                       Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(pathS / 15),
                            bottomLeft: Radius.circular(pathS / 15),
                          ),
                          color: isDarkMode ? yellowColor1 : yellowColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: pathS / 5,
                            top: pathS / 10,
                            right: pathS / 8,
                            bottom: pathS / 10,
                          ),
                          child: Text(
                            shift.shiftName,
                            style: TextStyle(
                              color: isDarkMode ? greyColorDark : greyColor7,
                              fontSize: pathS / 5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: pathS / 3),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            'start_time'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor6,
                              fontSize: pathS / 5.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.start,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              Text(
                                formatTime(shift.startTime, 'HH:mm'),
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 4,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(width: pathS/12),
                              Padding(
                                padding:  EdgeInsets.only(top: pathS/25),
                                child: Text(
                                  formatTime(shift.startTime, 'a').toUpperCase(),
                                  style: TextStyle(
                                    color: isDarkMode ? whiteColor : greyColor4,
                                    fontSize: pathS / 6,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ''.tr(),
                            style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor6,
                              fontSize: pathS / 5.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.start,
                          ),
                          // Spacer(),
                          Row(
                            children: [
                              Container(
                                height: 1.5,
                                width: pathS / 3,
                                color: isDarkMode ? greyColorDark : greyColor6,
                              ),
                              SizedBox(width: pathS / 15),
                              Text(
                                '${getFormattedTime(shift.dutyHrs, 'HH')} ${'hours'.tr()}',
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 6,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(width: pathS / 15),
                              Container(
                                height: 1.5,
                                width: pathS / 3,
                                color: isDarkMode ? greyColorDark : greyColor6,
                              ),
                            ],
                          ),
                          // Spacer(),

                        ],
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'end_time'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor6,
                              fontSize: pathS / 5.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                formatTime(shift.endTime, 'HH:mm'),
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 4,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(width: pathS/12),
                              Padding(
                                padding:  EdgeInsets.only(top: pathS/25),
                                child: Text(
                                  formatTime(shift.endTime, 'a').toUpperCase(),
                                  style: TextStyle(
                                    color: isDarkMode ? whiteColor : greyColor4,
                                    fontSize: pathS / 6,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),


                  SizedBox(height: pathS / 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (String day in ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: pathS / 10),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDarkMode ? greyColorDark : greyColor1,
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(pathS / 10),
                              child: Text(
                                day,
                                style: TextStyle(
                                  color: isDayActive(day, shift.activeDays)
                                      ? (isDarkMode ? greenColor5 : greenColor6)
                                      : (isDarkMode ? greyColorDark : greyColor1),
                                  fontSize: pathS / 6.5,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: pathS/5),
        ],
      ),
    );
  }
  Widget buildUserShiftPostContainer(UnitDutyPost post, int index){
    return Padding(
      padding: EdgeInsets.only(left: pathS / 5, right: pathS / 5), // Add some padding for alignment
      child: Container(
        width: screenWidth - 2 * pathS / 3,
        decoration: BoxDecoration(
          color: isDarkMode ? greyColor8 : whiteColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(pathS / 8),
          border: Border.all(
            color: isDarkMode ? greyColorDark : greyColor1,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(pathS / 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      // SizedBox(
                      //   width: pathL,
                      //   child: Text(
                      //     '',
                      //     style: TextStyle(
                      //       color: isDarkMode ? whiteColor : greyColor7,
                      //       fontSize: pathS / 5,
                      //       fontWeight: FontWeight.w500,
                      //       fontFamily: 'Roboto',
                      //     ),
                      //     textAlign: TextAlign.start,
                      //   ),
                      // ),
                       Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(pathS / 15),
                            bottomLeft: Radius.circular(pathS / 15),
                          ),
                          color: isDarkMode ? yellowColor1 : yellowColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: pathS / 5,
                            top: pathS / 10,
                            right: pathS / 8,
                            bottom: pathS / 10,
                          ),
                          child: Text(
                            '${'post'.tr()}$index',
                            style: TextStyle(
                              color: isDarkMode ? greyColorDark : greyColor7,
                              fontSize: pathS / 5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: pathS / 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 2*pathL,
                        child: Text(
                          post.address,
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
                            fontSize: pathS / 4,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        post.postName,
                        style: TextStyle(
                          color: isDarkMode ? whiteColor : greyColor6,
                          fontSize: pathS / 5.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.start,
                      ),

                    ],
                  ),
                  SizedBox(height: pathS / 5),

                ],
              ),
            ),
            Container(
              height: 1.0,
              width: screenWidth - 2 * pathS / 3,
              color: isDarkMode ? greyColorDark : greyColor1,
            ),
            GestureDetector(
              onTap: (){
                List<String> activeDayList = post.geoLocation.split(',').map((e) => e.trim()).toList();

                double lat = double.parse(activeDayList[1]); // Latitude
                double lng = double.parse(activeDayList[0]); // Longitude

                launchGoogleMap(lat, lng);


              },
              child: Padding(
                padding: EdgeInsets.only(left: pathS/10,right: pathS/8,top: pathS/5,bottom: pathS/5), // Adjust top and left as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: pathS/3,
                      width: pathS/4,
                      decoration: BoxDecoration(
                        // shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/dashboard-icons/location-on.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: pathS/6),

                    Text(
                      'location_on_map'.tr(),
                      style: TextStyle(
                        color: isDarkMode ?  redColor1:redColor3,
                        fontSize: pathS / 4.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',

                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initialSetup() {}

  String getDateTime(DateTime date) {
    return DateFormat('dd MMM').format(date);
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

// Helper function to precisely match days.
  bool isDayActive(String day, String activeDays) {
  // Map short form days to full forms for comparison
  Map<String, String> dayMapping = {
  'S': 'SUN',
  'M': 'MON',
  'T': 'TUE',
  'W': 'WED',
  'T': 'THU',
  'F': 'FRI',
  'S': 'SAT',
  };

  // Convert activeDays string to a list
  List<String> activeDayList = activeDays.split(',').map((e) => e.trim()).toList();

  // Match short form (day) with the full form in the list
  return activeDayList.contains(dayMapping[day]);
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
  final List<String> items;
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
        final name = entry.value;

        return RadioButton(
          id: index,
          callback: radioGroupCallback,
          selectedID: selectedId,
          name: name,
        );
      }).toList(),
    );
  }

  void radioGroupCallback(int id) {
    callback(id);
  }
}