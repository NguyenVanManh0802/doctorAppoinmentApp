import '../Repository/authRepository.dart';
import '../model/user_model.dart';

class AuthService {
  final AuthRepository _authRepository = AuthRepository();

  Future<void> saveUserData({
    required String uid,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String role,
    String SpecialtyId="",
  }) async {
    final userMap = {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'SpecialtyId': SpecialtyId
    };
    await _authRepository.saveUserToFirestore(uid, userMap);
  }

  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    return await _authRepository.getUserFromFirestore(uid);
  }
  Future<List<User>> getDoctorsBySpecialty(String specialtyId) async {
    return await _authRepository.getDoctorsBySpecialtyFromFirestore(specialtyId);
  }
  Future<User?> getUserById(String uid) async {
    final userData = await _authRepository.getUserFromFirestore(uid);
    if (userData != null) {
      return User.fromMap(userData, uid);
    }
    return null;
  }

  // Hàm để lấy tất cả bác sĩ
  Future<List<User>> getAllDoctors() async {
    return await _authRepository.getAllDoctorsFromFirestore();
  }

  // Hàm để cập nhật SpecialtyId cho một bác sĩ theo doctorId
  Future<void> updateDoctorSpecialty(String doctorId, String specialtyId) async {
    await _authRepository.updateDoctorSpecialtyInFirestore(doctorId, specialtyId);
  }
  Future<void> deleteUser(String doctorId) async {
    await _authRepository.deleteUserFromFirestore(doctorId);
  }

  // Hàm để cập nhật thông tin người dùng theo UID
  Future<void> updateUser(String uid, {
    String? fullName,
    String? email,
    String? phoneNumber,
  }) async {
    final Map<String, dynamic> updateData = {};
    if (fullName != null) {
      updateData['fullName'] = fullName;
    }
    if (email != null) {
      updateData['email'] = email;
    }
    if (phoneNumber != null) {
      updateData['phoneNumber'] = phoneNumber;
    }

    if (updateData.isNotEmpty) {
      await _authRepository.updateUserInFirestore(uid, updateData);
    }
  }
}
