import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import '../CommonViews/AlertPopupView.dart';
import '../CommonViews/LoaderView.dart';
import '../SharedClasses/APIHelper.dart';

class SarvamLoanView extends StatefulWidget {
  const SarvamLoanView({super.key});

  @override
  SarvamLoanViewState createState() => SarvamLoanViewState();
}

class SarvamLoanViewState extends State<SarvamLoanView>{

  bool showLoaderView = false;
  bool showAlert = false;
  String alertHeader = '';
  String alertMessage = '';
  String cancelText = '';
  String okText = '';

  late PageController _pageController;
  int pageIndex = 0;
  List page1Header = ['easy_repayment'.tr(),'affordable_emi'.tr(),'only_emergency'.tr(),'service_not_free'.tr(),'loan_not_by_sis'.tr(),'disclaimer'.tr()];
  List page1footer = [];
  List pageImageName = ['assets/images/sulabhLoan/easy_loan.PNG','assets/images/sulabhLoan/affordable.PNG','assets/images/sulabhLoan/emergency_icon.PNG','assets/images/sulabhLoan/interset_icon.PNG','assets/images/sulabhLoan/not_provided.PNG','assets/images/onboarding/erc-icon.png'];
  Color nextBgColor = isDarkMode ? redColor1 : redColor3;
  Color nextFontColor = whiteColor;
  Color nextShadowColor = Colors.transparent;
  String btnNext = 'agree_apply'.tr().toUpperCase();
  List<Offset> pageImageSize = [
    Offset(pathL * 1.45, 2 * pathL),
    Offset(pathL * 2.1, 1.65 * pathL),
    Offset(pathL * 1.65, 1.65 * pathL),
    Offset(pathL * 1.25, 1.45 * pathL),
    Offset(pathL * 1.75, 1.6 * pathL),
    Offset(pathL * 1.5, 1.65 * pathL),
  ];


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: pageIndex);
    _loadPagesSequentially();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    calculateSizes(context);

    return Scaffold(
      body: Container(
        width: logicalWidth,
        height: logicalHeight,
        decoration:  BoxDecoration(
          shape: BoxShape.rectangle,
          color: isDarkMode ? greyColorDark:whiteColor
          // gradient: isDarkMode ? backgroundGradientDark : backgroundGradient,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: screenWidth,
              height: pathS,
            ),


            // PageView
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  pageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                pageIndex = index;
                return loanPage(pageIndex);
              },
              itemCount: 6,
            ),
            Positioned(
              bottom: paddingBottom,
              right: paddingRight + pathS / 3,
              child: Stack(
                children: [
                  if(pageIndex == 5)GestureDetector(
                    onTap: () {
                      _nextPage();
                      printInDebug('Next button tapped'); // Use 'print' for debugging
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: nextBgColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                        borderRadius: BorderRadius.circular(pathS/3),
                        boxShadow: [
                          BoxShadow(
                            color: nextShadowColor, // Shadow color
                            blurRadius: pathS/10, // Spread of the shadow
                            // spreadRadius: pathS/15, // How far the shadow extends
                            offset:  Offset(-pathS/12, pathS/12),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(left: pathS/4,right: pathS/4,top: pathS/6,bottom: pathS/6),
                        child: Text(
                          btnNext,
                          style: TextStyle(
                            color: nextFontColor,
                            fontSize: pathS / 5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if(pageIndex < 5)GestureDetector(
                    onTap: () {
                      _nextPage();
                      printInDebug('Next button tapped'); // Use 'print' for debugging
                    },
                    child: Container(
                      width: pathS / 1.2,
                      height: pathS / 1.2,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/onboarding/next-arrow.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: paddingBottom+pathS/5 + pathS/4,
              left: paddingLeft+pathS/3 +pathS/20,
              child: Text(
                'step'.tr() + ' '+ '${pageIndex+1}',
                style: TextStyle(
                  fontSize: pathS/6,
                  color: isDarkMode ? whiteColor : greyColor6,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            Positioned(
              bottom: paddingBottom+ pathS/4,
              left: paddingLeft+pathS/3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6, // Change this to the total number of onboarding pages
                      (index) => GestureDetector(
                      onTap: () => animatePage(index),
                      child:buildDot(index)),
                ),
              ),
            ),
            Positioned(
              top: paddingTop+pathS/2,
              left: paddingLeft +pathS/3,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: pathS/5,
                      height: pathS/5,
                      child: Image.asset(
                        'assets/images/dashboard-icons/left-arrow.png',
                        color: isDarkMode ? whiteColor:greyColor6,
                      ),

                    ),
                    SizedBox(width: pathS/8),
                    Text(
                      'loan_by_sarvam'.tr(),
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
            LoaderView(isVisible: showLoaderView, message: ''),
            Visibility(
              visible: showAlert,
              child: AlertPopupView(
                header: alertHeader,
                message: alertMessage,
                cancelBtn: cancelText,
                okBtn: okText,
                callBack:(val){
                  setState(() {
                    showAlert = false;
                  });
                  if(val == 0) {
                    Navigator.pop(context);
                  }
                  if(val == 1){
                    applyLoan();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loanPage(int index) {

      return Stack(
        alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: pathS/4,right: pathS/4,top: pathS),
                    child: Text(
                      page1Header[index],
                      style: TextStyle(
                          fontSize: pathS/3,
                          color: isDarkMode? whiteColor : greyColor6,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: pathS/1.5),
                  if(pageIndex<5)Container(
                    width: 2.2*pathL,
                    height:2.2*pathL,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(pageImageName[index]),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  if(pageIndex == 5)Container(
                    color: isDarkMode ? greyColor7:whiteColor,
                    height: screenHeight- 2*pathL,
                    child:  SingleChildScrollView(
                      child: Padding(
                        padding:  EdgeInsets.only(left: pathS/3,right: pathS/3,bottom: pathS/3 ),
                        child: Text(
                          'disclaimer_data'.tr(),
                          style: TextStyle(
                            fontSize: pathS/5,
                            color: isDarkMode? whiteColor : greyColor6,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: pathS),

                ],
              ),
              // Positioned(
              //   bottom: paddingBottom+pathL,
              //   child: Container(
              //   width: 2*pathL,
              //   child: Text(
              //     page1footer[index],
              //     style: TextStyle(
              //       fontSize: pathS/5.5,
              //       color: Colors.white,
              //       fontWeight: FontWeight.w700,
              //       fontFamily: 'Roboto',
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              // ),
              // Positioned(
              //   bottom: paddingBottom+pathS/5 + pathS/4,
              //   left: paddingLeft+pathS/3 +pathS/20,
              //     child: Text(
              //   'step'.tr() + ' '+ '${index+1}',
              //   style: TextStyle(
              //       fontSize: pathS/6,
              //       color: Colors.white,
              //     fontWeight: FontWeight.w500,
              //     fontFamily: 'Roboto',
              //   ),
              // ),
              // ),
              // Positioned(
              //   bottom: paddingBottom+ pathS/4,
              //   left: paddingLeft+pathS/3,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: List.generate(
              //       6, // Change this to the total number of onboarding pages
              //           (index) => GestureDetector(
              //               onTap: () => animatePage(index),
              //               child:buildDot(index)),
              //     ),
              //   ),
              // ),
            ],
      );

    }
  Widget buildDot(int index) {
    return Container(
      margin: EdgeInsets.all(pathS/20),
      width: pageIndex == index ? pathS/7 : pathS/10,
      height: pathS/10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: pageIndex == index ? isDarkMode ? redColor1:redColor3 : isDarkMode ? greyColor7:greyColor1,
      ),
    );
  }
  // Load pages sequentially
  void _loadPagesSequentially() {
    Future.delayed(Duration(seconds: 5), () {
      _pageController.nextPage(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
      pageIndex ++; // Circular loop
      if (pageIndex <5) {
        _loadPagesSequentially();
      }
    });
  }


  void animatePage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    if (pageIndex < 5) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    else{
     //request API here
      onTapApply();

    }
  }

  void onTapApply() {

    setState(() {
      alertHeader = 'alert'.tr();
      alertMessage ='apply_loan_alert'.tr();
      showAlert = true;
      cancelText = 'No'.tr();
      okText = 'Yes'.tr();
    });

  }

  void applyLoan(){
    setState(() {
      showLoaderView = true;
    });
    Map <String,String> inputData = {

    };
    APIHelper.instance.getData(applyLoanApi,inputData, (data) {

      setState(() {
        showLoaderView = false;
      });
      if(data.isNotEmpty){

        Map<String, dynamic> loanApplyData = data.first as Map<String, dynamic>;

        final String message = loanApplyData['Message'] ?? '';

        setState(() {
          alertHeader = '';
          alertMessage =message.isNotEmpty ? message: 'loan_requested'.tr();
          showAlert = true;
          cancelText = 'ok'.tr();
          okText = '';
        });


      }

    },(error){
      setState(() {
        showLoaderView = false;
      });
      printInDebug('error received');
    });
  }

}
