import 'dart:math';

import 'package:dans_productivity_app_flutter/src/models/history.dart';
import 'package:dans_productivity_app_flutter/src/widgets/log-card.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Dashboard',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 20, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "20/05/2024",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(children: [
                    Text(
                      "Vawn Datj Lor",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ])
                ],
              ),
            ),
          ),
          Container(
            transform: Matrix4.translationValues(
                0, MediaQuery.of(context).size.height * 0.16, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35)),
                color: Color.fromARGB(255, 73, 195, 183)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 20, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Today",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  LogCard(date: "20/05/2024", total: 370, activities: [
                    Activity(type: 1, percentage: 70),
                    Activity(type: 2, percentage: 10),
                    Activity(type: 3, percentage: 20)
                  ]),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
