import 'dart:ui';

import 'package:flutter/material.dart';

import '../CommonViews/Utility.dart';


class CleanDataViewHelp extends StatefulWidget {
  const CleanDataViewHelp({super.key});

  @override
  CleanDataViewHelpState createState() => CleanDataViewHelpState();
}

class CleanDataViewHelpState extends State<CleanDataViewHelp> {

  TextEditingController txtUserName = TextEditingController(text: "");
  TextEditingController txtPassword = TextEditingController(text: "");
  bool showPassword = false;
  bool rememberMe = false;
  bool showLoaderView = false;

  bool isAlertVisible = false;
  String alertHeader = 'Error!';
  String alertMessage = 'There is an  internal error.';

  bool showToastMessageView = false;
  String toastMessage = '';
  String header = 'Duty at Attendance';
  String date = '02/04/2024, 12:02PM';
  String number = 'No of Records';
  String records ='Unsynced Records';
  String number1='02';
  String number2='08';

  var backgroundGredient = LinearGradient(
    colors: [
      Colors.white60,
      Color.fromARGB(51, 51, 51, 1),
    ],
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
  );

  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: backgroundGredient,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left:pathS/3, right:pathS/3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height:paddingTop+pathS),
                      Container(
                        // height: 200,
                        // width: 350,
                        decoration: BoxDecoration(

                          // border: Border.all(
                          //  width: 0,
                          //  color: Colors.white,
                          // ),
                          //
                          color: isDarkMode ? greyColor4 : whiteColor,
                          borderRadius: BorderRadius.circular(pathS/8),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1), // Shadow color
                              blurRadius: 0.5, // Spread of the shadow
                              // spreadRadius: pathS/15, // How far the shadow extends
                              offset: Offset(-3, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: pathS/3, right: pathS/3, top: pathS/5, bottom: pathS/5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            header,
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor : greyColor6,
                                              fontSize: pathS/5,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(

                                            date,
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor : greyColor4,
                                              fontSize: pathS /7,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/sync/clean.png',
                                            width: pathS/2.5,
                                            height: pathS/2.5,
                                          ),
                                          SizedBox(width: pathS/8),

                                          Image.asset(
                                            'assets/images/sync/sync.png',
                                            width: pathS/2.5,
                                            height: pathS/2.5,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: pathS/3.2),
                                  Container(
                                    color: isDarkMode ? greyColorDark : greyColor2,
                                    height: 1,
                                  ),
                                  SizedBox(
                                    height: pathS/8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        number,
                                        style: TextStyle(
                                          color: isDarkMode ? redColor1 : redColor3,
                                          fontSize: pathS/5,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        records,
                                        style: TextStyle(
                                          color: isDarkMode ? redColor1 : redColor3,
                                          fontSize: pathS/5,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: pathS/8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Text(
                                        number1,
                                        style: TextStyle(
                                          color: isDarkMode ? whiteColor : greyColor6,
                                          fontSize: pathS/6,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        number2,
                                        style:  TextStyle(
                                          color: isDarkMode ? whiteColor : greyColor6,
                                          fontSize: pathS/6,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),

                                    ],

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

                 Container(
                   color: Colors.transparent.withOpacity(0.8),
                   height: logicalHeight,
                   width: screenWidth,
                 ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: paddingTop+pathS),
                    Container(
                      // height: 200,
                      // width: 350,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only( top: pathS/5, bottom: pathS/5,right: pathS/1.8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/sync/clean2.png',
                                          width: pathS/2.5,
                                          height: pathS/2.5,
                                        ),
                                        SizedBox(height: pathS/8),
                                        Image.asset(
                                          'assets/images/sync/tapx.png',
                                          width: pathS/2.5,
                                          height: pathS/1.7,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: pathS/1.8 ),
                                  ],
                                ),
                                SizedBox(height: pathS/2.6),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white.withOpacity(0.2),width: 1),
                                    color:Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(pathS/8),
                                    boxShadow: [
                                      ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: pathS/2, right: pathS/2, top: pathS/5, bottom: pathS/5),
                                    child: Text(
                                      'Click on this Icon to Clear Data',
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: pathS/4.5,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  void initialSetup() {
  }
}