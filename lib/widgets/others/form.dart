//FORM
import 'package:flutter/material.dart';
import 'package:maroon_app/widgets/others/default.dart';

//controller

// ignore: must_be_immutable
class FormWidget extends StatelessWidget {
  FormWidget(
      {super.key,
      required this.hint_text,
      required this.label_text,
      required this.controller,
      this.validator, required this.obscurega});

  final String hint_text;
  final String label_text;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  bool obscurega = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: formColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              hintText: hint_text,
              labelText: label_text,
              border: InputBorder.none),
          validator: validator,
          obscureText: obscurega,
        ),
      ),
    );
  }
}
