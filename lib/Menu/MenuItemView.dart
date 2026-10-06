

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/DutyVerification/DutySummaryModule/DutySummaryScreen.dart';
import 'package:mysis/KoshLoan/ReferAndEarnScreen.dart';
import 'package:mysis/KoshLoan/koshdialoggetstartedconsent.dart';
import 'package:mysis/Notifications/NotificationsView.dart';
import 'package:mysis/SharedClasses/ThemeProvider.dart';
import 'package:mysis/SyncData/SyncDataView.dart';
import 'package:provider/provider.dart';
import 'package:mysis/Language/SelectLanguageView.dart';
import 'package:mysis/Profile/ProfileView.dart';
import 'package:mysis/Leaves/LeaveView.dart';

import '../AKR/AKRView.dart';
import '../GMD/GMDSeBolo.dart';
import '../EscortDuty/EscortDutyView.dart';
import '../G2G/G2GView.dart';
import '../GeneralQuestions/GenerealQuestionsView.dart';
import '../GeneralRules/GeneralRulesView.dart';
import '../Salary/SalaryView.dart';
import '../SulabhLoan/SarvamLoanView.dart';

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
    double verticalGap = pathS/6;
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
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: isDarkMode
                    ? backgroundGradientDark
                    : backgroundGradient,
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: paddingBottom),
                child: Column(
                  children: [

                    // =========================================================
                    // MENU AREA
                    // =========================================================
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: pathL / 2,
                          bottom: pathL,
                          left: 4,
                          right: 4,
                        ),
                        child: Column(
                          children: [

                            // =================================================
                            // ROW 1
                            // Home | Duty | Profile
                            // =================================================
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // Home
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      widget.onCloseBottomSheet();
                                      widget.onTabSelected(0);
                                    },
                                    child: _menuItem(
                                      icon: 'assets/images/dashboard-icons/home.png',
                                      title: 'home'.tr(),
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // Duty
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      widget.onCloseBottomSheet();
                                      widget.onTabSelected(1);
                                    },
                                    child: _menuItem(
                                      icon: 'assets/images/dashboard-icons/duty.png',
                                      title: 'txt_duty'.tr(),
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // Profile
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      widget.onCloseBottomSheet();
                                      onLoadProfileView();
                                    },
                                    child: _menuItem(
                                      icon: 'assets/images/dashboard-icons/user.png',
                                      title: 'profile'.tr(),
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: verticalGap),

                            // =================================================
                            // ROW 2
                            // Notification | Leaves | Sync
                            // =================================================
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // Notification
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      widget.onCloseBottomSheet();
                                      onLoadNotificationView();
                                    },
                                    child: _menuItem(
                                      icon:
                                      'assets/images/dashboard-icons/notification.png',
                                      title: 'notification'.tr(),
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // Leaves
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      widget.onCloseBottomSheet();
                                      onLoadLeaveView();
                                    },
                                    child: _menuItem(
                                      icon:
                                      'assets/images/dashboard-icons/leaves.png',
                                      title: 'txt_leaves'.tr(),
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // Sync
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      widget.onCloseBottomSheet();
                                      onLoadSyncDataView();
                                    },
                                    child: _menuItem(
                                      icon:
                                      'assets/images/dashboard-icons/circular-refresh.png',
                                      title: 'txt_sync'.tr(),
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: verticalGap),

                            // =================================================
                            // ROW 3
                            // FAQ | GMD | Language
                            // =================================================
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // FAQ
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      widget.onCloseBottomSheet();
                                      onLoadGeneralQAView();
                                    },
                                    child: _menuItem(
                                      icon:
                                      'assets/images/dashboard-icons/faqs.png',
                                      title: 'faq'.tr(),
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // GMD
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      widget.onCloseBottomSheet();
                                      onLoadERCView();
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        Container(
                                          width: iconSize,
                                          height: iconSize,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(1),
                                          child: Image.asset(
                                            'assets/images/dashboard-icons/gmd.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),

                                        SizedBox(height: iconTextGap),

                                        Text(
                                          'GMD_se_bolo'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? whiteColor
                                                : greyColor6,
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

                                SizedBox(width: horizontalGap),

                                // Language
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      widget.onCloseBottomSheet();
                                      onLoadLanguageView();
                                    },
                                    child: _menuItem(
                                      icon:
                                      'assets/images/dashboard-icons/language.png',
                                      title: 'language'.tr(),
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: verticalGap),

                            // =================================================
                            // ROW 4
                            // Salary | General Rules | G2G
                            // =================================================
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // Salary
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      widget.onCloseBottomSheet();
                                      onLoadSalaryView();
                                    },
                                    child: _menuItem(
                                      icon:
                                      'assets/images/dashboard-icons/salary.png',
                                      title: 'salary'.tr(),
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // General Rules
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'coming_soon'.tr(),
                                          ),
                                        ),
                                      );
                                    },
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
                                                'assets/images/dashboard-icons/documents.png',
                                                width: iconSize,
                                                height: iconSize,
                                                color: isDarkMode
                                                    ? whiteColor
                                                    : greyColor6,
                                              ),

                                              Positioned(
                                                top: -4,
                                                right: -4,
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius:
                                                    BorderRadius.circular(12),
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
                                          'general_rules'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? whiteColor
                                                : greyColor6,
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

                                SizedBox(width: horizontalGap),

                                // G2G
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      widget.onCloseBottomSheet();
                                      onLoadG2GView();
                                    },
                                    child: _menuItem(
                                      icon:
                                      'assets/images/dashboard-icons/g2g.png',
                                      title: 'g2g'.tr(),
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: verticalGap),

                            // =================================================
                            // ROW 5
                            // Kosh Loan | Earn with Kosh | Escort Duty
                            // =================================================
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // Kosh Loan
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      onLoadKoshLoan();
                                    },
                                    child: _menuItem(
                                      icon:
                                      'assets/images/KoshImage/kosh_loan_menu_icon.png',
                                      title: 'kosh_loan'.tr(),
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // Earn with Kosh
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      widget.onCloseBottomSheet();
                                      onLoadKoshReferContent();
                                    },
                                    child: _menuItem(
                                      icon:
                                      'assets/images/KoshImage/Earn with Kosh.png',
                                      title: 'Earn with Kosh'.tr(),
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),

                                SizedBox(width: horizontalGap),

                                // Escort Duty
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      widget.onCloseBottomSheet();
                                      onLoadEscortDutyView();
                                    },
                                    child: _menuItem(
                                      icon:
                                      'assets/images/dashboard-icons/escort-duty.png',
                                      title: 'Escort_Duty'.tr(),
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: verticalGap),

                            // =================================================
                            // ROW 6
                            // Duty Verification
                            // =================================================
                            Row(
                              children: [

                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      onLoadDutyVerification();
                                    },
                                    child: _menuItem(
                                      icon:
                                      'assets/images/ic_duty_verification_clipboard.png',
                                      title: 'Duty Verification',
                                      iconSize: iconSize,
                                      iconTextGap: iconTextGap,
                                      pathS: pathS,
                                      isDarkMode: isDarkMode,
                                    ),
                                  ),
                                ),

                                // Empty space
                                Expanded(
                                  child: const SizedBox(),
                                ),

                                Expanded(
                                  child: const SizedBox(),
                                ),
                              ],
                            ),

                            // Extra bottom space before footer
                            SizedBox(height: pathS / 2),
                          ],
                        ),
                      ),
                    ),

                    // =========================================================
                    // FIXED BOTTOM SECTION
                    // App Version + Dark Mode
                    // =========================================================
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        // App Version
                        Text(
                          'app_version'.tr(),
                          style: TextStyle(
                            color: isDarkMode
                                ? whiteColor
                                : greyColor6,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.center,
                        ),

                        Text(
                          '${packageInfo.version}',
                          style: TextStyle(
                            color: isDarkMode
                                ? whiteColor
                                : greyColor6,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: verticalGap / 2),

                        // Divider
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: isDarkMode
                              ? greyColorDark
                              : greyColor2,
                        ),

                        // Dark Mode
                        Padding(
                          padding: EdgeInsets.only(
                            top: pathS / 4,
                            bottom: pathS / 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text(
                                'dark_mode'.tr(),
                                style: TextStyle(
                                  color: isDarkMode
                                      ? whiteColor
                                      : greyColor6,
                                  fontSize: pathS / 5.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(width: pathS / 5),

                              GestureDetector(
                                onTap: () {
                                  themeProvider.toggleTheme();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                    BorderRadius.circular(pathS / 4),
                                    color: whiteColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: pathS / 10,
                                      right: pathS / 8,
                                      top: pathS / 20,
                                      bottom: pathS / 20,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        Container(
                                          height: pathS / 4,
                                          width: pathS / 4,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                "assets/images/dashboard-icons/mode-red.png",
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: pathS / 20),

                                        Text(
                                          isDarkMode
                                              ? 'off'.tr().toUpperCase()
                                              : 'on'.tr().toUpperCase(),
                                          style: TextStyle(
                                            color: greyColor7,
                                            fontSize: pathS / 6,
                                            fontWeight: FontWeight.w500,
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
              ),
            ),
          ),
        );
      },
    );

  }
  Widget _menuItem({
    required String icon,
    required String title,
    required double iconSize,
    required double iconTextGap,
    required double pathS,
    required bool isDarkMode,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          SizedBox(
            width: iconSize,
            height: iconSize,
            child: Image.asset(
              icon,
              width: iconSize,
              height: iconSize,
              color: isDarkMode
                  ? whiteColor
                  : greyColor6,
            ),
          ),

          SizedBox(height: iconTextGap),

          Text(
            title,
            style: TextStyle(
              color: isDarkMode
                  ? whiteColor
                  : greyColor6,
              fontSize: pathS / 5,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
        builder: (context) => GMDSeBolo(),
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

  void onLoadKoshReferContent() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.50),
      builder: (context) {
        return  ReferAndEarnScreen();
      },
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
  void onLoadKoshLoan(){

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.50),
      builder: (context) {
        return KoshDialogGetStartedConsent();
      },
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => KoshDialogGetStartedConsent(),
    //   ),
    // );
  }
  void onLoadDutyVerification(){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DutySummaryScreen(user: "AGR002430", deviceToken: "", password: "5054",mPin: "5054",),
      ),
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => KoshDialogGetStartedConsent(),
    //   ),
    // );
  }

}