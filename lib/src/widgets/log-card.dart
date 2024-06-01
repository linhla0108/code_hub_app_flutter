import 'package:dans_productivity_app_flutter/src/widgets/log-text.dart';
import 'package:flutter/material.dart';

class LogCard extends StatelessWidget {
  final String date;
  final int total;
  final List activities;
  LogCard({
    super.key,
    required this.date,
    required this.total,
    required this.activities,
  });
  @override
  Widget build(BuildContext context) {
    final convertTotalHours = total ~/ 60;
    final convertTotalMins = total % 60;
    final typeActivityName = <int, String>{
      1: 'Coding',
      2: 'Research',
      3: 'Meeting'
    };

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
          color: Color(0XFFEAE9E9),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: const Color(0XFF000000).withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(4, 4), // changes position of shadow
            ),
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Text(date,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),
              Row(
                children: [
                  Text(
                    "Total: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    convertTotalHours.toString() +
                        "h " +
                        convertTotalMins.toString() +
                        "m",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: activities.map<Widget>((activity) {
              return LogText(
                title: typeActivityName[activity.type]!,
                data: activity.value.toString(),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
