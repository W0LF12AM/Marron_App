//USER PROFILE HEADER
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroon_app/pages/profile_page.dart';
import 'package:maroon_app/services/userServices.dart';
import 'package:maroon_app/widgets/others/default.dart';

class User_Header extends StatefulWidget {
  const User_Header({super.key});

  @override
  State<User_Header> createState() => _User_HeaderState();
}

class _User_HeaderState extends State<User_Header> {
  final UserService _userService = UserService();
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _userService.getUserProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //header app
        Container(
          width: double.infinity,
          height: 110,
          decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25))),
        ),
        //user profile
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ProfilePage()));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 60),
            child: Container(
              width: double.infinity,
              height: 81,
              decoration: BoxDecoration(
                  color: secondaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: const Color.fromARGB(60, 0, 0, 0), blurRadius: 2)
                  ],
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 40,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FutureBuilder<Map<String, dynamic>?>(
                            future: _userDataFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Error Loading Data',
                                  style: Title_style,
                                );
                              } else if (snapshot.hasData) {
                                final data = snapshot.data!;
                                final name = data['name'] ?? 'User';
                                final npm = data['npm'] ?? 'Unidentified';
                                final className =
                                    data['class'] ?? 'Belum pilih kelas';
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      name,
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    Text("$npm - $className",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400))),
                                  ],
                                );
                              } else {
                                return Text(
                                  'Klik untuk input profile',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                );
                              }
                            })
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfilePage()));
                      },
                      child: SvgPicture.asset(
                        'assets/setting.svg',
                        width: 25,
                        height: 25,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
