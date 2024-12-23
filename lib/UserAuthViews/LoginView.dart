import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:mysis/CommonViews/AlertView.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/SharedClasses/LanguageProvider.dart';
import 'package:mysis/UserAuthViews/VerifyOTPView.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/Preferences.dart';
import '../SharedClasses/ThemeProvider.dart';
import 'EnterPINView.dart';
import 'SetPINView.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_text_field.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  TextEditingController txtUserId = TextEditingController(text: "9015235213");
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

  Color lineBorderColor = Color.fromRGBO(255, 0, 0, 1);
  String lblErrorMsg = '';

  String lblCompany = 'company'.tr();

  String lblUserIdHintMsg = 'enter_mobile_no'.tr();
  String lblUserIdHintText = 'ex_mobile'.tr();

  String btnNext = 'next'.tr();
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
                                          fontWeight: FontWeight.normal,
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
                                              fontSize: pathS / 5.5,
                                              fontWeight: FontWeight.bold,
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
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                      // OtpTextField(
                                      //
                                      //   numberOfFields: 10,
                                      //   obscureText: false,
                                      //   keyboardType: TextInputType.streetAddress,
                                      //   borderColor: isDarkMode ? whiteColor : greyColor6,
                                      //   focusedBorderColor: isDarkMode ? whiteColor : greyColor1,
                                      //   styles: PINTextStyle(
                                      //     isDarkMode ? whiteColor : greyColor6,
                                      //     10,
                                      //   ),
                                      //   showFieldAsBox: false,
                                      //   borderWidth: 2.0,
                                      //   fieldWidth: pathS/2.4,
                                      //   margin:EdgeInsets.only(right: 0,left: 1),
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
                                      //     print("user id completed: " + pin);
                                      //
                                      //   },
                                      // ),
                                      // OTPTextField(
                                      //   length: 10,
                                      //   width: pathL * 2,
                                      //   fieldWidth: pathS / 2.5,
                                      //   obscureText: false,
                                      //
                                      //   keyboardType: TextInputType.emailAddress,
                                      //   style: TextStyle(
                                      //     color: isDarkMode ? whiteColor : greyColor6,
                                      //     fontSize: pathS / 6,
                                      //     fontFamily: 'Roboto',
                                      //   ),
                                      //   textFieldAlignment: MainAxisAlignment.spaceAround,
                                      //   fieldStyle: FieldStyle.underline,
                                      //
                                      //   onChanged: (pin) {
                                      //     print("OTP Entered: " + pin);
                                      //     txtUserId.text = pin;
                                      //     onUserIdChange(pin);
                                      //   },
                                      //   onCompleted: (pin) {
                                      //     print("OTP completed: " + pin);
                                      //     txtUserId.text = pin;
                                      //     onUserIdChange(pin);
                                      //   },
                                      // ),
                                      SimpleOTPTextField(
                                        isDarkMode: isDarkMode,
                                        txtUserId: txtUserId,
                                        onUserIdChange: (data  ) {

                                          onUserIdChange(data);

                                      },),
                                      SizedBox(height: pathS / 8),
                                      Text(
                                        lblUserIdHintText,
                                        style: TextStyle(
                                          color: Color.fromRGBO(51, 51, 51, 0.7),
                                          fontSize: pathS / 6.5,
                                          fontWeight: FontWeight.w500,
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
                        Container(
                          width: screenWidth-4*marginValue,
                          child:Text(
                            lblErrorMsg,
                            style: TextStyle(
                              color: redColor2,
                              fontSize: pathS / 6,
                              fontWeight: FontWeight.w500,

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
                              fontWeight: FontWeight.w600,
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
      },
    );

  }

  void initialSetup() {}

  void onUserIdChange(String userid){

    if(userid.length ==  10 || userid.length ==  9){
      setState(() {
        nextBgColor = Color.fromRGBO(195, 50, 30, 1);
        nextFontColor = Colors.white;
        nextShadowColor = Colors.black.withOpacity(0.2);
        lineBorderColor = Color.fromRGBO(51, 51, 51, 0.5);
        lblErrorMsg = '';
      });

    }else{
      setState(() {
        nextBgColor = Color.fromRGBO(51, 51, 51, 0.2);
        nextFontColor = Color.fromRGBO(51, 51, 51, 0.6);
        nextShadowColor = Colors.transparent;
        lineBorderColor = Color.fromRGBO(255, 0, 0, 1);
        lblErrorMsg = 'enter_10_digit_number'.tr();

      });

    }

  }


  void onTapLogin() {
    if (txtUserId.text.isEmpty) {
      showToastView("All fields are required");
      return;

    }

      setState(() {
        showLoaderView = true;
      });
      Map <String,String> inputData = {
        "UserName": txtUserId.text,
      };

      APIHelper.instance.getData(authenticateApi,inputData, (data) {

        setState(() {
          showLoaderView = false;
        });
        if(data.isNotEmpty){

          Map<String, dynamic> userData = data.first as Map<String, dynamic>;

          userName = userData['Name'] ?? '';
          userId = userData['RegNo'] ?? 0;
          designation = userData['Designation'] ?? '';
          phoneNo = userData['MobileNo'] ?? '';

          String otp = userData['OTP'] ?? '';
          String pin = userData['PIN'] ?? '';
          String languageCode = userData['Language'] ?? '';
          int isOTPRequired = userData['BypassOTPScreen'] ?? 0;
          int OTPTimer = userData['OTP_Validity'] ?? 0;

          String pwd = userData['Password'] ?? '';


          Preferences.saveUserPreference(keyUserName, userName);
          Preferences.saveUserPreference(keyUserID, '$userId');

          updateLanguage(languageCode);

          loadNextScreen(isOTPRequired, otp,OTPTimer,pin);

          getToken(userId, pwd);

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
      Preferences.saveUserPreference(keyUserToken, '$token');


    }

  },(error){
   if (kDebugMode) {
     print(error);
   }
  }
  );
}
  void loadNextScreen(int isOTPRequired, String otp,int timerVal, String pin) {
    if(isOTPRequired == 0 && otp.isNotEmpty){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOTPView(otpReceived: otp, otpTimer: timerVal,pinReceived: pin),
        ),
      );
    }else{
      String? currentPIN = pin;
      if(currentPIN != null && currentPIN!.isNotEmpty && currentPIN!.length == 4){
        Preferences.saveUserPreference(keyPIN, pin);
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


class SimpleOTPTextField extends StatelessWidget {
  final TextEditingController txtUserId;
  final Function(String) onUserIdChange;
  final bool isDarkMode;

  const SimpleOTPTextField({
    required this.txtUserId,
    required this.onUserIdChange,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: txtUserId,
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10), // Limit to 10 characters
        // FilteringTextInputFormatter., // Allow digits only
      ],
      style: TextStyle(
        color: isDarkMode ? whiteColor : greyColor6,
        fontSize: pathS/5,
        fontFamily: 'Roboto',
      ),
      decoration: InputDecoration(
        // hintText: 'Enter OTP',
        hintStyle: TextStyle(
          color:  isDarkMode ? whiteColor : greyColor6,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      onChanged: (value) {
        onUserIdChange(value);
      },
      textAlign: TextAlign.start, // Ensures input starts from the left
    );
  }
}
