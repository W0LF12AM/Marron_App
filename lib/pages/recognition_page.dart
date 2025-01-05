import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:maroon_app/Model/faceRecognitionServices.dart';
import 'package:maroon_app/Model/user_model.dart';
import 'package:maroon_app/data/databse_helper.dart';

import 'package:maroon_app/pages/loading_page.dart';
import 'package:maroon_app/services/failedNotification.dart';
import 'package:maroon_app/services/successNotification.dart';

class RecognitionPage extends StatefulWidget {
  const RecognitionPage({super.key});

  @override
  State<RecognitionPage> createState() => _RecognitionPageState();
}

class _RecognitionPageState extends State<RecognitionPage> {
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

    // Buat gambar hasil crop
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    // Potong wajah dari gambar asli
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

    // Simpan file hasil crop
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

        // Load stored embeddings from SQLite
        List<User> users = await DatabaseHelper.instance.queryAllUsers();
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Success_Notofication()),
          );
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Face recognition failed!')),
          // );
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
      appBar: AppBar(title: const Text('Sign In')),
      body: _isInitialized
          ? Stack(
              children: [
                CameraPreview(_cameraController!),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    onPressed: _performRecognition,
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
              ],
            )
          : const Center(child: LoadingPage(pesan: 'Initializing...')),
    );
  }
}
