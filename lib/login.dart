import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  TextEditingController email = TextEditingController();
  TextEditingController password=TextEditingController();

  signIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
      ),
    );
  }
}
