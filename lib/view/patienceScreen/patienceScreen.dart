import 'package:doctor_app/view/patienceScreen/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SchedulePatience.dart';

class patienceScreen extends StatefulWidget {
  const patienceScreen({super.key});

  @override
  State<patienceScreen> createState() => _patienceScreenState();
}

class _patienceScreenState extends State<patienceScreen> {

  int _selectedIndex = 0;
  final _screen=[
  Homepage(),
  Schedulepatience(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black26,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        currentIndex:   _selectedIndex,
        onTap: (index){
          setState(() {
            _selectedIndex=index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label:"Home",
          ) ,
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule_rounded),
            label:"Schedule",
          )
        ],
      ),
    )  ;
  }
}
