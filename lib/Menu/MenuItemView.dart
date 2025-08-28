
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
    double verticalGap = pathS/5;
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
                                // Home
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.onCloseBottomSheet();
                                    widget.onTabSelected(0);
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: iconSize,
                                          height: iconSize,
                                          child: Image.asset(
                                            'assets/images/dashboard-icons/home.png',
                                            color: isDarkMode ? whiteColor : greyColor6,
                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'home'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // Duty
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.onCloseBottomSheet();
                                    widget.onTabSelected(1);
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: iconSize,
                                          height: iconSize,
                                          child: Image.asset(
                                            'assets/images/dashboard-icons/duty.png',
                                            color: isDarkMode ? whiteColor : greyColor6,
                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'txt_duty'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // Profile
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.onCloseBottomSheet();
                                    onLoadProfileView();
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: iconSize,
                                          height: iconSize,
                                          child: Image.asset(
                                            'assets/images/dashboard-icons/user.png',
                                            color: isDarkMode ? whiteColor : greyColor6,
                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'profile'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
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
                                // Notification
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.onCloseBottomSheet();
                                    onLoadNotificationView();
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: iconSize,
                                          height: iconSize,
                                          child: Image.asset(
                                            'assets/images/dashboard-icons/notification.png',
                                            color: isDarkMode ? whiteColor : greyColor6,
                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'notification'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // Leaves
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.onCloseBottomSheet();
                                    onLoadLeaveView();
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: iconSize,
                                          height: iconSize,
                                          child: Image.asset(
                                            'assets/images/dashboard-icons/leaves.png',
                                            color: isDarkMode ? whiteColor : greyColor6,
                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'txt_leaves'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // Sync
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.onCloseBottomSheet();
                                    onLoadSyncDataView();
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: iconSize,
                                          height: iconSize,
                                          child: Image.asset(
                                            'assets/images/dashboard-icons/circular-refresh.png',
                                            color: isDarkMode ? whiteColor : greyColor6,
                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'txt_sync'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
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
                                // FAQ
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.onCloseBottomSheet();
                                    onLoadGeneralQAView();
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: iconSize,
                                          height: iconSize,
                                          child: Image.asset(
                                            'assets/images/dashboard-icons/faqs.png',
                                            color: isDarkMode ? whiteColor : greyColor6,
                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'faq'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // ERC (Coming Soon)
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('coming_soon'.tr())),
                                    );
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: iconSize,
                                          height: iconSize,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Image.asset(
                                                'assets/images/dashboard-icons/erc.png',
                                                color: isDarkMode ? whiteColor : greyColor6,
                                                width: iconSize,
                                                height: iconSize,
                                              ),
                                              Positioned(
                                                top: -4,
                                                right: -4,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    'coming_soon'.tr(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'erc'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // Language
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.onCloseBottomSheet();
                                    onLoadLanguageView();
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: iconSize,
                                          height: iconSize,
                                          child: Image.asset(
                                            'assets/images/dashboard-icons/language.png',
                                            color: isDarkMode ? whiteColor : greyColor6,
                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'language'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
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
                                // Salary (Coming Soon)
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('coming_soon'.tr())),
                                    );
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: iconSize,
                                          height: iconSize,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Image.asset(
                                                'assets/images/dashboard-icons/salary.png',
                                                color: isDarkMode ? whiteColor : greyColor6,
                                                width: iconSize,
                                                height: iconSize,
                                              ),
                                              Positioned(
                                                top: -4,
                                                right: -4,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    'coming_soon'.tr(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'salary'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // General Rules
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.onCloseBottomSheet();
                                    onLoadGeneralRuleView();
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/images/dashboard-icons/documents.png',
                                          width: iconSize,
                                          height: iconSize,
                                          color: isDarkMode ? whiteColor : greyColor6,
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'general_rules'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // G2G
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.onCloseBottomSheet();
                                    onLoadG2GView();
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/images/dashboard-icons/g2g.png',
                                          width: iconSize,
                                          height: iconSize,
                                          color: isDarkMode ? whiteColor : greyColor6,
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'g2g'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
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
                                // AKR - Coming Soon
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('coming_soon'.tr())),
                                    );
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: iconSize,
                                          height: iconSize,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Image.asset(
                                                'assets/images/dashboard-icons/akr.png',
                                                width: iconSize,
                                                height: iconSize,
                                                color: isDarkMode ? whiteColor : greyColor6,
                                              ),
                                              Positioned(
                                                top: -4,
                                                right: -4,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    'coming_soon'.tr(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'akr'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // Sarvam Loan
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.onCloseBottomSheet();
                                    onLoadSarvamLoanView();
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/images/dashboard-icons/sarvam_logo.png',
                                          width: iconSize,
                                          height: iconSize,
                                          color: isDarkMode ? whiteColor : greyColor6,
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'loan_by_sarvam'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // Escort Duty
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    widget.onCloseBottomSheet();
                                    onLoadEscortDutyView();
                                  },
                                  child: Container(
                                    width: screenWidth / 3,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/images/dashboard-icons/escort-duty.png',
                                          width: iconSize,
                                          height: iconSize,
                                          color: isDarkMode ? whiteColor : greyColor6,
                                        ),
                                        SizedBox(height: iconTextGap),
                                        Text(
                                          'Escort_Duty'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
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