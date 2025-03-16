
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:maroon_app/Model/faceRecognitionServices.dart';
import 'package:maroon_app/Model/user_model.dart' as local_user;
import 'package:maroon_app/data/database_helper.dart';
import 'package:maroon_app/pages/loading/loading_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:maroon_app/pages/notification/successNotification.dart';
import 'package:maroon_app/widgets/others/default.dart';

import 'dart:ui' as ui;

class RegistfacePage extends StatefulWidget {
  const RegistfacePage({super.key});

  @override
  State<RegistfacePage> createState() => _RegistfacePageState();
}

class _RegistfacePageState extends State<RegistfacePage> {
  CameraController? _cameraController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
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

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

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
    final croppedFile = File('${imageFile.parent.path}/cropped_face.png');
    await croppedFile.writeAsBytes(byteData!.buffer.asUint8List());

    return croppedFile;
  }

  Future<void> _uploadImageToFirebase(File imageFile) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      String fileName =
          "faces/$userId/${DateTime.now().millisecondsSinceEpoch}.png";
      await FirebaseStorage.instance.ref(fileName).putFile(imageFile);
      print('Image uploaded to Firebase: $fileName');
    } catch (e) {
      print('Error uploading image to Firebase: $e');
    }
  }

  Future<void> _performRegistration() async {
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
        List<double> embeddingList =
            await FaceRecognitionService.generateLiveEmbedding(croppedFace);
        Float32List embedding = Float32List.fromList(embeddingList);

        // Save user data to SQLite
        local_user.User newUser = local_user.User(
            user: "username",
            password: "password",
            modelData: embedding.toList());
        await DatabaseHelper.instance.insert(newUser);

        // Upload image to Firebase
        await _uploadImageToFirebase(croppedFace);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Face registered successfully!')),
        // );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Success_Notofication(
                    pesan: 'Muka anda berhasil didaftarkan')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No face detected!')),
        );
      }
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: mainColor,
          iconSize: 28,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Register Face',
          style: Card_Title_Attendance_Style,
        ),
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
                      onPressed: _performRegistration,
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
