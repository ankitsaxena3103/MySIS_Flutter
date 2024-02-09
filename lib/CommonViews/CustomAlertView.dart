
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';


class CustomAlertView extends StatelessWidget {
  // const SettingsView({super.key});
   final String header ;
   final String message;
   final String cancelButtonTitle;
   final String okButtonTitle;

   final void Function(int) callBack;


  const CustomAlertView({
    required this.header,
    required this.message,
    required this.callBack,
    required this.cancelButtonTitle,
    required this.okButtonTitle,
  });


  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    var backgroundGradient =  LinearGradient(
      colors: [Colors.blue.shade50, Colors.lightBlue.shade100],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    return GestureDetector(
      onTap: () {
        print('Tapped setting popover');
        callBack(0);
      },
      child: Container(
        width: logicalWidth,
        height: logicalHeight,
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Container(
            width: logicalWidth-2*marginValue,
            decoration: BoxDecoration(
              gradient: backgroundGradient,
              border: Border.all(color: Colors.lightBlue.shade300, width: pathS/18),
              borderRadius: BorderRadius.circular(pathS/15),

            ),
            child: Stack(
              children: [
                Padding(
                  padding:  EdgeInsets.fromLTRB(pathS/5, pathS/2, pathS/5, pathS/2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,  // Ensure the column size adjusts to its content
                    children: [
                      Text(
                        header,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: pathS/2.5,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: pathS/2.5),
                      Container(
                        width: 2.2*pathL,
                        height: pathL,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(pathS / 8),
                        ),
                        child: Padding(
                          padding:  EdgeInsets.fromLTRB(pathS/5, 0.0, pathS/5, 0.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                              child: Text(
                                message,

                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: pathS / 4,
                                  fontWeight: FontWeight.bold,

                                ),
                                textAlign: TextAlign.center,

                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: pathS/2.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(cancelButtonTitle.isNotEmpty)GestureDetector(
                            onTap: (){
                              callBack(0);
                            },
                            child: Container(
                              width:pathL,
                              height: pathS / 1.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                // border: Border.all(color: Colors.yellow, width:pathS/18),
                                // borderRadius: BorderRadius.circular(pathS/3),
                              ),
                              child: Text(
                                cancelButtonTitle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: pathS / 4,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: pathS/8),
                          if(okButtonTitle.isNotEmpty)GestureDetector(
                            onTap: (){
                              callBack(1);
                            },
                            child: Container(
                              width: pathL,
                              height: pathS / 1.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                // border: Border.all(color: Colors.yellow, width: pathS/18),
                                // borderRadius: BorderRadius.circular(pathS/3),
                              ),
                              child: Text(
                                okButtonTitle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: pathS / 4,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                        ],
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
