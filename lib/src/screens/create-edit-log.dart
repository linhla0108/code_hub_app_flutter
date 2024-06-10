import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/history.dart';
import '../utils/custom-snack-bar.dart';
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
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
      getHistory();
      idItem = widget.historyId.toString();
    }
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

  void checkExitedData() {
    idItem = dateController.text.replaceAll('/', '');

    dbFB.collection('histories').doc(idItem).get().then((doc) {
      if (doc.exists && dateController.text != "") {
        setState(() {
          isExitedData = true;
        });
      } else {
        setState(() {
          isExitedData = false;
        });
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
  }

  Future addToFireStore() async {
    final dataLog = {
      'id': idItem,
      'date': dateController.text,
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
    dbFB.collection('histories').doc('${idItem}').set(dataLog).then((message) {
      print('success');
    }).catchError((error) {
      print('Error : $error');
    }); //add data (can overwrite)
  }

  List<History> history = [];

  void getHistory() {
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
          dateController.text = data['date'];
        });
        calculateStats();
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
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
        if (widget.isCreateNew == true) {
          addToFireStore();
          CustomSnackBar(
              context,
              isExitedData
                  ? "Your log has been overwrited!"
                  : "Your log has been created!",
              false);
          clearForm();
        } else {
          addToFireStore();
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
