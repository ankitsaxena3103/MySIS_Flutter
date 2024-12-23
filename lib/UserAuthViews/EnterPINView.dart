import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/MyTabBarView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/UserAuthViews/SetPINView.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
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

  Color nextBgColor = isDarkMode ? greyColor5 : greyColor2;
  Color nextFontColor = isDarkMode ? greyColor7 : greyColor3;
  Color nextShadowColor = Colors.transparent;

  String lblErrorMsg = '';



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

                    Positioned(
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
                                    Container(
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
                                    OTPTextField(
                                      length: 4,
                                      width: pathL * 1.2,
                                      fieldWidth: pathS / 2.2,
                                      obscureText: true,

                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        color: isDarkMode ? whiteColor : greyColor6,
                                        fontSize: pathS / 5,
                                        fontFamily: 'Roboto',
                                      ),
                                      textFieldAlignment: MainAxisAlignment.spaceAround,
                                      fieldStyle: FieldStyle.underline,

                                      onChanged: (pin) {
                                        print(" Entered PIN : " + pin);
                                        txtEnterPIN.text = pin;
                                        onPINChange(pin);
                                      },
                                      onCompleted: (pin) {
                                        print("OTP completed: " + pin);

                                        // txtUserPIN.text = pin;
                                        // onUserIdChange(pin);
                                      },
                                    ),

                                    // OtpTextField(
                                    //   numberOfFields: 4,
                                    //   obscureText: true,
                                    //   keyboardType: TextInputType.number,
                                    //   borderColor: isDarkMode ? whiteColor : greyColor6,
                                    //   focusedBorderColor: Colors.blue,
                                    //   styles: PINTextStyle(
                                    //     isDarkMode ? whiteColor : greyColor6,
                                    //     4,
                                    //   ),
                                    //   showFieldAsBox: false,
                                    //   borderWidth: 2.0,
                                    //   fieldWidth: pathS/2.5,
                                    //   //runs when a code is typed in
                                    //   onCodeChanged: (String pin) {
                                    //
                                    //
                                    //   },
                                    //   //runs when every textfield is filled
                                    //   onSubmit: (String pin) {
                                    //     txtEnterPIN.text = pin;
                                    //     onUserIdChange(pin);
                                    //     print("OTP completed: " + pin);
                                    //
                                    //   },
                                    // ),
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
                            onTapNext();

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

  Future<void> onPINChange(String enteredPIN) async {

    String? currentPIN = await Preferences.getUserPreference(keyPIN);

    if(enteredPIN.length == 4){
      setState(() {
        if(currentPIN != enteredPIN){
          lblErrorMsg = 'repeat_not_match'.tr();
          return;

        }else{
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
        lblErrorMsg = 'repeat_not_match'.tr();

      });

    }

  }


  Future<void> onTapNext() async {
    if (txtEnterPIN.text.isEmpty || txtEnterPIN.text.length != 4) {
      showToastView('repeat_not_match'.tr());
      return;
    }

    String? currentPIN = await Preferences.getUserPreference(keyPIN);


      if(currentPIN != txtEnterPIN.text){
        showToastView('repeat_not_match'.tr());
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

   void onLoadNewPIN(){

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetPINView(),
        ),
    );
}



}
