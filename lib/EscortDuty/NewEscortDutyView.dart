import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/EscortDuty/ApplyEscortDutyView.dart';
import 'package:mysis/Profile/UnitDutyPost.dart';

import '../Profile/UnitShiftDetail.dart';
import '../Profile/UserPosting.dart';
import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';

class NewEscortDutyView extends StatefulWidget {
  const NewEscortDutyView({super.key});

  @override
  NewEscortDutyViewState createState() => NewEscortDutyViewState();
}

class NewEscortDutyViewState extends State<NewEscortDutyView>{

  List<UnitDutyPost> unitDutyPost = [];
  List<UserPosting> userPosting = [];

  int selectedIndex = -1;

  UnitDutyPost? selectedUnitDutyPost ;
  UserPosting? selectedUserPosting;

  @override
  void initState() {
    getPostingTableData();
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
                        SizedBox(
                          width: pathS/5,
                          height: pathS/2,
                          child: Image.asset(
                            'assets/images/dashboard-icons/left-arrow.png',
                            color: isDarkMode ?  whiteColor:greyColor6,

                          ),

                        ),
                        SizedBox(width: pathS/8),
                        Text(
                          'New_Escort_Duty'.tr(),
                          style: TextStyle(
                            color: isDarkMode ?  whiteColor:greyColor5,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + pathS),
                    Text(
                      'select_unit'.tr(),
                      style: TextStyle(
                          color: isDarkMode ? Colors.white:greyColor5,
                          fontSize: pathS / 4,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto'
                      ),
                    ),
                    SizedBox(height: pathS/1.5),

                    if(userPosting.isNotEmpty)SizedBox(
                      height: screenHeight - 2*pathS/1.2 - pathL,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if(userPosting.isNotEmpty)UnitTileGroup(
                              userPostingData: userPosting,
                              items: unitDutyPost,
                              selectedId: selectedIndex,
                              callback: (int index, selectedPostingData) {
                                setState(() {
                                  selectedIndex = index;
                                });
                                selectedUnitDutyPost = unitDutyPost[index];
                                selectedUserPosting = selectedPostingData;


                              },
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Positioned(
                  bottom: 0,

                  child: GestureDetector(
                    onTap: (){


                    },
                    child: Container(
                      width: screenWidth,
                      height: pathS / 1.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDarkMode ? greyColor6:whiteColor,

                        // border: Border.all(color: Colors.yellow, width: pathS/18),
                        // borderRadius: BorderRadius.circular(pathS/3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.transparent, // Shadow color
                            blurRadius: pathS/10, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(-pathS/12, pathS/12),
                          ),
                        ],
                      ),

                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom,

                  child: Container(
                    width: screenWidth,
                    height: pathS / 1.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDarkMode ? greyColor6:whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor, // Shadow color
                          blurRadius: pathS/15, // Spread of the shadow
                          // spreadRadius: pathS/15, // How far the shadow extends
                          offset:  Offset(-1, -pathS/15),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding:  EdgeInsets.only(left: pathS/4,right: pathS/4),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: pathS/5,
                                  height: pathS/2,
                                  child: Image.asset(
                                    'assets/images/dashboard-icons/left-arrow.png',
                                    color: isDarkMode ?  whiteColor:greyColor3,

                                  ),

                                ),
                                SizedBox(width: pathS/12),
                                Text(
                                  'back'.tr().toUpperCase(),
                                  style: TextStyle(
                                    color: isDarkMode ?  whiteColor:greyColor3,
                                    fontSize: pathS / 5.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                              ],
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: (){
                             onTapNext();
                            },
                            child: Row(
                              children: [
                                Text(
                                  'next'.tr().toUpperCase(),
                                  style: TextStyle(
                                    color: isDarkMode ?  redColor3:redColor1,
                                    fontSize: pathS / 5.5,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: pathS/12),
                                SizedBox(
                                  width: pathS/5,
                                  height: pathS/2,
                                  child: Image.asset(
                                    'assets/images/dashboard-icons/right-arrow.png',
                                    color: isDarkMode ?  whiteColor:greyColor6,

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

              ],
            ),
          ),

        ],
      ),
    );
  }


  Future<void> getPostingTableData() async {

   final unitDutyPostData = await DatabaseHelper.instance.getAllRecords<UnitDutyPost>(
      keyTableUnitDutyPost,
          (map) => UnitDutyPost.fromMap(map),


    );

   final userPostingData = await DatabaseHelper.instance.getAllRecords<UserPosting>(
     keyTableUserPosting,
         (map) => UserPosting.fromMap(map),
   );

   final filteredUserPostingData = userPostingData.where((data) =>
   data.deleted == 0 && data.escortDutyAllowed == 1
   ).toList();

   if(unitDutyPostData.isNotEmpty && filteredUserPostingData.isNotEmpty) {
      printInDebug('All duty related data fetched');
      for (var data in filteredUserPostingData) {
        printInDebug('user posting  Data');
        data.toMap().forEach((i, j) {
          printInDebug('$i : $j');
        });
      }

      // for (var data in unitDutyPostData) {
      //   printInDebug('unit duty post  Data');
      //   data.toMap().forEach((i, j) {
      //     printInDebug('$i : $j');
      //   });
      // }
      setState(() {
        unitDutyPost = unitDutyPostData;
        userPosting = filteredUserPostingData;
      });
    }else{
      onLoadUserPostingData();
    }


  }
  void onLoadUserPostingData() {
    // setState(() {
    //   showLoaderView = true;
    // });

    Map <String, String> inputData = {
    };

    APIHelper.instance.getUserData(userPostingApi, inputData, (data) {

      // setState(() {
      //   showLoaderView = false;
      // });

      if (data.isNotEmpty) {
        if (data.containsKey('UserPosting')) {
          final List<dynamic> dataList = data['UserPosting'];

         final   userPostings = dataList.map((json) => UserPosting.fromJson(json)).toList();

          for (var data in userPostings) {
            printInDebug('userPosting ID: ${data.id}');
            printInDebug('userPosting  name: ${data.siteName}');
          }

          syncUserPostingData(userPostings);

        }
        if (data.containsKey('UnitDutyPost')) {
          final List<dynamic> dataList = data['UnitDutyPost'];
         final  unitDutyPosts = dataList.map((json) => UnitDutyPost.fromJson(json)).toList();
          unitDutyPosts.forEach((profile) {
            printInDebug('UnitDutyPost ID: ${profile.id}');
            printInDebug('UnitDutyPost  name: ${profile.postName}');
          });

          setState(() {
            unitDutyPost = unitDutyPosts;
          });

          syncUnitDutyPostData(unitDutyPosts);
        }
        if (data.containsKey('UnitShiftDetail')) {
          final List<dynamic> dataList = data['UnitShiftDetail'];
        final  unitShiftDetails = dataList.map((json) => UnitShiftDetail.fromJson(json)).toList();
          unitShiftDetails.forEach((profile) {
            printInDebug('UnitShiftDetail ID: ${profile.id}');
            printInDebug('UnitShiftDetail  name: ${profile.shiftName}');
          });

          syncUnitShiftDetailData(unitShiftDetails);


        }

      }
    }, (error) {
      // setState(() {
      //   showLoaderView = false;
      // });
      setState(() {
        // isAlertVisible = true;
        // alertMessage = '$error';
      });
    });
  }
  Future<void> syncUnitShiftDetailData(List<UnitShiftDetail> unitShiftDetails) async {
    await DatabaseHelper.instance.replaceTableData<UnitShiftDetail>(keyTableUnitShiftDetail, unitShiftDetails, (unitShiftDetail) =>
        unitShiftDetail.toMap());

  }
  Future<void> syncUnitDutyPostData(List<UnitDutyPost> unitDutyPosts) async {
    await DatabaseHelper.instance.replaceTableData<UnitDutyPost>(keyTableUnitDutyPost, unitDutyPosts, (unitDutyPosts) =>
        unitDutyPosts.toMap());

  }
  Future<void> syncUserPostingData(List<UserPosting> userPostings) async {
    await DatabaseHelper.instance.replaceTableData<UserPosting>(
        keyTableUserPosting,
        userPostings,
            (userPosting) => userPosting.toMap());

  }


  void onTapNext(){
    if(selectedUnitDutyPost == null || selectedUserPosting == null){
      return;
    }

    loadApplyEscortScreen();

  }

  void loadApplyEscortScreen(){
    Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => ApplyEscortDutyView(
           unitDutyPost: selectedUnitDutyPost!,
            userPosting: selectedUserPosting!,
          ),
        ),
    );
  }
}


class UnitTile extends StatelessWidget {
 final UserPosting selectedPosting;
  final int id;
  final Function(int,UserPosting) callback;
  final int selectedID;
  late double controlSize;
  final Color color;
  final double textSize;
  final String name;
  final String address;
  final String unit;


  UnitTile({super.key,
    required this.id,
    required this.callback,
    required this.selectedID,
    this.controlSize = 28,
    this.color = Colors.white,
    this.textSize = 14,
    required this.name,
    required this.address,
    required this.unit,
    required this.selectedPosting,
  });

  @override
  Widget build(BuildContext context) {
    final size = pathS/5;
    controlSize = pathS/4;

    return Padding(
      padding: EdgeInsets.only(bottom: pathS/8),
      child: GestureDetector(
        onTap: () {
          callback(id,selectedPosting);
        },
        child:Container(

          width: screenWidth-2.5*marginValue,

          decoration:  BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(pathS/8),
            color: isDarkMode?greyColor6:whiteColor,

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Shadow color
                blurRadius: pathS/10, // Spread of the shadow
                // spreadRadius: pathS/15, // How far the shadow extends
                offset:  Offset(-pathS/12, pathS/12),
              ),
            ],
          ),

          child:  Padding(
            padding:  EdgeInsets.all(pathS/4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        SizedBox(
                          width: 2*pathL,
                          child: Text(
                            name,
                            style: TextStyle(
                              color: isDarkMode ? whiteColor:greyColor6,
                              fontSize: pathS/5,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(width: pathS/8),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            selectedID == id ? Icons.radio_button_on: Icons.radio_button_off,
                            size: pathS/4,
                            color: isDarkMode ? greenColor5:greenColor6,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: pathS/25),
                    SizedBox(
                      width: 2*pathL,
                      child: Text(
                        address,
                        style: TextStyle(
                          color: isDarkMode ? whiteColor:greyColor5,
                          fontSize: pathS/6.5,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: pathS/8),
                    SizedBox(
                      width: 2*pathL,
                      child: Text(
                        unit,
                        style: TextStyle(
                          color: isDarkMode ? whiteColor:greyColor6,
                          fontSize: pathS/5,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.left,
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
  }


}

class UnitTileGroup extends StatelessWidget {
  final List<UserPosting> userPostingData;

  final List<UnitDutyPost> items;
  final int selectedId;
  final Function(int,UserPosting) callback;

  const UnitTileGroup({super.key,
    required this.items,
    required this.selectedId,
    required this.callback,
    required this.userPostingData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: userPostingData.asMap().map((index, item) {
        final indexNo = index;
        final name = item.siteName;
        final address = item.siteAddress;
        final unitCode = item.unitCode;

        // final UserPosting? selectedPosting = getUserPostingForUnit(unitCode);

        return MapEntry(
          index,
          UnitTile(
            id: indexNo,
            callback: callback,
            selectedID: selectedId,
            name: name,
           address: address,
            unit: unitCode,
            selectedPosting: item,
          ),
        );
      }).values.toList(), // Convert MapEntry values to a list
    );
  }


  UserPosting? getUserPostingForUnit(String unitCode) {
    for (var data in userPostingData) {
      if (data.unitCode == unitCode) {
        return data; // Return the matching LeaveType
      }
    }
    return null; // Return null if no matching LeaveType is found
  }



}