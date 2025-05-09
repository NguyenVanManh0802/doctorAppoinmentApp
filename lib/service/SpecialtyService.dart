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
  Future<String?> getSpecialtyNameByDoctorId(String doctorId) async {
    return await _specialtyRepository.getSpecialtyNameByDoctorId(doctorId);
  }
  // Hàm thêm bác sĩ vào danh sách bác sĩ của một chuyên khoa
  Future<void> addDoctorIdToSpecialty(String specialtyId, String doctorId) async {
    await _specialtyRepository.addDoctorIdToSpecialty(specialtyId, doctorId);
  }

  // Hàm xóa bác sĩ khỏi danh sách bác sĩ của một chuyên khoa
  Future<void> removeDoctorIdFromSpecialty(String specialtyId, String doctorId) async {
    await _specialtyRepository.removeDoctorIdFromSpecialty(specialtyId, doctorId);
  }

  // Hàm cập nhật toàn bộ danh sách bác sĩ theo SpecialtyId (ghi đè)
  Future<void> updateDoctorIds(String specialtyId, List<String> doctorIds) async {
    await _specialtyRepository.updateDoctorIds(specialtyId, doctorIds);
  }

  // Hàm lấy SpecialtyId theo SpecialtyName
  Future<String?> getSpecialtyIdByName(String specialtyName) async {
    return await _specialtyRepository.getSpecialtyIdByName(specialtyName);
  }
}