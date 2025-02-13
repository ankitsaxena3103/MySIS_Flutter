import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/Utility.dart';

import 'dart:core';

class CustomNumericKeypad extends StatefulWidget {
  final void Function(int) keypadNumber;
  const CustomNumericKeypad({
    super.key,
    required this.keypadNumber,
  });

  @override
  CustomNumericKeypadState createState() => CustomNumericKeypadState();
}

class CustomNumericKeypadState extends State<CustomNumericKeypad> with SingleTickerProviderStateMixin {
  int? _keyPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.keypadNumber(-1); // Handle background tap if needed
      },
      child: Container(
        width: logicalWidth,
        height: logicalHeight, // Adjust the height of the keypad container
        color: Colors.black.withOpacity(0.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: screenWidth,
              height: 4 * pathS / 1.5 + 3 * marginValue + paddingBottom,
              color: isDarkMode ? greyColor7 : greyColor1,
              child: Padding(
                padding: EdgeInsets.only(top: pathS / 8, bottom: pathS / 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // First row of keys
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return _buildKey(index + 1);
                      }),
                    ),
                    SizedBox(height: marginValue / 2), // Gap between rows
                    // Second row of keys
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return _buildKey(index + 4);
                      }),
                    ),
                    SizedBox(height: marginValue / 2), // Gap between rows
                    // Third row of keys
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return _buildKey(index + 7);
                      }),
                    ),
                    SizedBox(height: marginValue / 2), // Gap between rows
                    // Fourth row of keys (for '0' and 'Delete')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth / 3 - marginValue,
                          height: pathS / 1.5,
                        ),
                        SizedBox(width: marginValue/2), // Gap between keys
                        _buildKey(0), // '0' key
                        _buildKey(10), // 'Delete' key
                      ],
                    ),
                    SizedBox(height: paddingBottom),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKey(int keyValue) {
    String keyText = keyValue == 0 ? '0' : keyValue.toString();
    return GestureDetector(
      onTap: (){
        _onKeyTapDown(keyValue);
      },
      // onTapDown: (_) => _onKeyTapDown(keyValue),
      // onTapUp: (_) => _onKeyTapUp(keyValue),
      onTapCancel: () => _onKeyTapCancel(),
      child: AnimatedScale(
        scale: _keyPressed == keyValue ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: marginValue / 4),
          width: screenWidth / 3 - marginValue,
          height: pathS / 1.5,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(pathS / 15),
            color: isDarkMode
                ? keyValue == 10
                ? Colors.transparent
                : greyColor8
                : keyValue == 10
                ? Colors.transparent
                : Colors.white,
            boxShadow: [
              BoxShadow(
                color: keyValue == 10 ? Colors.transparent : Colors.black.withOpacity(0.1),
                blurRadius: pathS / 10,
                offset: Offset(-pathS / 12, pathS / 12),
              ),
            ],
          ),
          child: Center(
            child: keyValue == 10
                ? Icon(
              Icons.backspace_outlined, // Use the backspace icon
              color: isDarkMode ? whiteColor : greyColor6,
              size: pathS / 3,
            )
                : Text(
              keyText,
              style: TextStyle(
                color: isDarkMode ? whiteColor : greyColor6,
                fontSize: pathS / 3,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }


  void _onKeyTapDown(int keyValue) {
    setState(() {
      _keyPressed = keyValue;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _keyPressed = null;
      });
      widget.keypadNumber(keyValue);
    });

  }

  void _onKeyTapUp(int keyValue) {
    setState(() {
      _keyPressed = null;
    });
    widget.keypadNumber(keyValue);
  }

  void _onKeyTapCancel() {
    setState(() {
      _keyPressed = null;
    });
  }
}

