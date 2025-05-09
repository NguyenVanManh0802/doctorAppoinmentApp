import 'package:doctor_app/model/Specialty.dart';
import 'package:get/get.dart'; // Nếu bạn đang sử dụng GetX cho quản lý state
import '../service/SpecialtyService.dart';

class SpecialtyController extends GetxController {
  final SpecialtyService _specialtyService = SpecialtyService();
  final RxList<Specialty> specialties = <Specialty>[].obs; // Sử dụng RxList của GetX để theo dõi sự thay đổi
  final RxString specialtyName = ''.obs; // Để lưu trữ tên chuyên khoa của bác sĩ
  // Lấy tất cả các chuyên khoa và cập nhật RxList (đã có)
  Future<void> fetchAllSpecialties() async {
    try {
      _specialtyService.getAllSpecialties().listen((fetchedSpecialties) {
        specialties.value = fetchedSpecialties;
      }, onError: (error) {
        print('Lỗi stream: $error');
        // Xử lý lỗi stream tại đây
      }, onDone: () {
        print('Stream đã đóng');
      });
    } catch (e) {
      print('Lỗi khi lấy dữ liệu chuyên khoa: $e');
      // Xử lý lỗi tại đây, ví dụ: hiển thị thông báo lỗi cho người dùng
    }
  }

  // Lấy một chuyên khoa theo ID và trả về
  Future<Specialty?> getSpecialtyById(String specialtyId) async {
    try {
      final specialty = await _specialtyService.getSpecialtyById(specialtyId);
      return specialty;
    } catch (e) {
      print('Lỗi khi lấy chuyên khoa theo ID: $e');
      // Xử lý lỗi tại đây, ví dụ: hiển thị thông báo lỗi cho người dùng
      return null;
    }
  }
  // Lấy tên chuyên khoa theo ID bác sĩ và cập nhật biến RxString
  Future<void> loadSpecialtyNameByDoctorId(String doctorId) async {
    final name =
    await _specialtyService.getSpecialtyNameByDoctorId(doctorId);
    if (name != null) {
      specialtyName.value =
          name; // Cập nhật RxString để giao diện người dùng phản ứng
    } else {
      specialtyName.value =
      'Chưa có chuyên khoa'; // Giá trị mặc định nếu không tìm thấy
    }
  }

  // Hàm lấy SpecialtyId theo SpecialtyName
  Future<String?> getSpecialtyIdByName(String specialtyName) async {
    try {
      final specialtyId = await _specialtyService.getSpecialtyIdByName(specialtyName);
      return specialtyId;
    } catch (e) {
      print('Lỗi khi lấy SpecialtyId theo tên: $e');
      return null;
    }
  }
  // Hàm thêm bác sĩ vào một chuyên khoa
  Future<void> addDoctorToSpecialty(String specialtyId, String doctorId) async {
    try {
      await _specialtyService.addDoctorIdToSpecialty(specialtyId, doctorId);
      // Có thể thêm logic cập nhật UI sau khi thêm thành công
    } catch (e) {
      print('Lỗi khi thêm bác sĩ vào chuyên khoa: $e');
      // Xử lý lỗi tại đây, ví dụ: hiển thị thông báo lỗi cho người dùng
    }
  }

  // Hàm xóa bác sĩ khỏi một chuyên khoa
  Future<void> removeDoctorFromSpecialty(String specialtyId, String doctorId) async {
    try {
      await _specialtyService.removeDoctorIdFromSpecialty(specialtyId, doctorId);
      // Có thể thêm logic cập nhật UI sau khi xóa thành công
    } catch (e) {
      print('Lỗi khi xóa bác sĩ khỏi chuyên khoa: $e');
      // Xử lý lỗi tại đây
    }
  }


}