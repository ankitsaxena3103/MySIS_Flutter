import 'package:flutter/material.dart';
import 'package:mysis/SharedClasses/APIHelper.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/MyTabBarView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/UserAuthViews/ConfirmPINView.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class SetPINView extends StatefulWidget {
  const SetPINView({super.key});

  @override
  SetPINViewState createState() => SetPINViewState();
}

class SetPINViewState extends State<SetPINView> {
  TextEditingController txtUserPIN= TextEditingController(text: "");

  bool showPassword = false;
  bool rememberMe = false;
  bool showLoaderView = false;

  bool isAlertVisible = false;
  String alertHeader = 'Error!';
  String alertMessage = 'There is an  internal error.';

  bool showToastMessageView = false;
  String toastMessage = '';

  String lblOTPVerification =  'Set PIN';

  Color nextBgColor = Color.fromRGBO(51, 51, 51, 0.2);
  Color nextFontColor = Color.fromRGBO(51, 51, 51, 0.6);
  Color nextShadowColor = Colors.transparent;

  Color lineBorderColor = Color.fromRGBO(255, 0, 0, 1);
  String lblErrorMsg = '';

  String lblCompany = 'Company';

  String lblUserIdHintMsg = 'Set 4 digit PIN for your MySIS security';
  String lblUserIdHintText = '';

  String btnNext = 'Next';


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
              gradient: backgroundGradient,
              // border: Border.all(color: Colors.lightBlue.shade300, width: pathS/18),
              // borderRadius: BorderRadius.circular(pathS/15),
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
                      image: AssetImage("assets/images/icons/icon@3x.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ),
                Positioned(
                  top: paddingTop+pathS/8,
                  left: 0,

                  child: Container(
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
                    SizedBox(height: pathS / 2),
                    Text(
                      lblOTPVerification,
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
                                            image: AssetImage("assets/images/icons/icon@3x.png"),
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
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                      fontSize: pathS/3.5,

                                  ),
                                  textFieldAlignment: MainAxisAlignment.spaceAround,
                                  fieldStyle: FieldStyle.underline,
                                    onChanged:(pin){
                                      print("OTP Entered: " + pin);
                                      txtUserPIN.text = pin;
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
        lblErrorMsg = '* Incorrect OTP';

      });

    }

  }


  void onTapLogin() {
    if (txtUserPIN.text.isEmpty) {
      // showToastView("All fields are required");
      return;
    }

    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmPINView(userPIN:txtUserPIN.text),
          ),
        );

    // setState(() {
    //   showLoaderView = true;
    // });
    // Map<String, dynamic> data = {"email": txtUserId.text, "password": txtPassword.text};

    // APIHelper.instance.postData(authenticateApi, data, (userData) {
    //   setState(() {
    //     showLoaderView = false;
    //   });
    //   if (userData.isNotEmpty) {
    //     token = userData['jwtToken'] ?? '';
    //     userName = userData['agentName'] ?? 'Agent';
    //     userId = userData['id'] ?? 0;
    //     Preferences.saveUserPreference(keyUserToken, token);
    //     Preferences.saveUserPreference(keyUserName, userName);
    //     Preferences.saveUserPreference(keyUserID, '$userId');
    //
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => HomeScreen(),
    //       ),
    //     );
    //   }
    // }, (error) {
    //   setState(() {
    //     showLoaderView = false;
    //   });
    //   setState(() {
    //     isAlertVisible = true;
    //     alertMessage = '$error';
    //   });
    // });
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
