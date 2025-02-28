import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/CustomAlertView.dart';
import 'package:mysis/MyTabBarView.dart';
import 'package:mysis/CommonViews/LoaderView.dart';
import 'package:mysis/Profile/UnitDutyPost.dart';
import 'package:mysis/Profile/UserPosting.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:mysis/CommonViews/ToastMessageView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:provider/provider.dart';

import '../Profile/ContactSIS.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';

class EscortDutyAppliedView extends StatefulWidget {
  final  int escortDutyDays ;
  final List<DateTime> appliedDutyDates;
  final UserPosting userPosting;
final UnitDutyPost unitDutyPost;
  const EscortDutyAppliedView({
    super.key,
    required this.escortDutyDays,
    required this.appliedDutyDates,
    required this.userPosting,
    required this.unitDutyPost,
  });

  @override
  EscortDutyAppliedViewState createState() => EscortDutyAppliedViewState();
}

class EscortDutyAppliedViewState extends State<EscortDutyAppliedView> {
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

  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String imagePath = '';
  String name = 'Samant Kumar';


  List<ContactSIS> contactSIS = [];


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
                          Navigator.of(context).popUntil((route) => route.isFirst);
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
                                  padding:  EdgeInsets.only(top: pathS/2.5,bottom: pathS/2.5),
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
                                      SizedBox(height: pathS/3),

                                      Text(
                                        'request_sent_successfully'.tr(),
                                        style: TextStyle(
                                          color: isDarkMode ?  whiteColor:greyColor6,
                                          fontSize: pathS /6,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(height: pathS/2),

                                      SizedBox(
                                        width: 2*pathL,
                                        child: Text(
                                          widget.userPosting.siteName,
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor:greyColor6,
                                            fontSize: pathS/5,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: pathS/8),
                                      SizedBox(
                                        width: 2*pathL,
                                        child: Text(
                                          widget.unitDutyPost.address,
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor:greyColor5,
                                            fontSize: pathS/6.5,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: pathS/8),
                                      SizedBox(
                                        width: 2*pathL,
                                        child: Text(
                                          widget.unitDutyPost.unitCode,
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor:greyColor6,
                                            fontSize: pathS/5,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                      SizedBox(height: pathS/4),

                                      Container(
                                        width: screenWidth -4*marginValue,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: isDarkMode ? greyColor6:whiteColor,
                                          border: Border.all(
                                              color: isDarkMode ? greyColorDark:greyColor1,
                                              width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              pathS/8
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:  EdgeInsets.only(left:pathS/5,right: pathS/5,top: pathS/8,bottom:pathS/8),
                                              child: Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    height: pathS/2,
                                                    width: pathS /2,
                                                    imageUrl: imagePath,
                                                    placeholder: (context, url) => CircleAvatar(
                                                      backgroundImage: AssetImage(assetsImagePath),
                                                      backgroundColor: Colors.white,
                                                    ),
                                                    errorWidget: (context, url, error) => CircleAvatar(
                                                      backgroundImage: AssetImage(assetsImagePath),
                                                      backgroundColor: Colors.white,
                                                    ),
                                                    imageBuilder: (context, imageProvider) => CircleAvatar(
                                                      backgroundImage: imageProvider,
                                                      backgroundColor: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: pathS/8),
                                                  SizedBox(
                                                    width: 1.5*pathL,
                                                    child: Text(
                                                      name,
                                                      style: TextStyle(
                                                        color: isDarkMode ? whiteColor:greyColor6,
                                                        fontSize: pathS/5,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 1,
                                              color: isDarkMode ? greyColorDark:greyColor1,
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.only(left:pathS/5,right: pathS/5,top: pathS/5,bottom:pathS/5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'date'.tr(),
                                                    style: TextStyle(
                                                      color: isDarkMode ? whiteColor:greyColor6,
                                                      fontSize: pathS/5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),

                                                  Text(
                                                    '${getDateTime(widget.appliedDutyDates.first)} - ${getDateTime(widget.appliedDutyDates.last)}',
                                                    style: TextStyle(
                                                      color: isDarkMode ? whiteColor:greyColor6,
                                                      fontSize: pathS/5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
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

  void initialSetup() {

    getTableData();
  }


  void onLoadData() {


    // setState(() {
    //   showLoaderView = true;
    // });
    Map <String,String> inputData = {

    };

    APIHelper.instance.getData(contactSISApi,inputData, (data) {

      // setState(() {
      //   showLoaderView = false;
      // });

      if(data.isNotEmpty){


        if (kDebugMode) {
          print(data);
        }
        contactSIS = data.map((json) => ContactSIS.fromJson(json)).toList();
        for (var contact in contactSIS) {
          printInDebug('contact  ID : ${contact.id}');
          printInDebug('contact unit cmd name: ${contact.ucName}');
        }

        if(contactSIS.isNotEmpty) {
          showDataOnUI(contactSIS.first);
          syncTableData();
        }



      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

    }
    );

  }

  Future<void> getTableData() async {
    contactSIS = await DatabaseHelper.instance.getAllRecords<ContactSIS>(
      keyTableContactSIS,
          (map) => ContactSIS.fromMap(map),
    );

    for (var contact in contactSIS) {
      printInDebug('table contact ID: ${contact.id}');
      printInDebug('table contact unit cmd name: ${contact.ucName}');
    }

    if(contactSIS.isNotEmpty) {
      showDataOnUI(contactSIS.first);
    }else{
      onLoadData();
    }


  }

  Future<void> syncTableData() async {
    await DatabaseHelper.instance.replaceTableData<ContactSIS>(keyTableContactSIS, contactSIS, (contactSIS) =>
        contactSIS.toMap());
  }

  void showDataOnUI(ContactSIS contact){

    setState(() {
      imagePath = contact.ucImage;
      name = contact.ucName.isNotEmpty ? contact.ucName:contact.aoImage;

    });
  }



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