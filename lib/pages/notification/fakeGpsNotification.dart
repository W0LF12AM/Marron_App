// ignore_for_file: prefer_const_constructors, camel_case_types, unnecessary_import, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroon_app/pages/landing_page.dart';
import 'package:maroon_app/widgets/button/customButtonMenu.dart';
import 'package:maroon_app/widgets/others/default.dart';

class Fakegpsnotification extends StatelessWidget {
  const Fakegpsnotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 150, left: 30, right: 30, bottom: 150),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/fake gps.png',
                scale: 5,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'FAKE GPS?!',
                style: FakeGps_Style,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Geramnya aku 😡😡😡\nCKPTW SIH :(',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
              ),
              SizedBox(
                height: 45,
              ),
              CustomButtonMenu(
                button_text: "Balik Lagi Ga?!",
                navigate: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Landing_Screen()));
                },
                color: smt12Color,
              )
            ],
          ),
        ),
      ),
    );
  }
}
