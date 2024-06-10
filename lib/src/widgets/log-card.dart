import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dans_productivity_app_flutter/src/utils/custom-snack-bar.dart';
import 'package:dans_productivity_app_flutter/src/widgets/log-text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../screens/create-edit-log.dart';

class LogCard extends StatefulWidget {
  final String date;
  final int total;
  final List activities;
  final String id;
  final Function(bool)? needRefreshOnChanged;
  LogCard({
    super.key,
    required this.id,
    required this.date,
    required this.total,
    required this.activities,
    this.needRefreshOnChanged,
  });

  @override
  State<LogCard> createState() => _LogCardState();
}

class _LogCardState extends State<LogCard> with TickerProviderStateMixin {
  // late SlidableController slidableController;
  // bool isDragLeft = false;
  bool needRefresh = false;

  @override
  void initState() {
    super.initState();
    // slidableController = SlidableController(this);
  }

  void deleteHistory() {
    FirebaseFirestore.instance
        .collection('histories')
        .doc(widget.id)
        .delete()
        .then((_) {
      widget.needRefreshOnChanged!(needRefresh);
      CustomSnackBar(context, "Delete successfully!", false);
      print('Document successfully deleted');
    }).catchError((error) {
      CustomSnackBar(context, "Please try later!", true);

      print('Error deleting document: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final convertTotalHours = widget.total ~/ 60;
    final convertTotalMins = widget.total % 60;
    final typeActivityName = <int, String>{
      1: 'Coding',
      2: 'Research',
      3: 'Meeting'
    };

    return Container(
      // color: Colors.blue,
      margin: EdgeInsets.only(bottom: 16),
      child: Slidable(
        key: Key(widget.id),
        // dragStartBehavior: DragStartBehavior.down,
        // controller: slidableController,
        endActionPane: ActionPane(
            dismissible: DismissiblePane(onDismissed: () {
              deleteHistory();
            }),
            extentRatio: 0.45,
            motion: DrawerMotion(),
            children: [
              CustomSlidableAction(
                flex: 7,
                backgroundColor: Colors.red,
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateEditLogScreen(
                                isCreateNew: false,
                                historyId: widget.id,
                              )));
                },
                padding: EdgeInsets.zero,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              CustomSlidableAction(
                flex: 6,
                // backgroundColor: Colors.red,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_forever_rounded),
                      Text('Delete'),
                    ],
                  ),
                ),
                backgroundColor: Colors.black,
                onPressed: (BuildContext context) {
                  deleteHistory();
                },
                autoClose: false,
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ]),
        child: Container(
          width: MediaQuery.of(context).size.width,
          // margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
              color: Color(0XFFEAE9E9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                bottomLeft: Radius.circular(13),
                topRight: Radius.circular(13),
                bottomRight: Radius.circular(13),
              ),
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
                    child: Text(widget.date,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ),
                  Row(
                    children: [
                      Text(
                        "Total: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
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
                children: widget.activities.map<Widget>((activity) {
                  return LogText(
                    title: typeActivityName[activity.type]!,
                    data: activity.value.toString(),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
