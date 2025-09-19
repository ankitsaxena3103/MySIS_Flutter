import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Profile/ThanksUploadView.dart';

import '../CommonViews/AlertPopupView.dart';
import '../CommonViews/LoaderView.dart';
import '../SharedClasses/APIHelper.dart';
import 'EditProfileImageView.dart';

class UploadPhotoView extends StatefulWidget {

  final String name;
  final String designation;
  final String filePath;
  final String profileId;
  final String imageData;


  const UploadPhotoView(
      {
        super.key,
        required this.imageData,
        required this.name,
        required this.designation,
        required this.filePath,
        required this.profileId,
      });
  @override
  UploadPhotoViewState createState() => UploadPhotoViewState();

}

class UploadPhotoViewState extends State<UploadPhotoView>{

  bool showLoaderView = false;

  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String imagePath = '';
  bool noData = true;
  late String imageData;
  List<Widget> containers = [];

  int selectedIndex = -1;
  String profileImage = 'assets/images/home/profile.png';
  String profileUrl = '';

  bool showAlert = false;
  String alertHeader = '';
  String alertMessage = '';

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
                  top:MediaQuery.of(context).padding.top+pathS/12,
                  right: paddingRight+pathS/3,
                  child: GestureDetector(
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

                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: pathS+ paddingTop),

                    Text(
                      'submit_photo_update_request'.tr(),
                      style: TextStyle(
                        color: isDarkMode ? whiteColor:greyColor6,
                        fontSize: pathS / 4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: pathS/2),

                    Container(
                      alignment: Alignment.center,
                      width:pathL*2,
                      height: pathL*2,
                      decoration: BoxDecoration(
                        color:  isDarkMode ? greyColor6:whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                        // borderRadius: BorderRadius.circular(pathS/5),
                        boxShadow: [
                          BoxShadow(
                            color:  shadowColor,
                            blurRadius: pathS/15, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(-pathS/25, pathS/12),
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
                            onTapEditProfile();
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

                LoaderView(isVisible: showLoaderView, message: ''),
                Visibility(
                  visible: showAlert,
                  child: AlertPopupView(
                    header: alertHeader,
                    message: alertMessage,
                    cancelBtn: 'ok'.tr(),
                    okBtn: '',
                    callBack:(val){
                      setState(() {
                        showAlert = false;
                      });

                    },
                  ),
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
    printInDebug(imagePath);
    if (pickedFile != null) {
      List<int> imageBytes = await pickedFile.readAsBytes();
      setState(() {
        imageData = base64Encode(imageBytes);
      });

    }
  }

  void onTapEditProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.25,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(pathS/8),
                topRight: Radius.circular(pathS/8),
              ),
            ),
            clipBehavior: Clip.antiAlias, // Add this line
            child: EditProfileImageView(
              onCloseBottomSheet: () {
                Navigator.pop(context);
              },
              onTabSelected: (val , name, designation) {

              }, name: userName, designation: widget.designation, profileId: widget.profileId,
            ),
          ),
        );
      },
    );
  }


  void onTapSubmit(){

    uploadProfileImage(widget.filePath);

  }


  Future<void> uploadProfileImage(String filePath) async {
    setState(() {
      showLoaderView = true;
    });

    Map <String,String> inputData = {
      'parentType' : 'ProfilePhoto',
      'parentID':widget.profileId,
      'fileDescription':'profile photo change',
      'file':filePath,
    };

    APIHelper.instance.postImage(uploadImageApi, inputData, (responseData) {
      if (responseData.isNotEmpty) {
        // Parse the response list directly

        Map<String, dynamic> data = responseData;

        final String message = data['message'] ?? '';
        loadThanks(message);

      }
      else {
        // Handle empty response
        printInDebug('Response data is empty.');
      }
      setState(() {showLoaderView = false;});
    },
          (error) {
        // Handle error
            setState(() {
              showLoaderView = false;
            });
        printInDebug('Error: $error');
      },
    );
  }

  void loadThanks(String message){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ThanksUploadView(
            name: widget.name,
            designation: widget.designation,
            imageData: imageData,
          message: message,
        ),
      ),
    );
  }

}

