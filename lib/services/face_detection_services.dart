// import 'package:camera/camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;

// class FaceDetectionService {
//   late FaceDetector _detector;

//   FaceDetectionService() {
//     _detector = FaceDetector(
//       options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
//     );
//   }

//   Future<List<Face>> detectFaces(InputImage inputImage) async {
//     return await _detector.processImage(inputImage);
//   }

//   img.Image convertYUV420ToImage(CameraImage cameraImage) {
//     // Tambahkan logika konversi YUV ke gambar di sini
//   }

//   int yuv2rgb(int y, int u, int v) {
//     // Tambahkan logika konversi YUV ke RGB di sini
//   }
// }
