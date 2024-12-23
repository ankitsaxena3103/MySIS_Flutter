import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Profile/UserProfile.dart';
import '../CommonViews/ToastMessageView.dart';

class ThanksDutyView extends StatefulWidget {

  final UserProfile userProfile;

  final regNo;

  final location;

  final shiftData;
  final post;
  final postRank;
  final imageData;

  ThanksDutyView(
      {
        super.key,

        this.regNo,
        this.location,
        this.shiftData,
        this.post,
        this.postRank,
        this.imageData,
        required this.userProfile,

      });

  @override
  ThanksDutyViewState createState() => ThanksDutyViewState();
}

class ThanksDutyViewState extends State<ThanksDutyView>{
  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String imagePath = '';
  bool noData = true;
  List<Widget> containers = [];
  bool showToastMessageView = false;
  String toastMessage = '';

  String name  = '';

  String position  = '';
  String positionSymbol  = '';

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
                        padding:  EdgeInsets.all(pathS/10),
                        child: ClipOval(
                          child: Image.memory(
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
                      name,
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 3.2,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto'
                      ),
                    ),
                    Text(
                      position,
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 5,
                        fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto'
                      ),
                    ),
                    Text(
                     positionSymbol,
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 6.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: pathS/3),

                    Text(
                      DateFormat('EEEE, MMM d', selectedLocale).format(DateTime.now()),
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
                          widget.shiftData['shiftName'],
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
                            fontSize: pathS / 5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        SizedBox(width: pathS/15),
                        Text(
                          widget.shiftData['shiftTime'],
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
                            fontSize: pathS / 6,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),

                    Text(
                      widget.location,
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 5.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: pathS/3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'post'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Container(
                          width: pathL/1.4,
                          child: Text(
                            widget.post,
                            style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor6,
                              fontSize: pathS / 5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),

                        Text(
                          'post_rank'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        SizedBox(width: 2),
                        Container(
                          width: pathS,
                          child: Text(
                            widget.postRank,
                            style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor6,
                              fontSize: pathS / 5.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ],
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
                              widget.shiftData['shiftTime'],
                              style: TextStyle(
                                color: isDarkMode ? whiteColor : greyColor6,
                                fontSize: pathS / 5.5,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Roboto',
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(width: pathS/5),

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
                              widget.shiftData['shiftTime'],
                              style: TextStyle(
                                color: isDarkMode ? whiteColor : greyColor6,
                                fontSize: pathS / 5.5,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: pathS/12),

                        Row(
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
                              '40.7543, 67.76777',
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

  void onLoadUpdateUI(){

    imagePath = widget.userProfile.profileImageUrl;
    name = widget.userProfile.empName;
    position = widget.userProfile.serviceName;
    positionSymbol = widget.userProfile.symbol;


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

