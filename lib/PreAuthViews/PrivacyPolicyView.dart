import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
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


  Color nextBgColor = Color.fromRGBO(195, 50, 53, 1);
  Color nextFontColor = Colors.white;
  Color nextShadowColor = Colors.black.withOpacity(0.2);

  Color lineBorderColor = Color.fromRGBO(255, 0, 0, 1);
  String lblErrorMsg = '* Enter 10 digit mobile number';

  String lblCompany = 'Company';

  String lblUserIdHintMsg = 'Enter Mobile / Registration N0.';
  String lblUserIdHintText = 'Eg. 9876543210 / PAT 561202';

  String btnNext = 'i_agree'.tr();


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
                  top: MediaQuery.of(context).padding.top+pathS/12,
                  left: paddingLeft +pathS/3,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Container(
                          width: pathS/5,
                          height: pathS/2,
                          child: Image.asset(
                            'assets/images/dashboard-icons/left-arrow.png',
                            color: isDarkMode ?  redColor1:redColor3,

                          ),

                        ),
                        SizedBox(width: pathS/8),
                        Text(
                          '            ',
                          style: TextStyle(
                            color: isDarkMode ?  whiteColor:greyColor6,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.center,
                        ),

                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [

                    Container(
                      height: screenHeight-pathS*1.7,
                      child: SingleChildScrollView(
                        child: Column(
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
                            SizedBox(height: pathS / 2),
                            Text(
                              'term_and_conditions'.tr(),
                              style: TextStyle(
                                color: Color.fromRGBO(195, 50, 53, 1),
                                fontSize: pathS / 3.2,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: pathS / 10),
                            Container(
                              width: 2.3*pathL,
                              child:  Text(
                                'term_cond_content'.tr(),
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: pathS / 5.5,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: pathS / 3.5),

                            Container(
                              width: screenWidth-2*marginValue,
                              // height: pathL*2.8 ,
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
                                    padding: EdgeInsets.only(left: pathS/3, top: pathS/4, right: pathS/3,bottom: pathS/4), // Adjust top and left as needed
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'device_location'.tr(),
                                            style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: pathS / 5.5,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: pathS / 25),
                                          Text(
                                            'device_location_content'.tr(),
                                            style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: pathS / 5.8,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.start,
                                          ),

                                          SizedBox(height: pathS / 5),

                                          Text(
                                            'sms'.tr(),
                                            style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: pathS / 5.5,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: pathS / 25),
                                          Text(
                                            'sms_content'.tr(),
                                            style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: pathS / 5.8,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.start,
                                          ),

                                          SizedBox(height: pathS / 5),

                                          Text(
                                            'camera'.tr(),
                                            style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: pathS / 5.5,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,

                                          ),
                                          SizedBox(height: pathS / 25),
                                          Text(
                                            'camera_content'.tr(),
                                            style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: pathS / 5.8,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.start,
                                          ),


                                          SizedBox(height: pathS / 5),

                                          Text(
                                            'contacts'.tr(),
                                            style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: pathS / 5.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: pathS / 25),
                                          Text(
                                            'contact_content'.tr(),
                                            style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: pathS / 5.8,
                                              fontWeight: FontWeight.w500,
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
                      ),
                    ),
                  ],
                ),


                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      bottom: paddingBottom +pathS/5,
                      child: GestureDetector(
                        onTap: () {
                          onTapNext();
                        },
                        child: Container(
                          width: pathL,
                          height: pathS / 1.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: nextBgColor,
                            borderRadius: BorderRadius.circular(pathS / 3),
                            boxShadow: [
                              BoxShadow(
                                color: nextShadowColor,
                                blurRadius: pathS / 10,
                                offset: Offset(-pathS / 12, pathS / 12),
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
                  ],
                ),

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
