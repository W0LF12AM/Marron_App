// ignore_for_file: file_names, camel_case_types, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:maroon_app/widgets/others/default.dart';
import 'package:maroon_app/widgets/card/scheduleCard.dart';
import 'package:maroon_app/widgets/others/userHeader.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Map<String, dynamic>> jadwals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Column(
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
            height: 0,
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('jadwal')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error bang : ${snapshot.error}'),
                      );
                    }

                    final jadwals = snapshot.data!.docs;

                    if (jadwals.isEmpty) {
                      return Center(
                        child: Text(
                          'Belum ada Jadwal',
                          style: Card_Title_Attendance_Style,
                        ),
                      );
                    }

                    return ListView(
                      children: jadwals.map((jadwalDoc) {
                        return Schedulecard(
                            jam: jadwalDoc['jam'],
                            kelas: jadwalDoc['kelas'],
                            lab: jadwalDoc['tempat'],
                            semester: jadwalDoc['semester']);
                      }).toList(),
                    );
                  }))

          // Schedulecard(
          //     jam: '13.00', kelas: 'Algo Pro A', lab: 'Lab MM', semester: '2')
        ],
      ),
    );
  }
}
