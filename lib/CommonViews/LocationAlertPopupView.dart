import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';

import 'dart:core';

class LocationAlertPopupView extends StatefulWidget {

  final String header ;
  final String message;
  final String  cancelBtn;
  final String  okBtn;
  final String otherBtnTitle;
  final String latLong;

  final void Function(int) callBack;

  const LocationAlertPopupView({
    super.key,
    required this.header,
    required this.message,
    required this.callBack,
    required this.cancelBtn,
    required this.okBtn,
    required this.otherBtnTitle,
    required this.latLong,

  });

  @override
  LocationAlertPopupViewState createState() => LocationAlertPopupViewState();
}

class LocationAlertPopupViewState extends State<LocationAlertPopupView>  {
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
          child: FittedBox(
            child: Container(
              width: screenWidth - 2.5 * marginValue,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(pathS / 8),
                color: isDarkMode ? greyColor8 : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow color
                    blurRadius: pathS / 10, // Spread of the shadow
                    offset: Offset(-pathS / 12, pathS / 12),
                  ),
                ],
              ),
              child: Padding(
                padding:  EdgeInsets.all(pathS/3),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Adjust height based on content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.header,
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor5,
                        fontSize: pathS / 5,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: pathS / 4),
                    Text(
                      widget.message,
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : greyColor6,
                        fontSize: pathS / 4.8,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Roboto',

                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: pathS / 4),
                    GestureDetector(
                      onTap: (){
                        if(widget.latLong.isEmpty){
                          return;
                        }
                        List<String> activeDayList = widget.latLong.split(',').map((e) => e.trim()).toList();

                        double lat = double.parse(activeDayList[0]); // Latitude
                        double lng = double.parse(activeDayList[1]); // Longitude
                        launchGoogleMap(lat, lng);

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.otherBtnTitle,
                            style: TextStyle(
                              color: isDarkMode ? redColor1 : redColor3,
                              fontSize: pathS / 4.5,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Roboto',
                              decoration: TextDecoration.underline,
                              decorationColor: isDarkMode ? redColor1 : redColor3,
                              decorationThickness: 2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: pathS / 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if(widget.cancelBtn.isNotEmpty)GestureDetector(
                          onTap: () {
                            widget.callBack(0);
                          },
                          child: Container(
                            // width: pathS*1.5,
                            height: pathS / 2,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isDarkMode ? redColor1 : redColor3,
                              borderRadius: BorderRadius.circular(pathS / 3),
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor, // Shadow color
                                  blurRadius: pathS / 10, // Spread of the shadow
                                  offset: Offset(-pathS / 12, pathS / 12),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:  EdgeInsets.only(left: pathS/3,right: pathS/3),
                              child: Text(
                                widget.cancelBtn.toUpperCase(),
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : whiteColor,
                                  fontSize: pathS / 5,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: pathS/4),
                        if(widget.okBtn.isNotEmpty)GestureDetector(
                          onTap: () {
                            widget.callBack(1);
                          },
                          child: Container(
                            // width: pathS*1.5,
                            height: pathS / 2,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isDarkMode ? redColor1 : redColor3,
                              borderRadius: BorderRadius.circular(pathS / 3),
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor, // Shadow color
                                  blurRadius: pathS / 10, // Spread of the shadow
                                  offset: Offset(-pathS / 12, pathS / 12),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:  EdgeInsets.only(left: pathS/3,right: pathS/3),
                              child: Text(
                                widget.okBtn.toUpperCase(),
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : whiteColor,
                                  fontSize: pathS / 5,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Roboto',
                                ),
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
        ),
      ),


    );
  }


}