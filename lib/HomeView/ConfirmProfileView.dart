import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/ScanUnitShiftView.dart';
import 'package:mysis/Profile/UserProfile.dart';

class ConfirmProfileView extends StatefulWidget {

  final UserProfile userProfile;

  const ConfirmProfileView({
    super.key,
    required this.userProfile
  });



  @override
  ConfirmProfileViewState createState() => ConfirmProfileViewState();
}

class ConfirmProfileViewState extends State<ConfirmProfileView>{

  String profileImage = 'assets/images/home/profile.png';
  String profileUrl = '';
  String name  = '';
  String position  = '';

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
                            onLoadScanUnitShift();
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

  void onLoadScanUnitShift(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanUnitShiftView(userProfile: widget.userProfile),
      ),
    );
  }

}
