
// import 'dart:html';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Profile/UploadPhotoView.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';




class EditProfileImageView extends StatefulWidget {

  final String profileId;
  final String name;
  final String designation;
  final VoidCallback onCloseBottomSheet; // Callback function
  final Function(int,String, String) onTabSelected;
  // Callback function

  const EditProfileImageView(
      {
        super.key,
        required this.onCloseBottomSheet,
        required this.onTabSelected,
        required this.name,
        required this.designation,
        required this.profileId,
      });


  @override
  EditProfileImageViewState createState() => EditProfileImageViewState();
}

class EditProfileImageViewState extends State<EditProfileImageView> {

  String base64Image = '';
  String imagePath = '';

  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    double iconSize = pathS/2;
    double verticalGap = pathS/2.5;
    double horizontalGap = 0;
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Material(
          child: Scaffold(
            body: Container(
                width: logicalWidth,
                height: logicalHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDarkMode ? greyColor8 : whiteColor,

                ),
                child: Padding(
                  padding: EdgeInsets.only(left: pathS/3, top: pathS/3, bottom: paddingBottom+pathS/3),
                  child: Stack(
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'profile_photo'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? whiteColor:greyColor6,
                              fontSize: pathS / 4,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: pathS/5),

                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                 getImageFromGallery();
                                },
                                child: Image.asset(
                                  'assets/images/profile/photo-icon.png',
                                  width: pathS/1.2,
                                ),
                              ),
                              SizedBox(width: pathS/5),
                              GestureDetector(
                                onTap: (){
                                  capturePhoto();
                                },
                                child: Image.asset(
                                  'assets/images/profile/camera-icon.png',
                                  width: pathS/1.2,
                                ),
                              ),

                            ],
                          ),



                        ],
                      ),


                    ],
                  ),
                )

            ),
          ),
        );
      },
    );

  }

  Future<void> capturePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    imagePath = (pickedFile?.path)!;
    if (pickedFile != null) {
      List<int> imageBytes = await pickedFile.readAsBytes();
      
      setState(() {
        base64Image = base64Encode(imageBytes);
      });
      onLoadUploadPhoto(base64Image);
    }
  }
  
  void initialSetup() {

  }

  Future<void> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    imagePath = (pickedFile?.path)!;
    printInDebug(imagePath);

    if (pickedFile != null) {
      List<int> imageBytes = await pickedFile.readAsBytes();

      setState(() {
        base64Image = base64Encode(imageBytes);
      });
      onLoadUploadPhoto(base64Image);
    }
  }

  void onLoadUploadPhoto(String imageData){
    
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => UploadPhotoView(
        name: widget.name,
        designation: widget.designation ,
        imageData: base64Image,
        filePath: imagePath,
        profileId: widget.profileId,
      )),
      
    );
    
  }


}