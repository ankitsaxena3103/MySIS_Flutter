import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/SelectShiftView.dart';
import 'package:mysis/Profile/UserProfile.dart';

class ScanUnitShiftView extends StatefulWidget {

  final UserProfile userProfile;

  ScanUnitShiftView(
      {
        super.key,
        required this.userProfile,

      });
  @override
  ScanUnitShiftViewState createState() => ScanUnitShiftViewState();
}

class ScanUnitShiftViewState extends State<ScanUnitShiftView>{
  String assetsImagePath = "assets/images/dashboard-icons/profile-icon.png";
  String imagePath = '';
  bool noData = true;

  String name  = '';
  String position  = '';


  @override
  void initState() {

    onLoadUpdateUI();
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
              color: greyColor6
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top:MediaQuery.of(context).padding.top,
                  child: Container(
                    width: screenWidth,
                    // height: pathS / 1.2,
                    decoration: BoxDecoration(
                      color: isDarkMode ? greyColor6 : whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: pathS / 10,
                          offset: Offset(-pathS / 12, pathS / 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: paddingLeft + pathS / 4, right: paddingRight + pathS / 3,top: pathS/5,bottom: pathS/5),
                      child: Column(
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CachedNetworkImage(
                                height: pathS / 1.55,
                                width: pathS / 1.55,
                                imageUrl: imagePath,
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundImage: AssetImage(assetsImagePath),
                                  backgroundColor: Colors.white,
                                ),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  backgroundImage: AssetImage(assetsImagePath),
                                  backgroundColor: Colors.white,
                                ),
                                imageBuilder: (context, imageProvider) => CircleAvatar(
                                  backgroundImage: imageProvider,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              SizedBox(width: pathS/5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          color: isDarkMode ? whiteColor : greyColor6,
                                          fontSize: pathS / 5,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        position,
                                        style: TextStyle(
                                          color: isDarkMode ? whiteColor : greyColor6,
                                          fontSize: pathS / 6.5,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),

                                    ],
                                  ),

                                ],
                              ),
                              Spacer(),
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
                          SizedBox(height: pathS/5),
                          Container(
                            height: 1,
                            color: isDarkMode ? greyColorDark : greyColor2,
                          ),
                          SizedBox(height: pathS/5),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/home/unit-location.png',
                                height: pathS/1.5,
                                width: pathS/1.5,
                                color: isDarkMode ? redColor1 : redColor3,
                              ),
                              SizedBox(width: pathS/5),
                              Expanded(
                                child: Text(
                                  'qr_code_scan_location'.tr(),
                                  style: TextStyle(
                                    color: isDarkMode ? whiteColor : greyColor6,
                                    fontSize: pathS / 5.5,
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

                ),


                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: pathL),
                    Container(
                      alignment: Alignment.center,
                      width:pathL*2,
                      height: pathL*2,
                      decoration: BoxDecoration(
                        color:  isDarkMode ? greyColor7:whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                        borderRadius: BorderRadius.circular(pathS/12),
                        boxShadow: [
                          BoxShadow(
                            color:  isDarkMode? shadowColor:shadowColor,
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
                          height: pathS/2,

                          child: Icon(
                            Icons.camera_alt_outlined,
                            color:  isDarkMode ? greyColor1:greyColor6,
                          ),
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
    );
  }


  Future<void> scanBarcode() async {
    onLoadSelectShift();
    return;
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color for the scan button
      'Cancel', // Text for the cancel button
      true, // Wait for the result before returning
      ScanMode.BARCODE, // Specify the type of scan (BARCODE or QR)
    );
  }

  void onLoadSelectShift(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectShiftView(regNo:'ABC 562314 ' , designation: 'Assistent Manager',location: 'AXIS BANK DLE UNT 12345',post: 'MAIN GATE',postRank: 'SO Rank', userProfile: widget.userProfile,),
      ),
    );
  }

  void onLoadUpdateUI(){

    imagePath = widget.userProfile.profileImageUrl;
    name = widget.userProfile.empName;
    position = widget.userProfile.symbol;

  }


}
