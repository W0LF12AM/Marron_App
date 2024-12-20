import 'dart:io';
import 'dart:core';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:maroon_app/Model/faceRecognitionHandler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognitionService {
  static Interpreter? _interpreter;

  static Future<void> initializeInterpreter() async {
    _interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite');
  }

  static Future<File?> captureAndDetectFace(CameraController controller) async {
    if (!controller.value.isInitialized) {
      throw Exception('Camera is not initialized');
    }

    final XFile picture = await controller.takePicture();
    final imageFile = File(picture.path);

    // Use ML Kit to detect faces
    final detectedFace = await _detectFace(imageFile);
    if (detectedFace == null) {
      print('No face detected!');
      return null;
    }

    // Crop the detected face from the image
    return _cropFace(imageFile, detectedFace);
  }

  static Future<Face?> _detectFace(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate),
    );

    final faces = await faceDetector.processImage(inputImage);
    await faceDetector.close();

    return faces.isNotEmpty ? faces.first : null;
  }

  static Future<File> _cropFace(File imageFile, Face face) async {
    final rawImage = img.decodeImage(imageFile.readAsBytesSync());
    if (rawImage == null) throw Exception('Unable to decode image');

    final boundingBox = face.boundingBox;
    final croppedImage = img.copyCrop(
      rawImage,
      boundingBox.left.toInt(),
      boundingBox.top.toInt(),
      boundingBox.width.toInt(),
      boundingBox.height.toInt(),
    );

    final croppedFile = File('${imageFile.path}_cropped.jpg');
    croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage));
    return croppedFile;
  }

  static Future<List<List<double>>> generateEmbeddings(
      List<File> images) async {
    List<List<double>> embeddings = [];
    for (var image in images) {
      final processedImage = await _preprocessImage(image);
      final embedding = _runModel(processedImage);
      embeddings.add(embedding);
    }
    return embeddings;
  }

  static Future<List<double>> generateLiveEmbedding(File liveImage) async {
    final processedImage = await _preprocessImage(liveImage);
    return _runModel(processedImage);
  }

  static bool isMatch(
      List<double> liveEmbedding, List<List<double>> storedEmbeddings) {
        print('Live embedding: $liveEmbedding');
    for (var storedEmbedding in storedEmbeddings) {
      final double distance =
          _calculateEuclidianDistance(liveEmbedding, storedEmbedding);
      print('distance-nya : $distance');
      if (distance < FaceRecognitionHandler.matchingThreshold) {
        return true;
      }
    }
    return false;
  }

  static double _calculateEuclidianDistance(List<double> a, List<double> b) {
    return sqrt(a
        .asMap()
        .entries
        .map((entry) => pow(entry.value - b[entry.key], 2))
        .reduce((value, element) => value + element));
  }

  static List<double> _runModel(Float32List input) {
    if (_interpreter == null) {
      throw Exception('Interpreter is not initialized');
    }
    final output = List.filled(192, 0.0).reshape([1, 192]);
    _interpreter!.run(input.reshape([1, 112, 112, 3]), output);
    return List<double>.from(output[0]);
  }

  static Future<Float32List> _preprocessImage(File imageFile) async {
    final rawImage = img.decodeImage(imageFile.readAsBytesSync());
    if (rawImage == null) throw Exception('Unable to decode image');

    final resizedImage = img.copyResize(rawImage, width: 112, height: 112);

    final Float32List input = Float32List(112 * 112 * 3);
    int pixelIndex = 0;

    for (int y = 0; y < 112; y++) {
      for (int x = 0; x < 112; x++) {
        final pixel = resizedImage.getPixel(x, y);
        input[pixelIndex++] = ((pixel >> 16) & 0xFF) / 255.0;
        input[pixelIndex++] = ((pixel >> 8) & 0xFF) / 255.0;
        input[pixelIndex++] = (pixel & 0xFF) / 255.0;
      }
    }
    return input;
  }
}
