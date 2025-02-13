import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/Profile/ContactSIS.dart';

import '../SharedClasses/APIHelper.dart';
import '../SharedClasses/DatabaseHelper.dart';

class ContactSISView extends StatefulWidget {
  const ContactSISView({super.key});

  @override
  ContactSISViewState createState() => ContactSISViewState();
}

class ContactSISViewState extends State<ContactSISView>{

  List<bool> showSubText = List.generate(5, (index) => false);

  List <String> headers = ['connect_erc'.tr(),'talk_to_your_seniors'.tr(),];

  String assetImage = "assets/images/dashboard-icons/profile-icon.png";

  String whatsAppNumber = '';
  String ercNumber = '';

  String ucImage = '';
  String aoImage = '';
  String bhImage = '';

  String ucName = '';
  String aoName = '';
  String bhName = '';

  String ucNumber = '';
  String aoNumber = '';
  String bhNumber = '';

  List <ContactSIS> contactSIS = [];

  @override
  void initState() {
    super.initState();


    getTableData();

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
                          'contact_sis'.tr(),
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

                SizedBox(
                  height: screenHeight - pathL,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: pathS/3),
                        Container(
                          width: screenWidth - 2.5 * marginValue,
                          child: Text(
                            'connect_erc'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor7,
                              fontSize: pathS / 4.5,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: pathS / 5),
                        Container(
                          width: screenWidth - 2.5 * marginValue,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(pathS / 8),
                            color: isDarkMode ? greyColor3 : whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                blurRadius: pathS / 10, // Spread of the shadow
                                offset: Offset(-pathS / 12, pathS / 12),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: pathS / 4, top: pathS / 8, bottom: pathS / 8,right: pathS/5),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {

                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'whatsApp_chat'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          shareOnWhatsApp(whatsAppNumber);
                                        },
                                        child: Image.asset(
                                          'assets/images/dashboard-icons/whatsApp.png',
                                          width: pathS/2,
                                          height: pathS/2,
                                        ),
                                      )


                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 1,
                                color: isDarkMode ? greyColorDark : greyColor2,
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: pathS / 4, top: pathS / 8, bottom: pathS / 8,right: pathS/5),
                                child: GestureDetector(
                                  onTap: () {
                                    makePhoneCall(ercNumber);
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'erc_number'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 5.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          makePhoneCall(ercNumber);
                                        },
                                        child: Image.asset(
                                            'assets/images/dashboard-icons/call.png',
                                          width: pathS/2.2,
                                          height: pathS/2.2,
                                        ),
                                      ),


                                    ],
                                  ),
                                ),
                              ),



                            ],
                          ),
                        ),

                        SizedBox(height: pathS/2),

                        SizedBox(
                          width: screenWidth - 2.5 * marginValue,
                          child: Text(
                            'talk_to_your_seniors'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? whiteColor : greyColor7,
                              fontSize: pathS / 4.5,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: pathS / 5),

                        Container(
                          width: screenWidth - 2.5 * marginValue,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(pathS / 8),
                              topRight: Radius.circular(pathS / 8),
                            ),
                            color: isDarkMode ? greyColor3 : whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                blurRadius: pathS / 10, // Spread of the shadow
                                offset: Offset(-pathS / 12, pathS / 12),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: pathS / 4, top: pathS / 8, bottom: pathS / 5,right: pathS/5),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    makePhoneCall('');
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: pathL*1.5,
                                        child: Text(
                                          'unit_commander'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 6.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      SizedBox(height: pathS/3),
                                      Row(
                                        children: [
                                          CachedNetworkImage(
                                            height: pathS /2,
                                            width: pathS /2,
                                            imageUrl: ucImage,
                                            placeholder: (context, url) => CircleAvatar(
                                              backgroundImage: AssetImage(assetImage),
                                              backgroundColor: Colors.white,
                                            ),
                                            errorWidget: (context, url, error) => CircleAvatar(
                                              backgroundImage: AssetImage(assetImage),
                                              backgroundColor: Colors.white,
                                            ),
                                            imageBuilder: (context, imageProvider) => CircleAvatar(
                                              backgroundImage: imageProvider,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: pathS/5),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: pathL*1.5,
                                                child: Text(
                                                  ucName,
                                                  style: TextStyle(
                                                    color: isDarkMode ? whiteColor : greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Text(
                                               ucNumber,
                                                style: TextStyle(
                                                  color: isDarkMode ? whiteColor : greyColor6,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: (){
                                              makePhoneCall(ucNumber);
                                            },
                                            child: Image.asset(
                                              'assets/images/dashboard-icons/call.png',
                                              width: pathS/2.5,
                                              height: pathS/2.5,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: pathS / 8),

                              ],
                            ),
                          ),
                        ),

                        Container(
                          height: 1.0,
                          color: isDarkMode ? greyColorDark : greyColor1,

                        ),
                        Container(
                          width: screenWidth - 2.5 * marginValue,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: isDarkMode ? greyColor3 : whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                blurRadius: pathS / 10, // Spread of the shadow
                                offset: Offset(-pathS / 12, pathS / 12),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: pathS / 4, top: pathS / 8, bottom: pathS / 5,right: pathS/5),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    makePhoneCall('');
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: pathL*1.5,
                                        child: Text(
                                          'area_officer'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 6.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      SizedBox(height: pathS/3),
                                      Row(
                                        children: [
                                          CachedNetworkImage(
                                            height: pathS /2,
                                            width: pathS /2,
                                            imageUrl: aoImage,
                                            placeholder: (context, url) => CircleAvatar(
                                              backgroundImage: AssetImage(assetImage),
                                              backgroundColor: Colors.white,
                                            ),
                                            errorWidget: (context, url, error) => CircleAvatar(
                                              backgroundImage: AssetImage(assetImage),
                                              backgroundColor: Colors.white,
                                            ),
                                            imageBuilder: (context, imageProvider) => CircleAvatar(
                                              backgroundImage: imageProvider,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: pathS/5),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: pathL*1.5,
                                                child: Text(
                                                  aoName,
                                                  style: TextStyle(
                                                    color: isDarkMode ? whiteColor : greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Text(
                                                aoNumber,
                                                style: TextStyle(
                                                  color: isDarkMode ? whiteColor : greyColor6,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: (){
                                              makePhoneCall( aoNumber);
                                            },
                                            child: Image.asset(
                                              'assets/images/dashboard-icons/call.png',
                                              width: pathS/2.5,
                                              height: pathS/2.5,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: pathS / 8),

                              ],
                            ),
                          ),
                        ),

                        Container(
                          height: 1.0,
                          color: isDarkMode ? greyColorDark : greyColor1,

                        ),
                        Container(
                          width: screenWidth - 2.5 * marginValue,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(pathS / 8),
                              bottomRight: Radius.circular(pathS / 8),
                            ),
                            color: isDarkMode ? greyColor3 : whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                blurRadius: pathS / 10, // Spread of the shadow
                                offset: Offset(-pathS / 12, pathS / 12),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: pathS / 4, top: pathS / 8, bottom: pathS / 5,right: pathS/5),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    makePhoneCall('');
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: pathL*1.5,
                                        child: Text(
                                          'branch_Head'.tr(),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS / 6.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      SizedBox(height: pathS/3),
                                      Row(
                                        children: [
                                          CachedNetworkImage(
                                            height: pathS /2,
                                            width: pathS /2,
                                            imageUrl: bhImage,
                                            placeholder: (context, url) => CircleAvatar(
                                              backgroundImage: AssetImage(assetImage),
                                              backgroundColor: Colors.white,
                                            ),
                                            errorWidget: (context, url, error) => CircleAvatar(
                                              backgroundImage: AssetImage(assetImage),
                                              backgroundColor: Colors.white,
                                            ),
                                            imageBuilder: (context, imageProvider) => CircleAvatar(
                                              backgroundImage: imageProvider,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: pathS/5),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: pathL*1.5,
                                                child: Text(
                                                  bhName,
                                                  style: TextStyle(
                                                    color: isDarkMode ? whiteColor : greyColor6,
                                                    fontSize: pathS / 5,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Text(
                                              bhNumber,
                                                style: TextStyle(
                                                  color: isDarkMode ? whiteColor : greyColor6,
                                                  fontSize: pathS / 6.5,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: (){
                                              makePhoneCall( bhNumber);
                                            },
                                            child: Image.asset(
                                              'assets/images/dashboard-icons/call.png',
                                              width: pathS/2.5,
                                              height: pathS/2.5,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: pathS / 8),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Positioned(
                //   bottom: 0,
                //
                //   child: GestureDetector(
                //     onTap: (){
                //
                //
                //     },
                //     child: Container(
                //       width: screenWidth,
                //       height: pathS / 1.5,
                //       alignment: Alignment.center,
                //       decoration: BoxDecoration(
                //         color: isDarkMode ? greyColor8:whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                //         // borderRadius: BorderRadius.circular(pathS/3),
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black.withOpacity(0.1), // Shadow color
                //             blurRadius: pathS/10, // Spread of the shadow
                //             // spreadRadius: pathS/15, // How far the shadow extends
                //             offset:  Offset(-pathS/12, pathS/12),
                //           ),
                //         ],
                //       ),
                //
                //     ),
                //   ),
                // ),

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
                        color: isDarkMode ? greyColor8:whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                        // borderRadius: BorderRadius.circular(pathS/3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // Shadow color
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

                  child: GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      width: screenWidth,
                      height: pathS / 1.4,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDarkMode ? greyColor8:whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                        // borderRadius: BorderRadius.circular(pathS/3),

                      ),
                      child: Text(
                        'connect_erc'.tr(),
                        style: TextStyle(
                            color: isDarkMode ? redColor1:redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                            fontSize: pathS / 4.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'
                        ),
                      ),
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

  void onLoadData() {


    // setState(() {
    //   showLoaderView = true;
    // });
    Map <String,String> inputData = {

    };

    APIHelper.instance.getData(contactSISApi,inputData, (data) {

      // setState(() {
      //   showLoaderView = false;
      // });

      if(data.isNotEmpty){


        if (kDebugMode) {
          print(data);
        }
        contactSIS = data.map((json) => ContactSIS.fromJson(json)).toList();
        for (var contact in contactSIS) {
          printInDebug('contact  ID : ${contact.id}');
          printInDebug('contact unit cmd name: ${contact.ucName}');
        }

        if(contactSIS.isNotEmpty) {
          showDataOnUI(contactSIS.first);
          syncTableData();
        }



      }

    },(error){
      // setState(() {
      //   showLoaderView = false;
      // });

    }
    );

  }

  Future<void> getTableData() async {
    contactSIS = await DatabaseHelper.instance.getAllRecords<ContactSIS>(
      keyTableContactSIS,
          (map) => ContactSIS.fromMap(map),
    );

    for (var contact in contactSIS) {
      printInDebug('table contact ID: ${contact.id}');
      printInDebug('table contact unit cmd name: ${contact.ucName}');
    }

    if(contactSIS.isNotEmpty) {
      showDataOnUI(contactSIS.first);
    }else{
      onLoadData();
    }


  }

  Future<void> syncTableData() async {
    await DatabaseHelper.instance.replaceTableData<ContactSIS>(keyTableContactSIS, contactSIS, (contactSIS) =>
        contactSIS.toMap());
  }

  void showDataOnUI(ContactSIS contact){

    setState(() {

      whatsAppNumber = contact.whatsappNumber;
      ercNumber = contact.ercNumber;

      ucImage = contact.ucImage;
      aoImage = contact.aoImage;
      bhImage = contact.bhImage;

      ucName = contact.ucName;
      aoName = contact.aoName;
      bhName = contact.bhName;

      ucNumber = contact.ucNumber;
      aoNumber = contact.aoNumber;
      bhNumber = contact.bhNumber;





    });
  }



}
