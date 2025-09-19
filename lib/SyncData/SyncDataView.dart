import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/EscortDuty/EscortDuty.dart';
import 'package:mysis/GeneralQuestions/HelpMaster.dart';
import 'package:mysis/Leaves/LeaveType.dart';
import 'package:mysis/Leaves/UserLeaves.dart';
import 'package:mysis/Notifications/UserNotification.dart';
import 'package:mysis/Profile/ContactSIS.dart';
import 'package:mysis/Profile/UnitDutyPost.dart';
import 'package:mysis/SharedClasses/DatabaseHelper.dart';

import '../CommonViews/AlertPopupView.dart';
import '../CommonViews/LoaderView.dart';
import '../CommonViews/ToastMessageView.dart';
import '../HomeView/UserAttendance.dart';
import '../HomeView/UserRoaster.dart';
import '../Profile/UnitShiftDetail.dart';
import '../Profile/UserPosting.dart';
import '../Profile/UserProfile.dart';
import '../SharedClasses/APIHelper.dart';

class SyncDataView extends StatefulWidget {
  const SyncDataView({super.key});

  @override
  SyncDataViewState createState() => SyncDataViewState();
}

class SyncDataViewState extends State<SyncDataView> {

  bool noData = true;

  List<Map<String, dynamic>> tableRecords = [];
  List<Map<String, dynamic>> allTablesToClear = [];

  bool showLoaderView = false;

  bool showAlert = false;
  String alertHeader = '';
  String alertMessage = '';

  bool showToastMessageView = false;
  String toastMessage = '';


  @override
  void initState()  {
     fetchAndShowTableRecords();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [

          Container(
            width: logicalWidth,
            height: logicalHeight,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: isDarkMode ? backgroundGradientDark : backgroundGradient,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: MediaQuery
                      .of(context)
                      .padding
                      .top + pathS / 12,
                  left: paddingLeft + pathS / 3,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: pathS / 5,
                          height: pathS / 2,
                          child: Image.asset(
                            'assets/images/dashboard-icons/left-arrow.png',
                            color: isDarkMode ? whiteColor : greyColor6,

                          ),

                        ),
                        SizedBox(width: pathS / 8),
                        Text(
                          'txt_sync'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
                            fontSize: pathS / 5.5,
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
                    // Header widget
                    SizedBox(height: MediaQuery.of(context).padding.top +pathS/1.2),
                    // Container(
                    //   alignment: Alignment.center,
                    //   width: screenWidth - 2.5 * marginValue,
                    //
                    //   child: Padding(
                    //     padding: EdgeInsets.only(bottom: pathS / 3, top: pathS / 8,left: pathS / 12, right: pathS / 12),
                    //     child: Row(
                    //       children: [
                    //         Expanded(
                    //           child: Text(
                    //             'record_name'.tr().toUpperCase(),
                    //             style: TextStyle(
                    //               color: isDarkMode ? whiteColor : greyColor3,
                    //               fontSize: pathS / 6.5,
                    //               fontWeight: FontWeight.w700,
                    //               fontFamily: 'Roboto',
                    //             ),
                    //             textAlign: TextAlign.left,
                    //           ),
                    //         ),
                    //         Expanded(
                    //           child: Text(
                    //             'sync_date_time'.tr().toUpperCase(),
                    //             style: TextStyle(
                    //               color: isDarkMode ? whiteColor : greyColor3,
                    //               fontSize: pathS / 6.5,
                    //               fontWeight: FontWeight.w700,
                    //               fontFamily: 'Roboto',
                    //             ),
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ),
                    //         Expanded(
                    //           child: Text(
                    //             'total_records'.tr().toUpperCase(),
                    //             style: TextStyle(
                    //               color: isDarkMode ? whiteColor : greyColor3,
                    //               fontSize: pathS / 6.5,
                    //               fontWeight: FontWeight.w700,
                    //               fontFamily: 'Roboto',
                    //             ),
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ),
                    //         Expanded(
                    //           child: Text(
                    //             'un_synced_records'.tr().toUpperCase(),
                    //             style: TextStyle(
                    //               color: isDarkMode ? whiteColor : greyColor3,
                    //               fontSize: pathS / 6.5,
                    //               fontWeight: FontWeight.w700,
                    //               fontFamily: 'Roboto',
                    //             ),
                    //             textAlign: TextAlign.right,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    //
                    SizedBox(
                      height: screenHeight - 2*pathS/1.2,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: tableRecords.map((table) {
                            return  Column(
                              children: [
                                Container(
                                  // alignment: Alignment.center,
                                  width: screenWidth - 2.5 * marginValue,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(pathS / 8),
                                    color: isDarkMode ? greyColor8 : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1), // Shadow color
                                        blurRadius: pathS / 10, // Spread of the shadow
                                        offset: Offset(-pathS / 12, pathS / 12),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: pathS / 4, right: pathS / 4),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: pathS / 6, top: pathS / 4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    formatTableName(table['tableName']),
                                                    style: TextStyle(
                                                      color: isDarkMode ? whiteColor : greyColorDark,
                                                      fontSize: pathS / 4.8,
                                                      fontWeight: FontWeight.w800,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    formatDateTime(table['latestUpdateTime']),
                                                    style: TextStyle(
                                                      color: isDarkMode ? whiteColor : greyColor3,
                                                      fontSize: pathS / 6.5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {

                                                      if(table['totalRecords'] ==  0)  {
                                                        showToastView('no_records_to_clear'.tr());
                                                        return;
                                                      }

                                                      clearData(table['tableName']);
                                                    },
                                                    child: Row(
                                                      crossAxisAlignment:CrossAxisAlignment.center,
                                                      children: [
                                                        // Text(
                                                        //   'clear_data'.tr().toUpperCase(),
                                                        //   style: TextStyle(
                                                        //     color: isDarkMode ? redColor1 : redColor3,
                                                        //     fontSize: pathS / 5.5,
                                                        //     fontWeight: FontWeight.w500,
                                                        //     fontFamily: 'Roboto',
                                                        //   ),
                                                        //   textAlign: TextAlign.center,
                                                        // ),
                                                        // SizedBox(width: pathS/25),
                                                        Column(
                                                          children: [
                                                            Container(
                                                              width: pathS/2,
                                                              height: pathS/2,
                                                              decoration:  BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color:   whiteColor,

                                                              ),
                                                              child: Image.asset(
                                                                'assets/images/sync/clear.png',
                                                                // color: isDarkMode ? whiteColor:greyColor6,
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: pathS/8),
                                                  GestureDetector(
                                                    onTap: () {
                                                      // Handle sync data action
                                                      uploadData(table['tableName']);
                                                      syncData(table['tableName']);

                                                    },
                                                    child: Row(
                                                      children: [
                                                        // Text(
                                                        //   'sync_data'.tr().toUpperCase(),
                                                        //   style: TextStyle(
                                                        //     color: isDarkMode ? whiteColor : greyColor6,
                                                        //     fontSize: pathS / 5.5,
                                                        //     fontWeight: FontWeight.w500,
                                                        //     fontFamily: 'Roboto',
                                                        //   ),
                                                        //   textAlign: TextAlign.center,
                                                        // ),
                                                        // SizedBox(width: pathS/25), // Space between icon and text
                                                        Column(
                                                          children: [
                                                            SizedBox(
                                                              width: pathS/2,
                                                              height: pathS/2,

                                                              child: Image.asset(
                                                                'assets/images/sync/sync.png',
                                                              ),
                                                            ),
                                                            // SizedBox(height: pathS/25),
                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: isDarkMode ? greyColorDark : greyColor1,
                                          height: 1.5,

                                        ),

                                        Padding(
                                          padding:  EdgeInsets.only(top: pathS/6,bottom: pathS/6),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'no_of_records'.tr(),
                                                    style: TextStyle(
                                                      color: isDarkMode ? redColor1 : redColor3,
                                                      fontSize: pathS / 6.5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    '${table['totalRecords']}',
                                                    style: TextStyle(
                                                      color: isDarkMode ? whiteColor : greyColor6,
                                                      fontSize: pathS / 5,
                                                      fontWeight: FontWeight.w800,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                             if(table['unsyncedRecords'] != null) Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'unsync_records'.tr(),
                                                    style: TextStyle(
                                                      color: isDarkMode ? redColor1 : redColor3,
                                                      fontSize: pathS / 6.5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    table['unsyncedRecords'] == null ? '0': '${table['unsyncedRecords']}',
                                                    style: TextStyle(
                                                      color: isDarkMode ? whiteColor : greyColor6,
                                                      fontSize: pathS / 5,
                                                      fontWeight: FontWeight.w800,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.right,
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
                                SizedBox(height: pathS/5),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),//next duties

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
                      // border: Border.all(color: Colors.yellow, width: pathS/18),
                      // borderRadius: BorderRadius.circular(pathS/3),
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
                      padding:  EdgeInsets.only(left: pathS/3,right: pathS/4),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){

                              onTapClearAll();

                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'clear_all_data'.tr().toUpperCase(),
                                  style: TextStyle(
                                    color: isDarkMode ?  redColor1:redColor3,
                                    fontSize: pathS / 5.5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: pathS/10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: pathS/4,
                                      height: pathS/4,
                                      decoration:  BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:   whiteColor,

                                      ),

                                      child: Image.asset(
                                        'assets/images/sync/clear.png',
                                      ),
                                    ),
                                    SizedBox(height: pathS/30),
                                  ],
                                ),

                              ],
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              GestureDetector(
                                onTap:(){
                                  onTapSyncAll();
                                 },
                                child: Container(
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(pathS/4),
                                    color: isDarkMode ?  redColor1:redColor3,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25), // Shadow color
                                        blurRadius: pathS/25, // Spread of the shadow
                                        // spreadRadius: pathS/15, // How far the shadow extends
                                        offset:  Offset(-pathS/48, pathS/18),
                                      ),
                                    ],
                                  ),

                                  child: Padding(
                                    padding:  EdgeInsets.only(left:pathS/4,right: pathS/4,top: pathS/12,bottom: pathS/15),
                                    child: Row(
                                      children: [
                                        Text(
                                          'sync_all_data'.tr().toUpperCase(),
                                          style: TextStyle(
                                            color: isDarkMode ?  whiteColor:whiteColor,
                                            fontSize: pathS / 5.5,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(width: pathS/15),
                                        SizedBox(
                                          width: pathS/3,
                                          height: pathS/3,

                                          child: Image.asset(
                                            'assets/images/sync/sync.png',
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: showAlert,
                  child: AlertPopupView(
                    header: alertHeader,
                    message: alertMessage,
                    cancelBtn: 'No'.tr(),
                    okBtn: 'Yes'.tr(),
                    callBack:(val){
                      setState(() {
                        showAlert = false;
                      });
                      if(val == 1){
                        setState(() {
                          showLoaderView = true;
                        });
                        clearData();
                      }
                    },
                  ),
                ),

                LoaderView(isVisible: showLoaderView, message: ''),
                ToastMessageView(isVisible: showToastMessageView, message: toastMessage),


              ],
            ),
          ),

        ],
      ),
    );
  }


  void onTapClearAll(){
    setState(() {
       showAlert = true;
       alertHeader = 'alert'.tr();
       alertMessage = 'clear_all_msg'.tr();
    });

  }

  Future<void> clearData([String? tableName]) async {
    // 🔹 First upload unsynced data
    await uploadData(tableName);

    setState(() {
      showLoaderView = true;
    });

    DatabaseHelper dbHelper = DatabaseHelper.instance;

    if (tableName == null || tableName == keyTableUserProfile) {
      await dbHelper.clearTable(keyTableUserProfile);
    }

    if (tableName == null || tableName == keyTableUserPosting) {
      await dbHelper.clearTable(keyTableUserPosting);
    }

    if (tableName == null || tableName == keyTableUnitDutyPost) {
      await dbHelper.clearTable(keyTableUnitDutyPost);
    }

    if (tableName == null || tableName == keyTableUnitShiftDetail) {
      await dbHelper.clearTable(keyTableUnitShiftDetail);
    }

    if (tableName == null || tableName == keyTableUserRoster) {
      await dbHelper.clearTable(keyTableUserRoster);
    }

    if (tableName == null || tableName == keyTableUserAttendance) {
      await dbHelper.clearTable(keyTableUserAttendance);
    }

    if (tableName == null || tableName == keyTableLeaveType) {
      await dbHelper.clearTable(keyTableLeaveType);
    }

    if (tableName == null || tableName == keyTableUserLeave) {
      await dbHelper.clearTable(keyTableUserLeave);
    }

    if (tableName == null || tableName == keyTableHelpMaster) {
      await dbHelper.clearTable(keyTableHelpMaster);
    }

    if (tableName == null || tableName == keyTableEscortDuty) {
      await dbHelper.clearTable(keyTableEscortDuty);
    }

    fetchAndShowTableRecords();
  }

  void onTapSyncAll() async {
    // 🔹 Upload before syncing fresh data
    await uploadData();

    // 🔹 Now fetch new data from server
    await syncData();
  }

  Future<void> uploadData([String? tableName]) async {
    if (tableName == null || tableName == keyTableUserAttendance) {
      await uploadTableDataToServer(
        tableName: keyTableUserAttendance,
        idColumn: "id",
        apiUrl: userAttendancePostApi,
      );
    }

    if (tableName == null || tableName == keyTableUserLeave) {
      await uploadTableDataToServer(
        tableName: keyTableUserLeave,
        idColumn: "id",
        apiUrl: userLeavesPostApi,
      );
    }

    if (tableName == null || tableName == keyTableEscortDuty) {
      await uploadTableDataToServer(
        tableName: keyTableEscortDuty,
        idColumn: "id",
        apiUrl: escortDutyPostApi,
      );
    }
  }

  Future<void> syncData([String? tableName])async {
    if (tableName == null || tableName == keyTableUserProfile) {
      fetchAndSyncData<UserProfile>(
        apiUrl: profileApi,
        tableName: keyTableUserProfile,
        fromJson: (json) => UserProfile.fromJson(json),
        toMap: (data) => data.toMap(),
      );
    }

    if (tableName == null || tableName == keyTableUserPosting ||  tableName == keyTableUnitDutyPost || tableName == keyTableUnitShiftDetail) {
      fetchAndSyncUserPostingData();
    }

    if (tableName == null || tableName == keyTableUserRoster) {
      fetchAndSyncData<UserRoaster>(
        apiUrl: userRosterApi,
        tableName: keyTableUserRoster,
        fromJson: (json) => UserRoaster.fromJson(json),
        toMap: (data) => data.toMap(),
      );
    }


    if (tableName == null || tableName == keyTableUserAttendance) {
      fetchAndSyncData<UserAttendance>(
        apiUrl: userAttendanceApi,
        tableName: keyTableUserAttendance,
        fromJson: (json) => UserAttendance.fromJson(json),
        toMap: (data) => data.toMap(),
      );
    }

    if (tableName == null || tableName == keyTableLeaveType) {
      fetchAndSyncData<LeaveType>(
        apiUrl: leaveTypeMasterApi,
        tableName: keyTableLeaveType,
        fromJson: (json) => LeaveType.fromJson(json),
        toMap: (data) => data.toMap(),
      );
    }

    if (tableName == null || tableName == keyTableUserLeave) {
      fetchAndSyncData<UserLeaves>(
        apiUrl: userLeavesApi,
        tableName: keyTableUserLeave,
        fromJson: (json) => UserLeaves.fromJson(json),
        toMap: (data) => data.toMap(),
      );
    }

    if (tableName == null || tableName == keyTableHelpMaster) {
      fetchAndSyncData<HelpMaster>(
        apiUrl: helpMasterApi,
        tableName: keyTableHelpMaster,
        fromJson: (json) => HelpMaster.fromJson(json),
        toMap: (data) => data.toMap(),
      );
    }

    if (tableName == null || tableName == keyTableEscortDuty) {
      fetchAndSyncData<EscortDuty>(
        apiUrl: escortDutyApi,
        tableName: keyTableEscortDuty,
        fromJson: (json) => EscortDuty.fromJson(json),
        toMap: (data) => data.toMap(),
      );
    }

  }


  Future<void> fetchAndShowTableRecords() async {
    tableRecords = [];
    allTablesToClear.clear();

    final allTablesData = await DatabaseHelper.instance.getTableRecords();

    // Allowed table names
    final allowedTables = {
      'UserProfile',
      'UserPosting',
      'UnitShiftDetail',
      'UnitDutyPost',
      'UserRoster',
      'UserAttendance',
      'UserLeaves',
      'LeaveType',
      'EscortDuty',
      'HelpMaster',
      //'GeneralRules'//need to add once created
    };



    // Filter only allowed tables
    final filteredTables = allTablesData.where((tableRecord) {
      return allowedTables.contains(tableRecord['tableName']);
    }).toList();

    // Process only filtered tables
    for (var tableRecord in filteredTables) {
      if (tableRecord['unsyncedRecords'] == 0) {
        allTablesToClear.add(tableRecord);
      }
    }

    if (filteredTables.isNotEmpty) {
      setState(() {
        tableRecords = filteredTables;
      });
    }

    setState(() {showLoaderView = false;});


  }


  String formatTableName(String tableName) {
    // Add a space before each uppercase letter (except the first character)
    String formattedName = tableName.replaceAllMapped(
      RegExp(r'(?<!^)([A-Z])'), // Matches uppercase letters not at the start
          (Match match) => ' ${match.group(0)}',
    );

    // Capitalize the first letter of each word
    return formattedName.split(' ').map((word) =>
    word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
  }
  String formatDateTime(String? updatedAt) {
    try {
      // Parse the updatedAt string or use the current time if null
      DateTime latestUpdateTime = DateTime.parse(updatedAt!);


      // Format the DateTime
      return DateFormat('yy-MM-dd hh:mm a').format(latestUpdateTime);
    } catch (e) {
      // Return a single quote in case of parsing failure
      return "'";
    }
  }


  Future<void> fetchAndSyncData<T>({
    required String apiUrl,
    required String tableName,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toMap,
  }) async {
    try {
      setState(() {
        showLoaderView = true;
      });
      Map<String, String> inputData = {};

      APIHelper.instance.getData(apiUrl, inputData, (data) async {
        if (data.isNotEmpty) {
          // Convert the response data to a list of objects
          List<T> dataList = data.map<T>((json) => fromJson(json)).toList();

          // Sync the data with the database
          await DatabaseHelper.instance.updateOrDeleteTableData<T>(
            tableName,
            dataList,
            'id', // Assuming 'id' is the primary key for all tables
            toMap,
          );
          fetchAndShowTableRecords();
          printInDebug('Data synced for $tableName');
          setState(() {
            showLoaderView = false;
          });
        }
      }, (error) {
        printInDebug('Error fetching data for $tableName: $error');
        setState(() {
          showLoaderView = false;
        });
      });
    } catch (e) {
      printInDebug('Error in fetchAndSyncData: $e');
      setState(() {
        showLoaderView = false;
      });
    }
  }

  void fetchAndSyncUserPostingData() {
    setState(() {
      showLoaderView = true;
    });

    Map <String, String> inputData = {
    };

    APIHelper.instance.getUserData(userPostingApi, inputData, (data) {

      setState(() {
        showLoaderView = false;
      });

      if (data.isNotEmpty) {
        if (data.containsKey('UserPosting')) {
          final List<dynamic> dataList = data['UserPosting'];
         final userPostings = dataList.map((json) => UserPosting.fromJson(json)).toList();


          syncUserPostingData(userPostings);

        }
        if (data.containsKey('UnitDutyPost')) {
          final List<dynamic> dataList = data['UnitDutyPost'];
         final unitDutyPosts = dataList.map((json) => UnitDutyPost.fromJson(json)).toList();


          syncUnitDutyPostData(unitDutyPosts);
        }
        if (data.containsKey('UnitShiftDetail')) {
          final List<dynamic> dataList = data['UnitShiftDetail'];
        final  unitShiftDetails = dataList.map((json) => UnitShiftDetail.fromJson(json)).toList();


          syncUnitShiftDetailData(unitShiftDetails);


        }
        fetchAndShowTableRecords();

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


  Future<void> uploadTableDataToServer({
    required String tableName,
    required String idColumn,
    required String apiUrl,
  }) async {
    final dirtyRows = await DatabaseHelper.instance.getDirtyRows(tableName);

    if (dirtyRows.isEmpty) {
      printInDebug("No dirty rows found for $tableName");
      return;
    }

    APIHelper.instance.postAllData(
      apiUrl,
      dirtyRows,
          (responseData) async {
        if (responseData.isNotEmpty) {
          for (var record in responseData) {
            final idValue = record['ID']; // assumes API response has "ID"
            if (idValue != null) {
              await DatabaseHelper.instance.markRowSynced(tableName, idColumn, idValue);
            }
          }
        } else {
          printInDebug("Empty response for $tableName");
        }
      },
          (error) {
        printInDebug("Error uploading $tableName: $error");
      },
    );
  }





  void showToastView(String message) {
    setState(() {
      showToastMessageView = true;
      toastMessage = message;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showToastMessageView = false;
      });
    });
  }


  // User Profile
  // User Posting
  // Roster
  // Attendance
  // Leave
  // Escort Duty
  // FAQ
  // General Rule

  //  'UserProfile';
  // 'UserPosting';
  //  'UnitShiftDetail';
  // 'UnitDutyPost';
  // 'UserRoster';
  // UserAttendance
  // UserLeaves
  // LeaveType
  // EscortDuty
  // HelpMaster



}

// Define your sync keys
enum SyncTarget {
  all,
  userProfile,
  userPosting,
  userRoster,
  userNotification,
  userAttendance,
  leaveType,
  userLeaves,
  helpMaster,
  escortDuty,
}

// Main sync method
