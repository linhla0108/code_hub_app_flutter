import 'package:flutter/material.dart';
import '../style/custom-style.dart';
import 'warning-message.dart';

class RowTypePercentage extends StatelessWidget {
  int total;
  int coding;
  int research;
  int meeting;
  RowTypePercentage(
      {super.key,
      required this.total,
      required this.coding,
      required this.research,
      required this.meeting});

  @override
  Widget build(BuildContext context) {
    final convertTotalHours = total ~/ 60;
    final convertTotalMins = total % 60;

    return Column(
      children: [
        Row(
          children: [
            Text(
              "Total: ",
              style: CustomStyle().StyleText,
            ),
            Text(
              convertTotalHours.toString() +
                  "h " +
                  convertTotalMins.toString() +
                  "m",
              style: CustomStyle().StyleText,
            )
          ],
        ),
        SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ChildRowTypePercentage(label: "Coding: ", data: coding),
            ChildRowTypePercentage(label: "Research: ", data: research),
            ChildRowTypePercentage(label: "Meeting: ", data: meeting),
          ],
        ),
        SizedBox(height: 40),
        WarningMessage(
          totalHour: convertTotalHours,
          totalMin: convertTotalMins,
        ),
      ],
    );
  }
}

class ChildRowTypePercentage extends StatelessWidget {
  final String label;
  final int data;
  ChildRowTypePercentage({super.key, required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: CustomStyle().StyleTextRowPercentage(true),
        ),
        Text(
          data.toString() + "%",
          style: CustomStyle().StyleTextRowPercentage(false),
        ),
      ],
    );
  }
}
