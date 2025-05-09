import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/Specialty.dart';

class SpecialtyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String specialtiesCollection = 'Specialty'; // Tên collection là "Specialty"

  // Lấy tất cả các chuyên khoa từ Firestore (đã có)
  Stream<List<Specialty>> getAllSpecialties() {
    return _firestore.collection(specialtiesCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Specialty.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Lấy một chuyên khoa theo ID từ Firestore
  Future<Specialty?> getSpecialtyById(String specialtyId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await _firestore.collection(specialtiesCollection).doc(specialtyId).get();

      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        return Specialty.fromJson(documentSnapshot.data()!, documentSnapshot.id);
      } else {
        return null; // Trả về null nếu không tìm thấy chuyên khoa với ID đó
      }
    } catch (e) {
      print('Lỗi khi lấy chuyên khoa theo ID: $e');
      // Xử lý lỗi tại đây, có thể trả về null hoặc throw exception tùy theo yêu cầu
      return null;
    }
  }
  Future<String?> getSpecialtyNameByDoctorId(String doctorId) async {
    try {
      // Lấy tất cả các chuyên khoa
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection(specialtiesCollection).get();

      // Duyệt qua từng chuyên khoa
      for (final doc in snapshot.docs) {
        final specialty = Specialty.fromJson(doc.data(), doc.id);
        // Kiểm tra xem ID bác sĩ có trong danh sách doctorIds của chuyên khoa không
        if (specialty.doctorIds.contains(doctorId)) {
          return specialty.name; // Trả về tên chuyên khoa nếu tìm thấy
        }
      }
      return null; // Trả về null nếu không tìm thấy chuyên khoa nào chứa ID bác sĩ này
    } catch (e) {
      print('Lỗi khi lấy tên chuyên khoa theo ID bác sĩ: $e');
      return null; // Trả về null hoặc xử lý lỗi khác
    }
  }
  // Hàm lấy SpecialtyId theo SpecialtyName
  Future<String?> getSpecialtyIdByName(String specialtyName) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection(specialtiesCollection).where('name', isEqualTo: specialtyName).get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print('Lỗi khi lấy SpecialtyId theo tên: $e');
      return null;
    }
  }
  // Hàm thêm bác sĩ vào danh sách bác sĩ của một chuyên khoa theo SpecialtyId
  Future<void> addDoctorIdToSpecialty(String specialtyId, String doctorId) async {
    try {
      final DocumentReference<Map<String, dynamic>> specialtyRef =
      _firestore.collection(specialtiesCollection).doc(specialtyId);

      await _firestore.runTransaction((transaction) async {
        final DocumentSnapshot<Map<String, dynamic>> snapshot = await transaction.get(specialtyRef);

        if (!snapshot.exists) {
          throw Exception("Không tìm thấy chuyên khoa với ID: $specialtyId");
        }

        final List<String> currentDoctorIds = (snapshot.data()?['doctorIds'] as List<dynamic>?)?.cast<String>() ?? [];

        if (!currentDoctorIds.contains(doctorId)) {
          final List<String> updatedDoctorIds = [...currentDoctorIds, doctorId];
          transaction.update(specialtyRef, {'doctorIds': updatedDoctorIds});
          print('Đã thêm bác sĩ có ID: $doctorId vào chuyên khoa có ID: $specialtyId');
        } else {
          print('Bác sĩ có ID: $doctorId đã tồn tại trong chuyên khoa có ID: $specialtyId');
        }
      });
    } catch (e) {
      print('Lỗi khi thêm bác sĩ vào chuyên khoa: $e');
      // Xử lý lỗi tại đây
    }
  }

  // Hàm xóa bác sĩ khỏi danh sách bác sĩ của một chuyên khoa theo SpecialtyId
  Future<void> removeDoctorIdFromSpecialty(String specialtyId, String doctorId) async {
    try {
      final DocumentReference<Map<String, dynamic>> specialtyRef =
      _firestore.collection(specialtiesCollection).doc(specialtyId);

      await _firestore.runTransaction((transaction) async {
        final DocumentSnapshot<Map<String, dynamic>> snapshot = await transaction.get(specialtyRef);

        if (!snapshot.exists) {
          throw Exception("Không tìm thấy chuyên khoa với ID: $specialtyId");
        }

        final List<String> currentDoctorIds = (snapshot.data()?['doctorIds'] as List<dynamic>?)?.cast<String>() ?? [];

        if (currentDoctorIds.contains(doctorId)) {
          final List<String> updatedDoctorIds = currentDoctorIds.where((id) => id != doctorId).toList();
          transaction.update(specialtyRef, {'doctorIds': updatedDoctorIds});
          print('Đã xóa bác sĩ có ID: $doctorId khỏi chuyên khoa có ID: $specialtyId');
        } else {
          print('Không tìm thấy bác sĩ có ID: $doctorId trong chuyên khoa có ID: $specialtyId');
        }
      });
    } catch (e) {
      print('Lỗi khi xóa bác sĩ khỏi chuyên khoa: $e');
      // Xử lý lỗi tại đây
    }
  }

  // Hàm cập nhật toàn bộ danh sách bác sĩ theo SpecialtyId (ghi đè)
  Future<void> updateDoctorIds(String specialtyId, List<String> doctorIds) async {
    try {
      await _firestore.collection(specialtiesCollection).doc(specialtyId).update({'doctorIds': doctorIds});
      print('Đã cập nhật danh sách bác sĩ cho chuyên khoa có ID: $specialtyId');
    } catch (e) {
      print('Lỗi khi cập nhật danh sách bác sĩ: $e');
      // Xử lý lỗi tại đây
    }
  }
// Bạn có thể thêm các phương thức khác như lấy một chuyên khoa theo ID, thêm, sửa, xóa chuyên khoa tại đây
}