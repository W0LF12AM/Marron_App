// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maroon_app/auth/auth_page.dart';
import 'package:maroon_app/widgets/button/validatorButton.dart';
import 'package:maroon_app/widgets/others/checkBox.dart';
import 'package:maroon_app/widgets/others/default.dart';
import 'package:maroon_app/widgets/others/form.dart';
import 'package:maroon_app/widgets/button/loginButton.dart';

class Login_Screen extends StatefulWidget {
  Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  final npmController = TextEditingController();

  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: npmController.text, password: passwordController.text);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthPage()));
    } catch (e) {
      if (e is FirebaseAuthException) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'Pengguna tidak ditemukan';
            break;
          case 'wrong-password':
            message = 'password salah!';
            break;
          default:
            message = 'Terjadi keaslahan :3';
        }
        _dialogError(context, message);
      } else {
        _dialogError(context, 'Terjadi kesalahan, Silahkan coba lagi');
      }
      // setState(() {
      //   _errorMessage = 'Gagal Login : ${e.toString()}';
      // });
      print('gagal login bang : $e');
    }
  }

  void _dialogError(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login Error!',
                    style: Title_style,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Divider(
                      thickness: 2,
                      color: Colors.black,
                    ),
                  ),
                  Image.asset('assets/user not found.png'),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    message,
                    style: Error_Validtion_Style,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Validatorbutton(
                        button_text: 'Ok',
                        navigate: () {
                          Navigator.pop(context);
                        },
                        color: mainColor),
                  )
                ],
              ),
            ),
          );
          // AlertDialog(
          //   title: Text('Login Failed'),
          //   content: Column(
          //     children: [
          //       SvgPicture.asset('assets/user not found.svg', width: 30, height: 40,),
          //       Text(message),
          //     ],
          //   ),
          //   actions: <Widget>[
          //     Validatorbutton(
          //         color: mainColor,
          //         button_text: 'Ok',
          //         navigate: () {
          //           Navigator.pop(context);
          //         })
          //   ],
          // );
        });
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
            child: Form(
              key: _formKey,
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
                          obscurega: false,
                          controller: npmController,
                          hint_text: "Masukkan email anda",
                          label_text: "Email",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email tidak boleh kosong!';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        FormWidget(
                          obscurega: true,
                          controller: passwordController,
                          hint_text: "Password",
                          label_text: "Password",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password tidak boleh kosong!';
                            }
                            return null;
                          },
                        ),
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
      ),
    );
  }
}
