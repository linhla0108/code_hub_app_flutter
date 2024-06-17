import 'package:flutter/material.dart';

class WarningMessage extends StatelessWidget {
  final bool isExistedData;
  final int totalHour;
  final int totalMin;
  WarningMessage(
      {super.key,
      required this.totalHour,
      required this.totalMin,
      required this.isExistedData});
  @override
  Widget build(BuildContext context) {
    if (isExistedData == true ||
        totalMin != 0 && totalHour < 4 ||
        totalHour >= 24) {
      return Container(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "Warning: ", style: styleWarningMessage().Warning),
              TextSpan(
                text: isExistedData == true
                    ? "The currently selected date already has on the database!!!"
                    : totalHour < 4
                        ? "Your work time under 4 hours?  Please double check!!!"
                        : "Your work time over 24 hours???",
                style: styleWarningMessage().Normal,
              ),
              TextSpan(
                  text: isExistedData == true
                      ? "\nDo you want overwrite it?"
                      : "",
                  style: styleWarningMessage().Important),
            ],
          ),
        ),
      );
    } else {
      return Container(); // or any other widget you want to display when totalHour <= 4
    }
  }
}

class styleWarningMessage {
  TextStyle Warning = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: Color(0XFF5E5E5E),
  );
  TextStyle Normal = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Color(0XFF5E5E5E),
  );

  TextStyle Important = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.red,
  );
}
