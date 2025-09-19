import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mysis/CommonViews/CustomNumericKeypad.dart';
import 'package:mysis/MyTabBarView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/UserAuthViews/LoginView.dart';
import 'package:mysis/UserAuthViews/SetPINView.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';

import '../CommonViews/AlertPopupView.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/Preferences.dart';

class EnterPINView extends StatefulWidget {
  final String  currentPIN;
  final  int calledValue;

  const EnterPINView({
    super.key,
      this.calledValue = 0,
    required this.currentPIN,
  });

  @override
  EnterPINViewState createState() => EnterPINViewState();
}

class EnterPINViewState extends State<EnterPINView> {
  final LocalAuthentication auth = LocalAuthentication();

  TextEditingController txtEnterPIN= TextEditingController(text: "");

  bool showPassword = false;
  bool rememberMe = false;
  bool showLoaderView = false;

  bool showAlert = false;
  String alertHeader = '';
  String alertMessage = '';

  bool showToastMessageView = false;
  String toastMessage = '';

  Color nextBgColor = isDarkMode ? greyColor5 : greyColor2;
  Color nextFontColor = isDarkMode ? greyColor7 : greyColor3;
  Color nextShadowColor = Colors.transparent;

  String lblErrorMsg = '';

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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Material(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                width: logicalWidth,
                height: logicalHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: isDarkMode ? backgroundGradientDark : backgroundGradient,

                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    if(widget.calledValue <= 1)Positioned(
                      top: paddingTop,
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
                    ),
                    if(widget.calledValue == 2)Positioned(
                      top: MediaQuery.of(context).padding.top+pathS/12,
                      left: paddingLeft +pathS/3,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
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


                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,

                          ),
                        ),//fake container for width only
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
                          'Enter_pin'.tr(),
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
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    SizedBox(
                                      width: screenWidth - 5*marginValue,
                                      child: Text(
                                        'enter_current_pin'.tr(),
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
                                                  color:  otpContainerColor,
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
                              fontSize: pathS / 6.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',

                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: pathS/2),
                        GestureDetector(
                          onTap: (){
                            onUserAuthenticatedLoadNext();

                          },
                          child: Container(
                            width: pathL,
                            height: pathS / 1.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:  nextBgColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
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
                              'next'.tr(),
                              style: TextStyle(
                                color: nextFontColor,
                                fontSize: pathS / 4.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: pathS/2),
                        GestureDetector(
                          onTap: (){
                            onLoadNewPIN();
                          },
                          child: Container(
                            // width: pathL,
                            height: pathS / 1.5,
                            alignment: Alignment.center,

                            child: Text(
                              'forget_current_pin'.tr(),
                              style: TextStyle(
                                color: isDarkMode ? redColor1 : redColor3,
                                fontSize: pathS / 4.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),


                    LoaderView(isVisible: showLoaderView, message: 'Loading...'),

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
                          onLogoutLoadLoginScreen();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
    txtEnterPIN.text = pin;
    onPINEntered(pin);
  }

  void initialSetup() {
    checkBiometricAvailability();
    recallGetToken();
    setState(() {
      lblErrorMsg = ''.tr();
    });
  }

  Future<void> recallGetToken() async {

    bool tokenExpired = await APIHelper.instance.checkForTokenExpiry();
    bool forceLogout = await Preferences.getUserPreferenceBool(keyIsForcedLogOut) ?? false;

    if(forceLogout){
      setState(() {
        alertHeader = '';
        alertMessage = 'logout_message'.tr();
        showAlert = true;
      });
      return;
    }


    if(tokenExpired){

      String userIdOrMobile = regNo.isNotEmpty ? await Preferences.getUserPreference(keyUserID) ?? '' : '';
      String pwd = await Preferences.getUserPreference(keyPwd) ?? '';
      if(userIdOrMobile != '' && pwd != '') {
        getToken(userIdOrMobile, pwd);
      }
    }

  }

  void getToken(String userId, String pwd) {
    APIHelper.instance.getToken(userId, pwd);
  }


  Future<void> onPINEntered(String enteredPIN) async {

    printInDebug("enteredPIN = $enteredPIN");
    printInDebug("widget.currentPIN = ${widget.currentPIN}");

    final bool passwordMatched = BCrypt.checkpw(
      enteredPIN,
      widget.currentPIN,
    );

    if(passwordMatched){
      setState(() {

          nextBgColor = isDarkMode ? redColor1 : redColor3;
          nextFontColor = isDarkMode ? whiteColor : whiteColor;
          nextShadowColor = shadowColor;
          lblErrorMsg = '';
          otpContainerColor = isDarkMode ? greyColorDark : greyColor5;

      });
      onUserAuthenticatedLoadNext();

    }
    else{
      setState(() {
        nextBgColor = isDarkMode ? greyColor8 : greyColor2;
        nextFontColor = isDarkMode ? greyColor7 : greyColor3;
        nextShadowColor = Colors.transparent;
        lblErrorMsg =  enteredPIN.length == 4 ? 'repeat_not_match'.tr() : '';
        otpContainerColor = isDarkMode ? greyColorDark : greyColor5;

      });

    }

  }


  Future<void> onUserAuthenticatedLoadNext() async {

    if(widget.calledValue <= 1 ){
      loadHomeScreen();
    }

    if(widget.calledValue == 2 ){
      onLoadNewPIN();
    }

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

   void onLoadNewPIN(){

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetPINView(
          calledValue: widget.calledValue,
          mobile: phoneNo,
          regNo: regNo,

        ),
        ),
    );
}

  void onLogoutLoadLoginScreen(){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginView(),
      ),
          (route) => false, // This removes all previous routes
    );
  }

  Future<void> checkBiometricAvailability() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      printInDebug('Biometric Available: $canCheckBiometrics, Supported: $isDeviceSupported');

      if (canCheckBiometrics && isDeviceSupported) {
        authenticateWithTouchID();
      } else {
        setState(() {
          showKeypad = true;
        });
      }
    } catch (e) {
      printInDebug('Biometric check error: $e');
      setState(() {
        showKeypad = true;
      });
    }
  }

  Future<void> authenticateWithTouchID() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticate using Touch ID",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if(authenticated) {
        onUserAuthenticatedLoadNext();
      }
     printInDebug('$authenticated');
    } catch (e) {
      printInDebug('auth error = $e');
    }
  }

}

