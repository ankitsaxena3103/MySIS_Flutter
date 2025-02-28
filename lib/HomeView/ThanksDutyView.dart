import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/HomeView.dart';
import 'package:mysis/HomeView/UserAttendance.dart';
import 'package:mysis/Profile/UserPosting.dart';
import 'package:mysis/Profile/UserProfile.dart';
import '../CommonViews/ToastMessageView.dart';
import '../MyTabBarView.dart';
import '../Profile/UnitDutyPost.dart';
import '../Profile/UnitShiftDetail.dart';

class ThanksDutyView extends StatefulWidget {

  final UserProfile userProfile;

  final UnitDutyPost unitDutyPost;
  final UnitShiftDetail unitShiftDetail;
  final UserPosting userPosting;
  final UserAttendance userAttendance;

  final imageData;

  final String latLong;


  const ThanksDutyView(
      {
        super.key,
        required this.imageData,
        required this.userProfile,
        required this.unitDutyPost,
        required this.unitShiftDetail,
        required this.userPosting,
        required this.latLong,
        required this.userAttendance,

      });

  @override
  ThanksDutyViewState createState() => ThanksDutyViewState();
}

class ThanksDutyViewState extends State<ThanksDutyView>{
  String imagePath = '';
  bool noData = true;
  List<Widget> containers = [];
  bool showToastMessageView = false;
  String toastMessage = '';


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

    List<String> activeDayList = widget.latLong.isNotEmpty ? widget.latLong.split(',').map((e) => e.trim()).toList() : ['0.0','0.0'];

    double lat = double.parse(activeDayList[0]) ; // Latitude
    double lng = double.parse(activeDayList[1]); // Longitude

    var backgroundGradientGreen =  LinearGradient(
      colors: [greyColor6,greenColor5],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
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
                  top: MediaQuery.of(context).padding.top,
                  right: paddingRight+pathS/3,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                          builder: (context) => MyTabBarView(),
                      ),
                            (route) => false, // This removes all previous routes
                      );
                    },
                    child: SizedBox(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    SizedBox(height: pathS/2+paddingTop),
                    Text(
                      'thanks'.tr(),
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 2.8,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Text(
                      'mark_successfully'.tr(),
                      style: TextStyle(
                        color: isDarkMode ? greenColor5 : greenColor6,
                        fontSize: pathS / 4,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: pathS/2),
                    Container(
                      alignment: Alignment.center,
                      width: pathL *1.5,
                      height: pathL*1.5 ,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isDarkMode ? backgroundGradientDark : backgroundGradientGreen ,
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor, // Shadow color
                            blurRadius: pathS/20, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(0, pathS/8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:  EdgeInsets.all(pathS/12),
                        child: ClipOval(
                          child:  Image.memory(
                            base64Decode(widget.imageData),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: pathS/5),
                    Text(
                      widget.userProfile.empName,
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 3.2,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto'
                      ),
                    ),
                    Text(
                      widget.userProfile.serviceName,
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 5,
                        fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto'
                      ),
                    ),
                    Text(
                     widget.userProfile.symbol,
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 6.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: pathS/3),

                    Text(
                      DateFormat('EEEE, d MMM', selectedLocale).format(DateTime.now()),
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 4.3,
                        fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: pathS/3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.unitShiftDetail.shiftName,
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
                            fontSize: pathS / 5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        SizedBox(width: pathS/15),
                        Text(
                          getFormattedDateTime(widget.unitShiftDetail.startTime, 'hh:mm:ss', 'hh:mm a'),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),

                    Text(
                      widget.userPosting.siteName,
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 5,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: pathS/3),
                    Padding(
                      padding:  EdgeInsets.only(left: pathS/5,right: pathS/5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'post'.tr(),
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 5.5,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              SizedBox(width: 2),
                              Text(
                                widget.unitDutyPost.address,
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'post_rank'.tr(),
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 5.5,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              SizedBox(width: 2),
                              Text(
                                widget.unitDutyPost.postName,
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 5.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),


                  ],
                ),

                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + pathS/3,
                    child: Column(
                      children: [
                        Container(
                          width: 2*pathL,
                          height: 1,
                          color: isDarkMode ? greyColor5 : greyColor3,
                        ),
                        SizedBox(height: pathS/5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Row(
                              children: [
                                Text(
                                  'duty_in'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ? whiteColor : greyColor6,
                                    fontSize: pathS / 5.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(width: pathS/15),
                                Text(
                                  '${DateFormat('h:mm').format(widget.userAttendance.actStartTime) } ${DateFormat('a').format(widget.userAttendance.actStartTime).toUpperCase()}',
                                  style: TextStyle(
                                    color: isDarkMode ? whiteColor : greyColor6,
                                    fontSize: pathS / 5.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),

                            if(widget.userAttendance.actEndTime != null)Row(
                              children: [
                                SizedBox(width: pathS/8),
                                Text(
                                  'duty_out'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ? whiteColor : greyColor6,
                                    fontSize: pathS / 5.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(width: pathS/15),
                                Text(
                                  '${DateFormat('h:mm').format(widget.userAttendance.actEndTime!) } ${DateFormat('a').format(widget.userAttendance.actEndTime!).toUpperCase()}',
                                  style: TextStyle(
                                    color: isDarkMode ? whiteColor : greyColor6,
                                    fontSize: pathS / 5.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),

                        SizedBox(height: pathS/12),

                        if(lat>0.0 && lng > 0.0)Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'lat_lang'.tr(),
                              style: TextStyle(
                                color: isDarkMode ? whiteColor : greyColor6,
                                fontSize: pathS / 5.5,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            SizedBox(width: pathS/20),
                            Text(
                              '$lat,$lng',
                              style: TextStyle(
                                color: isDarkMode ? whiteColor : greyColor6,
                                fontSize: pathS / 5.5,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Roboto',
                              ),
                              textAlign: TextAlign.left,
                            ),

                          ],
                        ),

                      ],
                    )
                ),

                ToastMessageView(isVisible: showToastMessageView, message: toastMessage),

              ],
            ),
          ),



        ],
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

