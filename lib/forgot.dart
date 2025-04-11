import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class forgot extends StatefulWidget {
  const forgot({super.key});

  @override
  State<forgot> createState() => _forgotState();
}

class _forgotState extends State<forgot> {
  TextEditingController email = TextEditingController();
  TextEditingController password=TextEditingController();

  reset() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);

    }on FirebaseAuthException catch(e) {
      Get.snackbar("Error", e.code);
    }
    catch(e){
      Get.snackbar("Error", e.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" forgot password"),
      ),
      body: Column(
        children: [
          TextField(
              controller:email ,
              decoration: InputDecoration(hintText: 'Enter email')
          ),
          ElevatedButton(onPressed: (()=>reset()), child: Text("Reset")),
        ],
      ),
    );
  }
}
