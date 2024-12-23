

import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Leaves/ApplyLeaveView.dart';

class LeaveRecordsView extends StatefulWidget {
  @override
  LeaveRecordsViewState createState() => LeaveRecordsViewState();
}

class LeaveRecordsViewState extends State<LeaveRecordsView>{

  bool noData = false;
  @override
  void initState() {
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
                          'leave_records'.tr(),
                          style: TextStyle(
                            color: isDarkMode ?  whiteColor:greyColor6,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.center,
                        ),

                      ],
                    ),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+pathS/1.5),
                  child: ListView.builder(
                    itemCount: 3, // Change this to the number of times you want to repeat the top column
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:  EdgeInsets.only(bottom: pathS/5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: screenWidth - 2.5*marginValue,
                              // height: pathS/1.2,
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
                                padding:  EdgeInsets.only(bottom: pathS/4,top: pathS/4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Padding(
                                      padding:  EdgeInsets.only(left: pathS/4,right: pathS/4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Reason',
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor6,
                                                  fontSize: pathS /5.5,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              SizedBox(width: pathS/8),
                                              Text(
                                                '2' +' '+ 'day'.tr() ,
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor6,
                                                  fontSize: pathS /6.5,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              Spacer(),

                                            ],
                                          ),
                                          SizedBox(height: pathS/8),
                                          Text(
                                            '25 Feb - 25 Mar',
                                            style: TextStyle(
                                              color: isDarkMode ?  whiteColor:greyColor6,
                                              fontSize: pathS /3.5,
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

                          ],
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),
          ),



        ],
      ),
    );
  }

  String getAssetImage(String status){
    if(status == 'Approved') {
      return 'assets/images/icons/status-done.png';
    }
    if(status == 'Rejected') {
      return 'assets/images/icons/status-rejected.png';
    }
    else{
      return 'assets/images/icons/status-pending.png';
    }
  }

  Color getStatusColor(String status){
    if(status == 'Approved') {
      return greenColor6;
    }
    if(status == 'Rejected') {
      return redColor2;
    }
    else{
      return orangeColor1;
    }
  }
  void onLoadApplyLeave(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyLeaveView(),
      ),
    );
  }
  void onLoadLeaveStatus(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyLeaveView(),
      ),
    );
  }
  void onLoadLeaveHistory(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyLeaveView(),
      ),
    );
  }

}
