// ignore_for_file: file_names, camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroon_app/data/Schedule_Data1.dart';
import 'package:maroon_app/data/Schedule_Data2.dart';
import 'package:maroon_app/data/Schedule_Data3.dart';
import 'package:maroon_app/widgets/default.dart';
import 'package:maroon_app/widgets/userHeader.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          User_Header(),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'Jadwal Praktikum',
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Jadwal_Praktikum(),
          SizedBox(
            height: 10,
          ),
          Jadwal_Praktikum2(),
          SizedBox(
            height: 10,
          ),
          Jadwal_Praktikum3()
        ],
      ),
    );
  }
}
