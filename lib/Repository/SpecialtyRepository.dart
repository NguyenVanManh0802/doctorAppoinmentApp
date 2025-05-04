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

// Bạn có thể thêm các phương thức khác như lấy một chuyên khoa theo ID, thêm, sửa, xóa chuyên khoa tại đây
}