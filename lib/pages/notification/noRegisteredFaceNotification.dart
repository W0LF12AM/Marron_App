import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maroon_app/pages/core/registFace_page.dart';
import 'package:maroon_app/widgets/button/customButtonMenu.dart';
import 'package:maroon_app/widgets/others/default.dart';


class Noregisteredfacenotification extends StatelessWidget {
  const Noregisteredfacenotification({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height * 0.15),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/Empty Data.json',
            ),
            Text(
              'No Registered Face\ntry to register your face first :3',
              style: Loading_Style,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomButtonMenu(
                  color: mainColor,
                  button_text: 'Register Face',
                  navigate: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RegistfacePage()));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
