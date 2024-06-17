import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dans_productivity_app_flutter/src/models/history.dart';
import 'package:dans_productivity_app_flutter/src/utils/formatDate.dart';
import 'package:dans_productivity_app_flutter/src/widgets/log-card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity.dart';

class HistoryScreen extends StatefulWidget {
  final Function(bool)? needRefreshOnChanged;
  const HistoryScreen({super.key, this.needRefreshOnChanged});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<History> history = [];

  Future<dynamic>? _historyFuture;

  Future getHistory() async {
    history.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore dbFB = FirebaseFirestore.instance;

    final res = await dbFB
        .collection('histories')
        .where('userId', isEqualTo: prefs.getString('userId'))
        .get();

    for (var eachItems in res.docs) {
      try {
        Map<String, dynamic> data = eachItems.data();

        List<ActivityEntity> activities = [];
        for (var activity in data["activities"]) {
          activities.add(
            ActivityEntity(
                type: activity["type"],
                value: data["total"] != 0
                    ? (activity["value"] / data["total"] * 100).round()
                    : 0),
          );
        }

        final item = History(
            id: eachItems.id,
            date: formatDate(data["date"].toDate()),
            total: data["total"],
            activities: activities);

        history.add(item);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _historyFuture = getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return
        // MaterialApp(
        //     debugShowCheckedModeBanner: false,
        //     home:
        Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
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
                                _historyFuture = getHistory();
                              });
                            },
                          )
                        ],
                        title: const Text(
                          'History',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: Colors.white,
                        floating: true,
                        snap: true,
                        elevation: 0.0,
                      ),
                    ];
                  },
                  body: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.5, 1.0],
                          colors: [
                            Color(0xFFF3F3F3),
                            Color(0x9FE6E5E5),
                            Color(0xFFC0C0C0),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: FutureBuilder(
                      future: _historyFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                              padding: EdgeInsets.fromLTRB(16, 28, 16, 0),
                              itemCount: history.length,
                              itemBuilder: (context, index) {
                                return LogCard(
                                  id: history[index].id,
                                  date: history[index].date,
                                  total: history[index].total,
                                  activities: history[index].activities,
                                  needRefreshOnChanged: (value) {
                                    setState(() {
                                      _historyFuture = getHistory();
                                    });
                                  },
                                );
                              });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    // ),
                  )),
            ))
        // )
        ;
  }
}
