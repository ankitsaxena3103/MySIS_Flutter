import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/Profile/ChangeMobileView.dart';
import 'package:mysis/Profile/ContactSISView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Profile/UserPosting.dart';
import 'package:mysis/Profile/UserShiftDetailView.dart';
import 'package:mysis/SharedClasses/DatabaseHelper.dart';

import '../CommonViews/LoaderView.dart';
import '../SharedClasses/APIHelper.dart';
import '../UserAuthViews/SetPINView.dart';
import 'EditProfileImageView.dart';
import 'UnitDutyPost.dart';
import 'UnitShiftDetail.dart';
import 'UserProfile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView>{

  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String imagePath = '';

  String userName = '';
  String degination = '';
  String description = '';

  String age = '';
  String qualification = '';
  String height = '';
  String weight = '';
  String branchName = '';
  String ta = '';

  String companyName = '';
  String unit = '';
  String department = '';
  String contactNum = '';

  String bankLogoPath = "assets/images/profile/bank.png";

  String bankLogoUrl = '';
  String bankName = '';
  String accountHolderName = '';
  String accountN = '';
  String addres = '';
  String ifscCode = '';


  String aAdhar = '';
  String esic= '';
  String pf = '';

  String aAdharLogoUrl = '';
  String esicLogoUrl = '';
  String pfLogoUrl = '';

  bool showLoaderView = false;
  List <UserProfile> userProfile = [];
  List<UserPosting> userPostings = [];
  List<UnitDutyPost> unitDutyPosts = [];
  List<UnitShiftDetail> unitShiftDetails = [];

  bool showUserShiftDetail = false;


  @override
  void initState() {
    super.initState();

    getProfileTableData();
    getPostingTableData();

    onLoadData();
    onLoadUserPostingData();

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

          Column(
            children: [

              Container(
                width: logicalWidth,
                height: 2*pathL,
                decoration:  BoxDecoration(
                  shape: BoxShape.rectangle,
                 gradient: backgroundGradientRed
                ),
              ),
              Container(
                width: logicalWidth,
                height: logicalHeight-2*pathL,
                decoration:  BoxDecoration(
                    shape: BoxShape.rectangle,
                  gradient: isDarkMode ? backgroundGradientDark : backgroundGradient,
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top+pathS/12,
            left: paddingLeft +pathS/3,
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Container(
                    width: pathS/5,
                    height: pathS/2,
                      child: Image.asset(
                      'assets/images/dashboard-icons/left-arrow.png',
                      color: isDarkMode ? whiteColor:whiteColor,

                    ),

                  ),
                  SizedBox(width: pathS/8),
                  Text(
                    'profile'.tr(),
                    style: TextStyle(
                      color: isDarkMode ?  whiteColor:whiteColor,
                      fontSize: pathS / 5,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            ),
          ),

          Container(
            height: screenHeight,

            child: Padding(
              padding: EdgeInsets.only(left: 0, top: pathL-pathS *1.2/2,bottom: pathS/1.2), // Adjust top and left as needed
              child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                       SizedBox(height: pathS *1.2/2,),
                      Container(
                        width: screenWidth-2.5*marginValue,
                        // height: pathL*3,
                        decoration:  BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(pathS/8),
                          color: isDarkMode?greyColor8:Colors.white,
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
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: pathS/5,right: pathS/5,top: pathS,bottom: pathS/4), // Adjust top and left as needed
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Text(
                                      userName,
                                      style: TextStyle(
                                        color: isDarkMode ?  whiteColor:greyColor6,
                                        fontSize: pathS / 4.5,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: pathS/10),
                                    Text(
                                      degination,
                                      style: TextStyle(
                                        color: isDarkMode ?  whiteColor:greyColor6,
                                        fontSize: pathS / 7,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: pathS/3),
                                    Text(
                                      description,
                                      style: TextStyle(
                                        color: isDarkMode ?  whiteColor:greyColor6,
                                        fontSize: pathS / 4,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: pathS/3),
                                    Container(
                                      height: pathL*1.4,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.circular(pathS / 8),
                                          border: Border.all(
                                              color: isDarkMode ?  greyColorDark : greyColor1,
                                              width: 1
                                          ),
                                        ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: pathS/4,right: pathS/4,top: pathS/4), // Adjust top and left as needed

                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'age'.tr(),
                                                  style: TextStyle(
                                                    color: isDarkMode ?  whiteColor:greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Spacer(),
                                                Text(
                                                  age,
                                                  style: TextStyle(
                                                    color: isDarkMode ?  whiteColor:greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: pathS/6),
                                            Row(
                                              children: [
                                                Text(
                                                  'qualification'.tr(),
                                                  style: TextStyle(
                                                    color: isDarkMode ?  whiteColor:greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Spacer(),
                                                Text(
                                                  qualification,
                                                  style: TextStyle(
                                                    color: isDarkMode ?  whiteColor:greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: pathS/6),
                                            Row(
                                              children: [
                                                Text(
                                                  'height'.tr(),
                                                  style: TextStyle(
                                                    color: isDarkMode ?  whiteColor:greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Spacer(),
                                                Text(
                                                  height,
                                                  style: TextStyle(
                                                    color: isDarkMode ?  whiteColor:greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: pathS/6),
                                            Row(
                                              children: [
                                                Text(
                                                  'weight'.tr(),
                                                  style: TextStyle(
                                                    color: isDarkMode ?  whiteColor:greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Spacer(),
                                                Text(
                                                  weight,
                                                  style: TextStyle(
                                                    color: isDarkMode ?  whiteColor:greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: pathS/5),
                                            Row(
                                              children: [
                                                Text(
                                                  'branch_name'.tr(),
                                                  style: TextStyle(
                                                    color: isDarkMode ?  whiteColor:greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Spacer(),
                                                Text(
                                                  branchName,
                                                  style: TextStyle(
                                                    color: isDarkMode ?  whiteColor:greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ],
                                            ),
                                            // Text(
                                            //   'view_details_tv'.tr(),
                                            //   style: TextStyle(
                                            //     color: isDarkMode ?  redFontcolor:redFontcolor,
                                            //     fontSize: pathS / 4.5,
                                            //     fontWeight: FontWeight.w800,
                                            //     fontFamily: 'Roboto',
                                            //   ),
                                            //   textAlign: TextAlign.right,
                                            // ),
                                          ],
                                        ),
                                      ),
                                      ),


                                  ],
                                ),
                              ),
                            ),


                          ],
                        ),

                      ),//profile summary

                      SizedBox(height: pathS/5),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: userPostings.map((posting) {
                          return buildUserPostingContainer(
                            posting,
                            isDarkMode,
                            screenWidth,
                            marginValue,
                            pathS,
                          );
                        }).toList(),
                      ),


                      SizedBox(height: pathS/5),
                      Container(
                        width: screenWidth-2.5*marginValue,
                        // height: pathS*1.3,
                        decoration:  BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(pathS/8),
                          color: isDarkMode?greyColor8:whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Shadow color
                              blurRadius: pathS/10, // Spread of the shadow
                              // spreadRadius: pathS/15, // How far the shadow extends
                              offset:  Offset(-pathS/12, pathS/12),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: pathS/4, top: pathS/4), // Adjust top and left as needed
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'contact'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ?  whiteColor:greyColor7,
                                    fontSize: pathS / 7,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: pathS/4,top: pathS/20,bottom: pathS/4), // Adjust top and left as needed

                                  child: Row(
                                    children: [
                                      Container(
                                        width: pathS/3,
                                        height: pathS/3,
                                        child: Image.asset(
                                          'assets/images/profile/phone.png',
                                          color: isDarkMode ? whiteColor:greyColor6,

                                        ),
                                      ),
                                      SizedBox(width: pathS/5),
                                      Text(
                                        contactNum,
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor7,
                                          fontSize: pathS / 5,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChangeMobileView(),
                                            ),
                                          );
                                        },
                                        child: Container(

                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: isDarkMode ? redColor1 : redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                                            borderRadius: BorderRadius.circular(pathS/3),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1), // Shadow color
                                                blurRadius: pathS/10, // Spread of the shadow
                                                // spreadRadius: pathS/15, // How far the shadow extends
                                                offset:  Offset(-pathS/12, pathS/12),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding:  EdgeInsets.only(left: pathS/5,right: pathS/5,top: pathS/10,bottom: pathS/11),
                                            child: Text(
                                              'change'.tr(),
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontSize: pathS / 5.5,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
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

                      SizedBox(height: pathS/5),
                      Container(
                        width: screenWidth-2.5*marginValue,
                        // height: pathS*1.3,
                        decoration:  BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(pathS/8),
                          color: isDarkMode?greyColor8:whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Shadow color
                              blurRadius: pathS/10, // Spread of the shadow
                              // spreadRadius: pathS/15, // How far the shadow extends
                              offset:  Offset(-pathS/12, pathS/12),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: pathS/4, top: pathS/4,bottom: pathS/4), // Adjust top and left as needed
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'security'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ?  whiteColor:greyColor7,
                                    fontSize: pathS / 7,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: pathS/4,top: pathS/20), // Adjust top and left as needed

                                  child: Row(
                                    children: [
                                      Container(
                                        width: pathS/3,
                                        height: pathS/3,
                                        child: Image.asset(
                                          'assets/images/profile/lock.png',
                                          color: isDarkMode ? whiteColor:greyColor6,

                                        ),
                                      ),

                                      SizedBox(width: pathS/5),
                                      Text(
                                        '****',
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor7,
                                          fontSize: pathS / 3.5,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: (){
                                          onLoadNewPIN();
                                        },

                                        child: Container(

                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: isDarkMode ? redColor1 : redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                                            // border: Border.all(color: Colors.yellow, width: pathS/18),
                                            borderRadius: BorderRadius.circular(pathS/3),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1), // Shadow color
                                                blurRadius: pathS/10, // Spread of the shadow
                                                // spreadRadius: pathS/15, // How far the shadow extends
                                                offset:  Offset(-pathS/12, pathS/12),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding:  EdgeInsets.only(left: pathS/5,right: pathS/5,top: pathS/10,bottom: pathS/10),

                                            child: Text(
                                              'change'.tr(),
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontSize: pathS / 5.5,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
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

                      SizedBox(height: pathS/5),
                      Container(
                        width: screenWidth-2.5*marginValue,
                        // height: pathL*1.25,
                        decoration:  BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(pathS/8),
                          color: isDarkMode?greyColor8:whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Shadow color
                              blurRadius: pathS/10, // Spread of the shadow
                              // spreadRadius: pathS/15, // How far the shadow extends
                              offset:  Offset(-pathS/12, pathS/12),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: pathS/4, top: pathS/4,bottom: pathS/4), // Adjust top and left as needed
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'bank_account'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ?  whiteColor:greyColor7,
                                    fontSize: pathS / 6.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: pathS/5),
                                Padding(
                                  padding: EdgeInsets.only(right: pathS/4), // Adjust top and left as needed

                                  child: Row(
                                    children: [
                                      CachedNetworkImage(
                                        height: pathS /3,
                                        width: pathS /3,
                                        imageUrl: bankLogoUrl,
                                        placeholder: (context, url) =>  Image.asset(
                                          bankLogoPath,
                                          fit: BoxFit.contain,

                                        ),
                                        errorWidget: (context, url, error) => Image.asset(
                                          bankLogoPath,
                                          fit: BoxFit.contain,

                                        ),
                                        imageBuilder: (context, imageProvider) => Image(
                                          image: imageProvider,
                                          fit: BoxFit.cover, // Adjust the fit as needed
                                        ),
                                      ),
                                      SizedBox(width: pathS/5),
                                      Text(
                                        bankName,
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor7,
                                          fontSize: pathS / 6.5,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.start,
                                      ),

                                    ],
                                  ),

                                ),

                                Padding(
                                  padding: EdgeInsets.only(left: pathS/1.8,right: pathS/4,top: pathS/8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        accountHolderName,
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor7,
                                          fontSize: pathS / 6.5,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        accountN,
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor7,
                                          fontSize: pathS / 6.5,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        addres,
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor7,
                                          fontSize: pathS / 6.5,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                       ifscCode,
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor7,
                                          fontSize: pathS / 6.5,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.start,
                                      ),

                                    ],
                                  ),// Adjust top and left as needed
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: pathS/5),
                      Container(
                        width: screenWidth-2.5*marginValue,
                        // height: pathS*1.3,
                        decoration:  BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(pathS/8),
                          color: isDarkMode?greyColor8:whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Shadow color
                              blurRadius: pathS/10, // Spread of the shadow
                              // spreadRadius: pathS/15, // How far the shadow extends
                              offset:  Offset(-pathS/12, pathS/12),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: pathS/4, top: pathS/4,bottom: pathS/4), // Adjust top and left as needed
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'esi_No'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ?  whiteColor:greyColor7,
                                    fontSize: pathS / 7,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: pathS/15),
                                Text(
                                  esic,
                                  style: TextStyle(
                                    color: isDarkMode ?  whiteColor:greyColor7,
                                    fontSize: pathS / 5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.start,
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: pathS/5),
                      Container(
                        width: screenWidth-2.5*marginValue,
                        // height: pathS*1.3,
                        decoration:  BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(pathS/8),
                          color: isDarkMode?greyColor8:whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Shadow color
                              blurRadius: pathS/10, // Spread of the shadow
                              // spreadRadius: pathS/15, // How far the shadow extends
                              offset:  Offset(-pathS/12, pathS/12),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: pathS/4, top: pathS/4,bottom: pathS/4), // Adjust top and left as needed
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'uan_no'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ?  whiteColor:greyColor7,
                                    fontSize: pathS / 7,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: pathS/15),
                                Text(
                                  pf,
                                  style: TextStyle(
                                    color: isDarkMode ?  whiteColor:greyColor7,
                                    fontSize: pathS / 5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.start,
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: pathS/5),
                      Container(
                        width: screenWidth-2.5*marginValue,
                        // height: pathL*1.25,
                        decoration:  BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(pathS/8),
                          color: isDarkMode?greyColor8:whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Shadow color
                              blurRadius: pathS/10, // Spread of the shadow
                              // spreadRadius: pathS/15, // How far the shadow extends
                              offset:  Offset(-pathS/12, pathS/12),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: pathS/4, top: pathS/4,bottom: pathS/4), // Adjust top and left as needed
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'document'.tr() ,
                                  style: TextStyle(
                                    color: isDarkMode ?  whiteColor:greyColor7,
                                    fontSize: pathS / 6.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: pathS/5),
                                Padding(
                                  padding: EdgeInsets.only(right: pathS/4), // Adjust top and left as needed

                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CachedNetworkImage(
                                            height: pathS /2,
                                            imageUrl: aAdharLogoUrl,
                                            placeholder: (context, url) =>  Image.asset(
                                              'assets/images/profile/aadhar.png',
                                              fit: BoxFit.contain,

                                            ),
                                            errorWidget: (context, url, error) => Image.asset(
                                              'assets/images/profile/aadhar.png',
                                              fit: BoxFit.contain,

                                            ),
                                            imageBuilder: (context, imageProvider) => Image(
                                              image: imageProvider,
                                              fit: BoxFit.cover, // Adjust the fit as needed
                                            ),
                                          ),
                                           SizedBox(width: pathS/5),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'aadhar_no'.tr(),
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor7,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                aAdhar,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor7,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.start,
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: pathS/5),
                                      Row(
                                        children: [
                                          CachedNetworkImage(
                                            height: pathS /2,
                                            imageUrl: esicLogoUrl,
                                            placeholder: (context, url) =>  Image.asset(
                                              'assets/images/profile/esic.png',
                                              fit: BoxFit.contain,
                                            ),
                                            errorWidget: (context, url, error) => Image.asset(
                                              'assets/images/profile/esic.png',
                                              fit: BoxFit.contain,

                                            ),
                                            imageBuilder: (context, imageProvider) => Image(
                                              image: imageProvider,
                                              fit: BoxFit.cover, // Adjust the fit as needed
                                            ),
                                          ),
                                          SizedBox(width: pathS/5),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'esi_No'.tr(),
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor7,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                esic,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor7,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.start,
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: pathS/5),
                                      Row(
                                        children: [
                                          CachedNetworkImage(
                                            height: pathS /2,
                                            imageUrl: pfLogoUrl,
                                            placeholder: (context, url) =>  Image.asset(
                                              'assets/images/profile/pf.png',
                                              fit: BoxFit.contain,
                                            ),
                                            errorWidget: (context, url, error) => Image.asset(
                                              'assets/images/profile/pf.png',
                                              fit: BoxFit.contain,

                                            ),
                                            imageBuilder: (context, imageProvider) => Image(
                                              image: imageProvider,
                                              fit: BoxFit.cover, // Adjust the fit as needed
                                            ),
                                          ),
                                          SizedBox(width: pathS/5),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'uan_no'.tr(),
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor7,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                pf,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor7,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.start,
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
                          ),
                        ),
                      ),

                    ],
                  ),
                  Positioned(
                    // top: pathL-pathS *1.2/2,
                    child: Container(

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: whiteColor,

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Shadow color
                            blurRadius: pathS/10, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(-pathS/20, pathS/20),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CachedNetworkImage(
                          height: pathS *1.2,
                          width: pathS *1.2,
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
                      ),
                    ),
                  ),
                  Positioned(
                     top: pathS/1.1,
                    left: screenWidth/2,
                    child: GestureDetector(
                      onTap: (){
                        onTapEditProfile();

                      },
                      child: Image.asset(
                        'assets/images/profile/edit-icon.png',
                            width: pathS/2.5,
                            height: pathS/2.5,
                      ),
                    ),
                  ),

                ],
              ),
            ),
            )
          ),
          Positioned(
            bottom: 0,

            child: GestureDetector(
              onTap: (){


              },
              child: Container(
                width: screenWidth,
                height: pathS / 1.5,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDarkMode ? greyColor8:whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                  // borderRadius: BorderRadius.circular(pathS/3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      blurRadius: pathS/10, // Spread of the shadow
                      // spreadRadius: pathS/15, // How far the shadow extends
                      offset:  Offset(-pathS/12, pathS/12),
                    ),
                  ],
                ),

              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom,

            child: GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactSISView(),
                    ),
                );

              },
              child: Container(
                width: screenWidth,
                height: pathS / 1.4,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDarkMode ? greyColor8:whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                  // borderRadius: BorderRadius.circular(pathS/3),

                ),
                child: Text(
                  'contact_sis'.tr(),
                  style: TextStyle(
                    color: isDarkMode ? redColor1:redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                    fontSize: pathS / 4.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto'
                  ),
                ),
              ),
            ),
          ),


          LoaderView(isVisible: showLoaderView, message: 'checking'.tr()),

          Visibility(
            visible: showUserShiftDetail,
            child: userPostings.isNotEmpty
                ? UserShiftDetailView(
              unitDutyPosts: unitDutyPosts,
              unitShiftDetails: unitShiftDetails,
              userPosting: userPostings.first, // Safe because we checked isNotEmpty
              callBack: (value) {
                setState(() {
                  showUserShiftDetail = false;
                });
              },
            )
                : Center(
              child: Text("No user postings available."),
            ),
          ),

        ],
      ),
    );
  }

  Widget buildUserPostingContainer(UserPosting userPosting, bool isDarkMode, double screenWidth, double marginValue, double pathS) {
    return Container(
      width: screenWidth - 2.5 * marginValue,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(pathS / 8),

        color: isDarkMode ? userPosting.isPrimary == 1 ? yellowColor : greyColor8 : userPosting.isPrimary == 1 ? yellowColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: pathS / 10,
            offset: Offset(-pathS / 12, pathS / 12),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: pathS / 4, top: pathS / 4, bottom: pathS / 4, right: pathS/4),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userPosting.isPrimary == 1 ? 'txt_base_unit'.tr() : 'AdditionalUnits'.tr(),
                style: TextStyle(
                  color: isDarkMode ? greyColorDark : greyColor7,
                  fontSize: pathS / 5,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: pathS / 5),
              Padding(
                padding: EdgeInsets.only(right: pathS),
                child: Text(
                  userPosting.siteName,
                  style: TextStyle(
                    color: isDarkMode ? greyColorDark : greyColor7,
                    fontSize: pathS / 5,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Row(
                children: [
                  Text(
                    userPosting.unitCode,
                    style: TextStyle(
                      color: isDarkMode ? greyColorDark : greyColor7,
                      fontSize: pathS / 5,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: (){

                      setState(() {
                        showUserShiftDetail = true;
                      });

                    },
                    child: Container(

                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDarkMode ? redColor1 : redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                        borderRadius: BorderRadius.circular(pathS/3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // Shadow color
                            blurRadius: pathS/10, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(-pathS/12, pathS/12),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(left: pathS/5,right: pathS/5,top: pathS/10,bottom: pathS/11),
                        child: Text(
                          '  ${'View'.tr()}  ',
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
                
              }, name: userName, designation: degination,
            ),
          ),
        );
      },
    );
  }
  void onLoadNewPIN(){

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SetPINView(),
      ),
    );
  }

  Future<void> getProfileTableData() async {
  final userProfiles = await DatabaseHelper.instance.getAllRecords<UserProfile>(
    keyTableUserProfile,
        (map) => UserProfile.fromMap(map),
  );

  userProfiles.forEach((profile) {
    printInDebug('profile ID: ${profile.id}');
    printInDebug('profile emp name: ${profile.empName}');
  });

  showDataOnUI(userProfiles.first);

}
  void showDataOnUI(UserProfile userProfile){

    setState(() {


      imagePath = userProfile.profileImageUrl;

      userName = userProfile.empName;
      degination = userProfile.serviceName;


      final joiningDate = userProfile.joiningDate; // Assuming this is a DateTime object
      final currentDate = DateTime.now();

// Calculate the difference in years
      final yearsWithSIS = currentDate.year - joiningDate.year;

// Adjust for incomplete years
      final isBeforeAnniversary = (currentDate.month < joiningDate.month) ||
          (currentDate.month == joiningDate.month && currentDate.day < joiningDate.day);

      final actualYearsWithSIS = isBeforeAnniversary ? yearsWithSIS - 1 : yearsWithSIS;

// Assign description
      description = '$actualYearsWithSIS ${'sis_years'.tr()} ${'with_sis'.tr()}';



      age = '${userProfile.age}';
      qualification = userProfile.qualification;
      height = '${userProfile.height}';
      weight = '${userProfile.weight}';
      branchName = userProfile.branchName;
      ta = '';

      companyName = userProfile.branchName;
      unit = userProfile.branchCode;
      department = userProfile.unitCode;
      contactNum = userProfile.mobile;

      bankLogoUrl = userProfile.bankLogo;
      bankName = userProfile.bankName;
      accountHolderName = userProfile.empName;
      accountN = userProfile.accountNo;
      addres = userProfile.bankAddress;
      ifscCode = userProfile.bankIfscCode;


      aAdhar = '';
      esic= userProfile.esiNo;
      pf = userProfile.uanNo;

      aAdharLogoUrl = '';
      esicLogoUrl = '';
      pfLogoUrl = '';



    });
  }
  Future<void> getPostingTableData() async {
    final userPosting = await DatabaseHelper.instance.getAllRecords<UserPosting>(
      keyTableUserPosting,
          (map) => UserPosting.fromMap(map),
    );

    userPosting.forEach((profile) {
      printInDebug('profile ID: ${profile.id}');
      printInDebug('profile emp name: ${profile.siteName}');
    });

    setState(() {
      userPostings = userPosting;
    });


  }
  void onLoadData() {


    // setState(() {
    //   showLoaderView = true;
    // });
    Map <String,String> inputData = {

    };

    APIHelper.instance.getData(profileApi,inputData, (data) {

      // setState(() {
      //   showLoaderView = false;
      // });

      if(data.isNotEmpty){
        print(data);
        List<UserProfile> userProfiles = data.map((json) => UserProfile.fromJson(json)).toList();
        userProfiles.forEach((profile) {
          printInDebug('profile ID: ${profile.id}');
          printInDebug('profile emp name: ${profile.empName}');
        });

        showDataOnUI(userProfiles.first);

        userProfile = userProfiles;

        syncUserProfileData();

      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

    }
    );

  }

  void onLoadUserPostingData() {
    // setState(() {
    //   showLoaderView = true;
    // });

    Map <String, String> inputData = {
    };

    APIHelper.instance.getUserData(userPostingApi, inputData, (data) {

      // setState(() {
      //   showLoaderView = false;
      // });

      if (data.isNotEmpty) {
        if (data.containsKey('UserPosting')) {
          final List<dynamic> dataList = data['UserPosting'];
          setState(() {
            userPostings = dataList.map((json) => UserPosting.fromJson(json)).toList();
          });
          userPostings.forEach((profile) {
            printInDebug('userPosting ID: ${profile.id}');
            printInDebug('userPosting  name: ${profile.siteName}');
          });

          syncUserPostingData();

        }
        if (data.containsKey('UnitDutyPost')) {
          final List<dynamic> dataList = data['UnitDutyPost'];
          unitDutyPosts = dataList.map((json) => UnitDutyPost.fromJson(json)).toList();
          unitDutyPosts.forEach((profile) {
            printInDebug('UnitDutyPost ID: ${profile.id}');
            printInDebug('UnitDutyPost  name: ${profile.postName}');
          });

          syncUnitDutyPostData();
        }
        if (data.containsKey('UnitShiftDetail')) {
          final List<dynamic> dataList = data['UnitShiftDetail'];
          unitShiftDetails = dataList.map((json) => UnitShiftDetail.fromJson(json)).toList();
          unitShiftDetails.forEach((profile) {
            printInDebug('UnitShiftDetail ID: ${profile.id}');
            printInDebug('UnitShiftDetail  name: ${profile.shiftName}');
          });

          syncUnitShiftDetailData();


        }

      }
    }, (error) {
      // setState(() {
      //   showLoaderView = false;
      // });
      setState(() {
        // isAlertVisible = true;
        // alertMessage = '$error';
      });
    });
  }

  Future<void> syncUserProfileData() async {
    await DatabaseHelper.instance.replaceTableData<UserProfile>(keyTableUserProfile, userProfile, (userProfile) =>
        userProfile.toMap());
  }
  Future<void> syncUnitShiftDetailData() async {
    await DatabaseHelper.instance.replaceTableData<UnitShiftDetail>(keyTableUnitShiftDetail, unitShiftDetails, (unitShiftDetail) =>
        unitShiftDetail.toMap());

    return;

  }
  Future<void> syncUnitDutyPostData() async {
    await DatabaseHelper.instance.replaceTableData<UnitDutyPost>(keyTableUnitDutyPost, unitDutyPosts, (unitDutyPosts) =>
        unitDutyPosts.toMap());

  }
  Future<void> syncUserPostingData() async {
    await DatabaseHelper.instance.replaceTableData<UserPosting>(keyTableUserPosting, userPostings, (userPosting) =>
        userPosting.toMap());

  }

}
