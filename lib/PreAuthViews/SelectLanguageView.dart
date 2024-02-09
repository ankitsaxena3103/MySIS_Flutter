import 'package:flutter/material.dart';
import 'package:mysis/SharedClasses/APIHelper.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/MyTabBarView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/PreAuthViews/PrivacyPolicyView.dart';
import 'package:easy_localization/easy_localization.dart';


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


  String lblHeader =  'Select Language';
  Color nextBgColor = Colors.white;
  Color nextFontColor = Color.fromRGBO(195, 50, 53, 1);

  Color nextShadowColor = Colors.transparent;



  final List<String> languages = [
    'English',
    'Hindi',
    'Kannada',
    'Telugu',
    'Odia',
    'Marathi',
  ];

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
    double gap = pathS/8;
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

                    Text(
                      'Select_language'.tr(),
                      style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontSize: pathS / 3.5,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: gap*8),
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
                  bottom: paddingBottom,

                  child: GestureDetector(
                    onTap: (){
                      onTapNext();

                    },
                    child: Container(
                      width: screenWidth,
                      height: pathS / 1.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: nextBgColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                        // borderRadius: BorderRadius.circular(pathS/3),
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
                        'confirm'.tr(),
                        style: TextStyle(
                          color: nextFontColor,
                          fontSize: pathS / 4.5,
                          fontWeight: FontWeight.bold,
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


  Widget buildLanguageItem(String language, String langugeCode, String countryCode) {
    return GestureDetector(
      onTap: () {
        print('Selected language: $language');
        context.setLocale(Locale(langugeCode, countryCode));
        setState(() {
          selectedLanguage = language;
        });

      },
      child: Container(
        width: screenWidth-2.5*marginValue,
        height: pathS,
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
                        color: Color.fromRGBO(51, 51, 51, 0.7),
                        fontSize: pathS / 4,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),

                   if(selectedLanguage == language) Container(
                      width: pathS / 4,
                      height: pathS / 4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/icons/check@3x.png"),
                            fit: BoxFit.contain),
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
  }



  void initialSetup() {}

  void onTapNext() {
    if(selectedLanguage.isEmpty){
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
