import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user=FirebaseAuth.instance.currentUser;
  signout()async{
    await FirebaseAuth.instance.signOut();
    Get.offAll(Login());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Hompage"),
      ),
      body: Center(
        child: Text('${user!.email}'),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (()=>signout()),
          child: Icon(Icons.login_rounded),
      ),
    );
  }
}
