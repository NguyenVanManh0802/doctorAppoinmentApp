import '../Repository/SpecialtyRepository.dart';
import '../model/Specialty.dart';

class SpecialtyService {
  final SpecialtyRepository _specialtyRepository = SpecialtyRepository();

  // Lấy stream của tất cả các chuyên khoa (đã có)
  Stream<List<Specialty>> getAllSpecialties() {
    return _specialtyRepository.getAllSpecialties();
  }

  // Lấy một chuyên khoa theo ID
  Future<Specialty?> getSpecialtyById(String specialtyId) async {
    return await _specialtyRepository.getSpecialtyById(specialtyId);
  }

// Bạn có thể thêm các phương thức nghiệp vụ khác liên quan đến chuyên khoa tại đây
}