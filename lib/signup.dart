import 'package:doctor_app/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


    class Signup extends StatefulWidget {
      const Signup({super.key});

      @override
      State<Signup> createState() => _SignupState();
    }

    class _SignupState extends State<Signup> {
      TextEditingController email = TextEditingController();
      TextEditingController password=TextEditingController();

      signup() async{
        try{
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);
          Get.offAll(Wrapper());
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
            title: Text("Sign up"),
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
              ElevatedButton(onPressed: (()=>signup()), child: Text("Sign Up")),
            ],
          ),
        );
      }
    }
