import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';

class NewEscortDutyView extends StatefulWidget {
  @override
  NewEscortDutyViewState createState() => NewEscortDutyViewState();
}

class NewEscortDutyViewState extends State<NewEscortDutyView>{

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
                          'New_Escort_Duty'.tr(),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [





                  ],
                ),
              ],
            ),
          ),



        ],
      ),
    );
  }

  void onLoadApplyLeave(){
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ApplyLeaveView(),
    //   ),
    // );
  }
  void onLoadLeaveStatus(){
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ApplyLeaveView(),
    //   ),
    // );
  }
  void onLoadLeaveHistory(){
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ApplyLeaveView(),
    //   ),
    // );
  }

}
