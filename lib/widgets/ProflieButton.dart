import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maroon_app/pages/loading_page.dart';
import 'package:maroon_app/widgets/customButtonMenu.dart';
import 'package:maroon_app/widgets/default.dart';
import 'package:image/image.dart' as img;

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
            String fileName =
                "faces/$userId/${DateTime.now().millisecondsSinceEpoch}.png";
            final storageRef = FirebaseStorage.instance.ref().child(fileName);
            await storageRef.putFile(croppedFace);
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
                          'assets/uploadIcon.svg',
                          width: 80,
                          height: 80,
                          color: mainColor,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  CustomButtonMenu(
                      button_text: 'Upload',
                      navigate: () async {
                        final userId = FirebaseAuth.instance.currentUser?.uid;

                        if (userId == null) {
                          print('lu belom login kocak');
                          return;
                        }

                        await _uploadImage(userId);

                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      color: mainColor)
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
