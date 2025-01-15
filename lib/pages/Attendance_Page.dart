// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:camera/camera.dart';
import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maroon_app/Model/geogeo.dart';
import 'package:maroon_app/function/function.dart';

import 'package:maroon_app/pages/loading/loading_page.dart';
import 'package:maroon_app/pages/core/recognition_page.dart';
import 'package:maroon_app/pages/notification/fakeGpsNotification.dart';
import 'package:maroon_app/pages/notification/gpsNotFound.dart';

import 'package:maroon_app/widgets/card/attendanceCard.dart';
import 'package:maroon_app/widgets/button/customButtonMenu.dart';
import 'package:maroon_app/widgets/others/default.dart';

class Attendance_Screen extends StatefulWidget {
  const Attendance_Screen({
    super.key,
    required this.camera,
    required this.kelas,
    required this.tempat,
    required this.pertemuan,
    required this.jam,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });
  final CameraDescription camera;

  final String kelas;
  final String tempat;
  final String pertemuan;
  final String jam;
  final double latitude;
  final double longitude;
  final double radius;

  @override
  State<Attendance_Screen> createState() => _Attendance_ScreenState();
}

class _Attendance_ScreenState extends State<Attendance_Screen> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    String name = await getUserName();
    setState(() {
      userName = name;
    });
  }

  Future<void> checkLokasiAndNavigate() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                LoadingPage(pesan: 'Lacak Gps')));

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position posisi = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double jarakMeter = Geolocator.distanceBetween(
        posisi.latitude, posisi.longitude, widget.latitude, widget.longitude);

    // RUMUS HAVERSINE
    //------------------------------------------------------
    // double haversine(Location loc1, Location loc2) {
    //   const r = 6371;

    //   double lat1 = loc1.latitude * pi / 180;
    //   double lat2 = loc2.latitude * pi / 180;
    //   double deltaLat = (loc2.latitude - loc1.latitude) * pi / 180;
    //   double deltaLong = (loc2.longitude - loc1.longitude) * pi / 180;

    //   double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
    //       cos(lat1) * cos(lat2) * sin(deltaLong / 2) * sin(deltaLong / 2);
    //   double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    //   return r * c * 1000;
    // }

    // Location userLocation = Location(posisi.latitude, posisi.longitude);
    // Location appointedLocation = Location(widget.latitude, widget.longitude);

    // double jarakMeter = haversine(userLocation, appointedLocation);

    //------------------------------------------------------

    Navigator.pop(context);

    if (jarakMeter <= widget.radius) {
      print('latitude user : ${posisi.latitude}');
      print('longitude user : ${posisi.longitude}');
      print('Jarak antara user dan lokasi : $jarakMeter');
      print('Radius toleransi antara user dan lokasi : ${widget.radius}');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => RecognitionPage(
                    kelas: widget.kelas,
                    tempat: widget.tempat,
                    pertemuan: widget.pertemuan,
                    userName: '',
                  )));
    } else {
      print('latitude user : ${posisi.latitude}');
      print('longitude user : ${posisi.longitude}');
      print('Jarak antara user dan lokasi : $jarakMeter');
      print('Radius toleransi antara user dan lokasi : ${widget.radius}');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => GpsNotFound_Screen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        body: Column(
          children: [
            Attendance_Card(
              kelas: widget.kelas,
              tempat: widget.tempat,
              pertemuan: widget.pertemuan,
              jam: widget.jam,
            ),
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
                          try {
                            bool isLokasiFake =
                                await DetectFakeLocation().detectFakeLocation();
                            if (isLokasiFake) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Fakegpsnotification()));
                              return;
                            }
                            await checkLokasiAndNavigate();
                          } catch (e) {
                            print('Error bangg : $e');
                          }
                        })
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
