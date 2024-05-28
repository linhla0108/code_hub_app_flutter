import 'package:dans_productivity_app_flutter/src/utils/pie_chart_section.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/activity.dart';

class ChartDashBoard extends StatelessWidget {
  List<ActivityEntity> dataChart;
  ChartDashBoard({super.key, required this.dataChart});

  final List<Color> colorList = [
    Color(0XFF626262),
    Color(0XFF9B9B9B),
    Color(0XFFE1E1E1),
  ];

  @override
  Widget build(BuildContext context) {
    print(dataChart);
    return PieChart(
      swapAnimationCurve: Curves.easeInOutCubic,
      swapAnimationDuration: const Duration(milliseconds: 600),
      PieChartData(
        sectionsSpace: 3,
        centerSpaceRadius: 0,
        sections: dataChart.map((activity) {
          return buildPieChartSectionData(
              color: colorList[activity.type - 1],
              value: activity.percentage.toDouble(),
              context: context);
        }).toList(),
      ),
    );
  }
}
