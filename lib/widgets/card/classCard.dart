//CLASS CARD
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:maroon_app/pages/Attendance_Page.dart';
import 'package:maroon_app/widgets/others/default.dart';

class Class_Card extends StatelessWidget {
  final CameraDescription camera;
  const Class_Card(
      {super.key,
      required this.camera,
      required this.kelas,
      required this.tempat,
      required this.pertemuan,
      required this.jam,
      required this.latitude,
      required this.longitude,
      required this.radius});

  final String kelas;
  final String tempat;
  final String pertemuan;
  final String jam;
  final double latitude;
  final double longitude;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 21, right: 21, bottom: 15),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
                color: mainColor, borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kelas,
                    style: Card_Title_Style,
                  ),
                  Text(
                    "$tempat - Pertemuan $pertemuan",
                    style: Subtitle_Class_Card_Style,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(jam, style: Subtitle_Class_Card_Style)
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Attendance_Screen(
                              kelas: kelas,
                              tempat: tempat,
                              pertemuan: pertemuan,
                              jam: jam,
                              camera: camera,
                              latitude: latitude,
                              longitude: longitude,
                              radius: radius,
                            )));
              },
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(60))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: mainColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
