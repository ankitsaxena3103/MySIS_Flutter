import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/MyTabBarView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';

class LeaveAppliedView extends StatefulWidget {
  final  int leaveDays ;
  final List<DateTime> appliedLeave;
  final reason;
  const LeaveAppliedView({
    super.key, required this.leaveDays, required this.appliedLeave, this.reason,
  });

  @override
  LeaveAppliedViewState createState() => LeaveAppliedViewState();
}

class LeaveAppliedViewState extends State<LeaveAppliedView> {
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

  Color nextBgColor = isDarkMode ? whiteColor: greyColor2;
  Color nextFontColor = isDarkMode ? greyColor1:greyColor3 ;
  Color nextShadowColor = Colors.transparent;

  String lblErrorMsg = 'repeat_not_match'.tr();

  List<String> reasonItems = ['family_emergency_txt'.tr(), 'other_reason_txt'.tr(), 'sick_txt'.tr(),'weekly_off'.tr()];
  int selectedIndex = 0;

  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Material(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                width: logicalWidth,
                height: logicalHeight,
                alignment: Alignment.center,
                color: greyColor6,

                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    Positioned(
                      top: MediaQuery.of(context).padding.top+pathS/12,
                      right: paddingRight +pathS/3,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Container(
                              width: pathS/3,
                              height: pathS/3,
                              child: Image.asset(
                                'assets/images/home/cross.png',
                                color: isDarkMode ?  whiteColor:whiteColor,

                              ),

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
                        ),//fake container for width only


                        Container(
                          width: screenWidth-2.5*marginValue,
                          // height: pathL,
                          decoration:  BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(pathS/8),
                            color: isDarkMode?greyColor7:whiteColor,
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
                                child: Padding(
                                  padding:  EdgeInsets.only(top: pathS/3,bottom: pathS/3),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [

                                      Container(
                                        width: pathS/1.2,
                                        height: pathS/1.2,
                                        child: Image.asset(
                                          'assets/images/dashboard-icons/tick.png',

                                        ),
                                      ),
                                      SizedBox(height: pathS/8),

                                      Text(
                                        '${widget.leaveDays}'  " "+ 'days'.tr(),
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /5,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                         'leave_request_raised_successfully'.tr(),
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /6.5,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(height: pathS/1.5),
                                      Text(
                                        'leave_for'.tr(),
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /6.5,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(height: pathS/8),
                                      Text(
                                        widget.reason,
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /5,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),



                                      SizedBox(height: pathS/1.5),
                                      Text(
                                        widget.leaveDays == 1 ? '${getDateTime(widget.appliedLeave.first)}' :
                                        '${getDateTime(widget.appliedLeave.first)} - ${getDateTime(widget.appliedLeave.last)}',
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /3,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(height: pathS/3),
                                      GestureDetector(
                                        onTap: (){


                                        },
                                        child: Container(
                                          width: pathL,
                                          height: pathS / 1.5,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color:  isDarkMode ? redColor3:redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                                            borderRadius: BorderRadius.circular(pathS/3),
                                            boxShadow: [
                                              BoxShadow(
                                                color:  shadowColor,
                                                blurRadius: pathS/10, // Spread of the shadow
                                                // spreadRadius: pathS/15, // How far the shadow extends
                                                offset:  Offset(-pathS/12, pathS/12),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            'done'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:whiteColor,
                                              fontSize: pathS / 4.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
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

  String getDateTime(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }
  Future<void> onUserIdChange(String enteredPIN) async {

    String? currentPIN = await Preferences.getUserPreference(keyPIN);

    if(enteredPIN.length == 4){
      setState(() {
        if(currentPIN != enteredPIN){
          lblErrorMsg = 'repeat_not_match'.tr();
          return;

        }else{
          nextBgColor = redColor3;
          nextFontColor = Colors.white;
          nextShadowColor = shadowColor;
          lblErrorMsg = '';
        }

      });


    }
    else{
      setState(() {
        nextBgColor = isDarkMode ? whiteColor: greyColor2;
        nextFontColor = isDarkMode ? greyColor1:greyColor3 ;
        nextShadowColor = Colors.transparent;
        lblErrorMsg = 'repeat_not_match'.tr();

      });

    }

  }
  Future<void> onTapLogin() async {
    if (txtEnterPIN.text.isEmpty || txtEnterPIN.text.length != 4) {
      showToastView('repeat_not_match'.tr());
      return;
    }

    String? currentPIN = await Preferences.getUserPreference(keyPIN);


    if(currentPIN != txtEnterPIN.text){
      showToastView('repeat_not_match'.tr());
      return;

    }



    Navigator.pushReplacement(
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



class RadioButton extends StatelessWidget {
  final int id;
  final Function(int) callback;
  final int selectedID;
  late double controlSize;
  final Color color;
  final double textSize;
  final String name;

  RadioButton({
    required this.id,
    required this.callback,
    required this.selectedID,
    this.controlSize = 28,
    this.color = Colors.white,
    this.textSize = 14,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final size = pathS/5;
    controlSize = pathS/3;

    return Padding(
      padding: EdgeInsets.only(bottom: pathS/8),
      child: GestureDetector(
        onTap: () {
          callback(id);
        },
        child: Row(

          children: [

            Icon(
              selectedID == id ? Icons.radio_button_checked : Icons.radio_button_off,
              size: controlSize,
              color: isDarkMode ? whiteColor:greyColor3,
            ),
            SizedBox(width: pathS/8),
            Container(
              height: pathS/3,
              child: Text(
                name,
                style: TextStyle(
                  color: isDarkMode ? whiteColor:greyColor6,
                  fontSize: size,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}

class RadioButtonGroup extends StatelessWidget {
  final List<String> items;
  final int selectedId;
  final Function(int) callback;

  RadioButtonGroup({
    required this.items,
    required this.selectedId,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final name = entry.value;

        return RadioButton(
          id: index,
          callback: radioGroupCallback,
          selectedID: selectedId,
          name: name,
        );
      }).toList(),
    );
  }

  void radioGroupCallback(int id) {
    callback(id);
  }
}