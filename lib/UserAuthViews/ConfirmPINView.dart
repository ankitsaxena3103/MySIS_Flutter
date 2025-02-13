import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:mysis/MyTabBarView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/UserAuthViews/VerifyOTPView.dart';

import '../CommonViews/AlertPopupView.dart';
import '../CommonViews/CustomNumericKeypad.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/Preferences.dart';

class ConfirmPINView extends StatefulWidget {

  final String userPIN;


  final String pinEntered;
  final String mobile;
  final String regNo;
  final int calledValue;


  const ConfirmPINView({
    super.key,
    required this.userPIN,

    required this.pinEntered,
    required this.mobile,
    required this.regNo,
    required this.calledValue,

  });

  @override
  ConfirmPINViewState createState() => ConfirmPINViewState();
}

class ConfirmPINViewState extends State<ConfirmPINView> {

  late String otpReceived;
  late int otpTimer;

  TextEditingController txtUserConfirmPIN= TextEditingController(text: "");

  bool showLoaderView = false;

  bool showAlert = false;
  String alertHeader = '';
  String alertMessage = '';

  bool showToastMessageView = false;
  String toastMessage = '';

  String lblHeader =  'repeat_pin'.tr();

  Color nextBgColor = isDarkMode ? greyColor5 : greyColor2;
  Color nextFontColor = isDarkMode ? greyColor7 : greyColor3;
  Color pinBorderColor = isDarkMode ? whiteColor:greyColor6;
  Color nextShadowColor = Colors.transparent;

  String lblErrorMsg = '';

  String lblCompany = 'Company';

  String lblUserIdHintMsg = 'repeat_pin_enter'.tr();
  String lblUserIdHintText = '';

  String btnNext = 'confirm'.tr();

  bool showKeypad = false;

  List<String> otpList = []; // List of 4 empty strings

  Color otpContainerColor = isDarkMode ? greyColorDark : greyColor5;


  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    var backgroundGradient = LinearGradient(
      colors: [Colors.white, Color.fromRGBO(217, 217, 217, 1)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    return Material(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: logicalWidth,
            height: logicalHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: isDarkMode ? backgroundGradientDark : backgroundGradient,
              // border: Border.all(color: Colors.lightBlue.shade300, width: pathS/18),
              // borderRadius: BorderRadius.circular(pathS/15),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [

                Positioned(
                  top: MediaQuery.of(context).padding.top+pathS/12,
                  left: paddingLeft +pathS/3,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: pathS/5,
                          height: pathS/2,
                          child: Image.asset(
                            'assets/images/dashboard-icons/left-arrow.png',
                            color: isDarkMode ? whiteColor:greyColor5,

                          ),

                        ),
                        SizedBox(width: pathS/8),
                        Text(
                          'PIN'.tr(),
                          style: TextStyle(
                            color: isDarkMode ?  whiteColor:greyColor5,
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

                // Positioned(
                //   top: paddingTop,
                //   child: Container(
                //     width: logicalWidth,
                //     height: pathS/1.2,
                //     color: isDarkMode?whiteColor:Colors.transparent, // Set white background color here
                //     child: Padding(
                //       padding: EdgeInsets.only(top: 0, bottom: 0,left: pathS/5,right: pathS/5), // Adjust the padding values as needed
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Container(
                //             width: pathL,
                //             height: pathS / 1.5,
                //             decoration: const BoxDecoration(
                //               shape: BoxShape.rectangle,
                //               image: DecorationImage(
                //                 image: AssetImage("assets/images/icons/logo.png"),
                //                 fit: BoxFit.cover,
                //               ),
                //             ),
                //           ),
                //           Spacer(),
                //           Container(
                //             width: pathS / 1.45,
                //             height: pathS / 1.5,
                //             decoration: const BoxDecoration(
                //               shape: BoxShape.rectangle,
                //               image: DecorationImage(
                //                 image: AssetImage("assets/images/icons/icon.png"),
                //                 fit: BoxFit.cover,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth,
                    ),
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
                    SizedBox(height: pathS / 2),
                    Text(
                      lblHeader,
                      style: TextStyle(
                        color: isDarkMode ? whiteColor:greyColor6,
                        fontSize: pathS / 4,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto'
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: pathS / 3),
                    Container(
                      width: screenWidth-2.5*marginValue,
                      height: pathL,
                      decoration:  BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(pathS/8),
                        color: isDarkMode ? greyColor8:whiteColor,
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
                                      color: isDarkMode ? whiteColor:greyColor6,
                                      fontSize: pathS / 6.5,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto'
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: pathS / 12),

                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showKeypad = true;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(4, (index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                        width: pathS/2.2,
                                        height: 50,
                                        color: isDarkMode?greyColor8:Colors.white,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Simple Text
                                            Text(
                                              index < otpList.length ? '*' : '', // Show the value if present, else blank
                                              style: TextStyle(
                                                  color: isDarkMode ? whiteColor:greyColor6,
                                                  fontSize: pathS / 3,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto'
                                              ),
                                              textAlign: TextAlign.center,                                                ),
                                            // Underline design
                                            Container(
                                              margin: const EdgeInsets.only(top: 4.0), // Space between text and underline
                                              height: 1.5, // Height of the underline
                                              color: otpContainerColor,
                                              // Underline color (can be customized)
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: pathS/5),
                    SizedBox(
                      width: screenWidth-4*marginValue,
                      child:Text(
                        lblErrorMsg,
                        style: TextStyle(
                          color: isDarkMode ? redColor1 : redColor3,
                          fontSize: pathS / 7,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto'
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
                      onTapConfirm();

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
                          fontSize: pathS / 4,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto'
                        ),
                      ),
                    ),
                  ),
                ),

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
                      loadHomeView();
                    },
                  ),
                ),
                LoaderView(isVisible: showLoaderView, message: ''),
                ToastMessageView(isVisible: showToastMessageView, message: toastMessage),
                Visibility(
                  visible: showKeypad,
                  child: CustomNumericKeypad(
                      keypadNumber: (value){
                        if(value == -1){
                          setState(() {
                            showKeypad = false;
                          });
                        }
                        else if(value >= 0 && value <= 10){
                          updateOTPList(value);
                        }
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateOTPList(int value) {

    setState(() {
      if (value == 10) {
        // Handle delete action
        if (otpList.isNotEmpty) {
          otpList.removeLast();
        }
      }
      else if (value >= 0 && value < 10) {
        // Handle number input
        if (otpList.length < 4) {
          otpList.add(value.toString()); // Add the value to the list
          if(otpList.length == 4){
            showKeypad = false;
          }
        }
      }
    });

    String pin = otpList.join();
    txtUserConfirmPIN.text = pin;
    onEnterPIN(pin);
  }

  void initialSetup() {

  }

  void onEnterPIN(String confirmPIN){

    if(confirmPIN.length == 4){
      setState(() {

        if(widget.userPIN != confirmPIN){
          lblErrorMsg = 'not_match'.tr();
          otpContainerColor = isDarkMode ? redColor1 : redColor3;

        }else{
          nextBgColor = isDarkMode ? redColor1 : redColor3;
          nextFontColor = Colors.white;
          nextShadowColor = shadowColor;

          lblErrorMsg = '';
          pinBorderColor = isDarkMode ? whiteColor:greyColor6;

          otpContainerColor = isDarkMode ? greyColorDark : greyColor5;

        }

      });


    }else{
      setState(() {
        nextBgColor = isDarkMode ? greyColor5 : greyColor2;
        nextFontColor = isDarkMode ? greyColor7 : greyColor3;
        nextShadowColor = Colors.transparent;
        lblErrorMsg = '';
        pinBorderColor = isDarkMode ? redColor1:redColor3;
        otpContainerColor = isDarkMode ? greyColorDark : greyColor5;


      });

    }

  }


  void onTapConfirm() {

    if (txtUserConfirmPIN.text.isEmpty || txtUserConfirmPIN.text != widget.userPIN) {
       showToastView('repeat_not_match'.tr());
      return;
    }


    if(widget.calledValue == 1) {
      //call get otp api and then load otp view
      otpReceived = '1234';
      otpTimer = 60;
      loadOTPView();
    }

    if(widget.calledValue == 2 || widget.calledValue == 0){
      currentPin = txtUserConfirmPIN.text;
      String hashedPin = BCrypt.hashpw(currentPin, BCrypt.gensalt());  // Hash the PIN
      Preferences.saveUserPreference(keyPIN, hashedPin);
      changePINApiCall();
    }

  }


  Future<void> changePINApiCall() async {
    setState(() {
      showLoaderView = true;
    });

    Map <String,String> inputData = {
      "PIN": txtUserConfirmPIN.text
    };

    APIHelper.instance.patchData(updateProfileApi, inputData, (responseData) {
      if (responseData.isNotEmpty) {
        // Parse the response list directly
        Map<String, dynamic> data = responseData.first as Map<String, dynamic>;

        final String message = data['Message'] ?? '';

        setState(() {
          alertHeader = '';
          alertMessage =message.isNotEmpty ? message: 'security_pin_change'.tr();
          showAlert = true;
        });

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


void loadHomeView(){

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => MyTabBarView(),
    ),
        (route) => false, // This removes all previous routes
  );
}

  void loadOTPView(){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyOTPView(
            otpIdReceived: otpReceived,
            otpTimer: otpTimer,
            pinReceived:widget.pinEntered,
            mobile: widget.mobile,
            regNo: widget.regNo,
            calledValue: widget.calledValue,
             enableOtpEntry: true,
        ),
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
