import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/UserAuthViews/ConfirmPINView.dart';
import '../CommonViews/CustomNumericKeypad.dart';

class SetPINView extends StatefulWidget {
  final String mobile;
  final String regNo;
  final int calledValue;

  const SetPINView({
    super.key,
    required this.mobile,
    required this.regNo,
    required this.calledValue,

  });

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

  String lblheader =  'enter_new_pin'.tr();

  Color nextBgColor = isDarkMode ? greyColor5 : greyColor2;
  Color nextFontColor = isDarkMode ? greyColor7 : greyColor3;
  Color nextShadowColor = Colors.transparent;

  String lblErrorMsg = '';

  String lblCompany = 'Company';

  String lblUserIdHintMsg = 'enter_below_message_set_pin'.tr();
  String lblUserIdHintText = '';

  String btnNext = 'confirm'.tr();
  bool showKeypad = false;

  List<String> otpList = []; // List of 4 empty strings


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
              gradient: isDarkMode ? backgroundGradientDark :  backgroundGradient,

            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
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

                // Positioned(
                //   top: paddingTop,
                //   child: Container(
                //     width: logicalWidth,
                //     height: pathS/1.2,
                //     color: isDarkMode?whiteColor:Colors.transparent, // Set white background color here
                //     child: Padding(
                //       padding: EdgeInsets.only(top: 0, bottom: 0,left: pathS/5,right: pathS/5), // Adjust the padding values as needed
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Container(
                //             width: pathL,
                //             height: pathS / 1.5,
                //             decoration: const BoxDecoration(
                //               shape: BoxShape.rectangle,
                //               image: DecorationImage(
                //                 image: AssetImage("assets/images/icons/logo.png"),
                //                 fit: BoxFit.cover,
                //               ),
                //             ),
                //           ),
                //           Spacer(),
                //           Container(
                //             width: pathS / 1.45,
                //             height: pathS / 1.5,
                //             decoration: const BoxDecoration(
                //               shape: BoxShape.rectangle,
                //               image: DecorationImage(
                //                 image: AssetImage("assets/images/icons/icon.png"),
                //                 fit: BoxFit.cover,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth,
                    ),
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
                      lblheader,
                      style: TextStyle(
                        color: isDarkMode ?   whiteColor : greyColor6,
                        fontSize: pathS / 4,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
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
                        color: isDarkMode ? greyColor8: whiteColor,
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
                                      color: isDarkMode ?  whiteColor : greyColor6,

                                      fontSize: pathS / 6.5,
                                      fontWeight: FontWeight.w500,
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
                                              color: isDarkMode ? greyColorDark : greyColor5,
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
                    // SizedBox(height: pathS/5),
                    // Container(
                    //   width: screenWidth-4*marginValue,
                    //   child:Text(
                    //     lblErrorMsg,
                    //     style: TextStyle(
                    //       color: isDarkMode ? redColor1 : redColor3,
                    //       fontSize: pathS / 7,
                    //       fontWeight: FontWeight.normal,
                    //
                    //     ),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),

                    SizedBox(height: pathS),

                  ],
                ),

                Positioned(
                  bottom: paddingBottom+pathS/2,

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
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Roboto'
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

              ],
            ),
          ),
        ),
      ),
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
      else if (value >=0  && value < 10) {
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
    txtUserPIN.text = pin;
    onPinChange(pin);
  }


  void initialSetup() {}

  void onPinChange(String otp){

    if(otp.length == 4){
      setState(() {
         nextBgColor = isDarkMode ? redColor1 : redColor3;
         nextFontColor = isDarkMode ? whiteColor : whiteColor;
         nextShadowColor = shadowColor;
        lblErrorMsg = '';
      });

    }else{
      setState(() {
         nextBgColor = isDarkMode ? greyColor5 : greyColor2;
         nextFontColor = isDarkMode ? greyColor7 : greyColor3;
         nextShadowColor = Colors.transparent;
        lblErrorMsg = '';

      });

    }

  }


  void onTapNext() {
    if (txtUserPIN.text.isEmpty) {
      // showToastView("All fields are required");
      return;
    }

    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmPINView(
                userPIN:txtUserPIN.text,
              calledValue: widget.calledValue,
              pinEntered: txtUserPIN.text,
              mobile: widget.mobile,
              regNo: widget.regNo,
            ),
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
