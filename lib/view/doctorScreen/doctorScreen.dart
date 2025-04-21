import 'package:doctor_app/view/doctorScreen/HomeDoctor.dart';
import 'package:doctor_app/view/doctorScreen/schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class Doctorscreen extends StatefulWidget {
  const Doctorscreen({super.key});

  @override
  State<Doctorscreen> createState() => _DoctorscreenState();
}

class _DoctorscreenState extends State<Doctorscreen> {

  int _selectedIndex = 0;
  final _screen=[
    Homedoctor(),
    Container(),
    Schedule(),
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
            icon: Icon(CupertinoIcons.chat_bubble_text_fill),
            label:"Message",
          ) ,
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label:"Schedule",
          )
        ],
      ),
    )  ;
  }
}
