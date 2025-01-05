// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:camera/camera.dart';

// class FaceRecognitionService {
//   Interpreter? _interpreter;
//   double threshold = 0.5; // Ambang batas untuk pencocokan

//   // Inisialisasi interpreter untuk model
//   Future<void> initialize() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite');
//     } catch (e) {
//       print('Gagal membuat interpreter: $e');
//     }
//   }

//   // Deteksi wajah dari file gambar
//   Future<Face?> detectFace(File imageFile) async {
//     final inputImage = InputImage.fromFile(imageFile);
//     final faceDetector = GoogleMlKit.vision.faceDetector(
//       FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate),
//     );

//     final faces = await faceDetector.processImage(inputImage);
//     await faceDetector.close();

//     return faces.isNotEmpty ? faces.first : null;
//   }

//   // Menghasilkan embedding untuk daftar gambar
//   Future<List<List<double>>> generateEmbeddings(List<File> images) async {
//     List<List<double>> embeddings = [];
//     for (var image in images) {
//       final processedImage = await _preprocessImage(image);
//       final embedding = _runModel(processedImage);
//       embeddings.add(embedding.toList());
//     }
//     return embeddings;
//   }

//   // Menghasilkan embedding untuk gambar langsung
//   Future<Float32List> generateLiveEmbedding(File liveImage) async {
//     final processedImage = await _preprocessImage(liveImage);
//     return _runModel(processedImage);
//   }

//   // Memeriksa apakah embedding langsung cocok dengan embedding yang disimpan
//   bool isMatch(List<double> liveEmbedding, List<double> storedEmbedding) {
//     if (storedEmbedding.isEmpty) {
//       print('Embedding yang disimpan kosong');
//       return false;
//     }

//     if (liveEmbedding.length != storedEmbedding.length) {
//       print('Panjang tidak cocok: panjang liveEmbedding = ${liveEmbedding.length}, panjang storedEmbedding = ${storedEmbedding.length}');
//       return false;
//     }

//     double distance = _euclideanDistance(liveEmbedding, storedEmbedding);
//     return distance < threshold;
//   }

//   // Menghitung jarak Euclidean antara dua embedding
//   double _euclideanDistance(List<double> a, List<double> b) {
//     double sum = 0.0;
//     for (int i = 0; i < a.length; i++) {
//       sum += pow((a[i] - b[i]), 2);
//     }
//     return sqrt(sum);
//   }

//   // Menjalankan model untuk mendapatkan embedding
//   Float32List _runModel(Float32List input) {
//     if (_interpreter == null) {
//       throw Exception('Interpreter belum diinisialisasi');
//     }
//     final output = List.filled(192, 0.0).reshape([1, 192]);
//     _interpreter!.run(input.reshape([1, 112, 112, 3]), output);
//     return Float32List.fromList(output[0]);
//   }

//   // Memproses gambar untuk model
//   Future<Float32List> _preprocessImage(File imageFile) async {
//     final rawImage = img.decodeImage(imageFile.readAsBytesSync());
//     if (rawImage == null) throw Exception('Tidak dapat mendekode gambar');

//     final resizedImage = img.copyResize(rawImage, width: 112, height: 112);
//     List<double> flattenedList = [];

//     for (int y = 0; y < resizedImage.height; y++) {
//       for (int x = 0; x < resizedImage.width; x++) {
//         int pixel = resizedImage.getPixel(x, y);
//         int r = (pixel >> 16) & 0xff;
//         int g = (pixel >> 8) & 0xff;
//         int b = pixel & 0xff;
//         flattenedList.add(r.toDouble());
//         flattenedList.add(g.toDouble());
//         flattenedList.add(b.toDouble());
//       }
//     }

//     Float32List float32Array = Float32List.fromList(flattenedList);
//     return float32Array; // Kembalikan data gambar yang sudah diratakan
//   }

//   // Mengonversi CameraImage menjadi imglib.Image
//   img.Image convertToImage(CameraImage image) {
//     try {
//       if (image.format.group == ImageFormatGroup.yuv420) {
//         return _convertYUV420(image);
//       } else if (image.format.group == ImageFormatGroup.bgra8888) {
//         return _convertBGRA8888(image);
//       }
//       throw Exception('Format gambar tidak didukung');
//     } catch (e) {
//       print("ERROR: " + e.toString());
//       throw Exception('Format gambar tidak didukung');
//     }
//   }

//   img.Image _convertBGRA8888(CameraImage image) {
//     return img.Image.fromBytes(
//       image.width,
//       image.height,
//       image.planes[0].bytes,
//       format: img.Format.bgra,
//     );
//   }

//   img.Image _convertYUV420(CameraImage image) {
//     int width = image.width;
//     int height = image.height;
//     var gambar = img.Image(width, height);
//     const int hexFF = 0xFF000000;
//     final int uvyButtonStride = image.planes[1].bytesPerRow;
//     final int? uvPixelStride = image.planes[1].bytesPerPixel;

//     for (int x = 0; x < width; x++) {
//       for (int y = 0; y < height; y++) {
//         final int uvIndex =
//             uvPixelStride! * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
//         final int index = y * width + x;
//         final yp = image.planes[0].bytes[index];
//         final up = image.planes[1].bytes[uvIndex];
//         final vp = image.planes[2].bytes[uvIndex];
//         int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
//         int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
//             .round()
//             .clamp(0, 255);
//         int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
//         gambar.data[index] = hexFF | (b << 16) | (g << 8) | r;
//       }
//     }

//     return gambar;
//   }
// }
