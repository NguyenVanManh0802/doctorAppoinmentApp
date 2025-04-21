import 'package:flutter/material.dart';

import '../service/AuthService.dart'; // Import RegisterService của bạn

class Authcontroller {
  final AuthService _authService = AuthService();

  // Các biến trạng thái để theo dõi thông tin đăng ký (có thể sử dụng GetX, Provider, hoặc BLoC cho quản lý trạng thái phức tạp hơn)
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController=TextEditingController();
  final TextEditingController roleController=TextEditingController();

  Future<void> register(BuildContext context) async {
    final fullname = fullnameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phoneNumber=phoneNumberController.text.trim();
    final  role=roleController.text.trim();

    try {
      await _authService.registerUser(fullname, email, password,phoneNumber,role);
      // Xử lý khi đăng ký thành công (ví dụ: hiển thị thông báo, chuyển trang)

      // Có thể chuyển người dùng đến trang đăng nhập hoặc trang chính

    } catch (e) {
      // Xử lý lỗi đăng ký (ví dụ: hiển thị thông báo lỗi)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng ký: $e')),
      );
    }
  }
}