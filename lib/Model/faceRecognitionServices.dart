import 'dart:io';
import 'dart:core';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:maroon_app/Model/faceRecognitionHandler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognitionService {
  static Interpreter? _interpreter;

  static Future<void> initializeInterpreter() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite');
    } catch (e) {
      print('gagal membuat interpreter karena : $e');
    }
  }

  // static Future<Face?> _detectFace(File imageFile) async {
  //   final inputImage = InputImage.fromFile(imageFile);
  //   final faceDetector = GoogleMlKit.vision.faceDetector(
  //     FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate),
  //   );

  //   final faces = await faceDetector.processImage(inputImage);
  //   await faceDetector.close();

  //   return faces.isNotEmpty ? faces.first : null;
  // }

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

  static Future<Float32List> generateLiveEmbedding(File liveImage) async {
    final processedImage = await _preprocessImage(liveImage);
    return _runModel(processedImage);
  }

  static bool isMatch(
      List<double> liveEmbedding, List<double> storedEmbedding) {
    print('Live embeddings: $liveEmbedding');

    if (storedEmbedding.isEmpty) {
      print('stored embedingnya kosong kocak');
      return false;
    }

    try {
      print('Processing stored embedding: $storedEmbedding');

      if (liveEmbedding.length != storedEmbedding.length) {
        print(
            'Length mismatch: liveEmbedding length = ${liveEmbedding.length}, storedEmbedding length = ${storedEmbedding.length}');
        return false;
      }
      final PairEmbedding pair = _findNearest(liveEmbedding, storedEmbedding);
      double distance = pair.distance;
      print('distance-nya : $distance');
      if (distance < FaceRecognitionHandler.matchingThreshold) {
        return true;
      }
    } catch (e) {
      print('distance nya : $e');
    }
    return false;
  }

  static PairEmbedding _findNearest(List<double> a, List<double> b) {
    PairEmbedding pair = PairEmbedding(-5);

    double distance = 0;
    for (int i = 0; i < a.length; i++) {
      double diff = a[i] - b[i];
      distance += diff * diff;
    }
    distance = sqrt(distance);

    if (pair.distance == -5 || distance < pair.distance) {
      pair.distance = distance;
    }
    return pair;
  }

  static Float32List _runModel(Float32List input) {
    if (_interpreter == null) {
      throw Exception('Interpreter is not initialized');
    }
    final output = List.filled(192, 0.0).reshape([1, 192]);
    _interpreter!.run(input.reshape([1, 112, 112, 3]), output);
    return Float32List.fromList(output[0]); // Ensure this returns Float32List
  }


  static Future<Float32List> _preprocessImage(File imageFile) async {
    final rawImage = img.decodeImage(imageFile.readAsBytesSync());
    if (rawImage == null) throw Exception('Unable to decode image');

    final resizedImage = img.copyResize(rawImage, width: 112, height: 112);

    List<double> flattenedList = [];
    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        int pixel = resizedImage.getPixel(x, y);
        int r = (pixel >> 16) & 0xff;
        int g = (pixel >> 8) & 0xff;
        int b = pixel & 0xff;
        flattenedList.add(r.toDouble());
        flattenedList.add(g.toDouble());
        flattenedList.add(b.toDouble());
      }
    }

    Float32List float32Array = Float32List.fromList(flattenedList);
    int channels = 3;
    int height = 112;
    int width = 112;

    Float32List reshapedArray = Float32List(1 * height * width * channels);
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          int index = c * height * width + h * width + w;
          reshapedArray[index] =
              (float32Array[c * height * width + h * width + w] - 127.5) /
                  127.5;
        }
      }
    }

    return reshapedArray;
  }
}

class PairEmbedding {
  double distance;
  PairEmbedding(this.distance);
}
