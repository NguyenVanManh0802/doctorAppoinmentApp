import 'package:doctor_app/model/Specialty.dart';
import 'package:get/get.dart'; // Nếu bạn đang sử dụng GetX cho quản lý state
import '../service/SpecialtyService.dart';

class SpecialtyController extends GetxController {
  final SpecialtyService _specialtyService = SpecialtyService();
  final RxList<Specialty> specialties = <Specialty>[].obs; // Sử dụng RxList của GetX để theo dõi sự thay đổi

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

// Bạn có thể thêm các phương thức khác để xử lý các hành động liên quan đến chuyên khoa từ View
}