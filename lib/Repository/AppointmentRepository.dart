import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/Appointment.dart';

class AppointmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String appointmentsCollection = 'appointments';

  Future<bool> makeAppointment(Appointment appointment) async {
    try {
      DocumentReference newAppointmentRef=await _firestore.collection(appointmentsCollection).add(appointment.toMap());
      String appointmentId = newAppointmentRef.id;
      await newAppointmentRef.update({'appointmentId': appointmentId});
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
          'appointmentId': doc.id,
          'doctorId':data['doctorId'],
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


  Future<List<Map<String, dynamic>>> fetchScheduleAppointmentsForDoctor(String? doctorId) async {
    try {
      if (doctorId == null) {
        return [];
      }
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(appointmentsCollection)
          .where('doctorId', isEqualTo: doctorId)
          .where('state', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'appointmentId': doc.id,
          'doctorId':data['doctorId'],
          'patientId': data['patientId'],
          'appointmentDate': data['appointmentDate'],
          'appointmentTime': data['appointmentTime'],
          'medical_examination': data['medical_examination'],
        };
      }).toList();
    } catch (e) {
      print('Lỗi khi tải lịch hẹn từ Repository: $e');
      return [];
    }
  }
  //lấy dl theo appointmentId
  Future<Map<String, dynamic>?> fetchAppointmentDetails(String appointmentId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection(appointmentsCollection).doc(appointmentId).get();
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data()!;
      }
      return null;
    } catch (e) {
      print('Lỗi khi tải chi tiết lịch hẹn từ Repository: $e');
      return null;
    }
  }


  Future<void> updateAppointmentState(String appointmentId) async {
    try {
      await _firestore.collection(appointmentsCollection).doc(appointmentId).update({'state': true});
      print('Appointment state updated to accepted for ID: $appointmentId');
    } catch (e) {
      print('Error updating appointment state: $e');
      rethrow; // Ném lại lỗi để controller xử lý
    }
  }

  // Hàm từ chối lịch hẹn và xóa nó
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await _firestore.collection(appointmentsCollection).doc(appointmentId).delete();
      print('Appointment deleted for ID: $appointmentId');
    } catch (e) {
      print('Error deleting appointment: $e');
      rethrow; // Ném lại lỗi để controller xử lý
    }
  }

}