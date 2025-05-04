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
    required String SpecialtyId
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
}
