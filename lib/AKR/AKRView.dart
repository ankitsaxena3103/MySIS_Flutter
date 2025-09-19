import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';

class AKRView extends StatefulWidget {
  const AKRView({super.key});

  @override
  AKRViewState createState() => AKRViewState();
}

class AKRViewState extends State<AKRView> {

  bool noData = true;

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
    calculateSizes(context);
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
                          'AKR_requests'.tr(),
                          style: TextStyle(
                            color: isDarkMode ? whiteColor : greyColor6,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Header widget
                    SizedBox(height: MediaQuery
                        .of(context)
                        .padding
                        .top +pathS),
                    Container(
                      // padding: EdgeInsets.symmetric(vertical: pathS / 4),
                      alignment: Alignment.center,
                      width: screenWidth - 2.5 * marginValue,

                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'item_name'.tr(),
                              style: TextStyle(
                                color: isDarkMode ? whiteColor : greyColor3,
                                fontSize: pathS / 6.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto',
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'qty'.tr().toUpperCase(),
                              style: TextStyle(
                                color: isDarkMode ? whiteColor : greyColor3,
                                fontSize: pathS / 6.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'received_date'.tr().toUpperCase(),
                              style: TextStyle(
                                color: isDarkMode ? whiteColor : greyColor3,
                                fontSize: pathS / 6.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'due_date'.tr().toUpperCase(),
                              style: TextStyle(
                                color: isDarkMode ? whiteColor : greyColor3,
                                fontSize: pathS / 6.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto',
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // List view
                    Container(
                      height: screenHeight-2*pathS/1.2,
                      child: ListView.builder(
                        itemCount: 13, // Change this to your desired itemCount
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: pathS / 15),
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
                                    padding: EdgeInsets.only(bottom: pathS / 4, top: pathS / 4,left: pathS / 4, right: pathS / 4),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Shirt',
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor : greyColor6,
                                              fontSize: pathS / 6,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '01',
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor : greyColor6,
                                              fontSize: pathS / 6,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '01.01.21',
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor : greyColor6,
                                              fontSize: pathS / 6,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '01.01.22',
                                            style: TextStyle(
                                              color: isDarkMode ? whiteColor : greyColor6,
                                              fontSize: pathS / 6,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.right,
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


                Positioned(
                  bottom: 0,
                  child: Container(
                    width: screenWidth,
                    height: pathS / 1.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDarkMode ? greyColor6:whiteColor,
                    ),

                  ),
                ),
                Positioned(
                  bottom: paddingBottom,

                  child: GestureDetector(
                    onTap: (){


                    },
                    child: Container(
                      width: screenWidth,
                      height: pathS / 1.4,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDarkMode ? greyColor6:whiteColor,
                        // border: Border.all(color: Colors.yellow, width: pathS/18),
                        // borderRadius: BorderRadius.circular(pathS/3),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor, // Shadow color
                            blurRadius: pathS/15, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(-1, -pathS/15),
                          ),
                        ],
                      ),
                      child: Text(
                        'logo_submission'.tr().toUpperCase(),
                        style: TextStyle(
                            color: isDarkMode ? redColor1:redColor3,
                            fontSize: pathS / 5,
                            fontWeight: FontWeight.w700,
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

}
