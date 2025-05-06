
import 'package:doctor_app/service/AuthService.dart';
import 'package:doctor_app/view/patienceScreen/patienceScreen.dart';
import 'package:firebase_auth/firebase_auth.dart'as firebase_auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';
import '../service/AppointmentService.dart';
import '../view/adminScreen/adminScreen.dart';
import '../view/auth/login.dart';
import '../view/doctorScreen/doctorScreen.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final AppointmentService _appointmentService = AppointmentService(); // Khởi tạo AppointmentService
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  final doctorsBySpecialty = <User>[].obs;
  Rxn<String> _userRole = Rxn<String>();
  String? get userRole => _userRole.value;


  final firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
  final pendingAppointments = <Map<String, dynamic>>[].obs;
  final getPatientBySchedule=<Map<String, dynamic>>[].obs;
  final appointmentDetails = Rxn<Map<String, dynamic>>(); // Thêm biến này

  @override
  // void onInit() {
  //   super.onInit();
  //   // Check for logged-in user and fetch their role on app start
  //   fetchCurrentUserRole();
  // }

  Future<void> registerWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String role,
    required String SpecialtyId
  }) async {
    try {
      // 1. Create user with email and password in Firebase Authentication
      final firebase_auth.UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // 2. Store additional user information in Firestore
        await _authService.saveUserData(
          uid: userCredential.user!.uid,
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          role: role,
          SpecialtyId:SpecialtyId,
        );
        Get.snackbar(
          "Success",
          "Registration successful!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        "Firebase Auth Error: ${e.message}",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      rethrow;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      rethrow;
    }
  }


  Future<String?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final firebase_auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        // After successful sign-in, fetch the user's role
        await fetchUserRole(userCredential.user!.uid);
        return userCredential.user!.uid;
      }
      return null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        "Firebase Auth Error: ${e.message}",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      rethrow;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<User?> fetchUserByUid(String uid) async {
    try {
      final userData = await _authService.fetchUserData(uid); // Gọi hàm từ AuthService
      if (userData != null) {
        // Ánh xạ Map<String, dynamic> sang User model
        return User.fromMap(userData, uid); // Pass the uid (documentId)
      }
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      Get.snackbar(
        "Error",
        "Failed to fetch user data: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return null;
    }
  }


  Future<void> fetchUserRole(String uid) async {
    final userData = await _authService.fetchUserData(uid);
    if (userData != null && userData.containsKey('role')) {
      _userRole.value = userData['role'] as String;
      print('User Role: ${_userRole.value}');
      if(_userRole.value == 'patient')
        {
          Get.offAll(patienceScreen());
        }
      else if(_userRole.value =='doctor')
        {
          Get.offAll(Doctorscreen());
        }
      else
        {
          Get.offAll(AdminScreen());
        }
    } else {
      _userRole.value = null;
      // Handle the case where the role is not found
      print('User role not found in Firestore');
    }
  }

  // Future<void> fetchCurrentUserRole() async {
  //   if (_auth.currentUser != null) {
  //     await fetchUserRole(_auth.currentUser!.uid);
  //   }
  // }



  Future<void> signOut() async {
    await _auth.signOut();
    _userRole.value = null;
    // Navigate to the login screen
    Get.offAll(() => const Login());
  }

  Future<void> fetchDoctorsBySpecialty(String specialtyId) async {
    try {
      final List<User> doctors =
      (await _authService.getDoctorsBySpecialty(specialtyId)).cast<User>();
      doctorsBySpecialty.assignAll(doctors);
    } catch (e) {
      print(e);
      Get.snackbar(
        "Error",
        "Failed to fetch doctors: $e",

        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<User?> fetchDoctorById(String doctorId) async {
    try {
      final User? doctor = await _authService.getUserById(doctorId);
      return doctor;
    } catch (e) {
      print("Error fetching doctor by ID: $e");
      Get.snackbar(
        "Error",
        "Failed to fetch doctor details: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return null;
    }
  }

  Future<bool> makeAppointment({
    required String doctorId,
    required DateTime appointmentDate,
    required String appointmentTime,
    String? patientId, // Thêm patientId nếu cần
  }) async {
    // Lấy ID người dùng hiện tại nếu chưa được truyền
    final String? currentUserId = _auth.currentUser?.uid;
    final String? finalPatientId = patientId ?? currentUserId;
    if (finalPatientId == null) {
      Get.snackbar("Lỗi", "Không tìm thấy thông tin người dùng. Vui lòng đăng nhập lại.");
      return false;
    }

    return await _appointmentService.makeAppointment(
      doctorId: doctorId,
      patientId: finalPatientId,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
    );
  }

  Future<void> fetchPendingAppointments() async {

      final appointments = await _appointmentService.getPendingAppointmentsForDoctor(user?.uid);
      pendingAppointments.assignAll(appointments);
  }

  //lấy list patient dưa theo state đã là true
  Future<void> fetchScheduleAppointments() async {

    final appointments = await _appointmentService.getPatientHasStateIsTrue(user?.uid);
    getPatientBySchedule.assignAll(appointments);
  }

  //lấy theo appointmentId
  Future<void> fetchAppointmentDetails(String appointmentId) async {
    appointmentDetails.value = await _appointmentService.getAppointmentDetails(appointmentId);
  }

  // Hàm chấp nhận lịch hẹn, gọi service để cập nhật trạng thái
  Future<void> acceptAppointment(String appointmentId) async {
    try {
      await _appointmentService.updateAppointmentState(appointmentId);
      Get.snackbar(
        "Success",
        "Appointment accepted successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to accept appointment: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      rethrow; // Để thông báo lỗi hiển thị
    }
  }

  // Hàm từ chối lịch hẹn, gọi service để xóa
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await _appointmentService.deleteAppointment(appointmentId);
      Get.snackbar(
        "Success",
        "Appointment rejected successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to reject appointment: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      rethrow; // Để thông báo lỗi hiển thị
    }
  }


}

