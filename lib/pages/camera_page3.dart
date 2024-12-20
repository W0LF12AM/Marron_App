import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:maroon_app/Model/faceRecognitionServices.dart';
import 'package:maroon_app/detector/face_detection_result.dart';
import 'package:maroon_app/pages/loading_page.dart';
import 'package:maroon_app/services/successNotification.dart';
import 'package:maroon_app/widgets/default.dart';

class CameraPage3 extends StatefulWidget {
  const CameraPage3({super.key, required this.embeddings});
  final List<List<double>> embeddings;

  @override
  State<CameraPage3> createState() => _CameraPage3State();
}

class _CameraPage3State extends State<CameraPage3> {
  CameraController? _cameraController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _faceDetector.close();
    _cameraController?.dispose();
    super.dispose();
  }

  final FaceDetector _faceDetector = FaceDetector(
      options:
          FaceDetectorOptions(enableContours: false, enableLandmarks: false));

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

  Future<File> cropFace(File imageFile, Rect boundingBox) async {
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

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile picture = await _cameraController!.takePicture();
      final imageFile = File(picture.path);

      await _processFaceRecognition(imageFile);
    } catch (e) {
      print('error : $e');
    }
  }

  Future<void> _processFaceRecognition(File imageFile) async {
    try {
      final liveEmbedding =
          await FaceRecognitionService.generateEmbeddings([imageFile]);

      final isAuthenticated = widget.embeddings.any((storedEmbedding) {
        return FaceRecognitionService.isMatch(
            liveEmbedding.first, storedEmbedding.cast<List<double>>());
      });

      if (isAuthenticated) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Success_Notofication()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Face recognition failed!')),
        );
      }
    } catch (e) {
      print('errornya : $e');
    }
  }

  Future<void> performRecognition() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      // Ambil gambar dari kamera
      final XFile picture = await _cameraController!.takePicture();
      final imageFile = File(picture.path);

      // Konversi ke InputImage
      final inputImage = InputImage.fromFile(imageFile);

      // Proses deteksi wajah
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        // Pindah ke halaman hasil deteksi wajah
        final faceBoundingBox = faces.first.boundingBox;
        final croppedFace = await cropFace(imageFile, faceBoundingBox);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FaceDetectionResultPage(
              imageFile: croppedFace,
              faces: faces,
            ),
          ),
        );
      } else {
        // Jika tidak ada wajah, tampilkan notifikasi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No face detected!')),
        );
      }
    } catch (e) {
      print('Error saat deteksi wajah: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: const Text('Camera'),
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
                    padding: const EdgeInsets.all(20),
                    child: FloatingActionButton(
                      backgroundColor: mainColor,
                      onPressed: performRecognition,
                      child: const Icon(
                        Icons.camera_alt,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: LoadingPage(
              pesan: 'Sabar',
            )),
    );
  }
}
