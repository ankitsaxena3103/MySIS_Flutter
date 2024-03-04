import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/ThanksDutyView.dart';

class SubmitDutyView extends StatefulWidget {

  final name;
  final regNo;
  final designation;
  final location;

  final shift;
  final post;
  final postRank;
  final imageData;


  SubmitDutyView(
      {
        super.key,
        required this.name,
        required this.designation,
        required this.regNo,
        required this.location,
        required this.shift,
        this.post,
        this.postRank,
        this.imageData
      });
  @override
  SubmitDutyViewState createState() => SubmitDutyViewState();
}

class SubmitDutyViewState extends State<SubmitDutyView>{
  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String imagePath = '';
  bool noData = true;
  late String imageData;
  List<Widget> containers = [];

  int selectedIndex = -1;
  String profileImage = 'assets/images/home/profile.png';
  String profileUrl = '';


  @override
  void initState() {
    imageData = widget.imageData;
    initialSetup();
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
              gradient: isDarkMode ? backgroundGradientDark : backgroundGradient ,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top:MediaQuery.of(context).padding.top,
                  child: Container(
                    width: screenWidth,

                    decoration: BoxDecoration(
                      color: isDarkMode ? greyColor8 : whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color:  shadowColor,
                          blurRadius: pathS/10, // Spread of the shadow
                          // spreadRadius: pathS/15, // How far the shadow extends
                          offset:  Offset(-pathS/12, pathS/12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: paddingLeft + pathS / 4, right: paddingRight + pathS / 3,top: pathS/5,bottom: pathS/5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CachedNetworkImage(
                                height: pathS / 1.5,
                                width: pathS / 1.5,
                                imageUrl: profileUrl,
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundImage: AssetImage(profileImage),
                                  backgroundColor: Colors.white,
                                ),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  backgroundImage: AssetImage(profileImage),
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
                                          Text(
                                            widget.name,
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor : greyColor6,
                                              fontSize: pathS / 4.5,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Container(
                                            width:pathL*1.8,
                                            child: Text(
                                              widget.designation,
                                              style: TextStyle(
                                                color: isDarkMode ? whiteColor : greyColor6,
                                                fontSize: pathS / 6.5,
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
                          Column(
                            children: containers,
                          ),


                          Padding(
                            padding:  EdgeInsets.only(left: pathS/5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [
                                Container(
                                  child: Image.asset(
                                    'assets/images/icons/location.png',
                                    height: pathS/3,
                                    width: pathS/3,
                                    color: isDarkMode ? redColor1 :redColor3,

                                  ),
                                ),
                                SizedBox(width: pathS/5),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: pathL * 1.5,
                                              child: Text(
                                                widget.location,
                                                style: TextStyle(
                                                  color: isDarkMode ? whiteColor : greyColor6,
                                                  fontSize: pathS / 4.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Container(
                                              width: pathL * 1.5,
                                              child: Text(
                                                widget.post,
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
                                      SizedBox(width: pathS/5),
                                      Container(
                                        width: pathS,
                                        height: pathS / 2.5,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: isDarkMode ? greenColor6 : greenColor1,
                                          borderRadius: BorderRadius.circular(pathS / 12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:  shadowColor,
                                              blurRadius: pathS/45, // Spread of the shadow
                                              // spreadRadius: pathS/15, // How far the shadow extends
                                              offset:  Offset(-pathS/45, pathS/45),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          widget.shift['shiftName'],
                                          style: TextStyle(
                                            color: isDarkMode ? greyColor7 : greenColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
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

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: pathL+ paddingTop),

                    Container(
                      alignment: Alignment.center,
                      width:pathL*2,
                      height: pathL*2,
                      decoration: BoxDecoration(
                        color:  isDarkMode ? greyColor6:whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                        borderRadius: BorderRadius.circular(pathS/8),
                        boxShadow: [
                          BoxShadow(
                            color:  shadowColor,
                            blurRadius: pathS/10, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(-pathS/12, pathS/12),
                          ),
                        ],
                      ),
                      child:ClipRect(
                        child: Image.memory(
                          base64Decode(widget.imageData),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    SizedBox(height: pathS*1.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            capturePhoto();
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
                              'txt_retake'.tr(),
                              style: TextStyle(
                                color: isDarkMode ? redColor1:redColor3,

                                fontSize: pathS / 4.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: pathS/3),
                        GestureDetector(
                          onTap: (){
                            onTapSubmit();

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
                                  color: shadowColor, // Shadow color
                                  blurRadius: pathS/15, // Spread of the shadow
                                  // spreadRadius: pathS/15, // How far the shadow extends
                                  offset:  Offset(-pathS/15, pathS/15),
                                ),
                              ],
                            ),
                            child: Text(
                              'submit'.tr(),
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: pathS / 4.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),






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
            width: pathS / 75,
            color: isDarkMode ? whiteColor : greyColor3,
          ),
        ),
      );
    }
  }

  Future<void> capturePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    imagePath = (pickedFile?.path)!;
    if (pickedFile != null) {
      List<int> imageBytes = await pickedFile.readAsBytes();

      setState(() {
        imageData = base64Encode(imageBytes);
      });

    }
  }

  void onTapSubmit(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThanksDutyView(name: widget.name, designation: widget.designation,shiftData: widget.shift,post: widget.post,postRank: widget.postRank,location: widget.location, imageData: imageData),
      ),
    );
  }


}

