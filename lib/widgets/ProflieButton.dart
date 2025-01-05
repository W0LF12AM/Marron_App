import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maroon_app/pages/loading_page.dart';
import 'package:maroon_app/pages/registFace_page.dart';
import 'package:maroon_app/dump/registerCamera_page.dart';
import 'package:maroon_app/widgets/customButtonMenu.dart';
import 'package:maroon_app/widgets/default.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class Profliebutton extends StatefulWidget {
  Profliebutton(
      {Key? key,
      required this.text,
      required this.iconProfliebutton,
      required this.fileName})
      : super(key: key);

  final String text;
  final IconData? iconProfliebutton;
  final String fileName;

  @override
  State<Profliebutton> createState() => _ProfliebuttonState();
}

class _ProfliebuttonState extends State<Profliebutton> {
  final picker = ImagePicker();

  Future<void> _uploadImage(String userId) async {
    final pickedFiles = await picker.pickMultiImage();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                LoadingPage(pesan: "Tunggu Sebentar")));

    for (var pickedFile in pickedFiles) {
      File file = File(pickedFile.path);
      try {
        final croppedFaces = await _detectAndCropFaces(file);
        if (croppedFaces.isNotEmpty) {
          for (var croppedFace in croppedFaces) {
            Float32List proecessedImage = await _preprocessImage(croppedFace);

            Float32List reducingEmbedding =
                reduceEmbeddingWithAverage(proecessedImage);

            final processedFile =
                File('${Directory.systemTemp.path}/processed_face.png');
            await processedFile
                .writeAsBytes(reducingEmbedding.buffer.asUint8List());

            String fileName =
                "faces/$userId/${DateTime.now().millisecondsSinceEpoch}.png";
            final storageRef = FirebaseStorage.instance.ref().child(fileName);
            await storageRef.putFile(processedFile);
            print('gambar berhasil di uplot, namanya $fileName');
          }
        } else {
          print(
              'Tidak ada wajah yang terdeteksi pada gambar : ${pickedFile.path}');
        }
      } catch (e) {
        print('error brow: $e');
      }
    }
    Navigator.of(context).pop();
  }

  Float32List reduceEmbeddingWithAverage(Float32List originalEmbedding) {
    if (originalEmbedding.length != 37632) {
      throw Exception('embed orinya kudu 37632');
    }

    Float32List reducedEmbedding = Float32List(192);

    int segmentSize = 37632 ~/ 192;
    for (int i = 0; i < 192; i++) {
      double sum = 0.0;
      for (int j = 0; j < segmentSize; j++) {
        sum += originalEmbedding[i * segmentSize + j];
      }
      reducedEmbedding[i] = sum / segmentSize;
    }
    return reducedEmbedding;
  }

  Future<List<File>> _detectAndCropFaces(File imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final faceDetector = GoogleMlKit.vision.faceDetector();
    final faces = await faceDetector.processImage(inputImage);
    List<File> croppedFiles = [];

    if (faces.isEmpty) {
      return croppedFiles;
    }

    final img.Image originalImage =
        img.decodeImage(await imageFile.readAsBytes())!;

    for (final face in faces) {
      final boundingBox = face.boundingBox;

      final img.Image croppedFace = img.copyCrop(
          originalImage,
          boundingBox.left.toInt(),
          boundingBox.top.toInt(),
          boundingBox.width.toInt(),
          boundingBox.height.toInt());

      final directory = Directory.systemTemp;
      final croppedFile = File(
          '${directory.path}/croppedFace_${DateTime.now().millisecondsSinceEpoch}.png')
        ..writeAsBytesSync(img.encodePng(croppedFace));

      croppedFiles.add(croppedFile);
    }
    return croppedFiles;
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

  Future<File> _getProcessedFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final processedFile = File('${directory.path}/processed_face.png');
    return processedFile;
  }

  Future<void> _deleteImage(String folderPath) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(folderPath);
      final result = await storageRef.listAll();

      for (var item in result.items) {
        await item.delete();
        print('file ${item.fullPath} dah diapus');
      }
    } catch (e) {
      print('error deletnya : $e');
    }
  }

  Future<void> deleteFiles() async {
    try {
      // Dapatkan direktori penyimpanan lokal
      final directory = await getApplicationDocumentsDirectory();

      // Path untuk file gambar cropped
      final croppedFaceFile = File('${directory.path}/cropped_face.png');
      // Path untuk file embedding
      final embeddingFile = File('${directory.path}/embedding.json');

      // Hapus file gambar cropped jika ada
      if (await croppedFaceFile.exists()) {
        await croppedFaceFile.delete();
        print(
            'Cropped face image deleted successfully at: ${croppedFaceFile.path}');
      } else {
        print('Cropped face image not found at: ${croppedFaceFile.path}');
      }

      // Hapus file embedding jika ada
      if (await embeddingFile.exists()) {
        await embeddingFile.delete();
        print('Embedding file deleted successfully at: ${embeddingFile.path}');
      } else {
        print('Embedding file not found at: ${embeddingFile.path}');
      }
    } catch (e) {
      print('Error deleting files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Submit Faces'),
                content: Container(
                  width: double.infinity,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/faceId.svg',
                          width: 80,
                          height: 80,
                          color: mainColor,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Column(
                    children: [
                      CustomButtonMenu(
                          button_text: 'Take Picture',
                          navigate: () async {
                            final userId =
                                FirebaseAuth.instance.currentUser?.uid;

                            if (userId == null) {
                              print('lu belom login kocak');
                              return;
                            }

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RegistfacePage(), // Ganti dengan embeddings yang sesuai
                              ),
                            );
                            // await _uploadImage(userId);

                            if (mounted) {
                              Navigator.pop(context);
                            }
                          },
                          color: mainColor),
                      TextButton(
                          onPressed: deleteFiles, child: Text('hapus data'))
                    ],
                  )
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: mainColor),
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(color: tertiaryColor),
                          borderRadius: BorderRadius.circular(8),
                          color: secondaryColor),
                      child: Icon(
                        widget.iconProfliebutton,
                        color: mainColor,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.text,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 115,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
