import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:maroon_app/widgets/classCard.dart';
import 'package:maroon_app/widgets/default.dart';
import 'package:maroon_app/widgets/userHeader.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late Future<CameraDescription> _camerasFuture;

  @override
  void initState() {
    super.initState();
    _camerasFuture = getFrontCamera();
  }

  Future<CameraDescription> getFrontCamera() async {
    final cameras = await availableCameras();
    return cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => throw Exception('Front Camera Error'),
    );
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

            return ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                User_Header(),
                SizedBox(
                  height: 27,
                ),
                ...List.generate(
                    3,
                    (index) => Class_Card(
                          camera: camera,
                        ))
              ],
            );
          }),
    );
  }
}
