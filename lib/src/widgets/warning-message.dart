import 'package:flutter/material.dart';

class WarningMessage extends StatelessWidget {
  int totalHour;
  int totalMin;
  WarningMessage({super.key, required this.totalHour, required this.totalMin});
  @override
  Widget build(BuildContext context) {
    if (totalMin != 0 && totalHour < 4 || totalHour > 24) {
      return Container(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Warning: ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0XFF5E5E5E),
                ),
              ),
              TextSpan(
                text: totalHour < 4
                    ? "Your work time under 4 hours?  Please double check!!!"
                    : "Your work time over 24 hours???",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF5E5E5E),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(); // or any other widget you want to display when totalHour <= 4
    }
  }
}
