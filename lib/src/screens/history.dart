import 'dart:async';

import 'package:dans_productivity_app_flutter/src/models/history.dart';
import 'package:dans_productivity_app_flutter/src/widgets/log-card.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/activity.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<History> history = [];
  Future<dynamic>? _historyFuture;
  Future getHistory() async {
    history.clear();
    var res = await http.get(Uri.parse('http://localhost:3000/histories'));
    var data = jsonDecode(res.body);

    for (var eachItems in data) {
      List<ActivityEntity> activities = [];
      for (var activity in eachItems["activities"]) {
        activities.add(
            ActivityEntity(type: activity["type"], value: activity["value"]));
      }
      final item = History(
          id: eachItems['id'],
          date: eachItems["date"],
          total: eachItems["total"],
          activities: activities);
      history.add(item);
    }
  }

  @override
  void initState() {
    super.initState();
    _historyFuture = getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // theme: ThemeData(
        //   fontFamily: 'Montserrat',
        // ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
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
                                  date: history[index].date,
                                  total: history[index].total,
                                  activities: history[index].activities,
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
            )));
  }
}
