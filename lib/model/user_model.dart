class User {
  final String? uid;
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String role; // Ví dụ: 'patient', 'doctor', 'admin'
  final DateTime? createdAt;

  User( {
    this.uid,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.role,
    this.createdAt,
  });

  // Factory method để tạo User object từ Map (ví dụ: từ Firestore)
  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    return User(
      uid: documentId,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      role: data['role'] ?? 'patient', // Giá trị mặc định nếu không có
      createdAt: data['createdAt'] != null ? (data['createdAt'] as dynamic).toDate() : null,
    );
  }

  // Method để chuyển User object thành Map để lưu trữ (ví dụ: lên Firestore)
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password':password,
      'role': role,
      'createdAt': createdAt,
    };
  }
}