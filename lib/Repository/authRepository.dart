import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';


class AuthRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String usersCollection = 'users';

  Future<void> saveUserToFirestore(String uid, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection(usersCollection).doc(uid).set(userData);
      print('User data saved to Firestore for UID: $uid');
    } catch (e) {
      print('Error saving user data to Firestore: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserFromFirestore(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection(usersCollection).doc(uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data()!;
      }
      return null;
    } catch (e) {
      print('Error fetching user data from Firestore: $e');
      rethrow;
    }
  }

  Future<List<User>> getDoctorsBySpecialtyFromFirestore(String specialtyId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(usersCollection)
          .where('role', isEqualTo: 'doctor')
          .where('SpecialtyId', isEqualTo: specialtyId)
          .get();

      return snapshot.docs.map((doc) {
        return User.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching doctors by specialty from Firestore: $e');
      rethrow;
    }
  }

  Future<User?> getUserByIdFromFirestore(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection(usersCollection).doc(uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        return User.fromMap(snapshot.data()!, snapshot.id);
      }
      return null;
    } catch (e) {
      print('Error fetching user data from Firestore: $e');
      rethrow;
    }
  }


  Future<List<User>> getAllDoctorsFromFirestore() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(usersCollection)
          .where('role', isEqualTo: 'doctor')
          .get();

      return snapshot.docs.map((doc) {
        return User.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching all doctors from Firestore: $e');
      rethrow;
    }
  }
  // Hàm để cập nhật SpecialtyId cho một bác sĩ theo doctorId
  Future<void> updateDoctorSpecialtyInFirestore(String doctorId, String specialtyId) async {
    try {
      await _firestore.collection(usersCollection).doc(doctorId).update({'SpecialtyId': specialtyId});
      print('Updated SpecialtyId for doctor with ID: $doctorId to $specialtyId');
    } catch (e) {
      print('Error updating doctor\'s SpecialtyId in Firestore: $e');
      rethrow;
    }
  }

  // Hàm để xóa user từ Firestore theo UID
  Future<void> deleteUserFromFirestore(String uid) async {
    try {
      await _firestore.collection(usersCollection).doc(uid).delete();
      print('User with UID: $uid deleted from Firestore');
    } catch (e) {
      print('Error deleting user from Firestore: $e');
      rethrow;
    }
  }

  // Hàm để cập nhật thông tin người dùng theo UID
  Future<void> updateUserInFirestore(String uid, Map<String, dynamic> updateData) async {
    try {
      await _firestore.collection(usersCollection).doc(uid).update(updateData);
      print('User with UID: $uid updated in Firestore with data: $updateData');
    } catch (e) {
      print('Error updating user in Firestore: $e');
      rethrow;
    }
  }
}

