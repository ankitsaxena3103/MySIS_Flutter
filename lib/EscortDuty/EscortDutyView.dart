import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/EscortDuty/EscortDuty.dart';
import 'package:mysis/EscortDuty/EscortDutyHistoryView.dart';
import 'package:mysis/EscortDuty/NewEscortDutyView.dart';

import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';

class EscortDutyView extends StatefulWidget {
  @override
  EscortDutyViewState createState() => EscortDutyViewState();
}

class EscortDutyViewState extends State<EscortDutyView>{

  @override
  void initState() {
    onLoadEscortDutyData();
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
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Container(
                          width: pathS/5,
                          height: pathS/2,
                          child: Image.asset(
                            'assets/images/dashboard-icons/left-arrow.png',
                            color: isDarkMode ?  whiteColor:greyColor6,

                          ),

                        ),
                        SizedBox(width: pathS/8),
                        Text(
                          'Escort_Duty'.tr(),
                          style: TextStyle(
                            color: isDarkMode ?  whiteColor:greyColor6,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        onLoadEscortDutyHistory();
                      },
                      child: Container(
                        width: pathL*2,
                        height: pathS / 1.5,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:  isDarkMode ? redColor3:redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                          borderRadius: BorderRadius.circular(pathS/3),
                          boxShadow: [
                            BoxShadow(
                              color:  shadowColor,
                              blurRadius: pathS/10, // Spread of the shadow
                              // spreadRadius: pathS/15, // How far the shadow extends
                              offset:  Offset(-pathS/12, pathS/12),
                            ),
                          ],
                        ),
                        child: Text(
                          'Escort_Duty_Histroy'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor:whiteColor,
                            fontSize: pathS / 4.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: pathS/5),
                    GestureDetector(
                      onTap: (){
                        onLoadNewEscortDuty();

                      },
                      child: Container(
                        width: pathL*2,
                        height: pathS / 1.5,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:  isDarkMode ? redColor3:redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                          borderRadius: BorderRadius.circular(pathS/3),
                          boxShadow: [
                            BoxShadow(
                              color:  shadowColor,
                              blurRadius: pathS/10, // Spread of the shadow
                              // spreadRadius: pathS/15, // How far the shadow extends
                              offset:  Offset(-pathS/12, pathS/12),
                            ),
                          ],
                        ),
                        child: Text(
                          'New_Escort_Duty'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor:whiteColor,
                            fontSize: pathS / 4.5,
                            fontWeight: FontWeight.bold,
                          ),
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

  void onLoadEscortDutyData() {


    // setState(() {
    //   showLoaderView = true;
    // });
    Map <String,String> inputData = {

    };

    APIHelper.instance.getData(escortDutyApi,inputData, (data) {

      // setState(() {
      //   showLoaderView = false;
      // });

      if(data.isNotEmpty){

        List<EscortDuty> escortDutyData = data.map((json) => EscortDuty.fromJson(json)).toList();

        for (var data in escortDutyData) {
          printInDebug('EscortDuty  Data');
          data.toMap().forEach((i, j) {
            printInDebug('$i : $j');
          });
        }

        if(escortDutyData.isNotEmpty){
          saveEscortDutyData(escortDutyData);
        }

      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

    }
    );

  }
  Future<void> saveEscortDutyData(List<EscortDuty> escortDuty) async {

    await DatabaseHelper.instance.updateOrDeleteTableData<EscortDuty>(
        keyTableEscortDuty,
        escortDuty,
        'id',
            (escortDuties) => escortDuties.toMap()
    );

  }

  void onLoadEscortDutyHistory(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EscortDutyHistoryView(),
      ),
    );
  }

  void onLoadNewEscortDuty(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewEscortDutyView(),
      ),
    );
  }


}
