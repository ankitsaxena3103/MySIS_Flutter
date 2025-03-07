import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/AlertView.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/SharedClasses/LanguageProvider.dart';
import 'package:mysis/UserAuthViews/VerifyOTPView.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../HomeView/SimpleTextField.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/Preferences.dart';
import '../SharedClasses/ThemeProvider.dart';
import 'EnterPINView.dart';
import 'SetPINView.dart';
import 'package:flutter/services.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  TextEditingController txtUserId = TextEditingController(text: "");
  TextEditingController txtPassword = TextEditingController(text: "");
  bool showPassword = false;
  bool rememberMe = false;
  bool showLoaderView = false;

  bool isAlertVisible = false;
  String alertHeader = 'Error!';
  String alertMessage = 'There is an  internal error.';

  bool showToastMessageView = false;
  String toastMessage = '';


  String lblSignIn =  'sign_in'.tr();
  Color nextBgColor = Color.fromRGBO(51, 51, 51, 0.2);
  Color nextFontColor = Color.fromRGBO(51, 51, 51, 0.6);
  Color nextShadowColor = Colors.transparent;
  String btnNext = 'next'.tr();
  bool isTapEnabled = false;

  Color lineBorderColor = Color.fromRGBO(51, 51, 51, 0.5);

  String lblErrorMsg = '';

  String lblCompany = 'company'.tr();

  String lblUserIdHintMsg = 'enter_mobile_no'.tr();
  String lblUserIdHintText = 'ex_mobile'.tr();

  late LanguageProvider languageProvider;



  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    var backgroundGradient = LinearGradient(
      colors: [Colors.white, Color.fromRGBO(217, 217, 217, 1)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Consumer2<LanguageProvider, ThemeProvider>(
      builder: (context, languageProvider, themeProvider, child) {
        return Material(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                width: logicalWidth,
                height: logicalHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: backgroundGradient,

                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [

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
                          lblSignIn,
                          style: TextStyle(
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontSize: pathS / 3.5,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: pathS / 3),

                        // Container(
                        //   width: screenWidth-2.5*marginValue,
                        //   height: pathL/1.5,
                        //   decoration:  BoxDecoration(
                        //     shape: BoxShape.rectangle,
                        //     borderRadius: BorderRadius.circular(pathS/8),
                        //     color: Colors.white,
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.black.withOpacity(0.1), // Shadow color
                        //         blurRadius: pathS/10, // Spread of the shadow
                        //         // spreadRadius: pathS/15, // How far the shadow extends
                        //         offset:  Offset(-pathS/12, pathS/12),
                        //       ),
                        //     ],
                        //   ),
                        //   child: Stack(
                        //     alignment: Alignment.topLeft,
                        //     children: [
                        //       Padding(
                        //         padding: EdgeInsets.only(left: pathS/5, top: pathS/6), // Adjust top and left as needed
                        //         child: Align(
                        //           alignment: Alignment.topLeft,
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               Text(
                        //                 lblCompany,
                        //                 style: TextStyle(
                        //                   color: Color.fromRGBO(51, 51, 51, 0.7),
                        //                   fontSize: pathS / 6.5,
                        //                   fontWeight: FontWeight.normal,
                        //                 ),
                        //                 textAlign: TextAlign.center,
                        //               ),
                        //               SizedBox(height: pathS / 8),
                        //               Row(
                        //                 mainAxisAlignment: MainAxisAlignment.start,
                        //                 children: [
                        //                   Container(
                        //                     width: pathS / 1.9,
                        //                     height: pathS / 1.9,
                        //                     decoration: const BoxDecoration(
                        //                       shape: BoxShape.rectangle,
                        //                       image: DecorationImage(
                        //                         image: AssetImage("assets/images/icons/icon.png"),
                        //                         fit: BoxFit.cover,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   SizedBox(width: pathS / 6),
                        //                   Text(
                        //                     'SIS INDIA',
                        //                     style: TextStyle(
                        //                       color: Color.fromRGBO(51, 51, 51, 1),
                        //                       fontSize: pathS / 5.5,
                        //                       fontWeight: FontWeight.bold,
                        //                     ),
                        //                     textAlign: TextAlign.center,
                        //                   ),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        //
                        // ),
                        SizedBox(height: pathS / 6),
                        Container(
                          width: screenWidth-2.5*marginValue,
                          // height: pathL/1.2,
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
                                padding: EdgeInsets.only(left: pathS/3, top: pathS/3,bottom: pathS/3,right: pathS/4), // Adjust top and left as needed
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lblUserIdHintMsg,
                                        style: TextStyle(
                                          color: greyColor6,
                                          fontSize: pathS / 6.5,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                      SimpleUnderLineTextField(
                                        isDarkMode: isDarkMode,
                                        txtUserId: txtUserId,
                                        onUserIdChange: (data  ) {

                                          onUserIdChange(data);

                                      }, lineBorderColor: lineBorderColor,),
                                      SizedBox(height: pathS / 8),
                                      Text(
                                        lblUserIdHintText,
                                        style: TextStyle(
                                          color: Color.fromRGBO(51, 51, 51, 0.7),
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
                            ],
                          ),
                        ),
                        SizedBox(height: pathS/5),
                        SizedBox(
                          width: screenWidth-4*marginValue,
                          child:Text(
                            lblErrorMsg,
                            style: TextStyle(
                              color: redColor2,
                              fontSize: pathS / 6,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',

                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),

                        SizedBox(height: pathS),



                      ],
                    ),

                    Positioned(
                      bottom: paddingBottom+pathS/2,

                      child: GestureDetector(
                        onTap: isTapEnabled ? onTapLogin : null, // Disable tap if isTapEnabled is false
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
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                    ),


                    LoaderView(isVisible: showLoaderView, message: ''),
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
      },
    );

  }

  void initialSetup() {}

  void onUserIdChange(String userid) {

    final mobileNoRegExp = RegExp(r'^\d{10}$'); // 10-digit mobile number
    final sisIdRegExp = RegExp(r'^SIS\d{7}$'); // SIS followed by exactly 7 numeric characters
    final otherIdRegExp = RegExp(r'^(?!SIS)[A-Z]{3}\d{6}$'); // Exclude SIS and match 3 uppercase letters followed by 6 digits

    if (mobileNoRegExp.hasMatch(userid) ||
        sisIdRegExp.hasMatch(userid) ||
        otherIdRegExp.hasMatch(userid)) {
      setState(() {
        nextBgColor = Color.fromRGBO(195, 50, 30, 1);
        nextFontColor = Colors.white;
        nextShadowColor = Colors.black.withOpacity(0.2);
        lineBorderColor = Color.fromRGBO(51, 51, 51, 0.5);
        lblErrorMsg = '';
        isTapEnabled = true; // Enable tap

        FocusScope.of(context).unfocus();
      });
    } else {
      setState(() {
        nextBgColor = Color.fromRGBO(51, 51, 51, 0.2);
        nextFontColor = Color.fromRGBO(51, 51, 51, 0.6);
        nextShadowColor = Colors.transparent;
        lineBorderColor = Color.fromRGBO(255, 0, 0, 1);
        lblErrorMsg = 'enter_mobile_no'.tr();
        isTapEnabled = false; // Disable tap
      });
    }
  }


  Future<String> getAppInfo() async {
    // Get app version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;

    // Get device type and OS version
    String deviceType = Platform.isAndroid ? "Android" : Platform.isIOS ? "iOS" : "Web";
    String osVersion = Platform.operatingSystemVersion;

    // Get device ID
    String deviceId = await getDeviceId();

    return '$deviceType $osVersion (Device ID: $deviceId) - MySIS $appVersion';
  }

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Returns a unique device ID for Android
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? ""; // Returns a unique device ID for iOS
    } else {
      return ""; // For unsupported platforms like Web
    }
  }
  Future<void> onTapLogin() async {
    String appInfoSendToServer = await getAppInfo();
    if (txtUserId.text.isEmpty) {
      showToastView("enter_mobile_no");
      return;
    }

      setState(() {
        showLoaderView = true;
      });
      Map <String,String> inputData = {
        "UserName": txtUserId.text,
        "AppToken" : appInfoSendToServer,
        "BypassOTPScreen" : "1",
        "Enable_OTPEntry" : "0"

      };

      APIHelper.instance.getData(requestLoginApi,inputData, (data) {

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
          String languageCode = userData['Language'] ?? '';

          String otpId = userData['OtpId'] ?? '';
          int isOTPRequired = userData['BypassOTPScreen'] ?? 0;
          int otpTimer = userData['OTP_Validity'] ?? 0;
          bool enableOTPEntry = (userData['Enable_OTPEntry'] ?? 0 ) == 1;

          String pwd = userData['Password'] ?? '';

          Preferences.saveUserPreference(keyUserName, userName);
          Preferences.saveUserPreference(keyUserID, regNo);
          Preferences.saveUserPreference(keyPwd, pwd);
          Preferences.saveUserPreference(keyMobile, phoneNo);
          Preferences.saveUserPreference(keyPIN, pin);


          updateLanguage(languageCode);

          loadNextScreen(enableOTPEntry, otpId,otpTimer,pin,phoneNo,regNo);

          if(otpId.isNotEmpty && pwd.isNotEmpty){
            getToken(regNo, pwd);
          }


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

  void getToken(String userId, String pwd){
  Map <String,String> inputData = {
    "Username": userId,
    "Password": pwd,

  };
  APIHelper.instance.postData(tokenApi,inputData, (data) {

    if(data.isNotEmpty){

      token = data['token'] ?? '';
      Preferences.saveUserPreference(keyUserToken, token);
      Preferences.saveUserPreferenceBool(keyIsForcedLogOut, false);


    }

  },(error){
   if (kDebugMode) {
     print(error);
   }
  });
}
  void loadNextScreen(bool enableOtpEntry, String otpId,int timerVal, String pin, String mobileNo,String regNo) {
    if(otpId.isNotEmpty){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOTPView(
            otpIdReceived: otpId,
            otpTimer: timerVal,
            pinReceived: pin,
            mobile: mobileNo,
            regNo: regNo,
            calledValue: 0,
            enableOtpEntry: enableOtpEntry,
          ),
        ),
      );
    }else{
      String? currentPIN = pin;
      if(currentPIN != null && currentPIN!.isNotEmpty ){
        Preferences.saveUserPreference(keyPIN, pin);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterPINView(
              currentPIN: pin
            ),
          ),
        );
      }
      else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetPINView(
              calledValue: 0,
              mobile: mobileNo,
              regNo: regNo,

            ),
          ),
        );
      }
    }
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

  void updateLanguage(String langCode){

    printInDebug(langCode);
    if(langCode == 'en'){
      selectedLocale = 'en-US';
      selectedLanguageCode = 'en';

      languageProvider.setLanguage(selectedLanguageCode, 'US');

    }else   if(langCode == 'hi'){
      selectedLocale = 'hi-IN';
      selectedLanguageCode = 'hi';
    }else   if(langCode == 'kn'){
      selectedLocale = 'kn-IN';
      selectedLanguageCode = 'kn';
    }else   if(langCode == 'mr'){
      selectedLocale = 'mr-IN';
      selectedLanguageCode = 'mr';
    }else   if(langCode == 'ta'){
      selectedLocale = 'ta-IN';
      selectedLanguageCode = 'ta';
    }else   if(langCode == 'te'){
      selectedLocale = 'te-IN';
      selectedLanguageCode = 'te';
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


