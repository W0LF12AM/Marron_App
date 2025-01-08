import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:maroon_app/Model/faceRecognitionServices.dart';
import 'package:maroon_app/Model/user_model.dart';
import 'package:maroon_app/data/database_helper.dart';
import 'package:maroon_app/function/function.dart';

import 'package:maroon_app/pages/loading/loading_page.dart';
import 'package:maroon_app/pages/notification/failedNotification.dart';
import 'package:maroon_app/pages/notification/noRegisteredFaceNotification.dart';
import 'package:maroon_app/pages/notification/successNotification.dart';
import 'package:maroon_app/widgets/others/default.dart';

class RecognitionPage extends StatefulWidget {
  const RecognitionPage(
      {Key? key,
      required this.kelas,
      required this.tempat,
      required this.pertemuan,
      required this.userName})
      : super(key: key);

  final String userName;
  final String kelas;
  final String tempat;
  final String pertemuan;

  @override
  State<RecognitionPage> createState() => _RecognitionPageState();
}

class _RecognitionPageState extends State<RecognitionPage> {
  CameraController? _cameraController;
  bool _isInitialized = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadUserName();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    String name = await getUserName();
    setState(() {
      userName = name;
    });
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);

    _cameraController =
        CameraController(frontCamera, ResolutionPreset.ultraHigh);

    await _cameraController?.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  Future<File> _cropFace(File imageFile, Rect boundingBox) async {
    final bytes = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    // Buat gambar hasil crop
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    // Potong wajah
    canvas.drawImageRect(
      image,
      boundingBox,
      Rect.fromLTWH(0, 0, boundingBox.width, boundingBox.height),
      paint,
    );

    final picture = recorder.endRecording();
    final croppedImage = await picture.toImage(
      boundingBox.width.toInt(),
      boundingBox.height.toInt(),
    );

    final byteData =
        await croppedImage.toByteData(format: ui.ImageByteFormat.png);

    // Simpen file hasil crop
    final croppedFile = File('${imageFile.parent.path}/cropped_face.png');
    await croppedFile.writeAsBytes(byteData!.buffer.asUint8List());

    return croppedFile;
  }

  Future<void> _performRecognition() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile picture = await _cameraController!.takePicture();
      final imageFile = File(picture.path);
      final inputImage = InputImage.fromFile(imageFile);
      final faces =
          await GoogleMlKit.vision.faceDetector().processImage(inputImage);

      if (faces.isNotEmpty) {
        final faceBoundingBox = faces.first.boundingBox;
        final croppedFace = await _cropFace(imageFile, faceBoundingBox);
        Float32List liveEmbedding =
            await FaceRecognitionService.generateLiveEmbedding(croppedFace);
        List<User> users = await DatabaseHelper.instance.queryAllUsers();
        if (users.isEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Noregisteredfacenotification()));
          return;
        }

        bool isAuthenticated = false;

        for (var user in users) {
          List<double> storedEmbedding = List<double>.from(user.modelData);
          if (await FaceRecognitionService.isMatch(
              liveEmbedding.toList(), storedEmbedding)) {
            isAuthenticated = true;
            break;
          }
        }
        if (isAuthenticated) {
          await FirebaseFirestore.instance.collection('presensi').add({
            'userName': userName,
            'kelas': widget.kelas,
            'tempat': widget.tempat,
            'pertemuan': widget.pertemuan,
            'jam': DateTime.now(),
            'timestamp': FieldValue.serverTimestamp()
          });

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Success_Notofication(
                      pesan: 'Yeaayy, Kehadiran Anda Berhasil Dicatat',
                    )),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Failednotification()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No face detected!')),
        );
      }
    } catch (e) {
      print('Error during recognition: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: mainColor,
          iconSize: 28,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Attendance',
          style: Card_Title_Attendance_Style,
        ),
        backgroundColor: secondaryColor,
      ),
      body: _isInitialized
          ? Stack(
              children: [
                Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: CameraPreview(_cameraController!)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: FloatingActionButton(
                      backgroundColor: mainColor,
                      onPressed: _performRecognition,
                      child: const Icon(
                        Icons.camera_alt,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: LoadingPage(pesan: 'Initializing...')),
    );
  }
}
