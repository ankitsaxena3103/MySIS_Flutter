import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';



class GeneralRulesView extends StatefulWidget {
  @override
  GeneralRulesViewState createState() => GeneralRulesViewState();
}

class GeneralRulesViewState extends State<GeneralRulesView>{

  String generalRuleData = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc scelerisque varius libero ut imperdiet. Donec sit amet neque at nisi convallis placerat at nec quam. Nunc scelerisque id sapien vel ornare. Mauris vel efficitur nulla. Sed sit amet sem sit amet ante placerat efficitur at vel nunc. Vivamus et porta lectus. Proin suscipit tortor at aliquet tincidunt. Nam venenatis purus velit, vel mattis augue efficitur aliquet. \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc scelerisque varius libero ut imperdiet. Donec sit amet neque at nisi convallis placerat at nec quam. \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc scelerisque varius libero ut imperdiet. Donec sit amet neque at nisi convallis placerat at nec quam. Nunc scelerisque id sapien vel ornare. Mauris vel efficitur nulla. Sed sit amet sem sit amet ante placerat efficitur at vel nunc. Vivamus et porta lectus. Proin suscipit tortor at aliquet tincidunt. Nam venenatis purus velit, vel mattis augue efficitur aliquet. \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc scelerisque varius libero ut imperdiet. Donec sit amet neque at nisi convallis placerat at nec quam. Nunc scelerisque id sapien vel ornare. Mauris vel efficitur nulla. Sed sit amet sem sit amet ante placerat efficitur at vel nunc. Vivamus et porta lectus. Proin suscipit tortor at aliquet tincidunt. Nam venenatis purus velit, vel mattis augue efficitur aliquet. \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc scelerisque varius libero ut imperdiet. Donec sit amet neque at nisi convallis placerat at nec quam. Nunc scelerisque id sapien vel ornare. Mauris vel efficitur nulla. Sed sit amet sem sit amet ante placerat efficitur at vel nunc. Vivamus et porta lectus. Proin suscipit tortor at aliquet tincidunt. Nam venenatis purus velit, vel mattis augue efficitur aliquet. \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc scelerisque varius libero ut imperdiet. Donec sit amet neque at nisi convallis placerat at nec quam. \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc scelerisque varius libero ut imperdiet. Donec sit amet neque at nisi convallis placerat at nec quam. Nunc scelerisque id sapien vel ornare. Mauris vel efficitur nulla. Sed sit amet sem sit amet ante placerat efficitur at vel nunc. Vivamus et porta lectus. Proin suscipit tortor at aliquet tincidunt. Nam venenatis purus velit, vel mattis augue efficitur aliquet. \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc scelerisque varius libero ut imperdiet. Donec sit amet neque at nisi convallis placerat at nec quam. Nunc scelerisque id sapien vel ornare. Mauris vel efficitur nulla. Sed sit amet sem sit amet ante placerat efficitur at vel nunc. Vivamus et porta lectus. Proin suscipit tortor at aliquet tincidunt. Nam venenatis purus velit, vel mattis augue efficitur aliquet.';


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
                    behavior: HitTestBehavior.translucent,
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
                          'txt_general_rule'.tr(),
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

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: pathS),
                    Text(
                      'general_rules'.tr(),
                      style: TextStyle(
                        color: isDarkMode ?  whiteColor:greyColor6,
                        fontSize: pathS / 4,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: pathS/3),
                    Container(
                      height: screenHeight -pathL*1.5,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(top:pathS/3, left: paddingLeft+pathS/4,right: paddingRight+pathS/4),
                          child:Text(
                            generalRuleData,
                            style: TextStyle(
                              color: isDarkMode ?  whiteColor:greyColor6,
                              fontSize: pathS / 5.5,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.left,
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


  }

