
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Notifications/UserNotification.dart';
import 'package:url_launcher/url_launcher.dart';

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


List<UserNotification> userNotifications = [];
  @override
  void initState() {

    // getTableData();
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
                      SizedBox(
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


                                                  if(userNotifications[index].messageType == 1 && !userNotifications[index].isHtmlPage && !userNotifications[index].isHtmlBody && !userNotifications[index].isImageUrl )Text(
                                                    userNotifications[index].message,
                                                    style: TextStyle(
                                                      color: isDarkMode ?  whiteColor:greyColor7,
                                                      fontSize: pathS / 6.5,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  if(userNotifications[index].isHtmlPage)_buildTappableLink(userNotifications[index].message),
                                                  if( userNotifications[index].isImageUrl)_buildImage(userNotifications[index].message),
                                                  if( userNotifications[index].isHtmlBody)_buildHtmlWeb(userNotifications[index].message, userNotifications[index].actionUrl ),

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


Widget _buildTappableLink(String url) {
  return RichText(
    text: TextSpan(
      text: url,
      style: TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ),
      recognizer: TapGestureRecognizer()..onTap = () async {
        loadMyUrl(url);
      },
    ),
  );
}

Widget _buildImage(String imageUrl) {
  return Image.network(
    imageUrl,
    width: pathL * 1.7,
    // height: pathL*1.5,
    fit: BoxFit.cover,
  );
}

late InAppWebViewController webViewController;

Widget _buildHtmlWeb(String htmlBody, String actionUrl) {
  return GestureDetector(
    onTap: () async {
      if (actionUrl.isNotEmpty) {
        final Uri url = Uri.parse(actionUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      }
    },
    child: Html(
      data: htmlBody, // Pass cleaned HTML
      style: {
        "h1": Style(
            color:  isDarkMode ? redColor1 : redColor3,
        ),
        "h2": Style(
          // color:  isDarkMode ? redColor1 : redColor3,
        ),
        "p": Style(
          color: isDarkMode ? whiteColor : greyColor7,
          // fontSize: FontSize(16),
          // fontWeight: FontWeight.w500,
          // fontFamily: 'Roboto',
        ),
      },
    ),
  );
}
Future<void> getTableData() async {
  List<UserNotification> datas = await DatabaseHelper.instance.getAllRecords<UserNotification>(
    keyTableUserNotification,
        (map) => UserNotification.fromMap(map),
  );


  for (var data in datas) {
    printInDebug(' ID: ${data.id}');
    printInDebug('title name: ${data.title}');
  }

  DateTime dateTimeNow = DateTime.now();
  final notification = datas
      .where((data) =>
  (data.expiryDate.year >= dateTimeNow.year && data.expiryDate.month >= dateTimeNow.month && data.expiryDate.day >= dateTimeNow.day))
      .toList();

  setState(() {
    userNotifications = notification;
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
      List<UserNotification> datas = data.map((json) => UserNotification.fromJson(json)).toList();

      for (var data in datas) {
        printInDebug(' ID: ${data.id}');
        printInDebug('title name: ${data.title}');
      }

      DateTime dateTimeNow = DateTime.now();
     final notification = datas
          .where((data) =>
      (data.expiryDate.year >= dateTimeNow.year && data.expiryDate.month >= dateTimeNow.month && data.expiryDate.day >= dateTimeNow.day))
          .toList();

      setState(() {
        userNotifications = datas;
      });


      syncData(datas);

    }

  },(error){
    // setState(() {
    //   showLoaderView = false;
    // });

  }
  );

}
Future<void> syncData( List<UserNotification> userNotifications) async {
  await DatabaseHelper.instance.replaceTableData<UserNotification>(keyTableUserNotification, userNotifications, (userNotification) =>
      userNotification.toMap());

}

}
