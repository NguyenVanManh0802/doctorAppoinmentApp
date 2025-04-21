import 'package:doctor_app/view/adminScreen/DoctorDetail.dart';
import 'package:doctor_app/view/adminScreen/adminScreen.dart';
import 'package:doctor_app/view/patienceScreen/DoctorDetailPage.dart';
import 'package:doctor_app/view/doctorScreen/doctorScreen.dart';
import 'package:doctor_app/theme/theme.dart';
import 'package:doctor_app/view/auth/welcom.dart';
import 'package:doctor_app/view/auth/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'view/patienceScreen/homepage.dart';
import 'widget/firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: lightMode,
      home: WelcomScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

