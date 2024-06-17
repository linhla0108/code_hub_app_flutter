import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:dans_productivity_app_flutter/src/widgets/floating-button.dart';
import 'package:dans_productivity_app_flutter/src/widgets/log-card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity.dart';
import '../models/dashboard.dart';
import '../utils/animation-text.dart';
import '../utils/formatDate.dart';
import '../utils/loading-animation.dart';
import '../widgets/pie-chart.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  FirebaseFirestore dbFB = FirebaseFirestore.instance;

  String userName = "...";
  int optionSelected = 1;
  DateTime now = DateTime.now();

  DashboardEntity? dataToday;
  DashboardEntity? dataThisMonth;
  DashboardEntity? dataThisYear;
  DashboardEntity? currentData;

  Future getDataUser() async {
    showLoadingDialog(context);

    var data = dbFB.collection('histories');

    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    DateTime endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    DateTime firstDayOfYear = DateTime(now.year, 1, 1);
    DateTime lastDayOfYear = DateTime(now.year + 1, 1, 0);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final infoUser = await dbFB.collection('users').doc(userId).get();

    setState(() {
      userName = infoUser['name'];
    });

    void fetchQueryDate(DateTime start, DateTime end, Function formatLabel) {
      data
          .where('date', isGreaterThanOrEqualTo: start)
          .where('date', isLessThanOrEqualTo: end)
          .where('userId', isEqualTo: userId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          num totalValue = 0;
          num totalCoding = 0;
          num totalResearch = 0;
          num totalMeeting = 0;
          List<ActivityEntity> activities = [];

          querySnapshot.docs.forEach((doc) {
            totalCoding += doc["activities"][0]["value"];
            totalResearch += doc["activities"][1]["value"];
            totalMeeting += doc["activities"][2]["value"];
            totalValue += doc['total'];
          });

          void addActivity(int type, num totalActivityValue) {
            activities.add(
              ActivityEntity(
                type: type,
                value: totalValue != 0
                    ? (totalActivityValue / totalValue * 100).round()
                    : 0,
              ),
            );
          }

          addActivity(1, totalCoding);
          addActivity(2, totalResearch);
          addActivity(3, totalMeeting);

          setState(() {
            DashboardEntity data = DashboardEntity(
                label: formatLabel(now),
                total: totalValue.toInt(),
                activities: activities);
            if (start == startOfToday) {
              dataToday = data;
              optionSelected != 1 ? null : currentData = dataToday;
            } else if (start == firstDayOfMonth) {
              dataThisMonth = data;
            } else if (start == firstDayOfYear) {
              dataThisYear = data;
            }
          });
        }
      }).catchError((error) {
        print("Failed to get data: $error");
      }).whenComplete(() =>
              start == firstDayOfYear ? Navigator.of(context).pop() : null);
    }

    fetchQueryDate(startOfToday, endOfToday, formatDate);
    fetchQueryDate(firstDayOfMonth, lastDayOfMonth, formatMonth);
    fetchQueryDate(firstDayOfYear, lastDayOfYear, formatYear);
  }

  void updateOption(int option) {
    setState(() {
      optionSelected = option;
      switch (option) {
        case 1:
          currentData = dataToday;
          break;
        case 2:
          currentData = dataThisMonth;
          break;
        case 3:
          currentData = dataThisYear;
          break;
        default:
          currentData = dataToday;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 20),
            icon: Icon(
              Icons.refresh,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                getDataUser();
              });
            },
          )
        ],
        backgroundColor: Colors.white,
        title: const Text('Dashboard',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
      ),
      floatingActionButton: Container(
          alignment: AlignmentGeometry.lerp(
              Alignment.topRight, Alignment.bottomRight, 0.85),
          child: FloatingButton()),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
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
                        formatDate(now),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(children: [
                    Text(
                      userName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ])
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            transform: Matrix4.translationValues(
                0, MediaQuery.of(context).size.height * 0.14, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Color.fromARGB(255, 73, 195, 183)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                children: [
                  CustomSlidingSegmentedControl<int>(
                    height: 40,
                    isStretch: true,
                    isShowDivider: true,
                    initialValue: 1,
                    dividerSettings: DividerSettings(
                      thickness: 0.3,
                      indent: 8,
                      endIndent: 8,
                    ),
                    children: {
                      1: AnimationText(
                          duration: 200,
                          text: 'Today',
                          fontSize: 14,
                          fontweight: FontWeight.w500,
                          color: optionSelected == 1
                              ? Colors.white
                              : Colors.black),
                      2: AnimationText(
                          duration: 200,
                          text: 'Month',
                          fontSize: 14,
                          fontweight: FontWeight.w500,
                          color: optionSelected == 2
                              ? Colors.white
                              : Colors.black),
                      3: AnimationText(
                          duration: 200,
                          text: 'Year',
                          fontSize: 14,
                          fontweight: FontWeight.w500,
                          color: optionSelected == 3
                              ? Colors.white
                              : Colors.black),
                    },
                    decoration: BoxDecoration(
                      color: CupertinoColors.lightBackgroundGray,
                      borderRadius: BorderRadius.circular(68),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff000000).withOpacity(.25),
                          blurRadius: 10,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    thumbDecoration: BoxDecoration(
                      color: Color(0XFF2E2E2E),
                      borderRadius: BorderRadius.circular(68),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.2),
                          blurRadius: 4.0,
                          spreadRadius: 1.0,
                          offset: Offset(
                            0.0,
                            2.0,
                          ),
                        ),
                      ],
                    ),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    onValueChanged: (clickOption) {
                      setState(() {
                        updateOption(clickOption);
                      });
                    },
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        optionSelected == 1
                            ? 'Today'
                            : optionSelected == 2
                                ? 'Current Month'
                                : 'Whole Year',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  currentData == null
                      ? Text("No Data Record")
                      : Column(
                          children: [
                            LogCard(
                                id: "", // need to change
                                date: currentData!.label,
                                total: currentData!.total,
                                activities: currentData!.activities),
                            SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 13,
                                        width: 13,
                                        margin: EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                          color: Color(0XFF626262),
                                        ),
                                      ),
                                      Text(
                                        "Coding",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 13,
                                        width: 13,
                                        margin: EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                          color: Color(0XFF9B9B9B),
                                        ),
                                      ),
                                      Text(
                                        "Research",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 13,
                                        width: 13,
                                        margin: EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                          color: Color(0XFFE1E1E1),
                                        ),
                                      ),
                                      Text(
                                        "Meeting",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 250,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(70, 20, 70, 0),
                                  child: ChartDashBoard(
                                    dataChart: currentData!.activities,
                                  )),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
