import 'package:flutter/material.dart';
import 'package:mysis/SharedClasses/APIHelper.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/MyTabBarView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/PreAuthViews/OnboardingPaginationView.dart';
import 'package:easy_localization/easy_localization.dart';


class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  PrivacyPolicyViewState createState() => PrivacyPolicyViewState();
}

class PrivacyPolicyViewState extends State<PrivacyPolicyView> {
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


  String lblSignIn =   'Terms of Service & Policy';
  Color nextBgColor = Color.fromRGBO(195, 50, 53, 1);
  Color nextFontColor = Colors.white;
  Color nextShadowColor = Colors.black.withOpacity(0.2);

  Color lineBorderColor = Color.fromRGBO(255, 0, 0, 1);
  String lblErrorMsg = '* Enter 10 digit mobile number';

  String lblCompany = 'Company';

  String lblUserIdHintMsg = 'Enter Mobile / Registration N0.';
  String lblUserIdHintText = 'Eg. 9876543210 / PAT 561202';

  String btnNext = 'I AGREE';


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
                Column(
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
                    SizedBox(height: pathS / 3.5),
                    Text(
                      'term_and_conditions'.tr(),
                      style: TextStyle(
                        color: Color.fromRGBO(195, 50, 53, 1),
                        fontSize: pathS / 3,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: pathS / 10),
                   Container(
                     width: 2.5*pathL,
                     child:  Text(
                       'We understand the nature and sensitivity of your personal data and have taken strong measures to ensure that your data is not compromised.',
                       style: TextStyle(
                         color: Color.fromRGBO(0, 0, 0, 1),
                         fontSize: pathS / 5,
                         fontWeight: FontWeight.normal,
                         fontFamily: 'Roboto',
                       ),
                       textAlign: TextAlign.center,
                     ),
                   ),
                    SizedBox(height: pathS / 3.5),

                    Container(
                      width: screenWidth-2.5*marginValue,
                      height: pathL*2.8 ,
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
                            padding: EdgeInsets.only(left: pathS/3, top: pathS/3, right: pathS/3), // Adjust top and left as needed
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Device Location',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: pathS / 5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: pathS / 25),
                                  Text(
                                    'This app collects location data to enable alerts upon detecting violation of defined threshold from the required location even when the app is closed or not in use. It is recommended to allow your location sharing as ‘Allow all the time’.',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: pathS / 5.5,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.start,
                                  ),

                                  SizedBox(height: pathS / 5),

                                  Text(
                                    'SMS',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: pathS / 5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: pathS / 25),
                                  Text(
                                    'It is recommended to permit access of messages to MySIS.',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: pathS / 5.5,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.start,
                                  ),

                                  SizedBox(height: pathS / 5),

                                  Text(
                                    'Camera',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: pathS / 5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.center,

                                  ),
                                  SizedBox(height: pathS / 25),
                                  Text(
                                    'It is recommended to permit access of mobile device camera to MySIS.',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: pathS / 5.5,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.start,
                                  ),


                                  SizedBox(height: pathS / 5),

                                  Text(
                                    'Contacts',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: pathS / 5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: pathS / 25),
                                  Text(
                                    'It is recommended to permit access of your mobile device contact list to MySIS.',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: pathS / 5.5,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.start,
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                    ),

                  ],
                ),

                Positioned(
                  bottom: paddingBottom,

                  child: GestureDetector(
                    onTap: (){
                      onTapNext();

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
                          fontFamily: 'Roboto',
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

  void onTapNext() {


    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingPaginationView(),
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
