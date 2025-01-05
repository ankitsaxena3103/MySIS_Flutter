import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';

import 'dart:core';

class AlertPopupView extends StatefulWidget {

  final String header ;
  final String message;

  final void Function(int) callBack;

  const AlertPopupView({
    super.key,
    required this.header,
    required this.message,
    required this.callBack,
  });

  @override
  AlertPopupViewState createState() => AlertPopupViewState();
}

class AlertPopupViewState extends State<AlertPopupView>  {
  late String header ;
  late String message;
  late String okButton;


  // Initial offset for the view
  double backgroundOpacity = 0.0;

  @override
  void initState() {
    header = widget.header;
    message = widget.message;
    super.initState();

  }

  @override
  void dispose(){

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        printInDebug('Tapped  popover');
        // callBack(-1);
      },
      child: Container(
        width: logicalWidth,
        height: logicalHeight,
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            width: screenWidth-2.5*marginValue,
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

                      Padding(
                        padding:  EdgeInsets.only(left: pathS/5,right: pathS/5),
                        child: Text(
                          widget.header,
                          style: TextStyle(
                              color: isDarkMode ? whiteColor:greyColor6,
                              fontSize: pathS / 4,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto'
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: pathS/3),
                      Padding(
                        padding:  EdgeInsets.only(left: pathS/5,right: pathS/5),
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
                      SizedBox(height: pathS/5),
                      GestureDetector(
                        onTap: (){
                          widget.callBack(-1);
                        },
                        child: Container(
                          width: pathL,
                          height: pathS / 1.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:  isDarkMode ? redColor1 : redColor3,
                            borderRadius: BorderRadius.circular(pathS/3),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor, // Shadow color
                                blurRadius: pathS/10, // Spread of the shadow
                                offset:  Offset(-pathS/12, pathS/12),
                              ),
                            ],
                          ),
                          child: Text(
                            'ok'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? whiteColor : whiteColor,
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
              ],
            ),
          ),
        ),
      ),

    );
  }


}