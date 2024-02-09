
// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';

class DutyView extends StatefulWidget {

  DutyView(
      {
        super.key,
      });


  @override
  DutyViewState createState() => DutyViewState();
}

class DutyViewState extends State<DutyView> {


  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);

    return Material(
      child: Scaffold(
        body: Container(
            width: logicalWidth,
            height: logicalHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: backgroundGradient,

            ),
            child: Stack(
              children: [

              ],
            )

        ),
      ),
    );
  }

  void initialSetup() {
  }




}