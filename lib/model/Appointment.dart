import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Appointment {
  String? appointmentId; // Make AppointmentId nullable
  final String? doctorId;
  final String? patientId;
  final DateTime? appointmentDate;
  final String? appointmentTime;
  final DateTime? createdAt;
  bool state = false;
  bool medical_examination =false;

  Appointment({
    this.appointmentId, // Add this to the constructor
    this.doctorId,
    this.patientId,
    this.appointmentDate,
    this.appointmentTime,
    this.createdAt,
    this.medical_examination=false,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointmentId':appointmentId,
      'doctorId': doctorId,
      'patientId': patientId,
      'appointmentDate': appointmentDate != null
          ? DateFormat('yyyy-MM-dd').format(appointmentDate!)
          : null,
      'appointmentTime': appointmentTime,
      'createdAt': createdAt ?? DateTime.now(),
      'state': state,
      'medical_examination' :medical_examination,
    };
  }

  factory Appointment.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      // Handle the case where the document doesn't exist.
      return Appointment(state: false,medical_examination:false); // Or throw an exception, or return null, depending on your error handling needs.
    }
    return Appointment(
      appointmentId: data['appointmentId'], // Get the ID from the DocumentSnapshot.
      doctorId: data['doctorId'],
      patientId: data['patientId'],
      appointmentDate: data['appointmentDate'] != null
          ? DateTime.parse(data['appointmentDate'])
          : null,
      appointmentTime: data['appointmentTime'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      state: data['state'] ?? false,
      medical_examination: data['medical_examination'] ?? false,
    );
  }
}