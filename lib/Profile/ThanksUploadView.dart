import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import '../CommonViews/ToastMessageView.dart';
import '../MyTabBarView.dart';

class ThanksUploadView extends StatefulWidget {

 final String name;
 final String designation;
 final String imageData;
 final  String message;

  const ThanksUploadView(
      {
        super.key,
        required this.name,
        required this.designation,
        required this.imageData,
        required this.message,


      });

  @override
  ThanksUploadViewState createState() => ThanksUploadViewState();
}

class ThanksUploadViewState extends State<ThanksUploadView>{
  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
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
                       onTapClose();
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

                    SizedBox(height: pathS+MediaQuery.of(context).padding.top),
                    Text(
                      'well_done'.tr(),
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 2.8,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: pathS/5),
                    Text(
                      widget.message,
                      style: TextStyle(
                        color: isDarkMode ? greenColor5 : greenColor6,
                        fontSize: pathS / 4,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    // SizedBox(height: pathS/12),
                    // Text(
                    //   'photo_update_requested_successfully'.tr(),
                    //   style: TextStyle(
                    //     color: isDarkMode ? whiteColor : greyColor6,
                    //     fontSize: pathS / 6.5,
                    //     fontWeight: FontWeight.w500,
                    //     fontFamily: 'Roboto',
                    //   ),
                    // ),
                    SizedBox(height: pathS),
                    Container(
                      alignment: Alignment.center,
                      width:pathL*2,
                      height: pathL*2,

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
                    SizedBox(height: pathS/4),
                    Text(
                      widget.name,
                      style: TextStyle(
                          color: isDarkMode ? whiteColor : greyColor6,
                          fontSize: pathS / 3.8,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto'
                      ),
                    ),
                    Text(
                      widget.designation,
                      style: TextStyle(
                          color: isDarkMode ? whiteColor : greyColor6,
                          fontSize: pathS / 6.5,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto'
                      ),
                    ),
                  ],
                ),

                ToastMessageView(isVisible: showToastMessageView, message: toastMessage),

              ],
            ),
          ),



        ],
      ),
    );
  }

  void onTapClose(){

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MyTabBarView(),
      ),
          (route) => false, // This removes all previous routes
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

