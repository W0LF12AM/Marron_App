// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maroon_app/Model/faceRecognitionHandler.dart';

import 'package:maroon_app/pages/loading_page.dart';
import 'package:maroon_app/pages/recognition_page.dart';

import 'package:maroon_app/widgets/attendanceCard.dart';
import 'package:maroon_app/widgets/customButtonMenu.dart';
import 'package:maroon_app/widgets/default.dart';

class Attendance_Screen extends StatefulWidget {
  const Attendance_Screen({super.key, required this.camera});
  final CameraDescription camera;

  @override
  State<Attendance_Screen> createState() => _Attendance_ScreenState();
}

class _Attendance_ScreenState extends State<Attendance_Screen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        body: Column(
          children: [
            Attendance_Card(),
            SizedBox(
              height: 70,
            ),
            Container(
              width: 315,
              height: 380,
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
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/faceId.svg',
                      color: mainColor,
                      width: 200,
                      height: 200,
                    ),
                    CustomButtonMenu(
                        color: mainColor,
                        button_text: 'Take Attendance',
                        navigate: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecognitionPage(),
                              ));
                        })
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
