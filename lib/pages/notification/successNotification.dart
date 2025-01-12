import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:maroon_app/pages/landing_page.dart';
import 'package:maroon_app/widgets/button/customButtonMenu.dart';
import 'package:maroon_app/widgets/others/default.dart';

class Success_Notofication extends StatelessWidget {
  Success_Notofication({super.key, required this.pesan});

  final String pesan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 110),
        child: Center(
          child: Column(
            children: [
              Lottie.asset('assets/Success Notification.json'),
              Text(
                'Success!',
                style: Notification_Style,
              ),
              Text(
                pesan,
                style: GoogleFonts.poppins(textStyle: TextStyle()),
              ),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomButtonMenu(
                  button_text: 'Kembali',
                  navigate: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Landing_Screen()));
                  },
                  color: mainColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
