class Specialty {
  String? specialtyId;
  String name; // Tên chuyên khoa (ví dụ: Răng Hàm Mặt, Tim mạch)
  List<String> doctorIds; // Danh sách ID của các bác sĩ thuộc chuyên khoa này
  String? imageUrl; // Đường dẫn hoặc URL của ảnh chuyên khoa

  Specialty({this.specialtyId, required this.name, required this.doctorIds, this.imageUrl});

  // Phương thức để thêm ID bác sĩ vào danh sách
  void addDoctorId(String doctorId) {
    doctorIds.add(doctorId);
  }

  // Phương thức để xóa ID bác sĩ khỏi danh sách
  void removeDoctorId(String doctorId) {
    doctorIds.remove(doctorId);
  }

  // Chuyển đối tượng Specialty thành Map để lưu vào Firestore (nếu cần)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'doctorIds': doctorIds,
      'imageUrl': imageUrl,
    };
  }

  // Tạo đối tượng Specialty từ Map lấy từ Firestore (nếu cần)
  factory Specialty.fromJson(Map<String, dynamic> json, String id) {
    return Specialty(
      specialtyId: id,
      name: json['name'] ?? '',
      doctorIds: List<String>.from(json['doctorIds'] ?? []),
      imageUrl: json['imageUrl'],
    );
  }
}