import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

Flushbar CustomSnackBar(
  BuildContext context,
  String message,
  bool isError,
) {
  return Flushbar(
    backgroundColor:
        isError == true ? Colors.red : Color.fromARGB(255, 82, 174, 85),
    duration: Duration(seconds: 2),
    flushbarStyle: FlushbarStyle.FLOATING,
    margin: EdgeInsets.fromLTRB(24, 0, 24, 15),
    padding: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(10),
    // reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticInOut,
    messageSize: 16,
    messageText: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(
            isError == false
                ? Icons.check_circle_outline_rounded
                : Icons.cancel_outlined,
            color: Colors.white,
            size: 40,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isError == false ? "Success" : "Error",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ))
      ],
    ),
  )..show(context);
}
