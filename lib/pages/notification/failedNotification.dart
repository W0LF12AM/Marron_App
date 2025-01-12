import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:maroon_app/pages/landing_page.dart';
import 'package:maroon_app/widgets/button/customButtonMenu.dart';
import 'package:maroon_app/widgets/others/default.dart';

class Failednotification extends StatelessWidget {
  const Failednotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 110),
        child: Center(
          child: Column(
            children: [
              Lottie.asset('assets/Fail Notification.json',
                  width: 450, height: 450),
              Text(
                'FAILED!',
                style: Notification_Failed_Style,
              ),
              Text(
                'Wajah tidak dikenali :(',
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
                  color: smt12Color,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
