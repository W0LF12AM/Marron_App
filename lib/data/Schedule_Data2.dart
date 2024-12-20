// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroon_app/widgets/default.dart';


class Jadwal_Praktikum2 extends StatelessWidget {
  const Jadwal_Praktikum2({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: smt34Color),
              bottom: BorderSide(color: smt34Color))),
      columns: [
        DataColumn(
            label: Expanded(
                child: Text('Praktikum', style: GoogleFonts.poppins()))),
        DataColumn(
            label:
                Expanded(child: Text('Kelas', style: GoogleFonts.poppins()))),
        DataColumn(
            label: Expanded(child: Text('Jam', style: GoogleFonts.poppins()))),
        DataColumn(
            label: Expanded(child: Text('Lab', style: GoogleFonts.poppins()))),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Align(
            alignment: Alignment.centerLeft,
            child: Text('Algopro'),
          )),
          DataCell(Align(
            alignment: Alignment.center,
            child: Text('C'),
          )),
          DataCell(Text('10.30')),
          DataCell(Text(
            'Lab MM',
            style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12)),
          )),
        ]),
        DataRow(cells: [
          DataCell(Text('MobPro')),
          DataCell(Align(
            alignment: Alignment.center,
            child: Text('Gab B'),
          )),
          DataCell(Text('13.00')),
          DataCell(Text('Lab MM',
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12)))),
        ]),
        DataRow(cells: [
          DataCell(Text('PIK')),
          DataCell(Align(
            alignment: Alignment.center,
            child: Text('A'),
          )),
          DataCell(Text('07.30')),
          DataCell(Text('Lab SC',
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12)))),
        ]),
        DataRow(cells: [
          DataCell(Text('UI/UX')),
          DataCell(Align(
            alignment: Alignment.center,
            child: Text('Gab A'),
          )),
          DataCell(Text('10.30')),
          DataCell(Text('Online')),
        ]),
        DataRow(cells: [
          DataCell(Align(
            alignment: Alignment.centerLeft,
            child: Text('Algo'),
          )),
          DataCell(Align(
            alignment: Alignment.center,
            child: Text('C'),
          )),
          DataCell(Text('10.30')),
          DataCell(Text(
            'Lab MM',
            style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12)),
          )),
        ]),
        DataRow(cells: [
          DataCell(Text('MobPro')),
          DataCell(Align(
            alignment: Alignment.center,
            child: Text('Gab B'),
          )),
          DataCell(Text('13.00')),
          DataCell(Text('Lab MM',
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12)))),
        ]),
      ],
    );
  }
}
