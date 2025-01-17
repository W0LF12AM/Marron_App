//COLOR STYLE
// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const mainColor = Color(0xff016D94);
const secondaryColor = Colors.white;
const tertiaryColor = Color.fromARGB(255, 234, 234, 234);
const formColor = Color(0xffEDEDED);
const smt12Color = Color.fromARGB(255, 185, 28, 16);
const smt34Color = Color(0xff016D94);
const smt56Color = Color.fromARGB(255, 1, 148, 62);
const smt78Color = Color.fromARGB(255, 148, 138, 1);

//TEXT STYLE
var Title_style = GoogleFonts.poppins(
    textStyle:
        TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: mainColor));

var Subtitle_style = GoogleFonts.poppins(
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400));

var Card_Title_Style = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontWeight: FontWeight.w700, fontSize: 25, color: secondaryColor));

var Card_Title_Attendance_Style = GoogleFonts.poppins(
    textStyle:
        TextStyle(fontWeight: FontWeight.w700, fontSize: 25, color: mainColor));

var Notification_Style = GoogleFonts.poppins(
    textStyle:
        TextStyle(fontWeight: FontWeight.bold, color: mainColor, fontSize: 30));

var FakeGps_Style = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontWeight: FontWeight.bold, color: smt12Color, fontSize: 30));

var Notification_Failed_Style = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontWeight: FontWeight.bold, color: smt12Color, fontSize: 30));

var Delete_Dialogue_Style = GoogleFonts.poppins(
    textStyle: TextStyle(
  fontWeight: FontWeight.bold,
  color: smt12Color,
));

var Subtitle_Class_Card_Style = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w400, color: secondaryColor));

var Loading_Style = GoogleFonts.poppins(
    textStyle:
        TextStyle(fontWeight: FontWeight.bold, color: mainColor, fontSize: 20));

var Alert_Dialogue_Style = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w700, color: secondaryColor));

var Error_Validtion_Style = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black));
