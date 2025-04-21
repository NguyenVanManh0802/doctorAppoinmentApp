

import '../Repository/authRepository.dart';
import '../model/user_model.dart'; // Import RegisterRepository của bạn

class AuthService {
  final authRepository _registerRepository = authRepository(); //register


  //register
  Future<void> registerUser(String fullname, String email, String Password,String PhoneNumber,String Role) async {
    // Thực hiện các logic nghiệp vụ cần thiết trước khi lưu (ví dụ: validate dữ liệu)
    if (fullname.isEmpty || email.isEmpty || Password.isEmpty || PhoneNumber.isEmpty) {
      throw Exception('Vui lòng điền đầy đủ thông tin.');
    }

    // Tạo một đối tượng Patient
    final user = User(
      fullName: fullname,
      email: email,
      password: Password,
      phoneNumber: PhoneNumber,
      role: Role, // Lưu ý: Mã hóa mật khẩu ở đây hoặc trước khi gọi Service
      // idUser sẽ được Firebase tạo tự động
    );

    // Gọi Repository để lưu dữ liệu
    await _registerRepository.registerUser(user);
  }
}