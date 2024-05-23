import 'package:flutter/material.dart';

class LogText extends StatelessWidget {
  final String title;
  final String data;
  const LogText({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title + ": ",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Text(data + "%")
      ],
    );
  }
}
