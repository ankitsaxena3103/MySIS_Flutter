import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactSISView extends StatefulWidget {
  @override
  ContactSISViewState createState() => ContactSISViewState();
}

class ContactSISViewState extends State<ContactSISView>{

  List<bool> showSubText = List.generate(5, (index) => false);

  List <String> headers = ['connect_erc'.tr(),'talk_to_your_seniors'.tr(),];

  String assetImage = "assets/images/dashboard-icons/profile-icon.png";

  String personImage = '';
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

                Container(
                  height: screenHeight - pathS*1.5 - paddingTop - paddingBottom,
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
                          child: Padding(
                            padding: EdgeInsets.only(left: pathS / 4, top: pathS / 4, bottom: pathS / 4,right: pathS/5),
                            child: Column(
                              children: [
                                GestureDetector(
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
                                          shareOnWhatsApp('');
                                        },
                                        child: Image.asset(
                                          'assets/images/dashboard-icons/whatsApp.png'
                                        ),
                                      )


                                    ],
                                  ),
                                ),
                                SizedBox(height: pathS / 8),

                                Padding(
                                  padding: EdgeInsets.only(right: 0),
                                  child: Container(
                                    height: 1,
                                    color: isDarkMode ? greyColorDark : greyColor2,
                                  ),
                                ),
                                SizedBox(height: pathS/5),

                                GestureDetector(
                                  onTap: () {
                                    setState(() {

                                    });
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
                                          makePhoneCall('9876543210');
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
                                SizedBox(height: pathS / 8),

                                Padding(
                                  padding: EdgeInsets.only(right: 0),
                                  child: Container(
                                    height: 1,
                                    color: isDarkMode ? greyColorDark : greyColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: pathS/2),

                        Container(
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
                          child: Padding(
                            padding: EdgeInsets.only(left: pathS / 4, top: pathS / 8, bottom: pathS / 5,right: pathS/5),
                            child: Column(
                              children: List.generate(
                                10,
                                    (index) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: pathS/10),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {

                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: pathL*1.5,
                                              child: Text(
                                                'Area Manager',
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
                                                  imageUrl: personImage,
                                                  placeholder: (context, url) =>  Image.asset(
                                                    assetImage,
                                                    fit: BoxFit.contain,

                                                  ),
                                                  errorWidget: (context, url, error) => Image.asset(
                                                    assetImage,
                                                    fit: BoxFit.contain,

                                                  ),
                                                  imageBuilder: (context, imageProvider) => Image(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover, // Adjust the fit as needed
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
                                                        'Samant Kumar Jaiswal',
                                                        style: TextStyle(
                                                          color: isDarkMode ? whiteColor : greyColor6,
                                                          fontSize: pathS / 5,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                    Text(
                                                      '9876543210',
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
                                                    makePhoneCall('9876543210');
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
                                      Padding(
                                        padding: EdgeInsets.only(right: 0),
                                        child: Container(
                                          height: 1,
                                          color: isDarkMode ? greyColorDark : greyColor2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // Shadow color
                            blurRadius: pathS/10, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(-pathS/12, pathS/12),
                          ),
                        ],
                      ),
                      child: Text(
                        'connect_erc'.tr(),
                        style: TextStyle(
                          color: isDarkMode ? redColor1:redColor3,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                          fontSize: pathS / 4.5,
                          fontWeight: FontWeight.bold,
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


}
