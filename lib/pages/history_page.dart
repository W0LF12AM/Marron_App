// ignore_for_file: file_names, camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:maroon_app/widgets/card/attendanceHistoryCard.dart';

import 'package:maroon_app/widgets/others/default.dart';
import 'package:maroon_app/widgets/card/scheduleCard.dart';
import 'package:maroon_app/widgets/others/userHeader.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
              'Attendance History',
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Attendancehistorycard(
              jam: '10.00',
              kelas: 'Statistika Dasar A',
              lab: 'Lab SC',
              semester: '4')

          // Jadwal_Praktikum(),
          // SizedBox(
          //   height: 10,
          // ),
          // Jadwal_Praktikum2(),
          // SizedBox(
          //   height: 10,
          // ),
          // Jadwal_Praktikum3()
        ],
      ),
    );
  }
}
