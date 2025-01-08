import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroon_app/widgets/others/default.dart';

class Attendancehistorycard extends StatelessWidget {
  Attendancehistorycard(
      {super.key,
      required this.jam,
      required this.kelas,
      required this.lab,
      required this.semester});

  String semester;
  String kelas;
  String jam;
  String lab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: secondaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 1.5),
              )
            ],
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: mainColor,
                      ),
                      child: Center(
                        //semeseter
                        child: Text(
                          semester,
                          style: GoogleFonts.poppins(
                              color: secondaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  //matprak
                  Text(
                    kelas,
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //jam
                  Text(
                    jam,
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  //lab
                  Text(
                    lab,
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
