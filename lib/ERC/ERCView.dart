import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';

import 'ExistingIssuesView.dart';

class ERCView extends StatefulWidget {
  @override
  ERCViewState createState() => ERCViewState();
}

class ERCViewState extends State<ERCView>{


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [

          Container(
            width: logicalWidth,
            height: logicalHeight,
            decoration:  BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: isDarkMode ? backgroundGradientDark : backgroundGradient,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: MediaQuery.of(context).padding.top+pathS/12,
                  left: paddingLeft +pathS/3,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
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
                          'connect_erc'.tr(),
                          style: TextStyle(
                            color: isDarkMode ?  whiteColor:greyColor6,
                            fontSize: pathS / 5,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.center,
                        ),

                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        onLoadExistingIssues();

                      },
                      child: Container(
                        width: pathL*2,
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
                          'existing_erc_issue'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor:whiteColor,
                            fontSize: pathS / 4.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: pathS/5),
                    GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        width: pathL*2,
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
                          'existing_new_issue'.tr(),
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
              ],
            ),
          ),



        ],
      ),
    );
  }

  void onLoadExistingIssues(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExistinIssuesView(),
      ),
    );
  }
  void onLoadLeaveStatus(){
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ApplyLeaveView(),
    //   ),
    // );
  }
  void onLoadLeaveHistory(){
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ApplyLeaveView(),
    //   ),
    // );
  }

}
