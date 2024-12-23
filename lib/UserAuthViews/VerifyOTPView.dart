import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/UserAuthViews/EnterPINView.dart';
import 'package:mysis/UserAuthViews/SetPINView.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../SharedClasses/Preferences.dart';

class VerifyOTPView extends StatefulWidget {
  final String otpReceived;
  final int otpTimer;
  final String pinReceived;

  const VerifyOTPView({
    super.key,
    required this.otpReceived,
    required this.otpTimer,
    required this.pinReceived
  });

  @override
  VerifyOTPViewState createState() => VerifyOTPViewState();
}

class VerifyOTPViewState extends State<VerifyOTPView> {
  TextEditingController txtUserOTP= TextEditingController(text: "");
  TextEditingController txtPassword = TextEditingController(text: "");
  bool showPassword = false;
  bool rememberMe = false;
  bool showLoaderView = false;

  bool isAlertVisible = false;
  String alertHeader = 'Error!';
  String alertMessage = 'There is an  internal error.';

  bool showToastMessageView = false;
  String toastMessage = '';

  String lblOTPVerification =  'otp_verification'.tr();

  Color nextBgColor = isDarkMode ? greyColor5 : greyColor2;
  Color nextFontColor = isDarkMode ? greyColor7 : greyColor3;
  Color nextShadowColor = Colors.transparent;


  String lblErrorMsg = 'txt_incorrect_otp'.tr();

  String lblCompany = 'company'.tr();

  String lblUserIdHintMsg = 'enter_otp_msg'.tr();
  String lblUserIdHintText = '';

  String btnNext = 'next'.tr();


  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);

    return Material(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: logicalWidth,
            height: logicalHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient:  isDarkMode ? backgroundGradientDark : backgroundGradient,
              // border: Border.all(color: Colors.lightBlue.shade300, width: pathS/18),
              // borderRadius: BorderRadius.circular(pathS/15),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: screenWidth,
                ),

                Positioned(
                  top: paddingTop+pathS/8,
                  right: 0,
                  child: Container(
                  width: pathS / 1.45,
                  height: pathS / 1.5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: AssetImage("assets/images/icons/icon.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ),
                Positioned(
                  top: paddingTop+pathS/8,
                  left: -0,

                  child: Container(
                    width: pathL,
                    height: pathS / 1.5,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: AssetImage("assets/images/icons/logo.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: pathS * 1.5,
                      height: pathS * 1.5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/icons/SIS-App-icon.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: pathS / 3),
                    Text(
                      lblOTPVerification,
                      style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontSize: pathS / 4,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: pathS / 3),
                    Container(
                      width: screenWidth-2.5*marginValue,
                      height: pathL/1.5,
                      decoration:  BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(pathS/8),
                        color: Colors.white,
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
                        alignment: Alignment.topLeft,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: pathS/5, top: pathS/6), // Adjust top and left as needed
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lblCompany,
                                    style: TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 0.7),
                                      fontSize: pathS / 6.5,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto'
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: pathS / 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: pathS / 1.9,
                                        height: pathS / 1.9,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: DecorationImage(
                                            image: AssetImage("assets/images/icons/icon.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: pathS / 6),
                                      Text(
                                        'SIS INDIA',
                                        style: TextStyle(
                                          color: Color.fromRGBO(51, 51, 51, 1),
                                          fontSize: pathS / 5,
                                          fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto'
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                    ),
                    SizedBox(height: pathS / 6),
                    Container(
                      width: screenWidth-2.5*marginValue,
                      height: pathL,
                      decoration:  BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(pathS/8),
                        color: Colors.white,
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
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Container(
                                  width: screenWidth - 5*marginValue,
                                  child: Text(
                                    lblUserIdHintMsg,
                                    style: TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      fontSize: pathS / 6.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: pathS / 12),
                                OTPTextField(
                                  length: 4,
                                  width: pathL*1.2,
                                  fieldWidth: pathS/2.2,
                                  obscureText: true,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      fontSize: pathS/3.5,

                                  ),
                                  textFieldAlignment: MainAxisAlignment.spaceAround,
                                  fieldStyle: FieldStyle.underline,
                                    onChanged:(pin){
                                      print("OTP Entered: " + pin);
                                      txtUserOTP.text = pin;
                                      onUserIdChange(pin);
                                    },
                                  onCompleted: (pin) {
                                    txtUserOTP.text = pin;
                                    onUserIdChange(pin);
                                    print("OTP completed: " + pin);

                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: pathS/5),
                    Container(
                      width: screenWidth-4*marginValue,
                      child:Text(
                        lblErrorMsg,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 0, 0, 1),
                          fontSize: pathS / 6.5,
                          fontWeight: FontWeight.w500,

                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: pathS),

                  ],
                ),

                Positioned(
                  bottom: paddingBottom+pathS/2,

                  child: GestureDetector(
                    onTap: (){
                      onTapLogin();

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
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),

                LoaderView(isVisible: showLoaderView, message: 'Loading...'),
                Visibility(
                  visible: isAlertVisible,
                  child: CustomAlertView(
                      callBack: (int val) {
                        if (val == 0) {
                          setState(() {
                            isAlertVisible = false;
                          });
                        } else {
                          makePhoneCall(phoneNo);
                        }
                      },
                      header: alertHeader,
                      message: alertMessage,
                      cancelButtonTitle: 'OK',
                      okButtonTitle: ''),
                ),
                ToastMessageView(isVisible: showToastMessageView, message: toastMessage),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initialSetup() {}

  void onUserIdChange(String otp){

    if(otp.length == 4){

      setState(() {
        if(otp != widget.otpReceived){
          lblErrorMsg = 'txt_incorrect_otp'.tr();
          return;

        }else {
          nextBgColor = isDarkMode ? redColor1 : redColor3;
          nextFontColor = isDarkMode ? whiteColor : whiteColor;
          nextShadowColor = shadowColor;
          lblErrorMsg = '';
        }
      });


    }
    else{
      setState(() {
        nextBgColor = isDarkMode ? greyColor8 : greyColor2;
        nextFontColor = isDarkMode ? greyColor7 : greyColor3;
        nextShadowColor = Colors.transparent;
        lblErrorMsg = 'txt_incorrect_otp'.tr();

      });

    }

  }


  Future<void> onTapLogin() async {
    printInDebug(widget.otpReceived);
    printInDebug(txtUserOTP.text);

    if (txtUserOTP.text.length != 4) {
      return;
    }



    if(widget.otpReceived == txtUserOTP.text ) {

      String? currentPIN = widget.pinReceived;

      if(currentPIN != null && currentPIN!.isNotEmpty && currentPIN!.length == 4){
        Preferences.saveUserPreference(keyPIN, currentPIN);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterPINView(),
          ),
        );
      }
      else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetPINView(),
          ),
        );
      }
    }
    else {
      setState(() {
        txtUserOTP.text = '';
      });
    }
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
