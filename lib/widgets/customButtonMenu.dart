//CUSTOM BUTTON MENU
import 'package:flutter/material.dart';
import 'package:maroon_app/widgets/default.dart';

class CustomButtonMenu extends StatelessWidget {
  CustomButtonMenu(
      {super.key,
      required this.button_text,
      required this.navigate,
      required this.color});

  final navigate;
  final button_text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigate,
      child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              button_text,
              style: Alert_Dialogue_Style,
            ),
          )),
    );
  }
}
