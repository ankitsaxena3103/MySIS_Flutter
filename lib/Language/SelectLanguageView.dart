import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/PreAuthViews/PrivacyPolicyView.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/SharedClasses/LanguageProvider.dart';
import 'package:provider/provider.dart';

import '../SharedClasses/ThemeProvider.dart';


class SelectLanguageView extends StatefulWidget {
  final bool isFirstScreen;
  const SelectLanguageView({
    super.key,
    required this.isFirstScreen,
  });

  @override
  SelectLanguageViewState createState() => SelectLanguageViewState();
}

class SelectLanguageViewState extends State<SelectLanguageView> {

  bool showLoaderView = false;

  bool isAlertVisible = false;
  String alertHeader = 'Error!';
  String alertMessage = 'There is an  internal error.';

  bool showToastMessageView = false;
  String toastMessage = '';

  Color nextBgColor = Colors.white;
  Color nextFontColor = redColor3;

  Color nextShadowColor = Colors.transparent;

  final List<String> languages = [
    'English',
    'Hindi',
    'Kannada',
    'Telugu',
    'Tamil',
    'Marathi',
  ];

  var backgroundGradient =  LinearGradient(
    colors: [Colors.white, Color.fromRGBO(217, 217, 217, 1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );


  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    double gap = pathS/12;
    return Consumer2<LanguageProvider, ThemeProvider>(
      builder: (context, languageProvider, themeProvider, child) {
         return Material(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                width: logicalWidth,
                height: logicalHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: isDarkMode? backgroundGradientDark : backgroundGradient,
                  // border: Border.all(color: Colors.lightBlue.shade300, width: pathS/18),
                  // borderRadius: BorderRadius.circular(pathS/15),
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).padding.top+pathS/12,
                      left: paddingLeft +pathS/3,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Visibility(
                          visible: !widget.isFirstScreen,
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
                                'language'.tr(),
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
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: screenWidth,
                          height: paddingTop+pathS,

                        ),

                        Text(
                          'Select_language'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor:greyColor6,
                            fontSize: pathS / 4,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto'
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: gap*5),
                        buildLanguageItem('English','en','US'),
                        SizedBox(height: gap),
                        buildLanguageItem('हिन्दी','hi','IN'),
                        SizedBox(height: gap),
                        buildLanguageItem('ಕನ್ನಡ','kn','IN'),
                        SizedBox(height: gap),
                        buildLanguageItem('తెలుగు','te','IN'),
                        SizedBox(height: gap),
                        buildLanguageItem('தமிழ்','ta','IN'),
                        SizedBox(height: gap),
                        buildLanguageItem('मराठी','mr','IN'),

                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: screenWidth,
                        height: pathS / 1.5,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDarkMode ? greyColor6:whiteColor,
                        ),

                      ),
                    ),
                    Positioned(
                      bottom: paddingBottom,

                      child: GestureDetector(
                        onTap: (){
                          onTapNext();

                        },
                        child: Container(
                          width: screenWidth,
                          height: pathS / 1.4,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDarkMode ? greyColor6:whiteColor,
                            // border: Border.all(color: Colors.yellow, width: pathS/18),
                            // borderRadius: BorderRadius.circular(pathS/3),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor, // Shadow color
                                blurRadius: pathS/15, // Spread of the shadow
                                // spreadRadius: pathS/15, // How far the shadow extends
                                offset:  Offset(-1, -pathS/15),
                              ),
                            ],
                          ),
                          child: Text(
                            'confirm'.tr().toUpperCase(),
                            style: TextStyle(
                              color: isDarkMode ? redColor1:redColor3,
                              fontSize: pathS / 5,
                              fontWeight: FontWeight.w700,
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

  }


  Widget buildLanguageItem(String language, String langugeCode, String countryCode) {
    return Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
      return GestureDetector(
        onTap: () {
          print('Selected language: $language');
          context.setLocale(Locale(langugeCode, countryCode));

          languageProvider.setLanguage(langugeCode, countryCode);
          selectedLocale = '$langugeCode-$countryCode';
          selectedLanguageCode = langugeCode;

        },
        child: Container(
          width: screenWidth-2*marginValue,
          height: pathS/1.2,
          decoration:  BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(pathS/8),
            color: isDarkMode ? greyColor6:whiteColor,
            boxShadow: [
              BoxShadow(
                color:  selectedLanguageCode == langugeCode ?  shadowColor : Colors.transparent, // Shadow color
                blurRadius: pathS/10, // Spread of the shadow
                // spreadRadius: pathS/15, // How far the shadow extends
                offset:  Offset(-pathS/12, pathS/12),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Padding(
                padding: EdgeInsets.only(left: pathS/4,right: pathS/4), // Adjust top and left as needed
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        language,
                        style: TextStyle(
                          color: isDarkMode ? whiteColor:greyColor6,
                          fontSize: pathS / 4,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),

                      if(selectedLanguageCode == langugeCode) Padding(
                        padding:  EdgeInsets.only(top: pathS/16),
                        child: Container(
                          width: pathS / 4,
                          height: pathS / 4,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/icons/check.png"),
                                fit: BoxFit.contain),
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
      );

        },
    );

  }



  void initialSetup() {

  }

  void onTapNext() {
    if(selectedLanguageCode.isEmpty){
      showToastView('Select_language'.tr());
      return;
    }
    if(widget.isFirstScreen) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrivacyPolicyView(),
        ),
      );
    }else{
      Navigator.pop(context);
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
}
