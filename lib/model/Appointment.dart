import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import thư viện intl

class Appointment {
  final String? doctorId;
  final String? patientId;
  final DateTime? appointmentDate;
  final String? appointmentTime;
  final DateTime? createdAt;
  bool state=false;

  Appointment({
    this.doctorId,
    this.patientId,
    this.appointmentDate,
    this.appointmentTime,
    this.createdAt,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'appointmentDate': appointmentDate != null
          ? DateFormat('yyyy-MM-dd').format(appointmentDate!) // Format chỉ lấy ngày
          : null,
      'appointmentTime': appointmentTime,
      'createdAt': createdAt ?? DateTime.now(),
      'state' :state ?? false
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    print('Data from Firestore: $map'); // Log dữ liệu Map
    return Appointment(
      doctorId: map['doctorId'],
      patientId: map['patientId'],
      appointmentDate: map['appointmentDate'] != null
          ? DateTime.parse(map['appointmentDate'])
          : null,
      appointmentTime: map['appointmentTime'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : null,
      state:map['state'],
    );
  }
}