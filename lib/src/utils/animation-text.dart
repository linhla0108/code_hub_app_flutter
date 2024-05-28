import 'package:flutter/material.dart';

class AnimationText extends StatelessWidget {
  final int duration;
  final double? fontSize;
  final String text;
  final FontWeight? fontweight;
  final Color? color;
  final TextStyle? otherTextStyle;
  final AnimatedDefaultTextStyle? otherStyle;

  const AnimationText(
      {super.key,
      required this.duration,
      this.fontSize,
      required this.text,
      this.fontweight,
      this.color,
      this.otherTextStyle,
      this.otherStyle});

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontweight,
        color: color,
      ).merge(otherTextStyle),
      duration: Duration(milliseconds: duration),
      child: Text(text),
    );
  }
}
