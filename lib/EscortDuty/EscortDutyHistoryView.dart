

import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/EscortDuty/EscortDuty.dart';
import 'package:mysis/Leaves/ApplyLeaveView.dart';
import 'package:mysis/Leaves/CancelRequestView.dart';
import 'package:mysis/Leaves/UserLeaves.dart';

import '../CommonViews/SuccessAlertView.dart';
import '../Profile/UserPosting.dart';
import '../SharedClasses/DatabaseHelper.dart';

class EscortDutyHistoryView extends StatefulWidget {
  const EscortDutyHistoryView({super.key});

  @override
  EscortDutyHistoryViewState createState() => EscortDutyHistoryViewState();
}

class EscortDutyHistoryViewState extends State<EscortDutyHistoryView>{

  bool isNoData = false;
  bool isUnSyncedData = true;

  bool isSucces  = false;
  bool isCancel = false;
  String dutyReason = '';
  String dutyDate = '';

  List<EscortDuty> escortDuties = [];
  List<UserPosting> userPostings = [];

  @override
  void initState() {
    getUserPostingTableData();
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    isNoData = escortDuties.isNotEmpty ? false : true;

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
                    behavior: HitTestBehavior.translucent,
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
                          'Escort_Duty_Histroy'.tr(),
                          style: TextStyle(
                            color: isDarkMode ?  whiteColor:greyColor6,
                            fontSize: pathS / 5,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.left,
                        ),

                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isNoData,
                  child: Padding(
                    padding:  EdgeInsets.all(pathS/2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'no_data'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
                            fontSize: pathS / 4,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: pathS/12),
                        Text(
                          'no_data_available'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor3,
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
                  children: [
                    SizedBox(height: pathL),
                    SizedBox(
                      height: screenHeight -pathL,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: escortDuties.map((duty) {
                            return   Column(
                              children: [
                                Container(
                                  // alignment: Alignment.center,
                                  width: screenWidth - 2*marginValue,
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(pathS/8),
                                    color: isDarkMode?greyColor8:Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1), // Shadow color
                                        blurRadius: pathS/10, // Spread of the shadow
                                        // spreadRadius: pathS/15, // How far the shadow extends
                                        offset:  Offset(-pathS/12, pathS/12),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding:  EdgeInsets.only(bottom: pathS/4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: pathS/5),
                                        Padding(
                                          padding:  EdgeInsets.only(left: pathS/4,right: pathS/4),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    duty.formattedEscortDutyDate,
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteColor:greyColor5,
                                                      fontSize: pathS /6.5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    getStatusMessage(duty.status) ,
                                                    style: TextStyle(
                                                      color: getStatusColor(duty.status),
                                                      fontSize: pathS /6.5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: pathS/20),
                                              Text(
                                                postingName(duty.unitCode),
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor6,
                                                  fontSize: pathS /5.5,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                postingAddress(duty.unitCode),
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor5,
                                                  fontSize: pathS /6,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              SizedBox(height: pathS/20),

                                              Text(
                                                duty.unitCode,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor6,
                                                  fontSize: pathS /5.5,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
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


  Future<void> getEscortDutyTableData() async {

    final duties = await DatabaseHelper.instance.getAllRecords<EscortDuty>(
      keyTableEscortDuty,
          (map) => EscortDuty.fromMap(map),
    );



    for (var data in duties) {
      printInDebug('Escort Data');
      data.toMap().forEach((i, j) {
        printInDebug('$i : $j');
      });
    }

    final filteredData = duties.where((leave) =>
     leave.deleted == 0
    ).toList();

    filteredData.sort((a, b) => b.startDate.compareTo(a.startDate));

    if(filteredData.isNotEmpty) {
      setState(() {
        escortDuties = filteredData;
      });


    }



  }

  Future<void> getUserPostingTableData() async {

    final postings = await DatabaseHelper.instance.getAllRecords<UserPosting>(
      keyTableUserPosting,
          (map) => UserPosting.fromMap(map),
    );


    final filterPostings = postings.where((data) =>
    data.deleted == 0
    ).toList();

    if(filterPostings.isNotEmpty) {
      setState(() {
        userPostings = filterPostings;
      });

      for (var data in userPostings) {
        printInDebug('user postings Data');
        data.toMap().forEach((i, j) {
          printInDebug('$i : $j');
        });
      }
      getEscortDutyTableData();

    }

  }


  String postingName(String unitId){

    printInDebug(unitId);
    String siteName = 'N/A';
    
    for(var data in userPostings){
      if(data.unitCode == unitId){

        siteName = data.siteName;
        break;
      }
    }
    
    return siteName;

  }
  String postingAddress(String unitId){

    printInDebug(unitId);
    String siteName = 'N/A';

    for(var data in userPostings){
      if(data.unitCode == unitId){

        siteName = data.siteAddress;
        break;
      }
    }

    return siteName;

  }

  String getAssetImage(int status){

    if(status == 0){
      return 'assets/images/icons/status-pending.png';
    }
    if(status == 1) {
      return 'assets/images/icons/status-done.png';
    }
    if(status == 2) {
      return 'assets/images/icons/status-rejected.png';
    }

    return 'assets/images/icons/status-pending.png';
  }
  Color getStatusColor(int status){
    Color statusColor = greyColor6;

    if(status == 0){
      statusColor = isDarkMode ? orangeColor:orangeColor1;
    }

    if(status == 1){
      statusColor = isDarkMode ? greenColor5:greenColor6;
    }

    if(status == 2){
      statusColor = isDarkMode ? redColor1:redColor3;
    }

    return statusColor;
  }
  String getStatusMessage(int status){
    String statusMessage = '';

    if(status == 0){
      statusMessage = 'in_progress'.tr();
    }

    if(status == 1){
      statusMessage = 'approved'.tr();
    }

    if(status == 2){
      statusMessage = 'rejected'.tr();
    }

    return statusMessage;
  }



}
