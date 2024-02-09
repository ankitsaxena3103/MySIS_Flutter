import 'package:flutter/material.dart';
import 'package:mysis/SharedClasses/APIHelper.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/MyTabBarView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/UserAuthViews/LoginViewError.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/ThemeProvider.dart';
import 'package:provider/provider.dart';

class EnterPINView extends StatefulWidget {

  const EnterPINView({
    super.key,
  });

  @override
  EnterPINViewState createState() => EnterPINViewState();
}

class EnterPINViewState extends State<EnterPINView> {
  TextEditingController txtEnterPIN= TextEditingController(text: "");

  bool showPassword = false;
  bool rememberMe = false;
  bool showLoaderView = false;

  bool isAlertVisible = false;
  String alertHeader = 'Error!';
  String alertMessage = 'There is an  internal error.';

  bool showToastMessageView = false;
  String toastMessage = '';

  String lblOTPVerification =  'Repeat PIN';

  Color nextBgColor = isDarkMode ? whiteFontColor: greyButtonBGColor;
  Color nextFontColor = isDarkMode ? whiteBGColor:greyButtonFontColor ;
  Color nextShadowColor = Colors.transparent;

  Color lineBorderColor = Color.fromRGBO(255, 0, 0, 1);
  String lblErrorMsg = 'repeat_not_match'.tr();



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

                    Positioned(
                      top: paddingTop,
                      child: Container(
                      width: logicalWidth,
                      height: pathS/1.2,
                        color: isDarkMode?whiteFontColor:Colors.transparent, // Set white background color here
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
                                  image: AssetImage("assets/images/icons/logo@3x.png"),
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
                                  image: AssetImage("assets/images/icons/icon@3x.png"),
                                  fit: BoxFit.cover,
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
                        SizedBox(height: pathS / 2),
                        Text(
                          'Enter_pin'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteFontColor:greyFontColor,
                            fontSize: pathS / 3.5,
                            fontWeight: FontWeight.normal,
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
                            color: isDarkMode?darkTileBgcolor:Colors.white,
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
                                        'enter_current_pin'.tr(),
                                        style: TextStyle(
                                          color: isDarkMode ? whiteFontColor:greyFontColor,
                                          fontSize: pathS / 6.5,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: pathS / 12),
                                    OTPTextField(
                                      length: 4,
                                      width: pathL*1.2,
                                      fieldWidth: pathS/2.2,
                                      style: TextStyle(
                                        color: isDarkMode? whiteFontColor:Color.fromRGBO(51, 51, 51, 1),
                                        fontSize: pathS/3.5,

                                      ),
                                      textFieldAlignment: MainAxisAlignment.spaceAround,
                                      fieldStyle: FieldStyle.underline,
                                      onChanged:(pin){
                                        print("OTP Entered: " + pin);
                                        txtEnterPIN.text = pin;
                                        onUserIdChange(pin);
                                      },
                                      onCompleted: (pin) {
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
                              fontSize: pathS / 7,
                              fontWeight: FontWeight.normal,

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
                            'confirm'.tr(),
                            style: TextStyle(
                              color: nextFontColor,
                              fontSize: pathS / 4.5,
                              fontWeight: FontWeight.bold,
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

  void onUserIdChange(String confirmPIN){

    if(confirmPIN.length == 4){
      setState(() {

        if('1234' != txtEnterPIN.text){
          lblErrorMsg = 'repeat_not_match'.tr();

        }else{
          nextBgColor = Color.fromRGBO(195, 50, 30, 1);
          nextFontColor = Colors.white;
          nextShadowColor = Colors.black.withOpacity(0.2);
          lineBorderColor = Color.fromRGBO(51, 51, 51, 0.5);
          lblErrorMsg = '';
        }

      });


    }else{
      setState(() {
        nextBgColor = isDarkMode ? whiteFontColor: whiteBGColor;
         nextFontColor = isDarkMode ? whiteBGColor:greyFontColor ;
        nextShadowColor = Colors.transparent;
        lineBorderColor = Color.fromRGBO(255, 0, 0, 1);
        lblErrorMsg = 'repeat_not_match'.tr();

      });

    }

  }


  void onTapLogin() {
    if (txtEnterPIN.text.isEmpty) {
      showToastView(
          'repeat_not_match'.tr());
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyTabBarView(),
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
