import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/custom-style.dart';

class InputCreateLog extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool? isDatepicker;
  Function()? onTap;
  void Function(String)? onChanged;
  final bool showSuffixText;
  final bool errorValidate = false;
  bool? hasValueDate = true;
  final String? Function(String?)? validator;
  final Widget? childWidget;
  InputCreateLog(
      {super.key,
      required this.label,
      required this.controller,
      required this.showSuffixText,
      this.onTap,
      this.validator,
      this.onChanged,
      this.isDatepicker,
      this.hasValueDate,
      this.childWidget});

  @override
  State<InputCreateLog> createState() => _InputCreateLogState();
}

class _InputCreateLogState extends State<InputCreateLog> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.label, style: CustomStyle().StyleText),
        Container(
          width: 240,
          height: 45,
          decoration: CustomStyle().StyleBoxShadow,
          child: TextFormField(
            validator: widget.validator,
            readOnly: widget.isDatepicker != null && widget.isDatepicker!
                ? true
                : false,
            keyboardType:
                widget.isDatepicker == null ? TextInputType.number : null,
            inputFormatters: widget.isDatepicker == null
                ? [FilteringTextInputFormatter.digitsOnly]
                : null,
            controller: widget.controller,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            style: TextStyle(fontSize: 17, height: 1),
            decoration: widget.isDatepicker == null
                ? CustomStyle().StyleInputNumber(widget.showSuffixText)
                : CustomStyle().StyleInputDatePicker(
                    widget.controller, widget.hasValueDate ?? true),
          ),
        )
      ],
    );
  }
}
