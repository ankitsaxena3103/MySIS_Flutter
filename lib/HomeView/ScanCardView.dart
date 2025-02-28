import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/HomeView/EnterManuallyView.dart';

import '../Profile/UnitDutyPost.dart';
import '../Profile/UnitShiftDetail.dart';
import '../Profile/UserPosting.dart';
import '../Profile/UserProfile.dart';
import 'ConfirmProfileView.dart';

class ScanCardView extends StatefulWidget {
  final UserProfile userProfile;
  final String attendanceMode;
  final List<UnitDutyPost> unitDutyPosts;
  final List<UnitShiftDetail> unitShiftDetails;
  final List<UserPosting> userPostings;
  final String attendanceStatus;


  const ScanCardView({
    super.key,
    required this.userProfile,
    required this.attendanceMode,
    required this.unitDutyPosts,
    required this.unitShiftDetails,
    required this.userPostings,
    required this.attendanceStatus
  });

  @override
  ScanCardViewState createState() => ScanCardViewState();
}

class ScanCardViewState extends State<ScanCardView>{

  Key scannerKey = UniqueKey();
  bool noData = true;

  late  MobileScannerController mobileNoScannerController;

  @override
  void initState() {
    mobileNoScannerController = MobileScannerController();
    super.initState();

  }

  @override
  void dispose() {
    mobileNoScannerController.dispose();
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
                  child:MobileScanner(
                    key: scannerKey, // Assign the unique key
                    controller: mobileNoScannerController,
                    onDetect: (barcodeCapture) {
                      for (final barcode in barcodeCapture.barcodes) {
                        debugPrint('Barcode found: ${barcode.rawValue}');
                        if(widget.userProfile.mobile == barcode.rawValue || widget.userProfile.regNo == barcode.rawValue) {
                          onUserScannedId(barcode.rawValue!);
                        }
                        else{
                          onUserScannedData(barcode.rawValue!);
                        }


                      }
                    },
                    fit: BoxFit.cover, // Ensure the scanner fills the container
                    placeholderBuilder: (context, constraints) {
                      return Center(
                        child: Text('Initializing camera...'),
                      );
                    },
                    errorBuilder: (context, error, child) {
                      return Center(
                        child: Text('Error: ${error.errorCode}'),
                      );
                    },
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
                      // Navigator.pop(context);
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
                              // Navigator.pop(context);
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


  void onUserScannedId(String myId){
    printInDebug(myId);
    if(widget.userProfile.mobile == myId || widget.userProfile.regNo == myId) {
      loadConfirmScreen();
    }else{

    }
  }

  void onUserScannedData(String scannedData){
    //dispose once done scanning
    // mobileNoScannerController.dispose();
    printInDebug(scannedData);

  }

  void loadConfirmScreen(){
    mobileNoScannerController.dispose();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmProfileView(
          userProfile: widget.userProfile,
          attendanceMode: widget.attendanceMode,
          unitDutyPosts: widget.unitDutyPosts,
          unitShiftDetails: widget.unitShiftDetails,
          userPostings: widget.userPostings,
          attendanceStatus: widget.attendanceStatus,
        ),
      ),
    )
        .then((val) {
        printInDebug('back from confirm profile');
        setState(() {
          mobileNoScannerController = MobileScannerController(
            detectionSpeed: DetectionSpeed.noDuplicates,
            facing: CameraFacing.back,
          );
        });
        scannerKey = UniqueKey(); // Force widget to reload
    });
  }

  void onLoadManualEntry(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EnterManuallyView(
          userProfile: widget.userProfile,
          attendanceMode: widget.attendanceMode,
          unitDutyPosts: widget.unitDutyPosts,
          unitShiftDetails: widget.unitShiftDetails,
          userPostings: widget.userPostings,
          attendanceStatus: widget.attendanceStatus,

        ),
      ),
    );
  }


}
