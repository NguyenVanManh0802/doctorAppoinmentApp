import 'package:doctor_app/service/AuthService.dart';
import 'package:doctor_app/view/patienceScreen/patienceScreen.dart';
import 'package:firebase_auth/firebase_auth.dart'as firebase_auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/authController.dart';
import '../../model/Specialty.dart';
import '../../model/user_model.dart';
import '../../controller/SpecialtyController.dart'; // Import SpecialtyController

class DoctorDetail extends StatefulWidget {
  const DoctorDetail({
    super.key,
    this.doctorId, // Make doctorId nullable
  });

  final String? doctorId;

  @override
  State<DoctorDetail> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail> {
  // Biến trạng thái cho khoa đã chọn
  String? _selectedSpecialtyId; // Lưu ID của chuyên khoa đã chọn
  final AuthController _authController = Get.find();
  final SpecialtyController _specialtyController = Get.find();
  // Biến trạng thái để lưu trữ thông tin bác sĩ
  User? _doctor;
  bool _isLoading = true; // Track loading state
  String _errorMessage = ''; // Track any error message
  List<Specialty> _specialtiesList = []; // Danh sách tất cả các chuyên khoa

  @override
  void initState() {
    super.initState();
    _loadDoctorDetails();
    _loadAllSpecialties(); // Load all specialties for the dropdown
  }

  // Hàm để tải thông tin bác sĩ
  Future<void> _loadDoctorDetails() async {
    if (widget.doctorId == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Doctor ID is null.';
      });
      return;
    }

    try {
      _doctor = await _authController.fetchUserByUid(widget.doctorId!);
      if (_doctor == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Doctor not found.';
        });
        return;
      }
      // Load specialty name
      await _specialtyController.loadSpecialtyNameByDoctorId(widget.doctorId!);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load doctor details: $e';
      });
      return;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Hàm để tải tất cả các chuyên khoa
  Future<void> _loadAllSpecialties() async {
    try {
      await _specialtyController.fetchAllSpecialties();
      _specialtiesList = _specialtyController.specialties.toList();
    } catch (e) {
      print('Lỗi khi tải danh sách chuyên khoa: $e');
      // Xử lý lỗi nếu cần
    }
  }

  // Hàm để cập nhật khoa cho bác sĩ
  Future<void> _updateDoctorSpecialty() async {
    if (widget.doctorId == null || _selectedSpecialtyId == null) {
      // Hiển thị thông báo lỗi nếu doctorId hoặc specialtyId là null
      Get.snackbar(
        'Lỗi',
        'Không thể cập nhật khoa. Thiếu thông tin.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn cập nhật chuyên khoa cho bác sĩ này?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Đóng dialog
              try {
                // Lấy ID của chuyên khoa hiện tại
                String? currentSpecialtyId = await _specialtyController.getSpecialtyIdByName(_specialtyController.specialtyName.value);

                if (currentSpecialtyId != null) {
                  // Nếu bác sĩ đã có chuyên khoa, hãy xóa doctorId khỏi chuyên khoa đó trước
                  await _specialtyController.removeDoctorFromSpecialty(currentSpecialtyId, widget.doctorId!);
                }

                // Thêm doctorId vào chuyên khoa đã chọn
                await _specialtyController.addDoctorToSpecialty(_selectedSpecialtyId!, widget.doctorId!);
                await _authController.updateDoctorSpecialty(widget.doctorId!, _selectedSpecialtyId!);

                // Cập nhật lại tên chuyên khoa hiển thị trên UI
                await _specialtyController.loadSpecialtyNameByDoctorId(widget.doctorId!);

                Get.snackbar(
                  'Thành công',
                  'Đã cập nhật khoa cho bác sĩ.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                print('Lỗi khi cập nhật khoa cho bác sĩ: $e');
                Get.snackbar(
                  'Lỗi',
                  'Không thể cập nhật khoa: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }

  // Hàm để xóa bác sĩ
  Future<void> _deleteDoctor() async {
    if (widget.doctorId == null) {
      Get.snackbar(
        'Lỗi',
        'Không thể xóa bác sĩ. Thiếu ID.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận'),
        content: Text('Bạn có chắc chắn muốn xóa bác sĩ "${_doctor?.fullName ?? "N/A"}" này?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Đóng dialog
              try {
                // Lấy ID của chuyên khoa hiện tại của bác sĩ
                String? currentSpecialtyId = await _specialtyController.getSpecialtyIdByName(_specialtyController.specialtyName.value);

                if (currentSpecialtyId != null) {
                  // Xóa bác sĩ khỏi danh sách bác sĩ của chuyên khoa hiện tại
                  await _specialtyController.removeDoctorFromSpecialty(currentSpecialtyId, widget.doctorId!);
                }

                // Xóa thông tin người dùng của bác sĩ
                await _authController.deleteUserByUid(widget.doctorId!);

                Get.snackbar(
                  'Thành công',
                  'Đã xóa bác sĩ thành công.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
                Navigator.pop(context); // Quay lại trang trước sau khi xóa thành công
              } catch (e) {
                print('Lỗi khi xóa bác sĩ: $e');
                Get.snackbar(
                  'Lỗi',
                  'Không thể xóa bác sĩ: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff053F5E),
        centerTitle: true,
        title: Text(
          'Chi Tiết Bác Sĩ',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
          child: Text(_errorMessage,
              style: const TextStyle(color: Colors.red)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage(
                        "assets/images/dr_1.png"), // Use a constant image.
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: true
                            ? Colors.green
                            : Colors
                            .orange, // Use a boolean.  You might want to get this from the doctor data.
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                _doctor?.fullName ?? "N/A",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Obx(() {
                return Text(
                  _specialtyController.specialtyName.value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                );
              }),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                "Phone: ${_doctor?.phoneNumber ?? "N/A"}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 20),
                SizedBox(width: 5),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              'Lựa chọn khoa',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            // DropdownButtonFormField to select specialty.
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
              value: _specialtiesList.firstWhereOrNull((specialty) => specialty.name == _specialtyController.specialtyName.value)?.specialtyId,
              items: _specialtiesList.map((Specialty specialty) {
                return DropdownMenuItem<String>(
                  value: specialty.specialtyId,
                  child: Text(
                    specialty.name,
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSpecialtyId = newValue;
                  print('Selected specialty ID: $_selectedSpecialtyId');
                });
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Hiển thị dialog xác nhận trước khi cập nhật
                    await _showConfirmationDialog(
                      title: 'Xác nhận',
                      content: 'Bạn có chắc chắn muốn cập nhật chuyên khoa cho bác sĩ này?',
                      onConfirm: _updateDoctorSpecialty,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Hiển thị dialog xác nhận trước khi xóa
                    await _showConfirmationDialog(
                      title: 'Xác nhận',
                      content: 'Bạn có chắc chắn muốn xóa bác sĩ "${_doctor?.fullName ?? "N/A"}" này?',
                      onConfirm: _deleteDoctor,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Delete',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Hàm hiển thị dialog xác nhận
  Future<void> _showConfirmationDialog({
    required String title,
    required String content,
    required Future<void> Function() onConfirm,
  }) async {
    return Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Đóng dialog
              await onConfirm();
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}