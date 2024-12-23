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
import 'package:provider/provider.dart';

class AlertView extends StatefulWidget {

  final String message;
  const AlertView({
    super.key,
    required this.message,
  });

  @override
  AlertViewState createState() => AlertViewState();
}

class AlertViewState extends State<AlertView> {

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
                                        widget.message,
                                        style: TextStyle(
                                          color: isDarkMode ? whiteColor:greyColor6,
                                          fontSize: pathS / 5,
                                          fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto'
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: pathS/2),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            // width: pathL,
                            height: pathS / 1.5,
                            alignment: Alignment.center,

                            child: Text(
                              'back'.tr(),
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

  }


}
