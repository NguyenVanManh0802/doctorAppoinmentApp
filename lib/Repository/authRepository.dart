import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';
 // Import model Patient của bạn

class authRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users'); // Tên collection bạn muốn sử dụng

  Future<void> registerUser(User user) async {
    try {
      // Thêm dữ liệu người dùng vào collection 'users' với ID tự động
      await _usersCollection.add(user.toMap());
      print('Người dùng đã được đăng ký thành công!');
    } catch (e) {
      print('Lỗi đăng ký người dùng: $e');
      rethrow; // Re-throw lỗi để Controller có thể xử lý
    }
  }
}