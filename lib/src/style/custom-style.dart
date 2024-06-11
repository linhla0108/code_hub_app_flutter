import 'package:flutter/material.dart';

class CustomStyle {
  TextStyle StyleText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Color(0XFF5C5C5C),
  );

  BoxDecoration StyleBoxShadow = BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: const Color(0XFF000000).withOpacity(0.05),
        spreadRadius: 0,
        blurRadius: 10,
        offset: Offset(2, 2),
      ),
    ],
  );
  BoxDecoration StyleBoxShadowLogin = BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: const Color(0XFF000000).withOpacity(0.05),
        spreadRadius: 0,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );

  InputDecoration StyleBorderInput(bool hasValueDate) {
    return InputDecoration(
      errorStyle: TextStyle(
        height: 0,
        color: hasValueDate ? Color(0XFFAAAAAA) : Colors.red,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: hasValueDate ? Color(0xFFDDDDDD) : Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      errorMaxLines: 1,
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: hasValueDate ? Color(0xFFDDDDDD) : Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      filled: true,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: hasValueDate ? Color(0xFFDDDDDD) : Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: hasValueDate ? Color(0xFFDDDDDD) : Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8)),
    );
  }

  InputDecoration StyleInputDatePicker(
      TextEditingController dateController, bool hasValueDate) {
    return StyleBorderInput(hasValueDate).copyWith(
      hintText: "Select Date",
      hintStyle: TextStyle(
        height: 0,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: hasValueDate == true ? Color(0XFF8391A1) : Colors.red,
      ),
      prefixIcon: Icon(
        Icons.calendar_month,
        color: Color(0XFFAAAAAA),
      ),
      suffixIcon: GestureDetector(
        onTap: () {
          dateController.clear();
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(color: Color(0XFFAAAAAA), width: 0.7))),
            child: Icon(Icons.cancel, color: Color(0XFFAAAAAA))),
      ),
    );
  }

  InputDecoration StyleInputNumber(bool showSuffixText) {
    return StyleBorderInput(true).copyWith(
      suffixText: showSuffixText ? "minutes" : null,
      hintText: "Enter your number",
      hintStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0XFF8391A1),
      ),
    );
  }

  TextStyle StyleTextRowPercentage(bool mainText) {
    return TextStyle(
      fontSize: 16,
      color: Color(0XFF555454),
      fontWeight: mainText ? FontWeight.w500 : FontWeight.w400,
    );
  }

  InputDecoration StyleInputLogin(
      bool isPassword, bool hasValue, Widget? revealPassword) {
    return StyleBorderInput(true).copyWith(
      hintText: isPassword ? "Enter your password" : "Enter your email",
      labelText: isPassword ? "Password" : 'Email',
      labelStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color.fromARGB(255, 63, 71, 79),
      ),
      hintStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: hasValue == true ? Color(0XFF8391A1) : Colors.red,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 19, vertical: 15),
      suffixIcon: revealPassword,
    );
  }
}
