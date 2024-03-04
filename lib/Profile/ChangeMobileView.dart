
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Profile/ChangeMobileOTPView.dart';

import '../CommonViews/LoaderView.dart';
import '../CommonViews/ToastMessageView.dart';

class ChangeMobileView extends StatefulWidget {
  @override
  ChangeMobileViewState createState() => ChangeMobileViewState();
}

class ChangeMobileViewState extends State<ChangeMobileView>{

  TextEditingController txtCurrentMobile = TextEditingController(text: "9015235231");
  TextEditingController txtNewMobile = TextEditingController(text: "");
  TextEditingController txtConfirmMobile = TextEditingController(text: "");

  bool isAlertVisible = false;
  String alertHeader = 'Error!';
  String alertMessage = 'There is an  internal error.';

  bool showToastMessageView = false;
  String toastMessage = '';
  bool showLoaderView = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [

            SingleChildScrollView(
              child: Container(
                width: logicalWidth,
                height: logicalHeight,
                decoration:  BoxDecoration(
                  shape: BoxShape.rectangle,
                  gradient: isDarkMode ? backgroundGradientDark : backgroundGradient,
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
                                color: isDarkMode ?  whiteColor:greyColor6,

                              ),

                            ),
                            SizedBox(width: pathS/8),
                            Text(
                              'change_mobile_no'.tr(),
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

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: paddingTop+pathS),
                        Container(
                          width: screenWidth - 2* marginValue,
                          child: Text(
                            'your_registered_mobile_number'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor7,
                              fontSize: pathS / 6.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: pathS / 25),
                        Container(
                          width: screenWidth - 2 * marginValue,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(pathS / 8),
                            color: isDarkMode ? greyColor3 : whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.transparent, // Shadow color
                                blurRadius: pathS / 10, // Spread of the shadow
                                offset: Offset(-pathS / 12, pathS / 12),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: pathS / 4, top: pathS / 45, bottom: pathS / 45,right: pathS/5),
                            child: TextField(
                              onChanged: (value) {
                              },
                              controller: txtCurrentMobile,
                              enabled: false,
                              keyboardType: TextInputType.number,
                              decoration:  InputDecoration(
                                // hintText: '${'name'.tr()}*', // Placeholder text
                                contentPadding: EdgeInsets.fromLTRB(0, 0, 8, 0),

                                hintStyle: TextStyle(
                                  color: isDarkMode ? greyColor1 : greyColor3,
                                  fontSize: pathS/4,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: isDarkMode ? whiteColor : greyColor4,
                                fontSize: pathS/4,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: pathS/3),

                        Container(
                          width: screenWidth - 2* marginValue,
                          child: Text(
                            'enter_new_mobile_number'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor7,
                              fontSize: pathS / 6.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: pathS / 25),
                        Container(
                          width: screenWidth - 2 * marginValue,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(pathS / 8),
                            color: isDarkMode ? greyColor3 : whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                blurRadius: pathS / 10, // Spread of the shadow
                                offset: Offset(-pathS / 12, pathS / 12),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: pathS / 4, top: pathS / 45, bottom: pathS / 45,right: pathS/5),
                            child: TextField(
                              onChanged: (value) {
                              },
                              controller: txtNewMobile,
                              keyboardType: TextInputType.number,
                              decoration:  InputDecoration(
                                // hintText: '${'name'.tr()}*', // Placeholder text
                                contentPadding: EdgeInsets.fromLTRB(0, 0, 8, 0),

                                hintStyle: TextStyle(
                                  color: isDarkMode ? greyColor1 : greyColor3,
                                  fontSize: pathS/4,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: isDarkMode ? whiteColor : greyColor6,
                                fontSize: pathS/4,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: pathS/3),

                        Container(
                          width: screenWidth - 2* marginValue,
                          child: Text(
                            'repeat_new_mobile_number'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor7,
                              fontSize: pathS / 6.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: pathS / 25),
                        Container(
                          width: screenWidth - 2 * marginValue,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(pathS / 8),
                            color: isDarkMode ? greyColor3 : whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                blurRadius: pathS / 10, // Spread of the shadow
                                offset: Offset(-pathS / 12, pathS / 12),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: pathS / 4, top: pathS / 45, bottom: pathS / 45,right: pathS/5),
                            child: TextField(
                              onChanged: (value) {
                              },
                              controller: txtConfirmMobile,
                              keyboardType: TextInputType.number,
                              decoration:  InputDecoration(
                                // hintText: '${'name'.tr()}*', // Placeholder text
                                contentPadding: EdgeInsets.fromLTRB(0, 0, 8, 0),

                                hintStyle: TextStyle(
                                  color: isDarkMode ? greyColor1 : greyColor3,
                                  fontSize: pathS/4,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: isDarkMode ? whiteColor : greyColor6,
                                fontSize: pathS/4,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: pathL ),



                      ],
                    ),


                    Positioned(
                      bottom: paddingBottom+pathS/12,
                        child:  GestureDetector(
                          onTap: (){
                            onLoadOTP();
                          },
                          child: Container(
                            width: pathL*1.5,
                            height: pathS / 1.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isDarkMode ? redColor1 : redColor3,
                              // border: Border.all(color: Colors.yellow, width: pathS/18),
                              borderRadius: BorderRadius.circular(pathS/3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1), // Shadow color
                                  blurRadius: pathS/10, // Spread of the shadow
                                  // spreadRadius: pathS/15, // How far the shadow extends
                                  offset:  Offset(-pathS/12, pathS/12),
                                ),
                              ],
                            ),
                            child: Text(
                              'raise_request'.tr(),
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: pathS / 4.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                    ),
                    LoaderView(isVisible: showLoaderView, message: 'Loading...'),

                    ToastMessageView(isVisible: showToastMessageView, message: toastMessage),

                  ],
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }

  void onLoadOTP() {

    if(txtNewMobile.text.length != 10){
      showToastView('enter_10_digit_number'.tr());
      return;
    }

    if(txtNewMobile.text != txtConfirmMobile.text){
      showToastView('Repeat_mobile_number_In_Valid'.tr());
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) =>   ChangeMobileOTPView(
          mobileNo:txtNewMobile.text,
         ),
       ),
      ).then((val) {
          if (val) {
            Navigator.pop(context);
          }
    });


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
