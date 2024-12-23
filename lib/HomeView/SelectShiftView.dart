import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/SubmitDutyView.dart';
import 'package:mysis/Profile/UserProfile.dart';

import '../CommonViews/ToastMessageView.dart';

class SelectShiftView extends StatefulWidget {

  final UserProfile userProfile;
  final regNo;

  final designation;
  final location;
  final post;
  final postRank;

  SelectShiftView(
      {
        super.key,
        required this.designation,
        this.regNo,
        this.location,

        this.post,
        this.postRank,
        required this.userProfile
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
  List <Map> shift = [
    {
      'id' : 0,
      'shiftName': 'Shift A',
      'shiftTime' : '10:00 AM',
    },
    {
      'id' : 1,
      'shiftName': 'Shift B',
      'shiftTime' : '12:00 PM',
    },
    {
      'id' : 2,
      'shiftName': 'Shift C',
      'shiftTime' : '01:00 PM',
    },
    {
      'id' : 3,
      'shiftName': 'Shift D',
      'shiftTime' : '03:00 PM',
    },
  ];
  bool showToastMessageView = false;
  String toastMessage = '';
  String name  = '';
  String position  = '';

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
                          color: shadowColor, // Shadow color
                          blurRadius: pathS/10, // Spread of the shadow
                          // spreadRadius: pathS/15, // How far the shadow extends
                          offset:  Offset(-pathS/12, pathS/12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: paddingLeft + pathS / 4, right: paddingRight + pathS / 3,top: pathS/5,bottom: pathS/5),
                      child: Container(
                        width: screenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                 widget.location,
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
                                                width:pathL*2,
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

                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: pathL),
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

                    RadioButtonGroup(
                      items: shift,
                      selectedId: selectedIndex,
                      callback: (int index) {
                        setState(() {
                          selectedIndex = index;
                        });


                      },
                    ),
                    
                    SizedBox(height: pathS),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){

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


  void onLoadUpdateUI(){

    imagePath = widget.userProfile.profileImageUrl;
    name = widget.userProfile.empName;
    position = widget.userProfile.symbol;

  }

  void onTapProceed(){

    if(selectedIndex <  0){
      showToastView('please_select_shift'.tr());
      return;
    }

    capturePhoto();
  }

  Future<void> capturePhoto() async {
    loadSubmitView('');
    return;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    imagePath = (pickedFile?.path)!;
    if (pickedFile != null) {
      List<int> imageBytes = await pickedFile.readAsBytes();

      String base64Image = base64Encode(imageBytes);
     loadSubmitView(base64Image);

    }

  }

  void loadSubmitView(String data){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitDutyView(  regNo: widget.regNo, location: widget.location, shift: shift[selectedIndex],post: widget.post,postRank: widget.postRank,imageData: data,  userProfile: widget.userProfile,),
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
  final List<Map> items;
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
      children: items.map((item) {
        final index = item['id'];
        final name = item['shiftName'];
        final time = item['shiftTime']; // Assuming you have 'time' field in your map

        return RadioButton(
          id: index,
          callback: callback,
          selectedID: selectedId,
          name: name,
          time: time,
        );
      }).toList(),
    );
  }
}
