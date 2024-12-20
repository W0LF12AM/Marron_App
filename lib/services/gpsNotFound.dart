// ignore_for_file: prefer_const_constructors, camel_case_types, unnecessary_import, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroon_app/widgets/customButtonMenu.dart';
import 'package:maroon_app/widgets/default.dart';

class GpsNotFound_Screen extends StatelessWidget {
  const GpsNotFound_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 170, left: 30, right: 30, bottom: 170),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/Gpsnotfound.png',
                scale: 5,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Ooops!',
                style: Notification_Style,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Sepertinya kamu berada diluar kampus, coba kembali ketika sudah di ruang praktikum ya :)',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 13)),
              ),
              SizedBox(
                height: 45,
              ),
              CustomButtonMenu(
                button_text: "Kembali",
                navigate: () {},
                color: mainColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
