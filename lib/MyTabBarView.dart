
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/HomeView/HomeView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/Menu/MenuItemView.dart';
import 'package:mysis/Duty/DutyView.dart';
import 'package:provider/provider.dart';

import 'SharedClasses/LanguageProvider.dart';
import 'SharedClasses/ThemeProvider.dart';

class MyTabBarView extends StatefulWidget {
  @override
  MyTabBarViewState createState() => MyTabBarViewState();
}

class MyTabBarViewState extends State<MyTabBarView> {
  int tabSelectedIndex = 0;
  late List<Widget> tabs;
  // late PersistentBottomSheetController bottomSheetController; // Declare a controller variable
  DateTime? lastBackPressTime;

  @override
  void initState() {
    super.initState();
    tabs = [
      HomeView(onTabSelected: (value ) {
        setState(() {
          tabSelectedIndex = value;
        });
      },),
      DutyView(),
      MenuItemView(
        onCloseBottomSheet: () {

        }, onTabSelected: (int ) {

      },
      ),
    ];
    setState(() {
      tabSelectedIndex = 0;
    });
  }

  @override
  // Widget build(BuildContext context) {
  //   calculateSizes(context);
  //   return Scaffold(
  //     body: tabs[tabSelectedIndex],
  //     bottomNavigationBar: BottomNavigationBar(
  //       backgroundColor: Color.fromRGBO(195, 50, 53, 1).withOpacity(1),
  //
  //       fixedColor: Colors.white,
  //       unselectedItemColor: Colors.white70,
  //       currentIndex: tabSelectedIndex,
  //       items: const <BottomNavigationBarItem>[
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.home),
  //           label: 'HOME',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.calendar_month),
  //           label: 'DUTY',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.menu),
  //           label: 'MENU ',
  //         ),
  //
  //       ],
  //
  //       onTap: (index) {
  //         setState(() {
  //           tabSelectedIndex = index;
  //         });
  //         if(index == 0){
  //
  //         }
  //         if(index == 1){
  //
  //         }
  //
  //         if(index == 2){
  //
  //         }
  //       },
  //     ),
  //   );
  // }


  Widget build(BuildContext context) {
    calculateSizes(context);

    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();

        if (lastBackPressTime == null ||
            now.difference(lastBackPressTime!) > Duration(seconds: 3)) {
          lastBackPressTime = now;

          // Show a toast message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("again_press".tr())),
          );

          return false; // Prevent exit on first tap
        }

        return true; // Exit on second tap within 2 seconds
      },
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, child) {
          return Scaffold(
            body: tabs[tabSelectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: redColor3,

              fixedColor: Colors.white,
              unselectedItemColor: Colors.white70,
              currentIndex: tabSelectedIndex,
              items:  <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'home'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: 'duty_txt'.tr(),

                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'menu_txt'.tr(),
                ),
              ],
              onTap: (index) {

                if (index == 0) {
                  setState(() {
                    tabSelectedIndex = index;
                  });
                  // Handle tapping on the HOME tab
                } else if (index == 1) {
                  setState(() {
                    tabSelectedIndex = index;
                  });
                  // Handle tapping on the DUTY tab
                }
                else if (index == 2) {
                  // Open bottom sheet for MENU tab
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // Set to true to occupy full screen height
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: pathL*4.1, // Adjust height factor as needed
                        child: MenuItemView(
                          onCloseBottomSheet: () {
                            Navigator.pop(context); // Close the bottom sheet
                          }, onTabSelected: (val ) {
                          setState(() {
                            tabSelectedIndex = val;
                          });
                        },
                        ),
                      );
                    },
                  );
                }

              },
              selectedLabelStyle: TextStyle( // Define the font style for labels
                fontSize: pathS/5.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
              unselectedLabelStyle: TextStyle( // Define the font style for labels
                fontSize: pathS/5.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            ),
          );
        },
      ),

    );

  }


}
