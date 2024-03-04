

import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';

class ToastMessageView extends StatelessWidget {
  final bool isVisible;
  final String message;
  const ToastMessageView({super.key,
    required this.isVisible, required this.message,
  });

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    return Visibility(
      visible: isVisible,
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding:  EdgeInsets.only(left: pathS/3,right: pathS/3),
              child: Container(
                // width: logicalWidth- 2*marginValue,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  // border: Border.all(color: Colors.red, width: 2),
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(pathS / 6),

                ),
                child: Padding(
                  padding:  EdgeInsets.fromLTRB(pathS/5,pathS/15,pathS/5,pathS/15),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: pathS / 5,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
