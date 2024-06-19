import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history.dart';
import '../utils/custom-snack-bar.dart';
import '../utils/formatDate.dart';
import '../utils/loading-animation.dart';
import '../widgets/button-create-submit.dart';
import '../widgets/input-field.dart';
import '../widgets/row-type-percentage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateEditLogScreen extends StatefulWidget {
  final bool isCreateNew;
  final String? historyId;

  CreateEditLogScreen({super.key, required this.isCreateNew, this.historyId});

  @override
  State<CreateEditLogScreen> createState() => _CreateEditLogScreenState();
}

class _CreateEditLogScreenState extends State<CreateEditLogScreen> {
  FirebaseFirestore dbFB = FirebaseFirestore.instance;
  final dateController = TextEditingController();
  final inputCodingController = TextEditingController();
  final inputResearchController = TextEditingController();
  final inputMeetingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime now = DateTime.now();

  String docIdExisted = '';
  String userId = '';
  String idItem = '';
  bool hasValueDate = true;
  bool validateComfirmed = false;
  bool isExitedData = false;
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
    getCurrentUserId();

    dateController.text = formatDate(now);
    maxlengthInput(inputCodingController);
    maxlengthInput(inputResearchController);
    maxlengthInput(inputMeetingController);

    dateController.addListener(() {
      setState(() {
        hasValueDate = dateController.text.isNotEmpty;
        isExitedData = false;
      });
    });

    if (widget.isCreateNew == true) {
      checkExitedData();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getHistory();
      });
      idItem = widget.historyId.toString();
    }
  }

  Future<void> getCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId')!;
    });
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

  Future checkExitedData() async {
    await getCurrentUserId();

    DateTime startDate = formatTimeStamp(dateController.text);
    DateTime endDate = DateTime(
        startDate.year, startDate.month, startDate.day, 23, 59, 59, 999);

    dbFB
        .collection('histories')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          isExitedData = true;
          docIdExisted = doc.id;
        });
      });
    }).catchError((error) {
      print('Error getting document: $error');
    });
  }

  Future addToFireStore() async {
    final dataLog = {
      'userId': userId,
      'id': idItem,
      'date': formatTimeStamp(dateController.text),
      'total': totalValue,
      "activities": [
        {
          "type": 1,
          "value": valueCoding,
        },
        {
          "type": 2,
          "value": valueMeeting,
        },
        {
          "type": 3,
          "value": valueResearch,
        }
      ],
    };

    if (isExitedData == true || docIdExisted.isNotEmpty) {
      dbFB
          .collection('histories')
          .doc(docIdExisted)
          .set(dataLog)
          .then((message) {
        print('success');
      }).catchError((error) {
        print('Error : $error');
      });
    } else {
      dbFB.collection('histories').add(dataLog).then((message) {
        print('success');
      }).catchError((error) {
        print('Error : $error');
      });
    }
  }

  List<History> history = [];

  void getHistory() {
    showLoadingDialog(context);
    setState(() {
      docIdExisted = widget.historyId!;
    });

    dbFB
        .collection('histories')
        .doc('${widget.historyId}')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          idItem = data['id'];
          totalValue = data['total'];
          valueCoding = data['activities'][0]['value'];
          valueResearch = data['activities'][1]['value'];
          valueMeeting = data['activities'][2]['value'];
          inputCodingController.text = valueCoding.toString();
          inputResearchController.text = valueResearch.toString();
          inputMeetingController.text = valueMeeting.toString();
          dateController.text = formatDate(data["date"].toDate());
        });
        calculateStats();
        Navigator.of(context).pop();
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
  }

  Future<void> _selectedDate(BuildContext context) async {
    int currentYear = now.year;

    DateTime? dateTimePicked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(currentYear - 1),
        lastDate: DateTime(currentYear + 1));

    if (dateTimePicked != null) {
      setState(() {
        dateController.text = formatDate(dateTimePicked);
      });
      checkExitedData();
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
      meetingPercentage = calculatePercentage(valueMeeting);
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
    });

    totalValue = 0;
    codingPercentage = 0;
    researchPercentage = 0;
    meetingPercentage = 0;
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
        addToFireStore();
        if (widget.isCreateNew == true) {
          CustomSnackBar(
              context,
              isExitedData
                  ? "Your log has been overwrited!"
                  : "Your log has been created!",
              false);
          clearForm();
        } else {
          CustomSnackBar(context, "Your log has been updated!", false);
        }
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
              : "EDIT LOG ${dateController.text}",
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
                  isExitedData: isExitedData,
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
