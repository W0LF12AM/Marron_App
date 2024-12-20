import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionResultPage extends StatelessWidget {
  final File imageFile;
  final List<Face> faces;

  const FaceDetectionResultPage({
    Key? key,
    required this.imageFile,
    required this.faces,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection Result'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(pi),
            child: Center(
              child: Image.file(imageFile), // Tampilkan gambar yang diambil
            ),
          ),
          ...faces.map((face) {
            return Positioned(
              left: face.boundingBox.left,
              top: face.boundingBox.top,
              width: face.boundingBox.width,
              height: face.boundingBox.height,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                ),
              ),
            );
          }).toList(), // Gambar kotak bounding box di wajah yang terdeteksi
        ],
      ),
    );
  }
}
