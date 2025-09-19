import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';

class ExistinIssuesView extends StatefulWidget {
  @override
  ExistinIssuesViewState createState() => ExistinIssuesViewState();
}

class ExistinIssuesViewState extends State<ExistinIssuesView> {

  bool isNoData = false;


  List <Map> issues = [
    {
      'dateTime' :  DateFormat('dd MMM, hh:mm a', selectedLocale).format(DateTime.now()),
      'status' : 'in_progress',
      'issueID' : 'GTP000004',
      'issueSubId' : 'GTD000044',
      'title' : 'Statutory & related issues',
      'description' : 'Death claim, PF/Pension settlement',
    },
    {
      'dateTime' :  DateFormat('dd MMM, hh:mm a', selectedLocale).format(DateTime.now()),
      'status' : 'approved',
      'issueID' : 'GTP000004',
      'issueSubId' : 'GTD000044',
      'title' : 'Statutory & related issues',
      'description' : 'Death claim, PF/Pension settlement',
    },
    {
      'dateTime' :  DateFormat('dd MMM, hh:mm a', selectedLocale).format(DateTime.now()),
      'status' : 'pending',
      'issueID' : 'GTP000004',
      'issueSubId' : 'GTD000044',
      'title' : 'Statutory & related issues',
      'description' : 'Death claim, PF/Pension settlement',
    },
    {
      'dateTime' :  DateFormat('dd MMM, hh:mm a', selectedLocale).format(DateTime.now()),
      'status' : 'rejected',
      'issueID' : 'GTP000004',
      'issueSubId' : 'GTD000044',
      'title' : 'Statutory & related issues',
      'description' : 'Death claim, PF/Pension settlement',
    },
    {
      'dateTime' :  DateFormat('dd MMM, hh:mm a', selectedLocale).format(DateTime.now()),
      'status' : 'completed',
      'issueID' : 'GTP000004',
      'issueSubId' : 'GTD000044',
      'title' : 'Statutory & related issues',
      'description' : 'Death claim, PF/Pension settlement',
    },
  ];

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
    isNoData = issues.length > 0 ? false : true;
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
                        Container(
                          width: pathS / 5,
                          height: pathS / 2,
                          child: Image.asset(
                            'assets/images/dashboard-icons/left-arrow.png',
                            color: isDarkMode ? whiteColor : greyColor6,

                          ),

                        ),
                        SizedBox(width: pathS / 8),
                        Text(
                          'connect_erc'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: pathS/1.5+paddingTop),
                    Container(
                      height: screenHeight - pathS/1.5-paddingTop-paddingBottom,
                      child: ListView.builder(
                        itemCount: issues.length, // Change this to your desired itemCount
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: pathS / 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
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
                                    padding: EdgeInsets.only(
                                        bottom: pathS / 4,
                                        top: pathS / 4,
                                        left: pathS / 4,
                                        right: pathS/4
                                    ),
                                    child: Column(
                                      children: [

                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                issues[index]['dateTime'],
                                                style: TextStyle(
                                                  color: isDarkMode ? whiteColor : greyColor6,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),

                                            Expanded(
                                              child: Text(
                                                '${issues[index]['status']}'.tr(),
                                                style: TextStyle(
                                                  color: getStatusColor('${issues[index]['status']}'),
                                                  fontSize: pathS / 6,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),

                                          ],
                                        ),

                                        SizedBox(height: pathS/5),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                issues[index]['issueID'],
                                                style: TextStyle(
                                                  color: isDarkMode ? whiteColor : greyColor6,
                                                  fontSize: pathS / 5,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),


                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                issues[index]['issueSubId'],
                                                style: TextStyle(
                                                  color: isDarkMode ? whiteColor : greyColor6,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),


                                          ],
                                        ),

                                        SizedBox(height: pathS/5),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                issues[index]['title'],
                                                style: TextStyle(
                                                  color: isDarkMode ? whiteColor : greyColor6,
                                                  fontSize: pathS / 5,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Roboto',
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),


                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                issues[index]['description'],
                                                style: TextStyle(
                                                  color: isDarkMode ? whiteColor : greyColor6,
                                                  fontSize: pathS / 6.5,
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
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                  ],
                ),
                Visibility(
                  visible: isNoData,
                  child: Padding(
                    padding:  EdgeInsets.all(pathS),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'no_existing_issues'.tr(),
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
                          'no_issues_available'.tr(),
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
              ],
            ),
          ),


        ],
      ),
    );
  }

  Color getStatusColor(String status){
    Color statusColor = greyColor6;

    if(status == 'in_progress'){
      statusColor = isDarkMode ? orangeColor:orangeColor1;
    }
    if(status == 'approved'){
      statusColor = isDarkMode ? greenColor5:greenColor6;
    }

    if(status == 'pending'){
      statusColor = isDarkMode ? whiteColor:greyColor6;
    }
    if(status == 'rejected'){
      statusColor = isDarkMode ? redColor1:redColor3;
    }
    if(status == 'completed'){
      statusColor = isDarkMode ? greenColor5:greenColor6;
    }

    return statusColor;
  }
}
