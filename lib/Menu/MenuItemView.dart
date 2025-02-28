
// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Leaves/Leaves-Help/LeaveViewHelp.dart';
import 'package:mysis/Notifications/NotificationsView.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:mysis/SyncData/SyncDataView.dart';
import 'package:mysis/SyncData/SyncDataViewHelp.dart';
import 'package:provider/provider.dart';
import 'package:mysis/Language/SelectLanguageView.dart';
import 'package:mysis/Profile/ProfileView.dart';
import 'package:mysis/Leaves/LeaveView.dart';

import '../AKR/AKRView.dart';
import '../ERC/ERCView.dart';
import '../EscortDuty/EscortDutyView.dart';
import '../G2G/G2GView.dart';
import '../GeneralQuestions/GenerealQuestionsView.dart';
import '../GeneralRules/GeneralRulesView.dart';
import '../Salary/SalaryView.dart';
import '../SulabhLoan/SarvamLoanView.dart';
import '../SulabhLoan/SulabhLoanView.dart';

class MenuItemView extends StatefulWidget {

  final VoidCallback onCloseBottomSheet; // Callback function
  final Function(int) onTabSelected;
  // Callback function

  MenuItemView(
      {
        super.key,
        required this.onCloseBottomSheet,
        required this.onTabSelected,
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
    double iconSize = pathS/3;
    double iconTextGap = pathS/8;
    double verticalGap = pathS/2.5;
    double horizontalGap = 0;
    var backgroundGradientDark =  LinearGradient(
      colors: [greyColor8, greyColor8],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

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
                  // color: isDarkMode ? greyColor6 : greyColor

                ),
                child: Padding(
                  padding: EdgeInsets.only( bottom: paddingBottom),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only( bottom: pathL),
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    widget.onCloseBottomSheet();
                                   widget.onTabSelected(0);
                                  },
                                  child:  Column(
                                    children: [
                                      SizedBox(
                                        width: iconSize,
                                        height: iconSize,

                                        child: Image.asset(
                                          'assets/images/dashboard-icons/home.png',
                                          color: isDarkMode ? whiteColor:greyColor6,
                                        ),
                                      ),
                                      SizedBox(height: iconTextGap),
                                      SizedBox(
                                        width: screenWidth/3,
                                        child:Text(
                                          'home'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor:greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
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
                                      widget.onTabSelected(1);
                                    },
                                    child:Column(
                                      children: [
                                        SizedBox(
                                          width: iconSize,
                                          height: iconSize,
                                          child: Image.asset(
                                            'assets/images/dashboard-icons/duty.png',
                                            color: isDarkMode ? whiteColor:greyColor6,
                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        SizedBox(
                                          width: screenWidth/3,
                                          child:Text(
                                            'txt_duty'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:greyColor6,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
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
                                    child:SizedBox(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: iconSize,
                                            height: iconSize,
                                            child: Image.asset(
                                              'assets/images/dashboard-icons/user.png',
                                              color: isDarkMode ? whiteColor:greyColor6,
                                            ),
                                          ),
                                          SizedBox(height: iconTextGap),
                                          SizedBox(
                                            width: screenWidth/3,
                                            child:Text(
                                              'profile'.tr(),
                                              style: TextStyle(
                                                color: isDarkMode ? whiteColor:greyColor6,
                                                fontSize: pathS / 5,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
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
                                      onLoadNotificationView();

                                    },
                                    child:Column(
                                      children: [
                                        Container(
                                          width: iconSize,
                                          height: iconSize,

                                          child: Image.asset(
                                            'assets/images/dashboard-icons/notification.png',
                                            color: isDarkMode ? whiteColor:greyColor6,

                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        SizedBox(
                                          width: screenWidth/3,
                                          child: Text(
                                            'notification'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:greyColor6,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
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

                                      onLoadLeaveView();

                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: iconSize,
                                          height: iconSize,

                                          child: Image.asset(
                                            'assets/images/dashboard-icons/leaves.png',
                                            color: isDarkMode ? whiteColor:greyColor6,

                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Container(
                                          width: screenWidth/3,
                                          child: Text(
                                            'txt_leaves'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:greyColor6,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
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
                                      onLoadSyncDataView();

                                    },
                                    child:Column(
                                      children: [
                                        Container(
                                          width: iconSize,
                                          height: iconSize,

                                          child: Image.asset(
                                            'assets/images/dashboard-icons/circular-refresh.png',
                                            color: isDarkMode ? whiteColor:greyColor6,

                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Container(
                                          width: screenWidth/3,
                                          child:Text(
                                            'txt_sync'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:greyColor6,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
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
                                      onLoadGeneralQAView();

                                    },
                                    child:Column(
                                      children: [
                                        Container(
                                          width: iconSize,
                                          height: iconSize,

                                          child: Image.asset(
                                            'assets/images/dashboard-icons/faqs.png',
                                            color: isDarkMode ? whiteColor:greyColor6,

                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Container(
                                          width: screenWidth/3,
                                          child:Text(
                                            'faq'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:greyColor6,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
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
                                      onLoadERCView();
                                    },
                                    child:Column(
                                      children: [
                                        SizedBox(
                                          width: iconSize,
                                          height: iconSize,

                                          child: Image.asset(
                                            'assets/images/dashboard-icons/erc.png',
                                            color: isDarkMode ? whiteColor:greyColor6,

                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        SizedBox(
                                          width: screenWidth/3,
                                          child:Text(
                                            'erc'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:greyColor6,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
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
                                          'assets/images/dashboard-icons/language.png',
                                          color: isDarkMode ? whiteColor:greyColor6,

                                        ),
                                      ),
                                      SizedBox(height: iconTextGap),
                                      Container(
                                        width: screenWidth/3,
                                        child:Text(
                                          'language'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor:greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
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
                                      onLoadSalaryView();

                                    },
                                    child:Column(
                                      children: [
                                        Container(
                                          width: iconSize,
                                          height: iconSize,

                                          child: Image.asset(
                                            'assets/images/dashboard-icons/salary.png',
                                            color: isDarkMode ? whiteColor:greyColor6,

                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Container(
                                          width: screenWidth/3,
                                          child:Text(
                                            'salary'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:greyColor6,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
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
                                      onLoadGeneralRuleView();


                                    },
                                    child:Column(
                                      children: [
                                        Container(
                                          width: iconSize,
                                          height: iconSize,

                                          child: Image.asset(
                                            'assets/images/dashboard-icons/documents.png',
                                            color: isDarkMode ? whiteColor:greyColor6,

                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Container(
                                          width: screenWidth/3,
                                          child: Text(
                                            'general_rules'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:greyColor6,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
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
                                      onLoadG2GView();

                                    },
                                    child:Column(
                                      children: [
                                        Container(
                                          width: iconSize,
                                          height: iconSize,

                                          child: Image.asset(
                                            'assets/images/dashboard-icons/g2g.png',
                                            color: isDarkMode ? whiteColor:greyColor6,

                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Container(
                                          width: screenWidth/3,
                                          child:Text(
                                            'g2g'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:greyColor6,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
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
                                      onLoadAKRView();


                                    },
                                    child:Column(
                                      children: [
                                        Container(
                                          width: iconSize,
                                          height: iconSize,

                                          child: Image.asset(
                                            'assets/images/dashboard-icons/akr.png',
                                            color: isDarkMode ? whiteColor:greyColor6,

                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Container(
                                          width: screenWidth/3,
                                          child:Text(
                                            'akr'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:greyColor6,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
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
                                      onLoadSarvamLoanView();

                                    },
                                    child:Column(
                                      children: [
                                        Container(
                                          width: iconSize,
                                          height: iconSize,

                                          child: Image.asset(
                                            'assets/images/dashboard-icons/sulabh-loan.png',
                                            color: isDarkMode ? whiteColor:greyColor6,

                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Container(
                                          width: screenWidth/3,
                                          child: Text(
                                            'loan_by_sarvam'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:greyColor6,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
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
                                      onLoadEscortDutyView();

                                    },
                                    child:Column(
                                      children: [
                                        Container(
                                          width: iconSize,
                                          height: iconSize,

                                          child: Image.asset(
                                            'assets/images/dashboard-icons/escort-duty.png',
                                            color: isDarkMode ? whiteColor:greyColor6,

                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Container(
                                          width: screenWidth/3,
                                          child:Text(
                                            'Escort_Duty'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor:greyColor6,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
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
                              color: isDarkMode ? whiteColor:greyColor6,
                              fontSize: pathS / 5.5,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${packageInfo.version}',
                            // '${packageInfo.version}(${packageInfo.buildNumber})',

                            style: TextStyle(
                              color: isDarkMode ? whiteColor:greyColor6,
                              fontSize: pathS / 5.5,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: verticalGap/2),
                          Container(
                            width: screenWidth,
                            height: 1,
                            color: isDarkMode? greyColorDark:greyColor2,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: pathS/4,bottom: pathS/4),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'dark_mode'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ? whiteColor:greyColor6,
                                    fontSize: pathS / 5.5,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Roboto',
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
                                      color: isDarkMode ?  whiteColor:whiteColor,
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
                                                image: AssetImage("assets/images/dashboard-icons/mode-red.png"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: pathS/20),

                                          Text(
                                            isDarkMode ? 'off'.tr():'on'.tr(),
                                            style: TextStyle(
                                              color: isDarkMode ?  greyColor7:greyColor7,
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
                  ),
                )

            ),
          ),
        );
      },
    );

  }

  void initialSetup() {

  }



  void onLoadProfileView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileView(),
      ),
    );
  }
  void onLoadNotificationView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationsView(),
      ),
    );
  }
  void onLoadLeaveView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeaveView(),
      ),
    );
  }
  void onLoadSyncDataView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SyncDataView(),
      ),
    );
  }
  void onLoadGeneralQAView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeneralQuestionsView(),
      ),
    );
  }
  void onLoadERCView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ERCView(),
      ),
    );
  }
  void onLoadLanguageView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectLanguageView(isFirstScreen: false),
      ),
    );
  }
  void onLoadSalaryView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalaryView(),
      ),
    );
  }
  void onLoadGeneralRuleView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeneralRulesView(),
      ),
    );
  }
  void onLoadG2GView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => G2GView(),
      ),
    );
  }
  void onLoadAKRView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AKRView(),
      ),
    );
  }

  void onLoadSarvamLoanView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SarvamLoanView(),
      ),
    );
  }
  void onLoadEscortDutyView(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EscortDutyView(),
      ),
    );
  }

}