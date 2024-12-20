//REMEMBER ME WITH CHECK BOX
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroon_app/widgets/default.dart';


class CekBog extends StatefulWidget {
  const CekBog({super.key});

  @override
  State<CekBog> createState() => _CekBogState();
}

class _CekBogState extends State<CekBog> {
  bool isCheked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Remember me',
          style: GoogleFonts.poppins(
              textStyle:
                  TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
        ),
        Checkbox(
            activeColor: mainColor,
            value: isCheked,
            onChanged: (bool? value) {
              setState(() {
                isCheked = value!;
              });
            })
      ],
    );
  }
}