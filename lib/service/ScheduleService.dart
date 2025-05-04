import 'package:firebase_auth/firebase_auth.dart';
import '../../model/Appointment.dart';
import '../Repository/ScheduleRepository.dart'; // Đảm bảo bạn đã tạo ScheduleRepository

class ScheduleService {
  final ScheduleRepository _scheduleRepository = ScheduleRepository();

  String? getCurrentPatientId() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    print('Current Patient ID: $userId'); // Log ID người dùng hiện tại
    return userId;
  }

  Future<List<Appointment>> getPatientAppointments(String patientId) async {
    print(
        'Fetching appointments for Patient ID: $patientId'); // Log ID được truyền để truy vấn
    return await _scheduleRepository.getPatientAppointments(patientId);
  }
}