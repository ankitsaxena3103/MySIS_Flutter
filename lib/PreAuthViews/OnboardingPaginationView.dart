import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:mysis/UserAuthViews/LoginView.dart';

class OnboardingPaginationView extends StatefulWidget {
  @override
  OnboardingPaginationViewState createState() => OnboardingPaginationViewState();
}

class OnboardingPaginationViewState extends State<OnboardingPaginationView>{

  late PageController _pageController;
  int pageIndex = 0;
  List page1Header = ['Now mark duty In one click!','Duty Attendance records on your fingertips!','Leave application & approval made paperless & simple!','Your important documents go digital, freedom from loss & damage!','Stay updated with notifications of salary, PF, etc.- LIVE!','Get your problems sorted out through ERC - on WhatsApp!'];
  List page1footer = ['MySIS app empowers you to mark daily attendance yourself. Enables you to know your next duty shift and unit.','With MySIS app you can view your daily & monthly duty attendance details anytime.','You can plan & apply for leave in advance. No need for written leave application & branch visit for approval.','MySIS app locker provides facility to have digital copy of all your important documents','','Through MySIS app you can reach to your Operation team, Branch Head or ERC instantly.'];
  List pageImageName = ['assets/images/Onboarding/mark-duty.png','assets/images/Onboarding/attendance-record.png','assets/images/Onboarding/attendance-calender.png','assets/images/Onboarding/document.png','assets/images/Onboarding/notification-icon.png','assets/images/Onboarding/erc-icon.png'];
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
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: paddingTop+pathS/5),
              Container(
                width: pathL,
                height: pathS / 1.5,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/icons/logo@3x.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: pathS/5),
              Container(
                width: screenWidth,
                height: logicalHeight-(paddingTop+2*pathS/5 + pathS/1.5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Onboarding/onboarding-page-bg.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
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
              return onboardingPage(pageIndex);
            },
            itemCount: 6,
          ),

          Positioned(
            bottom: paddingBottom,
            right: paddingRight + pathS / 3,
            child: GestureDetector(
              onTap: () {
                _nextPage();
                print('Next button tapped'); // Use 'print' for debugging
              },
              child: Container(
                width: pathS / 1.2,
                height: pathS / 1.2,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/Onboarding/next-arrow.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget onboardingPage(int index) {

      return Stack(
        alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 2.5*pathL,
                    child: Text(
                      page1Header[index],
                      style: TextStyle(
                          fontSize: pathS/3.5,
                          color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Khand',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: pathS/1.5),
                  Container(
                    width: pageImageSize[index].dx,
                    height:pageImageSize[index].dy,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(pageImageName[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: pathS),

                ],
              ),
              Positioned(
                bottom: paddingBottom+pathL,
                child: Container(
                width: 2*pathL,
                child: Text(
                  page1footer[index],
                  style: TextStyle(
                    fontSize: pathS/5.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ),
              Positioned(
                bottom: paddingBottom+pathS/5 + pathS/4,
                left: paddingLeft+pathS/3 +pathS/20,
                  child: Text(
                'STEP ${index+1}',
                style: TextStyle(
                    fontSize: pathS/6,
                    color: Colors.white,
                  fontWeight: FontWeight.normal,
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
            ],
      );

    }
  Widget buildDot(int index) {
    return Container(
      margin: EdgeInsets.all(pathS/20),
      width: pageIndex == index ? 12.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: pageIndex == index ? Colors.white : Colors.white38,
      ),
    );
  }
  // Load pages sequentially
  void _loadPagesSequentially() {
    Future.delayed(Duration(seconds: 2), () {
      _pageController.nextPage(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
      pageIndex = (pageIndex + 1) % 6; // Circular loop
      _loadPagesSequentially();
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginView(),
        ),
      );
    }
  }

}
