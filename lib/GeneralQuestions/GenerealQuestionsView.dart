import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/GeneralQuestions/HelpMaster.dart';

import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';

class GeneralQuestionsView extends StatefulWidget {
  const GeneralQuestionsView({super.key});

  @override
  GeneralQuestionsViewState createState() => GeneralQuestionsViewState();
}

class GeneralQuestionsViewState extends State<GeneralQuestionsView>{

  List<bool> showSubText = List.generate(5, (index) => false);

  late var groupedData = <String, List<HelpMaster>>{};

  @override
  void initState() {
    getHelpMasterTableData();
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
                          'faq'.tr(),
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

                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + pathS/2),
                  child: ListView.builder(
                    itemCount: groupedData.keys.length, // Number of unique categories
                    itemBuilder: (context, groupIndex) {
                      final groupKey = groupedData.keys.elementAt(groupIndex); // Get the category name
                      final groupItems = groupedData[groupKey]!; // Get the list of items for this category

                      return Padding(
                        padding: EdgeInsets.only(bottom: pathS / 2.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Category Header
                            SizedBox(
                              width: screenWidth - 2.5 * marginValue,
                              child: Text(
                                groupKey, // Show the group/category name
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 5,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: pathS / 8),
                            // Grouped Items
                            Container(
                              width: screenWidth - 2.5 * marginValue,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(pathS / 8),
                                color: isDarkMode ? greyColor8 : whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1), // Shadow color
                                    blurRadius: pathS / 10, // Spread of the shadow
                                    offset: Offset(-pathS / 12, pathS / 12),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: pathS / 4, top: pathS / 8, bottom: pathS / 8,right: pathS/4),
                                child: Column(
                                  children: List.generate(
                                    groupItems.length, // Number of items in the current group
                                        (index) => Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                showSubText[index] = !showSubText[index];
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    groupItems[index].title, // Display the item's title
                                                    style: TextStyle(
                                                      color: isDarkMode ? whiteColor : greyColor7,
                                                      fontSize: pathS / 5,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                SizedBox(width: pathS/8),
                                                SizedBox(
                                                  width: pathS / 6,
                                                  height: pathS / 6,
                                                  child: Image.asset(
                                                    showSubText[index]
                                                        ? "assets/images/dashboard-icons/up-arrow.png"
                                                        : "assets/images/dashboard-icons/down-arrow.png",
                                                    color: isDarkMode ? whiteColor : greyColor6,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: pathS / 12),
                                          // Show Details on Toggle
                                          Visibility(
                                            visible: showSubText[index],
                                            child: Padding(
                                              padding: EdgeInsets.only(right: pathS / 2),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      groupItems[index].detail ?? '', // Display the item's details
                                                      style: TextStyle(
                                                        color: isDarkMode ? whiteColor : greyColor4,
                                                        fontSize: pathS / 5,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: pathS / 12),
                                          Padding(
                                            padding: EdgeInsets.only(right: 16.0),
                                            child: Container(
                                              height: 1,
                                              color: isDarkMode ? greyColorDark : greyColor2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )

              ],
            ),
          ),



        ],
      ),
    );
  }


  Future<void> getHelpMasterTableData() async {
    final helpMasterList = await DatabaseHelper.instance.getAllRecords<HelpMaster>(
      keyTableHelpMaster,
          (map) => HelpMaster.fromMap(map),
    );

    if(helpMasterList.isEmpty){
      onLoadHelpData();
    }else {
      final createdGroup = <String, List<HelpMaster>>{};

      for (var item in helpMasterList) {
        final category = item.category;
        if (!createdGroup.containsKey(category)) {
          createdGroup[category] = [];
        }
        createdGroup[category]!.add(item);
      }

      // Print the grouped data
      createdGroup.forEach((key, value) {
        printInDebug('Category: $key');
        for (var item in value) {
          if (kDebugMode) {
            print(item.title);
          }
        }
      });

      setState(() {
        groupedData = createdGroup;
      });
    }

  }
  void onLoadHelpData() {


    // setState(() {
    //   showLoaderView = true;
    // });
    Map <String,String> inputData = {

    };

    APIHelper.instance.getData(helpMasterApi,inputData, (data) {

      // setState(() {
      //   showLoaderView = false;
      // });

      if(data.isNotEmpty){
        if (kDebugMode) {
          print(data);
        }
        List<HelpMaster> helpMasterList = data.map((json) => HelpMaster.fromJson(json)).toList();

        final createdGroup = <String, List<HelpMaster>>{};

        for (var item in helpMasterList) {
          final category = item.category;
          if (!createdGroup.containsKey(category)) {
            createdGroup[category] = [];
          }
          createdGroup[category]!.add(item);
        }

        // Print the grouped data
        createdGroup.forEach((key, value) {
          printInDebug('Category: $key');
          for (var item in value) {
            if (kDebugMode) {
              print(item.title);
            }
          }
        });

        setState(() {
          groupedData = createdGroup;
        });
        syncHelpMasterData(helpMasterList);

      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

    }
    );

  }
  Future<void> syncHelpMasterData(List<HelpMaster> helpData) async {
    await DatabaseHelper.instance.replaceTableData<HelpMaster>(keyTableHelpMaster, helpData, (help) =>
        help.toMap());
  }


}
