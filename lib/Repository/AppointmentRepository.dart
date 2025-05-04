import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/Appointment.dart';

class AppointmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String appointmentsCollection = 'appointments';

  Future<bool> makeAppointment(Appointment appointment) async {
    try {
      await _firestore.collection(appointmentsCollection).add(appointment.toMap());
      print('Appointment saved to Firestore');
      return true;
    } catch (e) {
      print('Error saving appointment to Firestore: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPendingAppointmentsForDoctor(String? doctorId) async {
    try {
      if (doctorId == null) {
        return [];
      }
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(appointmentsCollection)
          .where('doctorId', isEqualTo: doctorId)
          .where('state', isEqualTo: false)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'patientId': data['patientId'],
          'appointmentDate': data['appointmentDate'],
          'appointmentTime': data['appointmentTime'],
        };
      }).toList();
    } catch (e) {
      print('Lỗi khi tải lịch hẹn từ Repository: $e');
      return [];
    }
  }
}