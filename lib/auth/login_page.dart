// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maroon_app/auth/auth_page.dart';
import 'package:maroon_app/widgets/others/checkBox.dart';
import 'package:maroon_app/widgets/others/default.dart';
import 'package:maroon_app/widgets/others/form.dart';
import 'package:maroon_app/widgets/button/loginButton.dart';

class Login_Screen extends StatelessWidget {
  Login_Screen({super.key});

  final npmController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: npmController.text, password: passwordController.text);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthPage()));
    } catch (e) {
      print('gagal login bang : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/Attendance Logo.png",
                    width: 326,
                    height: 326,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                //form login
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Login', style: Title_style),
                      Text('Please Login to continue', style: Subtitle_style),
                      SizedBox(
                        height: 20,
                      ),
                      FormWidget(
                        controller: npmController,
                        hint_text: "Masukkan NPM anda",
                        label_text: "NPM",
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      FormWidget(
                          controller: passwordController,
                          hint_text: "Password",
                          label_text: "Password"),
                      CekBog(),
                      SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        button_text: "Sign In",
                        navigate: () => _signIn(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
