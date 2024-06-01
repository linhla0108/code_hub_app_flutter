import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../models/history.dart';
import '../utils/custom-snack-bar.dart';
import '../widgets/button-create-submit.dart';
import '../widgets/input-field.dart';
import '../widgets/row-type-percentage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateLogScreen extends StatefulWidget {
  bool isCreateNew;
  int? historyId;

  CreateLogScreen({super.key, required this.isCreateNew, this.historyId});

  @override
  State<CreateLogScreen> createState() => _CreateLogScreenState();
}

class _CreateLogScreenState extends State<CreateLogScreen> {
  final dateController = TextEditingController();
  final inputCodingController = TextEditingController();
  final inputResearchController = TextEditingController();
  final inputMeetingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool hasValueDate = true;
  bool validateComfirmed = false;
  int totalValue = 0;
  int valueCoding = 0;
  int valueResearch = 0;
  int valueMeeting = 0;
  int codingPercentage = 0;
  int researchPercentage = 0;
  int meetingPercentage = 0;

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    maxlengthInput(inputCodingController);
    maxlengthInput(inputResearchController);
    maxlengthInput(inputMeetingController);

    dateController.addListener(() {
      setState(() {
        hasValueDate = dateController.text.isNotEmpty;
      });
    });

    widget.isCreateNew == true ? null : getHistory(100);
  }

  void maxlengthInput(TextEditingController controller) {
    controller.addListener(() {
      if (controller.text.length > 10) {
        controller.text = controller.text.substring(0, 10);
        controller.selection =
            TextSelection.fromPosition(TextPosition(offset: 10));
      }
    });
  }

  List<History> history = [];
  Future getHistory(int id) async {
    history.clear();
    var res =
        await http.get(Uri.parse('http://localhost:3000/histories?id=$id'));
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

      setState(() {
        inputCodingController.text = item.activities[0].value.toString();
        inputResearchController.text = item.activities[1].value.toString();
        inputMeetingController.text = item.activities[2].value.toString();
      });
      calculateStats();
      history.add(item);
    }
    print(history);
  }

  Future<void> _selectedDate(BuildContext context) async {
    int currentYear = DateTime.now().year;

    DateTime? dateTimePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(currentYear - 1),
        lastDate: DateTime(currentYear + 1));

    if (dateTimePicked != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(dateTimePicked);
      });
    }
  }

  void calculateStats() {
    valueCoding = int.tryParse(inputCodingController.text) ?? 0;
    valueResearch = int.tryParse(inputResearchController.text) ?? 0;
    valueMeeting = int.tryParse(inputMeetingController.text) ?? 0;

    totalValue = valueCoding + valueResearch + valueMeeting;

    calculatePercentage(int input) {
      return totalValue != 0 ? (input / totalValue * 100).round() : 0;
    }

    setState(() {
      codingPercentage = calculatePercentage(valueCoding);
      researchPercentage = calculatePercentage(valueResearch);
      meetingPercentage = calculatePercentage(valueResearch);
    });
  }

  void clearForm() {
    List<TextEditingController> controllers = [
      dateController,
      inputCodingController,
      inputResearchController,
      inputMeetingController
    ];
    controllers.forEach((controllers) {
      controllers.clear();
      print(controllers.text);
    });

    totalValue = 0;
    codingPercentage = 0;
    researchPercentage = 0;
    meetingPercentage = 0;
  }

  Future<void> createNewLog() async {
    var now = DateTime.now();
    var formatter = DateFormat('HHmmssMMdd');
    String idItem = formatter.format(now);

    // await http.post(
    //   Uri.parse('http://localhost:3000/histories/'),
    //   body: jsonEncode({
    //     'id': int.parse(idItem),
    //     'date': dateController.text,
    //     'total': totalValue,
    //     "activities": [
    //       ActivityEntity(type: 1, value: valueCoding),
    //       ActivityEntity(type: 2, value: valueMeeting),
    //       ActivityEntity(type: 3, value: valueResearch),
    //     ],
    //   }),
    // );
    await http.put(
      Uri.parse('http://localhost:3000/histories?id=${widget.historyId}'),
      body: jsonEncode({
        'id': int.parse(idItem),
        'date': dateController.text,
        'total': totalValue,
        "activities": [
          ActivityEntity(type: 1, value: valueCoding),
          ActivityEntity(type: 2, value: valueMeeting),
          ActivityEntity(type: 3, value: valueResearch),
        ],
      }),
    );
  }

  Future<void> uploadData() async {
    await createNewLog();
    CustomSnackBar(context, "Your log has been created!", false);
    clearForm();
  }

  void validateForm() {
    if (hasValueDate == false) {
      CustomSnackBar(context, "Please select a date", true);
    } else if (inputCodingController.text.isEmpty &&
        inputResearchController.text.isEmpty &&
        inputMeetingController.text.isEmpty) {
      CustomSnackBar(context, "You must enter at least 1 field ", true);
    } else {
      if (formKey.currentState!.validate()) {
        //  widget.isCreateNew ==true ?
        uploadData();
      } else {
        CustomSnackBar(context, "Please try again!", true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.isCreateNew == true
              ? 'CREATE NEW LOG'
              : "EDIT LOG ID ${widget.historyId}",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Color(0XFFF3F3F3),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              InputCreateLog(
                label: "Date:",
                controller: dateController,
                onTap: () {
                  _selectedDate(context);
                },
                showSuffixText: false,
                isDatepicker: true,
                hasValueDate: hasValueDate,
                validator: (date) {
                  if (date == null || date.isEmpty) {
                    return "";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              InputCreateLog(
                label: 'Coding:',
                showSuffixText: inputCodingController.text.isNotEmpty,
                controller: inputCodingController,
                onChanged: (value) {
                  calculateStats();
                },
              ),
              SizedBox(height: 20),
              InputCreateLog(
                label: 'Research:',
                showSuffixText: inputResearchController.text.isNotEmpty,
                controller: inputResearchController,
                onChanged: (value) {
                  calculateStats();
                },
              ),
              SizedBox(height: 20),
              InputCreateLog(
                label: 'Meeting:',
                showSuffixText: inputMeetingController.text.isNotEmpty,
                controller: inputMeetingController,
                onChanged: (value) {
                  calculateStats();
                },
              ),
              SizedBox(
                height: 32,
                child: Divider(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
              RowTypePercentage(
                  total: totalValue,
                  coding: codingPercentage,
                  research: researchPercentage,
                  meeting: meetingPercentage),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ButtonCreateSubmit(
                        isCreateNew: widget.isCreateNew,
                        onPressed: validateForm)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
