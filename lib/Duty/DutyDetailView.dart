import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';


class DutyDetailView extends StatefulWidget {


  @override
  DutyDetailViewState createState() => DutyDetailViewState();
}

class DutyDetailViewState extends State<DutyDetailView>{

  bool isUnsyncedData = true;

  String post = 'MAIN GATE';
  String postRank = 'SO';

  String dutyInTime = '07:45 AM';
  String dutyOutTime = '08:45 PM';

  String attendanceTime = '06:12';
  String shift = 'Shift A';
  String companyName = 'IL & FS Environmental Infrastructure & Services Limited';
  String unit = 'DLE UNT 12345';

  Color dutyInBgColor = redColor3;
  Color dutyInFontColor = whiteColor;
  Color dutyInShadowColor = Colors.black.withOpacity(0.2);

  Color dutyOutBgColor = isDarkMode? greyColor5:greyColor1;
  Color dutyOutFontColor = isDarkMode? greyColor7:greyColor4;
  Color dutyOutShadowColor = Colors.transparent;

  DateTime _focusedDay = DateTime.now();




  DateTime focusedDay = DateTime.now();

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
                          'txt_duty'.tr(),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: pathS+paddingTop),
                    Text(
                      DateFormat('EEEE',selectedLocale).format(_focusedDay),
                      style: TextStyle(
                        color: isDarkMode ?  whiteColor:greyColor3,
                        fontSize: pathS /5.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: pathS/8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              _focusedDay = DateTime(
                                _focusedDay.year,
                                _focusedDay.month ,
                                _focusedDay.day -1,
                              );
                            });
                          },
                          child:  Container(
                            width: pathS/5,
                            height: pathS/5,
                            child: Image.asset(
                              'assets/images/dashboard-icons/left-arrow.png',
                              color: isDarkMode ? whiteColor:greyColor6,

                            ),
                          ),

                        ),
                        SizedBox(width: pathS/5),
                        Text(
                          DateFormat('d MMM',selectedLocale).format(_focusedDay),
                          style: TextStyle(
                            color: isDarkMode ?  whiteColor:greyColor6,
                            fontSize: pathS /3.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: pathS/5),

                        GestureDetector(
                          onTap: (){
                            setState(() {
                              _focusedDay = DateTime(
                                _focusedDay.year,
                                _focusedDay.month ,
                                _focusedDay.day +1,

                              );
                            });

                          },
                          child:  Container(
                            width: pathS/5,
                            height: pathS/5,
                            child: Image.asset(
                              'assets/images/dashboard-icons/right-arrow.png',
                              color: isDarkMode ? whiteColor:greyColor6,

                            ),
                          ),

                        ),
                      ],
                    ),
                    SizedBox(height: pathS/1.5),
                    Container(
                      width: screenWidth-2.5*marginValue,
                      // height: pathL*2.8,
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
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Column(
                            children: [
                              Visibility(
                                visible: isUnsyncedData,
                                child: Container(
                                  width: screenWidth-2*marginValue,
                                  height: pathS/2.5,
                                  decoration: BoxDecoration(
                                    color: yellowColor1,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(pathS/8),
                                      topRight: Radius.circular(pathS/8),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:  EdgeInsets.only(left: pathS/4),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/icons/unsync.png',
                                          color: isDarkMode ?  brownColor:brownColor,

                                        ),
                                        SizedBox(width: pathS/8),
                                        Text(
                                          'unsynced_data'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ?  brownColor:brownColor,
                                            fontSize: pathS /6.5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: pathS/5),
                              Padding(
                                padding: EdgeInsets.only(left: pathS/4,bottom: pathS/4), // Adjust top and left as needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(pathS / 15),
                                            // color: isDarkMode ?  greenColor5:greenColor1,
                                          ),
                                          child:Row(
                                            children: [
                                              Text(
                                                '08:00',
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor6,
                                                  fontSize: pathS / 3,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(width: pathS/25),
                                              Text(
                                                'AM',
                                                style: TextStyle(
                                                  color: isDarkMode ?  whiteColor:greyColor6,
                                                  fontSize: pathS / 7,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(pathS / 15), // Adjust as needed
                                              bottomLeft: Radius.circular(pathS / 15), // Adjust as needed
                                            ),
                                            color: isDarkMode ?  greenColor5:greenColor1,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1), // Shadow color
                                                blurRadius: pathS/75, // Spread of the shadow
                                                // spreadRadius: pathS/15, // How far the shadow extends
                                                offset:  Offset(-pathS/75, pathS/75),
                                              ),
                                            ],
                                          ),
                                          child:Padding(
                                            padding: EdgeInsets.only(left: pathS/5, top: pathS/10,right: pathS/8,bottom: pathS/12), // Adjust top and left as needed
                                            child: Text(
                                              shift,
                                              style: TextStyle(
                                                color: isDarkMode ?  greyColor7:greenColor6,
                                                fontSize: pathS / 5.5,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: pathS / 4),

                                    Padding(
                                      padding:  EdgeInsets.only(right: pathS/4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            companyName,
                                            style: TextStyle(
                                              color: isDarkMode ?  whiteColor:greyColor7,
                                              fontSize: pathS / 6.5,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            unit,
                                            style: TextStyle(
                                              color: isDarkMode ?  whiteColor:greyColor7,
                                              fontSize: pathS / 5,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(height: pathS/3),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'post'.tr(),
                                                style: TextStyle(
                                                  color: isDarkMode ? greyColor : greyColor3,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  post,
                                                  style: TextStyle(
                                                    color: isDarkMode ? whiteColor : greyColor6,
                                                    fontSize: pathS / 6.5,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              SizedBox(width: pathS/5),

                                              Text(
                                                'post_rank'.tr(),
                                                style: TextStyle(
                                                  color: isDarkMode ? greyColor : greyColor3,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                              SizedBox(width: pathS/15),
                                              Container(
                                                width: pathS,
                                                child: Text(
                                                  postRank,
                                                  style: TextStyle(
                                                    color: isDarkMode ? whiteColor : greyColor6,
                                                    fontSize: pathS / 6.5,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: pathS/8),
                                          Container(
                                            width: screenWidth,
                                            height:  pathS/60,
                                            color: isDarkMode? greyColorDark:greyColor2,
                                          ),
                                          SizedBox(height: pathS/8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'duty_in'.tr(),
                                                style: TextStyle(
                                                  color: isDarkMode ? greyColor : greyColor3,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                              SizedBox(width: pathS/15),
                                              Container(
                                                child: Text(
                                                  dutyInTime,
                                                  style: TextStyle(
                                                    color: isDarkMode ? whiteColor : greyColor6,
                                                    fontSize: pathS / 6.5,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              SizedBox(width: pathS/5),

                                              Text(
                                                'duty_out'.tr(),
                                                style: TextStyle(
                                                  color: isDarkMode ? greyColor : greyColor3,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                              SizedBox(width: pathS/15),
                                              SizedBox(width: 2),
                                              Container(
                                                width: pathS,
                                                child: Text(
                                                  dutyOutTime,
                                                  style: TextStyle(
                                                    color: isDarkMode ? whiteColor : greyColor6,
                                                    fontSize: pathS / 6.5,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Roboto',
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
                              ),
                            ],
                          ),

                        ],
                      ),

                    ),//duty in out

                  ],
                ),

                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom +pathS/12,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {

                        });

                      },
                      child: Visibility(
                        visible: isUnsyncedData,
                        child: Container(
                          // width: pathL*1.3,
                          // height: pathS / 1.5,
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
                          child: Padding(
                            padding:  EdgeInsets.only(left: pathS/3,right: pathS/3,top: pathS/8,bottom: pathS/8),
                            child: Text(
                              'sync_now'.tr(),
                              style: TextStyle(
                                color: isDarkMode ? whiteColor:whiteColor,
                                fontSize: pathS / 5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                )
              ],
            ),
          ),



        ],
      ),
    );
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
