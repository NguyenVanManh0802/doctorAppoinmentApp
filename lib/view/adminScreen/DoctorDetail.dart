import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorDetail extends StatefulWidget {
  // Dữ liệu bác sĩ nhận vào (thay thế bằng model thực tế của bạn)
  final String doctorName;
  final String speciality;
  final String imageUrl;
  final double rating;
  final bool isApproved;

  const DoctorDetail({
    super.key,
    required this.doctorName,
    required this.speciality,
    required this.imageUrl,
    required this.rating,
    this.isApproved = false, // Giá trị mặc định
  });

  @override
  State<DoctorDetail> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail> {
  // Biến trạng thái cho khoa đã chọn (có thể là một dropdown hoặc radio button)
  String? _selectedSpeciality;

  @override
  void initState() {
    super.initState();
    _selectedSpeciality = widget.speciality; // Khởi tạo với khoa hiện tại
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage(widget.imageUrl),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.isApproved ? Colors.green : Colors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        widget.isApproved ? Icons.check : Icons.warning,
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
                widget.doctorName,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                widget.speciality,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 5),
                Text(
                  '${widget.rating}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
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
            // Sử dụng DropdownButton để lựa chọn khoa
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              value: _selectedSpeciality,
              items: <String>['Tim mạch', 'Xương khớp', 'Răng hàm mặt']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSpeciality = newValue;
                  // Cập nhật khoa của bác sĩ (gọi API hoặc cập nhật state quản lý danh sách bác sĩ)
                  print('Đã chọn khoa: $_selectedSpeciality');
                });
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: widget.isApproved
                      ? null
                      : () {
                    // Xử lý logic duyệt bác sĩ (gọi API hoặc cập nhật state)
                    print('Đã duyệt bác sĩ: ${widget.doctorName}');
                    // Cập nhật trạng thái UI nếu cần
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Duyệt',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: !widget.isApproved
                      ? null
                      : () {
                    // Xử lý logic từ chối bác sĩ (gọi API hoặc cập nhật state)
                    print('Đã từ chối bác sĩ: ${widget.doctorName}');
                    // Cập nhật trạng thái UI nếu cần
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Từ chối',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Xử lý logic xóa bác sĩ (gọi API hoặc cập nhật state)
                    print('Đã xóa bác sĩ: ${widget.doctorName}');
                    // Có thể điều hướng trở lại trang trước sau khi xóa
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Xóa',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}