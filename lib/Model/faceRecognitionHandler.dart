import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class FaceRecognitionHandler {
  late List<List<double>> storedEmbeddings = [];
  static const double matchingThreshold = 1;

  Future<File> _downloadFile(String downloadUrl, String fileName) async {
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/$fileName');
    final Dio dio = Dio();
    await dio.download(downloadUrl, file.path);
    return file;
  }
}
