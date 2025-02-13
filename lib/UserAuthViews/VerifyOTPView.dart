import 'dart:async';

import 'package:bcrypt/bcrypt.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/UserAuthViews/EnterPINView.dart';
import 'package:mysis/UserAuthViews/SetPINView.dart';

import '../CommonViews/AlertPopupView.dart';
import '../CommonViews/AlertView.dart';
import '../CommonViews/CustomNumericKeypad.dart';
import '../MyTabBarView.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/Preferences.dart';

class VerifyOTPView extends StatefulWidget {

  final String otpIdReceived;
  final int otpTimer;
  final String pinReceived;
  final String mobile;
  final String regNo;
  final int calledValue;
  final  bool enableOtpEntry;

  const VerifyOTPView({
    super.key,
    required this.otpIdReceived,
    required this.otpTimer,
    required this.pinReceived,
    required this.mobile,
    required this.regNo,
    required this.calledValue,
    required this.enableOtpEntry,

  });

  @override
  VerifyOTPViewState createState() => VerifyOTPViewState();
}

class VerifyOTPViewState extends State<VerifyOTPView> {
  TextEditingController txtUserOTP= TextEditingController(text: "");
  bool showPassword = false;
  bool rememberMe = false;
  bool showLoaderView = false;

  bool showAlert = false;
  String alertHeader = '';
  String alertMessage = '';

  bool showToastMessageView = false;
  String toastMessage = '';
  String lblOTPVerification =  'otp_verification'.tr();

  Color nextBgColor = isDarkMode ? greyColor5 : greyColor2;
  Color nextFontColor = isDarkMode ? greyColor7 : greyColor3;
  Color nextShadowColor = Colors.transparent;


  String lblErrorMsg = '';
  String lblOtpTimeText = 'resend_otp'.tr();

  String lblCompany = 'company'.tr();

  String lblUserIdHintMsg = 'enter_otp_msg'.tr();
  String lblUserIdHintText = '';

  String btnNext = 'next'.tr();

  bool showKeypad = false;

  List<String> otpList = []; // List of 4 empty strings

  Color otpContainerColor = isDarkMode ? greyColorDark : greyColor5;

  String? pinReceived ;


  @override
  void initState() {
    pinReceived = widget.pinReceived;

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
                  top: MediaQuery.of(context).padding.top,
                  child: Container(
                    width: logicalWidth,
                    height: pathS/1.2,
                    color: isDarkMode?whiteColor:Colors.transparent, // Set white background color here
                    child: Padding(
                      padding: EdgeInsets.only(top: 0, bottom: 0,left: pathS/5,right: pathS/5), // Adjust the padding values as needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
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
                          Spacer(),
                          Container(
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
                        ],
                      ),
                    ),
                  ),
                ),//header logo

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
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 4,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: pathS / 3),
                    SizedBox(height: pathS / 6),
                    Container(
                      width: screenWidth-2.5*marginValue,
                      // height: pathL,
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
                            child: Padding(
                              padding:  EdgeInsets.only(top:pathS/3,bottom: pathS/3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  SizedBox(
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

                                  SizedBox(height: pathS / 30),
                                  SizedBox(
                                    width: screenWidth - 5*marginValue,
                                    child: Text(
                                      '(${maskMobile(widget.mobile)} / ${widget.regNo})',
                                      style: TextStyle(
                                        color: Color.fromRGBO(51, 51, 51, 1),
                                        fontSize: pathS / 6,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: pathS / 8),
                                  SizedBox(
                                    width: screenWidth - 5*marginValue,
                                    child: Text(
                                      'warning_message_in_OTP_Screen'.tr(),
                                      style: TextStyle(
                                        color: redColor1,
                                        fontSize: pathS / 6,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  SizedBox(height: pathS / 12),
                                  if(widget.enableOtpEntry)GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showKeypad = widget.enableOtpEntry;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(4, (index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                          width: pathS/2.2,
                                          height: pathS/1.5,
                                          color: Colors.white,
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
                          color: Color.fromRGBO(255, 0, 0, 1),
                          fontSize: pathS / 6.5,
                          fontWeight: FontWeight.w500,

                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: pathS/5),

                    ResendOTP(timerValue: widget.otpTimer, callBack: (value){

                      if(value == 1){
                        onTapResendOtp();
                      }


                    }),
                    SizedBox(height: pathS),

                  ],
                ),

                Positioned(
                  bottom: paddingBottom+pathS/2,

                  child: GestureDetector(
                    onTap: (){
                      onTapVerify();
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
                        else if(value >=0 && value <= 10){
                          updateOTPList(value);
                        }
                      }
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
                      loadHomeScreen();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  String maskMobile(String mobile) {
    if (mobile.length >= 10) {
      return 'xxx-xxx-${mobile.substring(mobile.length - 4)}';
    }
    return mobile; // Return the original string if it's shorter than 10 characters
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
    txtUserOTP.text = pin;
    onOTPEntered(pin);
  }

  void initialSetup() {}

  void onOTPEntered(String otp){

    if(otp.length == 4){

      setState(() {
          nextBgColor = isDarkMode ? redColor1 : redColor3;
          nextFontColor = isDarkMode ? whiteColor : whiteColor;
          nextShadowColor = shadowColor;
          lblErrorMsg = '';
          otpContainerColor = isDarkMode ? greyColorDark : greyColor5;

      });

    }
    else{
      setState(() {
        nextBgColor = isDarkMode ? greyColor8 : greyColor2;
        nextFontColor = isDarkMode ? greyColor7 : greyColor3;
        nextShadowColor = Colors.transparent;
        lblErrorMsg = ''.tr();
        otpContainerColor = isDarkMode ? greyColorDark : greyColor5;


      });

    }

  }

  void onVerifyOTP() {

    setState(() {
      showLoaderView = true;
    });
    Map <String,String> inputData = {
      "OtpId": widget.otpIdReceived,
      "RegNo" : regNo,
      "OTP" : txtUserOTP.text,

    };

    APIHelper.instance.getData(validateOTPApi,inputData, (data) {

      setState(() {
        showLoaderView = false;
      });
      if(data.isNotEmpty){

        Map<String, dynamic> userData = data.first as Map<String, dynamic>;


        userName = userData['Name'] ?? '';
        regNo = userData['RegNo'] ?? 0;
        designation = userData['Designation'] ?? '';
        phoneNo = userData['MobileNo'] ?? '';

        String pin = userData['PIN'] ?? '';

        String pwd = userData['Password'] ?? '';

        Preferences.saveUserPreference(keyUserName, userName);
        Preferences.saveUserPreference(keyUserID, regNo);
        Preferences.saveUserPreference(keyPwd, pwd);
        Preferences.saveUserPreference(keyMobile, phoneNo);
        Preferences.saveUserPreference(keyPIN, pin);

        pinReceived = pin;
        checkForPIN();
      }

    },(error){
      setState(() {
        showLoaderView = false;
      });
      printInDebug('error received');

      loadAlertScreen(error['ErrorMessage'] ?? '');

    }
    );

  }
  void loadAlertScreen(String message) {
    if(message.isNotEmpty){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlertView(message: message),
        ),
      );
    }
  }

  void onTapVerify(){
    if (txtUserOTP.text.length != 4) {
      showToastView('valid_OTP'.tr());
      return;
    }

    if(widget.calledValue == 0){
      onVerifyOTP();
    }

    if(widget.calledValue == 1){
      String? updatedPIN = widget.pinReceived;
      if(updatedPIN != null && updatedPIN.isNotEmpty && updatedPIN.length == 4) {

        String hashedPin = BCrypt.hashpw(updatedPIN, BCrypt.gensalt());  // Hash the PIN

        Preferences.saveUserPreference(keyPIN, hashedPin);
        changePINApiCall(updatedPIN);
      }
    }

  }
  Future<void> changePINApiCall(String updatedPIN) async {
    setState(() {
      showLoaderView = true;
    });

    Map <String,String> inputData = {
      "PIN": updatedPIN,
    };

    APIHelper.instance.patchData(updateProfileApi, inputData, (responseData) {
      if (responseData.isNotEmpty) {
        // Parse the response list directly
        Map<String, dynamic> data = responseData.first as Map<String, dynamic>;

        final String message = data['Message'] ?? '';
        currentPin = updatedPIN;
        Preferences.saveUserPreference(keyPIN, updatedPIN);

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

  void loadHomeScreen(){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MyTabBarView(),
      ),
          (route) => false, // This removes all previous routes
    );
  }

  Future<void> checkForPIN() async {

    String currentPIN = pinReceived!;  // Hash the PIN

      if(currentPIN != null && currentPIN.isNotEmpty){
        currentPin = currentPIN;
        Preferences.saveUserPreference(keyPIN, currentPIN);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => EnterPINView(
                currentPIN: currentPIN
            ),
          ),
              (route) => false, // This removes all previous routes
        );

      }
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SetPINView(
              calledValue: widget.calledValue,
              mobile: widget.mobile,
              regNo: widget.regNo,
            ),
          ),
        );
      }

  }

  void onTapResendOtp(){

    showToastView('your_request_sent_successfully'.tr());


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


class ResendOTP extends StatefulWidget {
  final int timerValue;
  final void Function(int) callBack;

  const ResendOTP({super.key,
    required this.timerValue,
    required this.callBack});

  @override
  ResendOTPState createState() => ResendOTPState();
}

class ResendOTPState extends State<ResendOTP> {
  late int timerValue; // Timer value in seconds
  late Timer timer;
  bool isResendActive = false;

  @override
  void initState() {
    timerValue = widget.timerValue;
    super.initState();
    startTimer(); // Start the timer when the widget is initialized
  }

  void startTimer() {
    setState(() {
      timerValue = widget.timerValue; // Set the initial timer value
      isResendActive = false; // Disable resend OTP initially
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerValue > 0) {
        setState(() {
          timerValue--; // Decrement the timer value
        });
      } else {
        setState(() {
          isResendActive = true; // Enable resend OTP
        });
        timer.cancel(); // Stop the timer
      }
    });
  }

  void onTapResendOtp() {
    if (isResendActive) {
      // Resend OTP logic here
      widget.callBack(1);
      startTimer(); // Restart the timer
    }
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width  - 2.5*marginValue, // Adjust margin dynamically
      child: GestureDetector(
        onTap: onTapResendOtp,
        child: Text(
          isResendActive
              ? "resend_otp".tr() // Text when resend is active
              : "${'resend_otp'.tr()} ${formatTimer(timerValue)}", // Countdown timer text
          style: TextStyle(
            color: isResendActive ? redColor1:greyColor5,
            fontSize: isResendActive ? pathS / 4 : pathS/6.5,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }


  String formatTimer(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0'); // Get minutes
    final secs = (seconds % 60).toString().padLeft(2, '0'); // Get seconds
    return "$minutes:$secs";
  }

}
