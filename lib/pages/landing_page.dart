// ignore_for_file: file_names, prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maroon_app/pages/course_page.dart';

import 'package:maroon_app/pages/schedule_page.dart';
import 'package:maroon_app/widgets/others/default.dart';

class Landing_Screen extends StatefulWidget {
  const Landing_Screen({super.key});

  @override
  State<Landing_Screen> createState() => _Landing_ScreenState();
}

class _Landing_ScreenState extends State<Landing_Screen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOption = <Widget>[
    CoursePage(),
    SchedulePage(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: formColor,
      body: _widgetOption.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.all_inbox_rounded), label: "Courses"),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm_rounded), label: "Schedule"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: secondaryColor,
        onTap: _onItemTap,
        backgroundColor: mainColor,
        unselectedItemColor: formColor,
      ),
    );
  }
}
