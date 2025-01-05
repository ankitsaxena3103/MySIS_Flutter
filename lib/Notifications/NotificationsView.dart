
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Notifications/UserNotification.dart';

import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  NotificationsViewState createState() => NotificationsViewState();
}

class NotificationsViewState extends State<NotificationsView>{

bool isNoData = true;

String iconPath = "assets/images/notifications/notification_L.png";
String iconPathClock= "assets/images/notifications/notification_clock.png";

List <Map> notificationData = [
  {
    'imageUrl' : '',
    'assetsPath' : "assets/images/notifications/notification_L.png",
    'notification' : 'Leave Request Accepted',
    'data' : 'Leave requested for 4 Mar 20 for bank work is accepted by Area manager',
    'dateTime' : 'Dec 16, 2020'
  },
  {
    'imageUrl' : '',
    'assetsPath' : "assets/images/notifications/notification_clock.png",
    'notification' : 'New Duty Added',
    'data' : 'You have assigned a new duty on 22 Dec 20, Wednesday at DLF center, CP. Start Time 8 AM, Shift B',
    'dateTime' : 'Dec 16, 2020'
  },
];

List<UserNotification> userNotifications = [];
  @override
  void initState() {

    getTableData();
    onLoadData();

    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    isNoData = userNotifications.isNotEmpty ? false : true;

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
                          'notification'.tr(),
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
                Visibility(
                  visible: isNoData,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'notification_not_found'.tr(),
                        style: TextStyle(
                          color: isDarkMode ? whiteColor:greyColor6,
                          fontSize: pathS /4,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Container(
                        width: 1.7*pathL,
                        child: Text(
                          'no_notifications_available'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? greyColor1:greyColor3,
                            fontSize: pathS /5,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+pathS/1.5),
                  child: ListView.builder(
                    itemCount: userNotifications.length, // Change this to the number of times you want to repeat the top column
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:  EdgeInsets.only(bottom: pathS/5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: screenWidth-2.5*marginValue,
                              // height: pathL*1.25,
                                  decoration:  BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(pathS/8),
                                color: isDarkMode?greyColor8:whiteColor,
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
                                    padding: EdgeInsets.only(left: pathS/4, top: pathS/4,bottom: pathS/4), // Adjust top and left as needed
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Padding(
                                              padding: EdgeInsets.only(right: pathS/3), // Adjust top and left as needed

                                              child: Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    height: pathS /3,
                                                    width: pathS /3,
                                                    imageUrl: '',
                                                    placeholder: (context, url) =>  Image.asset(
                                                      iconPathClock,
                                                      fit: BoxFit.contain,
                                                      color: isDarkMode ? whiteColor : greyColor6,

                                                    ),
                                                    errorWidget: (context, url, error) => Image.asset(
                                                      iconPathClock,
                                                      color: isDarkMode ? whiteColor : greyColor6,
                                                      fit: BoxFit.contain,

                                                    ),
                                                    imageBuilder: (context, imageProvider) => Image(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                      color: isDarkMode ? whiteColor : greyColor6,

                                                    ),
                                                  ),
                                                  SizedBox(width: pathS/5),
                                                  Text(
                                                    userNotifications[index].title,
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteColor:greyColor7,
                                                      fontSize: pathS / 5,
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),

                                                ],
                                              ),

                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(left: pathS/1.8,right: pathS/3,top: pathS/8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    userNotifications[index].message,
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteColor:greyColor7,
                                                      fontSize: pathS / 6.5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  SizedBox(height: pathS/5),
                                                  Text(
                                                    '',
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteColor:greyColor7,
                                                      fontSize: pathS / 7,
                                                      fontWeight: FontWeight.w300,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),

                                                ],
                                              ),// Adjust top and left as needed
                                            ),
                                          ],
                                      ),
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

Future<void> getTableData() async {
  List<UserNotification> datas = await DatabaseHelper.instance.getAllRecords<UserNotification>(
    keyTableUserNotification,
        (map) => UserNotification.fromMap(map),
  );

  

  datas.forEach((data) {
    printInDebug(' ID: ${data.id}');
    printInDebug('title name: ${data.title}');
  });

  setState(() {
    userNotifications = datas;
  });


}

void onLoadData() {


  // setState(() {
  //   showLoaderView = true;
  // });
  Map <String,String> inputData = {

  };

  APIHelper.instance.getData(userNotificationApi,inputData, (data) {

    // setState(() {
    //   showLoaderView = false;
    // });

    if(data.isNotEmpty){
      print(data);
      List<UserNotification> datas = data.map((json) => UserNotification.fromJson(json)).toList();
      datas.forEach((data) {
        printInDebug(' ID: ${data.id}');
        printInDebug('title name: ${data.title}');
      });


      userNotifications = datas;

      syncData();

    }

  },(error){
    // setState(() {
    //   showLoaderView = false;
    // });

  }
  );

}
Future<void> syncData() async {
  await DatabaseHelper.instance.replaceTableData<UserNotification>(keyTableUserNotification, userNotifications, (userNotification) =>
      userNotification.toMap());

}
}
