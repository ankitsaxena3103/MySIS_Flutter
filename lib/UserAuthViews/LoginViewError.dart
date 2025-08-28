import 'package:flutter/material.dart';
import 'package:mysis/SharedClasses/APIHelper.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/MyTabBarView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';

class LoginViewError extends StatefulWidget {
  const LoginViewError({super.key});

  @override
  LoginViewErrorState createState() => LoginViewErrorState();
}

class LoginViewErrorState extends State<LoginViewError> {
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
  
  Color backBgColor = Colors.transparent;
  Color backFontColor = Color.fromRGBO(195, 50, 30, 1);
  Color backShadowColor = Colors.transparent;
  String btnBack = 'Back';

  String lblErrorHeader = 'Invalid Account';
  String lblErrorMsg = 'Invalid User, Please contact to admin.';



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
                    SizedBox(height: pathS / 2),

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
                          Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                lblErrorHeader,
                                style: TextStyle(
                                  color: Color.fromRGBO(51, 51, 51, 0.7),
                                  fontSize: pathS / 4,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // SizedBox(height: pathS / 12),

                              SizedBox(height: pathS / 4),
                              Text(
                                lblErrorMsg,
                                style: TextStyle(
                                  color: Color.fromRGBO(51, 51, 51, 0.7),
                                  fontSize: pathS / 6.5,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: pathS/1.2),

                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: pathL,
                        height: pathS / 1.5,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: backBgColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                          borderRadius: BorderRadius.circular(pathS/3),
                          boxShadow: [
                            BoxShadow(
                              color: backShadowColor, // Shadow color
                              blurRadius: pathS/10, // Spread of the shadow
                              // spreadRadius: pathS/15, // How far the shadow extends
                              offset:  Offset(-pathS/12, pathS/12),
                            ),
                          ],
                        ),
                        child: Text(
                          btnBack,
                          style: TextStyle(
                            color: backFontColor,
                            fontSize: pathS / 4.5,
                            fontWeight: FontWeight.bold,
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
  }

  void initialSetup() {}



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
