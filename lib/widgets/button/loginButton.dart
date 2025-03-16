//CUSTOM BUTTON LOGIN
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroon_app/widgets/others/default.dart';

class Loginbutton extends StatelessWidget {
  Loginbutton({super.key, required this.button_text, required this.navigate});

  final VoidCallback navigate;
  final button_text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigate,
      child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              color: mainColor, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              button_text,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: secondaryColor)),
            ),
          )),
    );
  }
}
