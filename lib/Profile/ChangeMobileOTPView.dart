import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/SuccessAlertView.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../CommonViews/AlertPopupView.dart';
import '../CommonViews/CustomNumericKeypad.dart';
import '../MyTabBarView.dart';
import '../SharedClasses/APIHelper.dart';

class ChangeMobileOTPView extends StatefulWidget {
  final String mobileNo;
  final String otp;
  const ChangeMobileOTPView({
    super.key,
    required this.mobileNo, required this.otp
  });

  @override
  ChangeMobileOTPViewState createState() => ChangeMobileOTPViewState();
}

class ChangeMobileOTPViewState extends State<ChangeMobileOTPView> {

  late String otp;
  TextEditingController txtUserOTP= TextEditingController(text: "");
  TextEditingController txtNewMobile = TextEditingController(text: "");
  bool showPassword = false;
  bool rememberMe = false;
  bool showLoaderView = false;

  bool isAlertVisible = false;


  bool showToastMessageView = false;
  String toastMessage = '';

  String lblOTPVerification =  'otp_verification'.tr();

  Color nextBgColor = isDarkMode ? greyColor5 : greyColor2;
  Color nextFontColor = isDarkMode ? greyColor7 : greyColor3;
  Color nextShadowColor = Colors.transparent;

  String lblErrorMsg = 'txt_incorrect_otp'.tr();

  String lblCompany = 'company'.tr();

  String lblUserIdHintMsg = 'enter_otp_msg'.tr();
  String lblUserIdHintText = '';

  String btnNext = 'next'.tr();

  bool showKeypad = false;
  List<String> otpList = []; // List of 4 empty strings
  Color otpContainerColor = isDarkMode ? greyColorDark : greyColor5;

  bool showAlert = false;
  String alertHeader = '';
  String alertMessage = '';

  @override
  void initState() {
    txtNewMobile.text = widget.mobileNo;
    otp = widget.otp;
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);

    return Material(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: logicalWidth,
            height: logicalHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient:  isDarkMode ? backgroundGradientDark : backgroundGradient,
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
                      Navigator.pop(context,false);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth,
                    ),

                    Container(
                      width: screenWidth - 2.5* marginValue,
                      child: Text(
                        'new_number_to_be_changed'.tr(),
                        style: TextStyle(
                          color: isDarkMode ? whiteColor : greyColor6,
                          fontSize: pathS / 6.5,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: pathS / 25),
                    Container(
                      width: screenWidth - 2.5 * marginValue,
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
                          controller: txtNewMobile,
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

                    SizedBox(height: pathS / 2),
                    Container(
                      width: screenWidth-2.5*marginValue,
                      height: pathL*1.2,
                      decoration:  BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(pathS/8),
                        color:  isDarkMode ? greyColor3 : whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor, // Shadow color
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
                                Text(
                                  lblOTPVerification,
                                  style: TextStyle(
                                    color: isDarkMode ?  whiteColor:greyColor6,
                                    fontSize: pathS / 4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: pathS/5),
                                Container(
                                  width: screenWidth - 5*marginValue,
                                  child: Text(
                                    lblUserIdHintMsg,
                                    style: TextStyle(
                                      color: isDarkMode ?  whiteColor:greyColor6,
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
                                              color: otpContainerColor,
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
                    SizedBox(height: pathS/5),
                    Container(
                      width: screenWidth-4*marginValue,
                      child:Text(
                        lblErrorMsg,
                        style: TextStyle(
                          color: isDarkMode ?  redColor1:redColor3,
                          fontSize: pathS / 6.5,
                          fontWeight: FontWeight.w500,

                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: pathL),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                        onTap: (){
                            Navigator.pop(context,false);
                          },
                          child: Container(
                            width: pathL,
                            height: pathS / 1.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isDarkMode ?  greyColor3:whiteColor,
                              // border: Border.all(color: Colors.yellow, width: pathS/18),
                              borderRadius: BorderRadius.circular(pathS/3),
                              border: Border.all(
                                  color: isDarkMode ?  redColor1:redColor3,
                                  width:1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.transparent, // Shadow color
                                  blurRadius: pathS/10, // Spread of the shadow
                                  // spreadRadius: pathS/15, // How far the shadow extends
                                  offset:  Offset(-pathS/12, pathS/12),
                                ),
                              ],
                            ),
                            child: Text(
                              'back'.tr(),
                              style: TextStyle(
                                color: isDarkMode ?  redColor1:redColor3,
                                fontSize: pathS / 4.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: pathS/3),
                        GestureDetector(
                          onTap: (){
                            onTapConfirm();

                          },
                          child: Container(
                            width: pathL,
                            height: pathS / 1.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: nextBgColor,
                              // border: Border.all(color: Colors.yellow, width: pathS/18),
                              borderRadius: BorderRadius.circular(pathS/3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.transparent, // Shadow color
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
                      ],
                    ),

                  ],
                ),



                LoaderView(isVisible: showLoaderView, message: ''),
                Visibility(
                  visible: isAlertVisible,
                  child: SuccessAlertView(callBack: (int ) {

                    setState(() {
                      isAlertVisible = false;
                    });
                    Navigator.pop(context,true);

                  }, message: 'your_request_sent_successfully'.tr(),

                  ),
                ),
                ToastMessageView(isVisible: showToastMessageView, message: toastMessage),
                Visibility(
                  visible: showAlert,
                  child: AlertPopupView(
                    header: alertHeader,
                    message: alertMessage,
                    cancelBtn: 'ok'.tr(),
                    okBtn: '',
                    callBack:(val){
                      setState(() {
                        showAlert = false;
                      });
                      onMobileNumberChanged();
                    },
                  ),
                ),
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

  void initialSetup() {}

  void onUserIdChange(String otpEntered){

    if(otpEntered.length == 4 && otpEntered == otp ){
      setState(() {

        nextBgColor = isDarkMode ? redColor1 : redColor3;
        nextFontColor = isDarkMode ? whiteColor : whiteColor;
        nextShadowColor = shadowColor;

        lblErrorMsg = '';
      });


    }else{
      setState(() {
        nextBgColor = isDarkMode ? greyColor8 : greyColor2;
        nextFontColor = isDarkMode ? greyColor7 : greyColor3;
        nextShadowColor = Colors.transparent;

        lblErrorMsg = 'txt_incorrect_otp'.tr();

      });

    }

  }

  void updateOTPList(int value) {

    setState(() {
      if (value == 10) {
        // Handle delete action
        if (otpList.isNotEmpty) {
          otpList.removeLast();
        }
      }
      else if (value >= 0 && value < 10) {
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
    txtUserOTP.text = pin;
    onUserIdChange(pin);
  }


  void onTapConfirm() {
    if (txtUserOTP.text.isEmpty || txtUserOTP.text != otp) {
      showToastView("valid_OTP".tr());
      return;
    }

    changeMobileApiCall();
  }

  Future<void> changeMobileApiCall() async {
    setState(() {
      showLoaderView = true;
    });

    Map <String,String> inputData = {
      "Phone": widget.mobileNo
    };

    APIHelper.instance.patchData(updateProfileApi, inputData, (responseData) {
      if (responseData.isNotEmpty) {
        // Parse the response list directly
        Map<String, dynamic> data = responseData.first as Map<String, dynamic>;

        final String message = data['Message'] ?? '';

        setState(() {
          alertHeader = '';
          alertMessage =message.isNotEmpty ? message: 'request_sent_successfully'.tr();
          showAlert = true;
        });



      }
      else {
        // Handle empty response
        printInDebug('Response data is empty.');
      }


      setState(() {showLoaderView = false;});

    },
          (error) {
        // Handle error
        setState(() {
          showLoaderView = false;
        });
        printInDebug('Error: $error');
      },
    );
  }

  void onMobileNumberChanged(){

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MyTabBarView(),
      ),
          (route) => false, // This removes all previous routes
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
