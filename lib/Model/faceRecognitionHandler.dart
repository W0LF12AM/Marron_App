import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FaceRecognitionHandler {
  late List<List<double>> storedEmbeddings = [];
  static const double matchingThreshold = 1;

  // Future<void> loadStoredEmbeddings() async {
  //   try {
  //     final userId = FirebaseAuth.instance.currentUser?.uid;
  //     if (userId == null) throw Exception('User Not lOgged Een');

  //     storedEmbeddings = await fetchStoredEmbeddings(userId);
  //     print("embed yang dah di taro berasil diambil lurd");
  //     print(storedEmbeddings);
  //   } catch (e) {
  //     print("errornya gara gara : $e");
  //   }
  // }

  // Future<List<List<double>>> fetchStoredEmbeddings(String userId) async {
  //   final List<List<double>> embeddings = [];
  //   final storageRef = FirebaseStorage.instance.ref('faces/$userId');
  //   final ListResult result = await storageRef.listAll();

  //   for (var item in result.items) {
  //     try {
  //       final String downloadUrl = await item.getDownloadURL();
  //       final File tempFile = await _downloadFile(downloadUrl, item.name);

  //       // Read file as binary and decode embeddings
  //       final Uint8List bytes = await tempFile.readAsBytes();
  //       final Float32List floatList = Float32List.fromList(
  //         bytes.buffer.asFloat32List(),
  //       );

  //       embeddings.add(floatList.toList());
  //       print("Binary embedding fetched successfully for ${item.name}");
  //     } catch (e) {
  //       print("Error fetching binary embedding from ${item.name}: $e");
  //     }
  //   }
  //   return embeddings;
  // }

  Future<File> _downloadFile(String downloadUrl, String fileName) async {
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/$fileName');
    final Dio dio = Dio();
    await dio.download(downloadUrl, file.path);
    return file;
  }
}
