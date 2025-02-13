import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../CommonViews/Utility.dart';

class SimpleUnderLineTextField extends StatelessWidget {
  final TextEditingController txtUserId;
  final bool isDarkMode;
  final Color lineBorderColor;

  final Function(String) onUserIdChange;

  const SimpleUnderLineTextField({
    super.key,
    required this.txtUserId,
    required this.onUserIdChange,
    required this.isDarkMode,
    required this.lineBorderColor,
  });



  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: txtUserId,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10), // Limit to 10 characters
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')), // Allow letters and numbers only
        UpperCaseTextInputFormatter(), // Convert input to uppercase
      ],
      style: TextStyle(
        color: isDarkMode ? whiteColor : greyColor6,
        fontSize: pathS / 5,
        fontFamily: 'Roboto',
      ),
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: isDarkMode ? whiteColor : greyColor6,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: lineBorderColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: lineBorderColor),
        ),
      ),
      onChanged: (value) {
        onUserIdChange(value);
      },
      textAlign: TextAlign.start, // Ensures input starts from the left
    );

  }
}

class UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(), // Convert text to uppercase
      selection: newValue.selection,
    );
  }
}
