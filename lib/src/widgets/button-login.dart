import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {
  final String title;
  final void Function() onPress;
  final double? width;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final AlignmentGeometry position;
  const ButtonLogin({
    super.key,
    required this.title,
    required this.height,
    required this.fontSize,
    required this.fontWeight,
    required this.onPress,
    this.width,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: position,
        child: Container(
          height: height,
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            onPressed: onPress,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                  fontWeight: fontWeight),
            ),
          ),
        ),
      ),
    );
  }
}
