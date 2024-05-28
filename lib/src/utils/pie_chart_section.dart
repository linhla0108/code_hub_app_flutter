import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

PieChartSectionData buildPieChartSectionData(
    {required BuildContext context,
    required double value,
    required Color color}) {
  return PieChartSectionData(
    radius: MediaQuery.of(context).size.width * 0.28,
    color: color,
    value: value,
    title: '${value.toString()}%',
    titleStyle: TextStyle(
        fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
    titlePositionPercentageOffset: value >= 50 ? 0.5 : 0.65,
  );
}
