import 'package:doctor_app/view/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomScreen extends StatelessWidget {
  const WelcomScreen({super.key});

  void onClickButton() {
    Get.offAll(Login());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg1.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Container(
              child: Text(
                "Welcom to Doctor Appoinment ",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset('assets/images/nen2.png',
                width: 300,
                height: 400,
                fit: BoxFit.cover), // Đặt ở đây để nằm dưới,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(padding: const EdgeInsets.only(bottom: 70.0),
            child: Container(
                child: ElevatedButton(
                    onPressed:()=> onClickButton(),
                    style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: Size(200, 70),
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)
                          ),
                          elevation: 30,
                          shadowColor: Colors.black.withOpacity(0.8),
                          side: BorderSide(width: 2,color: Colors.yellow)
                  ),
                    child:const Text('Login',style: TextStyle(fontSize: 25),)
        ),
            ),
          ),
          ),
        ],
      ),

    );
  }
}