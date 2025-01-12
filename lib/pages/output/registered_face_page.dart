import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:maroon_app/Model/user_model.dart';
import 'package:maroon_app/data/database_helper.dart';
import 'package:maroon_app/pages/loading/loading_page.dart';
import 'package:maroon_app/pages/profile_page.dart';
import 'package:maroon_app/widgets/others/default.dart';
import 'package:path_provider/path_provider.dart';

class RegisteredFacePage extends StatefulWidget {
  final String folderPath;
  const RegisteredFacePage({Key? key, required this.folderPath})
      : super(key: key);

  @override
  State<RegisteredFacePage> createState() => _RegisteredFacePageState();
}

class _RegisteredFacePageState extends State<RegisteredFacePage> {
  late Future<List<String>> _imagesFuture;
  late Future<List<User>> _usersFuture;

  Future<List<String>> fetchUploadedImage(String folderPath) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(folderPath);
      final result = await storageRef.listAll();

      List<String> imageUrls = [];
      for (var item in result.items) {
        final url = await item.getDownloadURL();
        imageUrls.add(url);
      }

      return imageUrls;
    } catch (e) {
      print('Error fetch Image : $e');
      return [];
    }
  }

  Future<void> deleteStoredImage(String username) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child(widget.folderPath);
      final result = await storageRef.listAll();
      await DatabaseHelper.instance.deleteUser(username);

      for (var item in result.items) {
        await item.delete();
      }

      setState(() {
        _imagesFuture = fetchUploadedImage(widget.folderPath);
        _usersFuture = DatabaseHelper.instance.queryAllUsers();
      });

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

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('All images has been deleted')));
    } catch (e) {
      print('Gagal delete gambar bwangk : $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal hapus gambar karena : $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    _imagesFuture = fetchUploadedImage(widget.folderPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: secondaryColor,
          iconSize: 28,
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ProfilePage()));
          },
        ),
        title: Text(
          'Registered Face',
          style: Card_Title_Style,
        ),
      ),
      body: FutureBuilder<List<String>>(
          future: _imagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage(pesan: 'Sabar Bwang');
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error : ${snapshot.error}',
                  style: Loading_Style,
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    Lottie.asset('assets/Empty Data.json'),
                    Text(
                      textAlign: TextAlign.center,
                      'No Submitted Faces\n Try To Register Your Face First :3',
                      style: Loading_Style,
                    ),
                  ],
                ),
              );
            }

            final imageUrls = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8),
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              imageUrls[index],
                              fit: BoxFit.cover,
                            );
                          }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                      child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: smt12Color,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Text(
                            'Delete',
                            style: Alert_Dialogue_Style,
                          ))),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: secondaryColor,
                                title: Center(
                                  child: Text(
                                    'WARNING !',
                                    style: Delete_Dialogue_Style,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to delete all images?',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  GestureDetector(
                                      onTap: () async {
                                        await deleteStoredImage('username');

                                        Navigator.of(context).pop();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: smt12Color,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Center(
                                              child: Text(
                                                'Delete',
                                                style: Alert_Dialogue_Style,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              );
                            });
                      }),
                )
              ],
            );
          }),
    );
  }
}
