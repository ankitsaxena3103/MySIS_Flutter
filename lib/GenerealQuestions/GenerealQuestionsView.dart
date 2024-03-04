import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';

class GenerealQuestionsView extends StatefulWidget {
  @override
  GenerealQuestionsViewState createState() => GenerealQuestionsViewState();
}

class GenerealQuestionsViewState extends State<GenerealQuestionsView>{

  List<bool> showSubText = List.generate(5, (index) => false);

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
                          'faq'.tr(),
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

                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+pathS),
                  child: ListView.builder(
                    itemCount: 3, // Change this to the number of times you want to repeat the top column
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:  EdgeInsets.only(bottom: pathS/2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: screenWidth - 2.5 * marginValue,
                              child: Text(
                                'Attendance',
                                style: TextStyle(
                                  color: isDarkMode ? whiteColor : greyColor6,
                                  fontSize: pathS / 5,
                                  fontWeight: FontWeight.w600,
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
                                color: isDarkMode ? greyColor8 : whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1), // Shadow color
                                    blurRadius: pathS / 10, // Spread of the shadow
                                    offset: Offset(-pathS / 12, pathS / 12),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: pathS / 4, top: pathS / 4, bottom: pathS / 4),
                                child: Column(
                                  children: List.generate(
                                    3,
                                        (index) => Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                showSubText[index] = !showSubText[index];
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'This is the dummy text for the question ${index + 1}',
                                                    style: TextStyle(
                                                      color: isDarkMode ? whiteColor : greyColor6,
                                                      fontSize: pathS / 5.5,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Container(
                                                  width: pathS / 2,
                                                  height: pathS / 2,
                                                  child: Image.asset(
                                                    showSubText[index]
                                                        ? "assets/images/dashboard-icons/up-arrow.png"
                                                        : "assets/images/dashboard-icons/down-arrow.png",
                                                    color: isDarkMode ? whiteColor : greyColor6,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: pathS / 8),
                                          Visibility(
                                            visible: showSubText[index],
                                            child: Padding(
                                              padding: EdgeInsets.only(right: pathS / 2),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'This is the dummy text for the question ${index + 1}',
                                                      style: TextStyle(
                                                        color: isDarkMode ? whiteColor : greyColor6,
                                                        fontSize: pathS / 7,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: pathS / 8),
                                          Padding(
                                            padding: EdgeInsets.only(right: 16.0),
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
                      );
                    },
                  )

                ),
              ],
            ),
          ),



        ],
      ),
    );
  }


}
