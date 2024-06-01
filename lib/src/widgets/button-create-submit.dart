import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ButtonCreateSubmit extends StatelessWidget {
  final bool isCreateNew;
  void Function() onPressed;

  ButtonCreateSubmit(
      {super.key, required this.isCreateNew, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 50),
        child: Container(
          width: 346,
          height: 55,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0XFF000000).withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
            onPressed: () {
              onPressed();
            },
            child: Text(
              isCreateNew == true ? "Create" : "Submit",
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: Color(0XFF5E5E5E)),
            ),
          ),
        ));
  }
}
