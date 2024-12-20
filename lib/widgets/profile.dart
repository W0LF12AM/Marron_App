import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroon_app/widgets/default.dart';

class Profile extends StatefulWidget {
  Profile({super.key, required this.text, required this.iconProfile});

  final String text;
  final IconData? iconProfile;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      widget.iconProfile,
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
