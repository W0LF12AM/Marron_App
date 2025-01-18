import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maroon_app/widgets/card/classCard.dart';
import 'package:maroon_app/widgets/others/default.dart';
import 'package:maroon_app/widgets/others/userHeader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late Future<CameraDescription> _camerasFuture;
  bool _isCardVisible = true;

  @override
  void initState() {
    super.initState();
    _camerasFuture = getFrontCamera();
    _checkCardVisibility();
  }

  Future<CameraDescription> getFrontCamera() async {
    final cameras = await availableCameras();
    return cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => throw Exception('Front Camera Error'),
    );
  }

  Future<void> _checkCardVisibility() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    DateTime? lastVisibleTime =
        DateTime.tryParse(pref.getString('lastVisibleTime') ?? '');

    if (lastVisibleTime != null) {
      if (now.isAfter(lastVisibleTime.add(Duration(days: 1)))) {
        _isCardVisible = true;
      } else {
        _isCardVisible = false;
      }
    }

    if (_isCardVisible) {
      await pref.setString('lastVisibleTime', now.toIso8601String());
    }

    setState(() {});
  }

  bool isClassKeliatan(DateTime endTime) {
    final now = DateTime.now();
    return now.isBefore(endTime) && _isCardVisible;
  }

  DateTime _parseTime(String time) {
    List<String> parts = time.split('.');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: FutureBuilder(
          future: _camerasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error loading camera : ${snapshot.error}'),
              );
            }
            final camera = snapshot.data!;

            return StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('kelas').snapshots(),
                builder: (context, kelasSnapshot) {
                  if (kelasSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (kelasSnapshot.hasError) {
                    return Center(
                      child: Text('Error : ${kelasSnapshot.error}'),
                    );
                  }

                  final classes = kelasSnapshot.data!.docs;

                  return ListView(
                    padding: EdgeInsets.only(top: 0),
                    children: [
                      User_Header(),
                      SizedBox(
                        height: 27,
                      ),
                      ...classes.map(
                        (classDoc) {
                          String timeString = classDoc['jam'];
                          List<String> waktu = timeString.split(' - ');
                          DateTime endTime = _parseTime(waktu[1]);
                          if (isClassKeliatan(endTime)) {
                            double latitude = classDoc['latitude'];
                            double longitude = classDoc['longitude'];
                            double radius = classDoc['radius'];

                            _isCardVisible = false;
                            return Class_Card(
                                camera: camera,
                                kelas: classDoc['kelas'],
                                tempat: classDoc['tempat'],
                                pertemuan: classDoc['pertemuan'],
                                jam: timeString,
                                latitude: latitude,
                                longitude: longitude,
                                radius: radius);
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ).toList(),
                    ],
                  );
                });
          }),
    );
  }
}
