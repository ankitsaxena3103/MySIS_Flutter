
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/HomeView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/MenuItemView.dart';
import 'package:mysis/DutyView.dart';
class MyTabBarView extends StatefulWidget {
  @override
  MyTabBarViewState createState() => MyTabBarViewState();
}

class MyTabBarViewState extends State<MyTabBarView> {
  int tabSelectedIndex = 0;
  late List<Widget> tabs;
  // late PersistentBottomSheetController bottomSheetController; // Declare a controller variable

  @override
  void initState() {
    super.initState();
    tabs = [
      HomeView(),
      DutyView(),
      MenuItemView(
        onCloseBottomSheet: () {
          // Close the bottom sheet
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
    return Scaffold(
      body: tabs[tabSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(195, 50, 53, 1).withOpacity(1),
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: tabSelectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'DUTY',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'MENU',
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
                return FractionallySizedBox(
                  heightFactor: 0.8, // Adjust height factor as needed
                  child: MenuItemView(
                    onCloseBottomSheet: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                  ),
                );
              },
            );
          }

        },
      ),
    );
  }


}
