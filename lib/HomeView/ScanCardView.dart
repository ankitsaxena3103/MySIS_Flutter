import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/EnterManuallyView.dart';

class ScanCardView extends StatefulWidget {
  @override
  ScanCardViewState createState() => ScanCardViewState();
}

class ScanCardViewState extends State<ScanCardView>{

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
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [

          Container(
            width: logicalWidth,
            height: logicalHeight,
            decoration:  BoxDecoration(
              shape: BoxShape.rectangle,
              // gradient: isDarkMode ? backgroundGradientDark : backgroundGradientDark ,
              color:  greyColor8,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top:MediaQuery.of(context).padding.top,
                  child: Container(
                    width: screenWidth,
                    height: pathS / 1.2,
                    decoration: BoxDecoration(
                      color: isDarkMode ? greyColor8 : whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: pathS / 15,
                          offset: Offset(-pathS / 12, pathS / 15),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: paddingLeft + pathS / 4, right: paddingRight + pathS / 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: pathS / 1.5,
                                height: pathS / 1.2,
                                child: Image.asset(
                                  'assets/images/home/card-icon.png',
                                  color: isDarkMode ? whiteColor : redColor3,
                                ),
                              ),
                              SizedBox(width: pathS / 5),
                              Text(
                                'scan_qr_code'.tr(),
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 5.5,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: pathS / 3,
                              height: pathS / 3,
                              child: Image.asset(
                                'assets/images/home/cross.png',
                                color: isDarkMode ? whiteColor : greyColor6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ),


                Container(
                  alignment: Alignment.center,
                  width:pathL*2,
                  height: pathL*2,
                  decoration: BoxDecoration(
                    color:  isDarkMode ? greyColorDark:whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                    borderRadius: BorderRadius.circular(pathS/15),
                    boxShadow: [
                      BoxShadow(
                        color:  isDarkMode ? greyColor6:shadowColor,
                        blurRadius: pathS/10, // Spread of the shadow
                        // spreadRadius: pathS/15, // How far the shadow extends
                        offset:  Offset(-pathS/12, pathS/12),
                      ),
                    ],
                  ),
                  child:GestureDetector(
                    onTap: (){
                      scanBarcode();
                    },
                    child: Container(
                      width: pathS/2,
                      height: pathS/1.5,

                        child: Icon(
                            Icons.camera_alt_outlined,
                          color:  isDarkMode ? greyColor1:greyColor6,
                        ),
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
                        color: isDarkMode ? greyColor6:whiteColor,

                        // border: Border.all(color: Colors.yellow, width: pathS/18),
                        // borderRadius: BorderRadius.circular(pathS/3),

                      ),

                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      onLoadManualEntry();

                    },
                    child: Container(
                      width: screenWidth,
                      height: pathS / 1.3,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDarkMode ? greyColor6:whiteColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            'not_able_scan'.tr(),
                            style: TextStyle(
                              color: isDarkMode ? whiteColor:greyColor6,
                              fontSize: pathS / 5,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          SizedBox(width: pathS/8),
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                              onLoadManualEntry();

                            },
                            child: Text(
                              'enter_Manually'.tr(),
                              style: TextStyle(
                                color: isDarkMode ? redColor1:redColor3,
                                fontSize: pathS / 4.8,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),

                        ],
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


  Future<void> scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scan button
      'Cancel', // Text for the cancel button
      true, // Wait for the result before returning
      ScanMode.BARCODE, // Specify the type of scan (BARCODE or QR)
    );
  }

  void onLoadManualEntry(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterManuallyView(),
      ),
    );
  }


}
