import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/MyTabBarView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/UserAuthViews/SetPINView.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:mysis/SharedClasses/Point.dart';


class DutyAlertView extends StatefulWidget {


  final dutyTime;
  final shift;
  final place;
  final location;

  const DutyAlertView({
    super.key,
    this.dutyTime, this.shift, this.place, this.location,
  });

  @override
  DutyAlertViewState createState() => DutyAlertViewState();
}

class DutyAlertViewState extends State<DutyAlertView> with TickerProviderStateMixin {

  TextEditingController txtEnterPIN= TextEditingController(text: "");

  bool showPassword = false;
  bool rememberMe = false;
  bool showLoaderView = false;

  bool isAlertVisible = false;
  String alertHeader = 'Error!';
  String alertMessage = 'There is an  internal error.';

  bool showToastMessageView = false;
  String toastMessage = '';

  Color redColor = isDarkMode ? redColor1 : redColor3;


  String lblErrorMsg = '';


  int playerButtonAnimationSpeed = 250;

  late AnimationController btnAnimationController;

  late Animation<double> scalingBtnAnimation;

  late AnimationController animationController;
  late Animation<double> animation;
  late Animation<double> animation2;

  double animationValue = 1.25;
  double animationValue2 = 1.45;


  @override
  void initState() {
    btnAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..repeat(reverse: false);

    scalingBtnAnimation = Tween<double>(begin: 1.0, end: 1).animate(CurvedAnimation(
      parent: btnAnimationController,
      curve: Curves.easeInOut,
    ),);


    animationController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      reverseDuration: const Duration(milliseconds: 1600),
      vsync: this,
    )
      ..repeat(reverse: true);

    animation = Tween<double>(begin: 1.0, end: animationValue).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
    animation2= Tween<double>(begin: 1.0, end: animationValue2).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
    initialSetup();
    super.initState();
  }
  @override
  void dispose() {
    btnAnimationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('mm:ss');
    String time1 =  DateFormat('hh:mm a').format(DateTime.now());
    String time2 =  DateFormat('hh:mm a').format(widget.dutyTime);
// Format the DateTime object as a time string
    String formattedTime = dateFormat.format(widget.dutyTime);
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
                      top: MediaQuery.of(context).padding.top+pathS/12,
                      right: paddingRight+pathS/3,
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
                                color: isDarkMode ?  whiteColor:greyColor6,

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
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,

                          ),
                        ),//fake container for width only
                        Container(
                          width: pathS,
                          height: pathS,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: AssetImage("assets/images/icons/SIS-App-icon.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: pathS / 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('hh:mm',selectedLocale).format(DateTime.now()),
                              style: TextStyle(
                                  color: redColor,
                                  fontSize: pathS/1.2 ,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto'
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(width: pathS/8),

                            Text(
                              DateFormat('a',selectedLocale).format(DateTime.now()),
                              style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS/5 ,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto'
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(width: pathS/5),
                        Text(
                         '${getDiffrenceInMinutes(time1, time2)} ' + 'duty_time_left'.tr(),
                          style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor6,
                              fontSize: pathS/5 ,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto'
                          ),
                          textAlign: TextAlign.center,
                        ),


                        SizedBox(height: pathS),
                        Container(

                          decoration: BoxDecoration(
                            color: isDarkMode ?  yellowColor2:yellowColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(pathS/20),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor, // Shadow color
                                blurRadius: pathS/25, // Spread of the shadow
                                // spreadRadius: pathS/15, // How far the shadow extends
                                offset:  Offset(-pathS/75, pathS/75),
                              ),
                            ],
                          ),

                          child: Padding(
                            padding:  EdgeInsets.only(left: pathS/5,right: pathS/5,top: pathS/24,bottom: pathS/24),
                            child: Text(
                              widget.shift,
                              style: TextStyle(
                                  color: isDarkMode ? greyColor8 : greyColor6,
                                  fontSize: pathS/5 ,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto'
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        SizedBox(height: pathS/5),
                        Text(
                          widget.place,
                          style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor6,
                              fontSize: pathS/4 ,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto'
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: pathS/25),
                        Text(
                          widget.location,
                          style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor6,
                              fontSize: pathS/5 ,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto'
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: pathS),
                        Text(
                          DateFormat('hh:mm a',selectedLocale).format(widget.dutyTime),
                          style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor6,
                              fontSize: pathS/3,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto'
                          ),
                          textAlign: TextAlign.center,
                        ),


                      ],
                    ),

                    Positioned(
                      bottom: MediaQuery.of(context).padding.bottom+pathS/12,
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: animationController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: animation2.value,
                                  child: child,
                                );
                              },
                              child:Container(

                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: isDarkMode ? Colors.white.withOpacity(0.15):Colors.black54.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(pathS/3),

                                ),
                                child: Padding(
                                  padding:  EdgeInsets.only(left: pathS/3,right: pathS/3,top: pathS/6,bottom: pathS/6,),
                                  child: Text(
                                    'duty_in'.tr(),
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: pathS / 4.5,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedBuilder(
                              animation: animationController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: animation.value,
                                  child: child,
                                );
                              },
                              child:Container(

                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: isDarkMode ? Colors.white.withOpacity(0.15):Colors.black54.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(pathS/3),

                                ),
                                child: Padding(
                                  padding:  EdgeInsets.only(left: pathS/3,right: pathS/3,top: pathS/8,bottom: pathS/8),
                                  child: Text(
                                    'duty_in'.tr(),
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: pathS / 4.5,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(

                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: redColor,
                                borderRadius: BorderRadius.circular(pathS/3),
                              ),
                              child: Padding(
                                padding:  EdgeInsets.only(left: pathS/3,right: pathS/3,top: pathS/12,bottom: pathS/12),
                                child: Text(
                                  'duty_in'.tr(),
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: pathS / 4.5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ),

                          ],
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




  void initialSetup() {

    String time1 =  DateFormat('hh:mm a').format(widget.dutyTime);
    String time2 =  DateFormat('hh:mm a').format(DateTime.now());

    if(getDiffrenceInSeconds(time1, time2) < 1800){
      redColor =  redColor2;
    }else{
      redColor =  isDarkMode ? redColor1: redColor3;
    }

  }



  Future<void> onTapLogin() async {
    if (txtEnterPIN.text.isEmpty || txtEnterPIN.text.length != 4) {
      showToastView('repeat_not_match'.tr());
      return;
    }

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
