// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maroon_app/auth/login_page.dart';
import 'package:maroon_app/pages/output/registered_face_page.dart';
import 'package:maroon_app/widgets/button/ProflieButton.dart';
import 'package:maroon_app/widgets/button/customButtonMenu.dart';
import 'package:maroon_app/widgets/others/default.dart';
import 'package:maroon_app/widgets/others/form.dart';

import 'package:maroon_app/widgets/others/profile.dart';
import 'package:maroon_app/widgets/button/profileButtonNavigate.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();

  final npmController = TextEditingController();

  final classController = TextEditingController();

  String? kelasDipilih;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  final List<String> pilihanKelas = [
    'Kelas A',
    'Kelas B',
    'Kelas C',
    'Kelas D',
    'Kelas E',
    'Kelas F',
    'Kelas G',
    'Kelas H',
    'Kelas I',
    'Kelas J',
    'Kelas O'
  ];

  String email = '';
  String name = '';
  String npm = '';

  @override
  void initState() {
    super.initState();
    _getUserProfileData();
  }

  Future<void> _getUserProfileData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (snapshot.exists) {
          Map<String, dynamic>? data = snapshot.data();
          setState(() {
            name = data?['name'] ?? 'User';
            npm = data?['npm'] ?? 'unidentified';
            kelasDipilih = data?['class'];
            email = user.email ?? 'Belum Terdaftar';
          });
        }
      }
    } catch (e) {
      print('gagal tjoey : $e');
    }
  }

  Future<void> _logOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Login_Screen()));
    } catch (e) {
      print('error cuy : $e');
    }
  }

  Future<void> _saveDataToFireStore(
      String name, String npm, String className) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'npm': npm,
          'class': className,
          'created_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('gagal deck');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 270,
              decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 85,
                      width: 85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: secondaryColor),
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color: mainColor,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      name,
                      style: Card_Title_Style,
                    ),
                    Text(
                      npm,
                      style: Subtitle_Class_Card_Style,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Profile(text: email, iconProfile: Icons.email_outlined),
            Profile(text: name, iconProfile: Icons.perm_identity),
            Profile(text: npm, iconProfile: Icons.card_membership_outlined),
            Profile(
                text: kelasDipilih ?? 'Belum pilih kelas',
                iconProfile: Icons.class_),
            Profliebutton(
              text: 'Submit Faces',
              iconProfliebutton: Icons.face_retouching_natural,
              fileName: 'faces/$userId/',
            ),
            // Profile(text: 'Test', iconProfile: Icons.text_snippet),
            Profilebuttonnavigate(
              text: 'Saved Faces',
              iconProfile: Icons.save,
              navigate: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            RegisteredFacePage(folderPath: "faces/$userId/")));
              },
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  CustomButtonMenu(
                      color: mainColor,
                      button_text: 'Edit Profile',
                      navigate: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: secondaryColor,
                                title: Text('Profile Edit'),
                                content: Container(
                                  width: double.infinity,
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FormWidget(
                                        obscurega: false,
                                          hint_text: 'Nama',
                                          label_text: 'Nama',
                                          controller: nameController),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FormWidget(
                                         obscurega: false,
                                          hint_text: 'NPM',
                                          label_text: 'NPM',
                                          controller: npmController),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: formColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: DropdownButtonFormField<
                                                  String>(
                                              value: kelasDipilih,
                                              items: pilihanKelas
                                                  .map((String className) {
                                                return DropdownMenuItem<String>(
                                                  value: className,
                                                  child: Text(className),
                                                );
                                              }).toList(),
                                              decoration: InputDecoration(
                                                  labelText: 'Kelas',
                                                  border: InputBorder.none),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  kelasDipilih = newValue;
                                                });
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  CustomButtonMenu(
                                      button_text: 'Simpan',
                                      navigate: () async {
                                        String name = nameController.text;
                                        String npm = npmController.text;
                                        String className = kelasDipilih ??
                                            'Tidak ada kelas dipilih';

                                        await _saveDataToFireStore(
                                            name, npm, className);

                                        await _getUserProfileData();
                                        Navigator.of(context).pop();
                                      },
                                      color: mainColor),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CustomButtonMenu(
                                      button_text: 'Batal',
                                      navigate: () {
                                        Navigator.pop(context);
                                      },
                                      color: smt12Color),
                                ],
                              );
                            });
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButtonMenu(
                      color: smt12Color,
                      button_text: 'Log Out',
                      navigate: () {
                        _logOut(context);
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
