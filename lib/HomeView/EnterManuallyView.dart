import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/ConfirmProfileView.dart';
import 'package:mysis/HomeView/ScanCardView.dart';

import '../Profile/UnitDutyPost.dart';
import '../Profile/UnitShiftDetail.dart';
import '../Profile/UserPosting.dart';
import '../Profile/UserProfile.dart';


class EnterManuallyView extends StatefulWidget {
  final UserProfile userProfile;
  final String attendanceMode;
  final List<UnitDutyPost> unitDutyPosts;
  final List<UnitShiftDetail> unitShiftDetails;
  final List<UserPosting> userPostings;
  final String attendanceStatus;


  const EnterManuallyView({
    super.key,
    required this.userProfile,
    required this.attendanceMode,
    required this.unitDutyPosts,
    required this.unitShiftDetails,
    required this.userPostings,
    required this.attendanceStatus,

  });

  @override
  EnterManuallyViewState createState() => EnterManuallyViewState();
}

class EnterManuallyViewState extends State<EnterManuallyView>{

  bool noData = true;

  TextEditingController txtUserId = TextEditingController(text: "");

  bool showToastMessageView = false;
  String toastMessage = '';

  Color nextBgColor = isDarkMode ? greyColor6 : greyColor2;
  Color nextFontColor = isDarkMode ? greyColor7 : greyColor3;
  Color nextShadowColor = Colors.transparent;

  String lblErrorMsg = '';


  String lblUserIdHintMsg = 'enter_mobile_no'.tr();
  String lblUserIdHintText = 'ex_mobile'.tr();

  String btnNext = 'next'.tr();


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
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [

          Container(
            width: logicalWidth,
            height: logicalHeight,
            decoration:  BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: isDarkMode ? backgroundGradientDark: backgroundGradient  ,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top:MediaQuery.of(context).padding.top ,
                  child: Container(
                    width: screenWidth,
                    height: pathS / 1.2,
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
                      padding: EdgeInsets.only(left: paddingLeft + pathS / 4, right: paddingRight + pathS / 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: pathS / 1.5,
                                height: pathS / 1.2,
                                child: Image.asset(
                                  'assets/images/home/card-icon.png',
                                  color: isDarkMode ? whiteColor : redColor3,
                                ),
                              ),
                              SizedBox(width: pathS / 5),
                              Text(
                                'enter_Manually'.tr(),
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 5,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
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
                    ),
                  ),

                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth - 2.5 * marginValue,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(pathS / 8),
                        color:  isDarkMode ? greyColor6:whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: pathS / 10,
                            offset: Offset(-pathS / 12, pathS / 12),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(left: pathS / 4, top: pathS / 3, bottom: pathS / 3,right: pathS/4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                lblUserIdHintMsg,
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor:greyColor6,
                                  fontSize: pathS / 6.5,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.center,
                              ),

                              // OtpTextField(
                              //
                              //   numberOfFields: 10,
                              //   obscureText: false,
                              //   keyboardType: TextInputType.streetAddress,
                              //   borderColor: isDarkMode ? whiteColor : greyColor6,
                              //   focusedBorderColor: Colors.blue,
                              //   styles: PINTextStyle(
                              //     isDarkMode ? whiteColor : greyColor6,
                              //     10,
                              //   ),
                              //   showFieldAsBox: false,
                              //   borderWidth: 2.0,
                              //   fieldWidth: pathS/3,
                              //   //runs when a code is typed in
                              //   onCodeChanged: (String pin) {
                              //     txtUserId.text = pin;
                              //     onUserIdChange(pin);
                              //
                              //   },
                              //   //runs when every textfield is filled
                              //   onSubmit: (String pin) {
                              //     txtUserId.text = pin;
                              //     onUserIdChange(pin);
                              //     print("OTP completed: " + pin);
                              //
                              //   },
                              // ),

                              TextField(
                                onChanged: (value) {
                                  txtUserId.text = value;
                                  onUserIdChange(value);
                                },
                                controller: txtUserId,
                                keyboardType: TextInputType.streetAddress,
                                decoration:  InputDecoration(
                                  // hintText: '${'name'.tr()}*', // Placeholder text
                                  contentPadding: EdgeInsets.fromLTRB(0, 0, 8, 0),

                                  hintStyle: TextStyle(
                                    color: isDarkMode ? greyColor1 : greyColor3,
                                    fontSize: pathS/4,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  // border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor4,
                                  fontSize: pathS/4,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: pathS / 8),
                              Text(
                                lblUserIdHintText,
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor:greyColor6,
                                  fontSize: pathS / 6.5,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.center,
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: pathS/5),
                    Container(
                      width: screenWidth-4*marginValue,
                      child:Text(
                        lblErrorMsg,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 0, 0, 1),
                          fontSize: pathS / 7,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,

                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                  ],
                ),

                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom+pathS,

                  child: GestureDetector(
                    onTap: (){
                      // Navigator.pop(context);
                      onTapNext();
                    },
                    child: Container(
                      width: pathL,
                      height: pathS / 1.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: nextBgColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                        borderRadius: BorderRadius.circular(pathS/3),
                        boxShadow: [
                          BoxShadow(
                            color: nextShadowColor, // Shadow color
                            blurRadius: pathS/10, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(-pathS/12, pathS/12),
                          ),
                        ],
                      ),
                      child: Text(
                        btnNext,
                        style: TextStyle(
                          color: nextFontColor,
                          fontSize: pathS / 4.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
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
                      Navigator.pop(context);
                      onLoadScanEntry();

                    },
                    child: Container(
                      width: screenWidth,
                      height: pathS / 1.4,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDarkMode?greyColor8:greyColor,

                        boxShadow: [
                          BoxShadow(
                            color: shadowColor, // Shadow color
                            blurRadius: pathS/15, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(-pathS/15, -pathS/15),
                          ),
                        ],
                      ),
                      child: Text(
                        'scan_qr_code'.tr(),
                        style: TextStyle(
                          color: isDarkMode ? redColor1:redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                          fontSize: pathS / 4.5,
                          fontWeight: FontWeight.bold,
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
    );
  }


  void onUserIdChange(String userid){

    if(userid.length >= 9){
      setState(() {
        nextBgColor = isDarkMode ? redColor1:redColor3;
        nextFontColor = Colors.white;
        nextShadowColor = shadowColor;
        lblErrorMsg = '';
      });


    }else{
      setState(() {
        nextBgColor =  isDarkMode ? greyColor8:greyColor2;
        nextFontColor = isDarkMode ? greyColor7 : greyColor3;
        nextShadowColor = Colors.transparent;
        lblErrorMsg = 'enter_10_digit_number'.tr();

      });

    }

  }


  void onTapConfirm() {
    if (txtUserId.text.isEmpty) {
      // showToastView("All fields are required");
      return;
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => VerifyOTPView(),
    //   ),
    // );

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

  void onLoadScanEntry(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanCardView(
            userProfile: widget.userProfile,
            attendanceMode: widget.attendanceMode,
          unitDutyPosts: widget.unitDutyPosts,
          unitShiftDetails: widget.unitShiftDetails,
          userPostings: widget.userPostings,
          attendanceStatus: widget.attendanceStatus,

        ),
      ),
    );
  }

  void onTapNext(){
    printInDebug(txtUserId.text);
    if(widget.userProfile.mobile == txtUserId.text) {
    loadConfirmScreen();
    }else{
     // call API to show data

    }
  }

void loadConfirmScreen(){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ConfirmProfileView(
        userProfile:widget.userProfile,
        attendanceMode: widget.attendanceMode,
        unitDutyPosts: widget.unitDutyPosts,
        unitShiftDetails: widget.unitShiftDetails,
        userPostings: widget.userPostings,
        attendanceStatus: widget.attendanceStatus,

      ),
    ),
  );
}

}
