// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, unnecessary_import

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroon_app/widgets/others/default.dart';

//CUSTOM WIDGET

class Attendance_Card extends StatelessWidget {
  const Attendance_Card({super.key, required this.kelas, required this.tempat, required this.pertemuan, required this.jam});


  final String kelas;
  final String tempat;
  final String pertemuan;
  final String jam;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25))),
              height: 140,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
              child: Container(
                decoration: BoxDecoration(
                    color: secondaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3))
                    ],
                    borderRadius: BorderRadius.circular(20)),
                height: 140,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kelas,
                        style: Card_Title_Attendance_Style,
                      ),
                      Text(
                        '$tempat - pertemuan $pertemuan',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: mainColor)),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        jam,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: mainColor)),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
