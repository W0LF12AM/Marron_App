import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FaceRecognitionHandler {
  late List<List<double>> storedEmbeddings = [];
  static const double matchingThreshold = 1.9252375453906844e+34 + 0.0000000001;

  Future<void> loadStoredEmbeddings() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User Not lOgged Een');

      storedEmbeddings = await fetchStoredEmbeddings(userId);
      print("embed yang dah di taro berasil diambil lurd");
      print(storedEmbeddings);
    } catch (e) {
      print("errornya gara gara : $e");
    }
  }

  static double _calculateEuclidianDistance(List<double> a, List<double> b) {
    return sqrt(a
        .asMap()
        .entries
        .map((entry) => pow(entry.value - b[entry.key], 2))
        .reduce((value, element) => value + element));
  }

  Future<List<List<double>>> fetchStoredEmbeddings(String userId) async {
    final List<List<double>> embeddings = [];
    final storageRef = FirebaseStorage.instance.ref('faces/$userId');
    final ListResult result = await storageRef.listAll();

    for (var item in result.items) {
      try {
        final String downloadUrl = await item.getDownloadURL();
        final File tempFile = await _downloadFile(downloadUrl, item.name);

        // Read file as binary and decode embeddings
        final Uint8List bytes = await tempFile.readAsBytes();
        final Float32List floatList = Float32List.fromList(
          bytes.buffer.asFloat32List(),
        );

        embeddings.add(floatList.toList());
        print("Binary embedding fetched successfully for ${item.name}");
      } catch (e) {
        print("Error fetching binary embedding from ${item.name}: $e");
      }
    }
    return embeddings;
  }

  Future<File> _downloadFile(String downloadUrl, String fileName) async {
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/$fileName');
    final Dio dio = Dio();
    await dio.download(downloadUrl, file.path);
    return file;
  }

  Future<bool> matchLiveInput(List<double> liveEmbedding) async {
    if (storedEmbeddings.isEmpty) {
      print('datanya embednya gada kocak');
      return false;
    }

    for (var storedEmbedding in storedEmbeddings) {
      final double distance =
          _calculateEuclidianDistance(liveEmbedding, storedEmbedding);
      print('distance : $distance');

      if (distance > matchingThreshold) {
        print('match found with this DISTANCCDEEEEEEE : $distance');

        return true;
      }
    }
    print('gaketemu bjir');
    print('gambar yang berhasil diembed : ${storedEmbeddings.length}');
    return false;
  }
}
