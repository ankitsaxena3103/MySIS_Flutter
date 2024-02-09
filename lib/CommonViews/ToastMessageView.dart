

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
            child: Container(
              width: logicalWidth- 2*marginValue,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                // border: Border.all(color: Colors.red, width: 2),
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(pathS / 10),

              ),
              child: Padding(
                padding:  EdgeInsets.fromLTRB(marginValue, pathS/6, marginValue, pathS/6),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: pathS / 4,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
