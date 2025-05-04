import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/Appointment.dart';

class ScheduleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String appointmentsCollection = 'appointments';

  Future<List<Appointment>> getPatientAppointments(String patientId) async {
    try {
      print('Querying Firestore with Patient ID: $patientId'); // Log ID dùng trong truy vấn
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(appointmentsCollection)
          .where('patientId', isEqualTo: patientId)
          .orderBy('appointmentDate')
          .get();

      final List<Appointment> appointments = snapshot.docs
          .map((doc) => Appointment.fromMap(doc.data()))
          .toList();

      print('Appointments fetched from Firestore: $appointments'); // Log dữ liệu trả về
      return appointments;
    } catch (e) {
      print('Lỗi khi tải lịch hẹn của bệnh nhân: $e');
      return [];
    }
  }

}