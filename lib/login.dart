import 'package:doctor_app/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forgot.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController email = TextEditingController();
  TextEditingController password=TextEditingController();

  bool isLoading=false;

  signIn() async{
    setState(() {
      isLoading=true;
    });
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
    }on FirebaseAuthException catch(e) {
      Get.snackbar("Error", e.code);
    }
    catch(e){
      Get.snackbar("Error", e.toString());
      }
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?Center(child: CircularProgressIndicator(),): Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller:email ,
            decoration: InputDecoration(hintText: 'Enter email')
      ),
          TextField(
            controller: password,
            decoration: InputDecoration(hintText: 'Enter password'),
          ),
          ElevatedButton(onPressed: (()=>signIn()), child: Text("Login")),
          SizedBox(height: 30,),
          ElevatedButton(onPressed: (()=>Get.to(Signup())), child: Text("Register now")),
          SizedBox(height: 30,),
          ElevatedButton(onPressed: (()=>Get.to(forgot())), child: Text("Forgot password")),
        ],
      ),
    );
  }
}
