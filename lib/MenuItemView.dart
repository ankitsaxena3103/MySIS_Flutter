
// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:mysis/PreAuthViews/SelectLanguageView.dart';
import 'package:mysis/Profile/ProfileView.dart';

class MenuItemView extends StatefulWidget {

  final VoidCallback onCloseBottomSheet; // Callback function

  MenuItemView(
      {
        super.key,
        required this.onCloseBottomSheet,
       });


  @override
  MenuItemViewState createState() => MenuItemViewState();
}

class MenuItemViewState extends State<MenuItemView> {

  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    double iconSize = pathS/2;
    double verticalGap = pathS/2.5;
    double horizontalGap = 0;
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Material(
          child: Scaffold(
            body: Container(
                width: logicalWidth,
                height: logicalHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: isDarkMode ? backgroundGradientDark : backgroundGradient,

                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only( bottom: pathL/1.1),
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              GestureDetector(
                                onTap: (){
                                  widget.onCloseBottomSheet();

                                },
                                child:  Column(
                                  children: [
                                    Container(
                                      width: iconSize,
                                      height: iconSize,

                                      child: Image.asset(
                                        'assets/images/Dashboard-icons/home.png',
                                        color: isDarkMode ? whiteFontColor:greyFontColor,

                                      ),
                                    ),
                                    Container(
                                      width: screenWidth/3,
                                      child:Text(
                                        'home'.tr(),
                                        style: TextStyle(
                                          color: isDarkMode ? whiteFontColor:greyFontColor,
                                          fontSize: pathS / 5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ) ,
                                    ),

                                  ],
                                ),//home
                              ),

                              SizedBox(width: horizontalGap),
                              GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();

                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/Dashboard-icons/duty.png',
                                          color: isDarkMode ? whiteFontColor:greyFontColor,

                                        ),
                                      ),
                                      Container(
                                        width: screenWidth/3,
                                        child:Text(
                                          'txt_duty'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteFontColor:greyFontColor,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                    ],
                                  ),
                              ),

                              SizedBox(width: horizontalGap),
                              GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();

                                    onLoadProfileView();

                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/Dashboard-icons/user.png',
                                          color: isDarkMode ? whiteFontColor:greyFontColor,

                                        ),
                                      ),
                                      Container(
                                        width: screenWidth/3,
                                        child:Text(
                                          'profile'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteFontColor:greyFontColor,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                    ],
                                  ),
                              ),

                            ],
                          ),
                          SizedBox(height: verticalGap),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();

                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/Dashboard-icons/notification.png',
                                          color: isDarkMode ? whiteFontColor:greyFontColor,

                                        ),
                                      ),
                                      Container(
                                        width: screenWidth/3,
                                        child: Text(
                                          'notification'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteFontColor:greyFontColor,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )

                                    ],
                                  ),
                              ),

                              SizedBox(width: horizontalGap),
                              GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();

                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/Dashboard-icons/leaves.png',
                                          color: isDarkMode ? whiteFontColor:greyFontColor,

                                        ),
                                      ),
                                      Container(
                                        width: screenWidth/3,
                                        child: Text(
                                          'txt_leaves'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteFontColor:greyFontColor,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                    ],
                                  ),
                              ),

                              SizedBox(width: horizontalGap),
                              GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();

                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/Dashboard-icons/circular-refresh.png',
                                          color: isDarkMode ? whiteFontColor:greyFontColor,

                                        ),
                                      ),
                                      Container(
                                        width: screenWidth/3,
                                        child:Text(
                                          'txt_sync'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteFontColor:greyFontColor,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                    ],
                                  ),
                              ),

                            ],
                          ),
                          SizedBox(height: verticalGap),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();

                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/Dashboard-icons/faqs.png',
                                          color: isDarkMode ? whiteFontColor:greyFontColor,

                                        ),
                                      ),
                                      Container(
                                        width: screenWidth/3,
                                        child:Text(
                                          'faq'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteFontColor:greyFontColor,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                    ],
                                  ),
                              ),

                              SizedBox(width: horizontalGap),
                              GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();

                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/Dashboard-icons/erc.png',
                                          color: isDarkMode ? whiteFontColor:greyFontColor,

                                        ),
                                      ),
                                      Container(
                                        width: screenWidth/3,
                                        child:Text(
                                          'erc'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteFontColor:greyFontColor,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                    ],
                                  ),
                              ),

                              SizedBox(width: horizontalGap),
                              GestureDetector(
                                onTap: (){
                                  widget.onCloseBottomSheet();

                                  onLoadLanguageView();

                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: iconSize,
                                      height: iconSize,

                                      child: Image.asset(
                                        'assets/images/Dashboard-icons/language.png',
                                        color: isDarkMode ? whiteFontColor:greyFontColor,

                                      ),
                                    ),
                                    Container(
                                      width: screenWidth/3,
                                      child:Text(
                                        'language'.tr(),
                                        style: TextStyle(
                                          color: isDarkMode ? whiteFontColor:greyFontColor,
                                          fontSize: pathS / 5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: verticalGap),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();

                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/Dashboard-icons/salary.png',
                                          color: isDarkMode ? whiteFontColor:greyFontColor,

                                        ),
                                      ),
                                      Container(
                                        width: screenWidth/3,
                                        child:Text(
                                          'salary'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteFontColor:greyFontColor,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                    ],
                                  ),
                              ),

                              SizedBox(width: horizontalGap),
                              GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();

                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/Dashboard-icons/documents.png',
                                          color: isDarkMode ? whiteFontColor:greyFontColor,

                                        ),
                                      ),
                                      Container(
                                        width: screenWidth/3,
                                        child: Text(
                                          'general_rules'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteFontColor:greyFontColor,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                    ],
                                  ),
                              ),

                              SizedBox(width: horizontalGap),
                              GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();

                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/Dashboard-icons/g2g.png',
                                          color: isDarkMode ? whiteFontColor:greyFontColor,

                                        ),
                                      ),
                                      Container(
                                        width: screenWidth/3,
                                        child:Text(
                                          'g2g'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteFontColor:greyFontColor,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                    ],
                                  ),
                              ),

                            ],
                          ),

                          SizedBox(height: verticalGap),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();

                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/Dashboard-icons/akr.png',
                                          color: isDarkMode ? whiteFontColor:greyFontColor,

                                        ),
                                      ),
                                      Container(
                                        width: screenWidth/3,
                                        child:Text(
                                          'akr'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteFontColor:greyFontColor,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                    ],
                                  ),
                              ),

                              SizedBox(width: horizontalGap),
                              GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();

                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/Dashboard-icons/sulabh-loan.png',
                                          color: isDarkMode ? whiteFontColor:greyFontColor,

                                        ),
                                      ),
                                      Container(
                                        width: screenWidth/3,
                                        child: Text(
                                          'sulabh_loan'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteFontColor:greyFontColor,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                    ],
                                  ),
                              ),

                              SizedBox(width: horizontalGap),
                              GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();

                                  },
                                  child:Column(
                                    children: [
                                      Container(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/Dashboard-icons/escort-duty.png',
                                          color: isDarkMode ? whiteFontColor:greyFontColor,

                                        ),
                                      ),
                                      Container(
                                        width: screenWidth/3,
                                        child:Text(
                                          'Escort_Duty'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteFontColor:greyFontColor,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'app_version'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteFontColor:greyFontColor,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${packageInfo.version}',
                          // '${packageInfo.version}(${packageInfo.buildNumber})',

                          style: TextStyle(
                            color: isDarkMode ? whiteFontColor:greyFontColor,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: verticalGap/2),
                        Container(
                          width: screenWidth,
                          height: 0.5,
                          color: isDarkMode? whiteBGColor:lightGreyFontColor,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: pathS/5,bottom: pathS/5),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'dark_mode'.tr(),
                                style: TextStyle(
                                  color: isDarkMode ? whiteFontColor:greyFontColor,
                                  fontSize: pathS / 5.5,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(width: pathS/5),
                              GestureDetector(
                                onTap: (){
                                  themeProvider.toggleTheme();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(pathS / 4),
                                    color: isDarkMode ?  whiteFontColor:whiteFontColor,
                                  ),
                                  child:Padding(
                                    padding: EdgeInsets.only(left: pathS/10,right: pathS/8,top: pathS/20,bottom: pathS/20), // Adjust top and left as needed
                                    child: Row(
                                      children: [
                                        Container(
                                          height: pathS/4,
                                          width: pathS/4,
                                          decoration: BoxDecoration(
                                            // shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: AssetImage("assets/images/Dashboard-icons/mode-red.png"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: pathS/20),

                                        Text(
                                          isDarkMode ? 'on'.tr():'off'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ?  darkGreyFontColor:darkGreyFontColor,
                                            fontSize: pathS / 5.5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),

                        ),

                      ],
                    ),


                  ],
                )

            ),
          ),
        );
      },
    );

  }

  void initialSetup() {

  }

void onLoadLanguageView(){
  Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectLanguageView(isFirstScreen: false),
        ),
      );
}

  void onLoadProfileView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileView(),
      ),
    );
  }

}