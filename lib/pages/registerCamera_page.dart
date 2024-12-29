import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:maroon_app/pages/loading_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class RegistercameraPage extends StatefulWidget {
  const RegistercameraPage({super.key});

  @override
  State<RegistercameraPage> createState() => _RegistercameraPageState();
}

class _RegistercameraPageState extends State<RegistercameraPage> {
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

  Future<void> _uploadImageToFirebase(File imageFile) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      // Upload ke Firebase Storage
      String fileName =
          "faces/$userId/${DateTime.now().millisecondsSinceEpoch}.png";
      await FirebaseStorage.instance.ref(fileName).putFile(imageFile);
      print('Image uploaded to Firebase: $fileName');
    } catch (e) {
      print('Error uploading image to Firebase: $e');
    }
  }

  Future<void> _saveImageLocally(File imageFile) async {
    try {
      // Dapatkan direktori penyimpanan lokal
      final directory = await getApplicationDocumentsDirectory();
      final localPath = '${directory.path}/cropped_face.png';

      // Simpan gambar ke penyimpanan lokal
      await imageFile.copy(localPath);
      print('Image saved locally at: $localPath');
    } catch (e) {
      print('Error saving image locally: $e');
    }
  }

  Future<void> _performRegistration() async {
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
        final croppedFace = await _cropFace(imageFile, faceBoundingBox);

        Float32List embedding = await _preprocessImage(croppedFace);

        await _saveEmbeddingLocally(embedding);

        // Upload gambar cropped ke Firebase
        await _uploadImageToFirebase(croppedFace);

        // Simpan gambar cropped secara lokal
        await _saveImageLocally(croppedFace);

        // Tampilkan notifikasi sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Face registered successfully!')),
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

  Future<void> _saveEmbeddingLocally(Float32List embedding) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/embedding.json');

    List<double> embeddingList = embedding.toList();
    await file.writeAsString(json.encode(embeddingList));
    print('Embedding saved successfully.');
  }

  Future<Float32List> _preprocessImage(File imageFile) async {
    final rawImage = img.decodeImage(imageFile.readAsBytesSync());
    if (rawImage == null) throw Exception('gabisa di dikod');

    final resizedImage = img.copyResize(rawImage, width: 112, height: 112);

    List<double> falttenedList = [];
    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        int pixel = resizedImage.getPixel(x, y);
        int r = (pixel >> 16) & 0xff;
        int g = (pixel >> 8) & 0xff;
        int b = pixel & 0xff;
        falttenedList.add(r.toDouble());
        falttenedList.add(g.toDouble());
        falttenedList.add(b.toDouble());
      }
    }

    Float32List float32Array = Float32List.fromList(falttenedList);
    return float32Array;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Register Face'),
        backgroundColor: Colors.blue,
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
                      backgroundColor: Colors.blue,
                      onPressed: _performRegistration,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
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
