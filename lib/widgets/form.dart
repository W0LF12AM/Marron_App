//FORM
import 'package:flutter/material.dart';
import 'package:maroon_app/widgets/default.dart';

//controller


class FormWidget extends StatelessWidget {
  FormWidget({super.key, required this.hint_text, required this.label_text, required this.controller});

  final hint_text;
  final label_text;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: formColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              hintText: hint_text,
              labelText: label_text,
              border: InputBorder.none),
        ),
      ),
    );
  }
}