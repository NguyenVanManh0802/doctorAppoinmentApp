import '../Repository/AppointmentRepository.dart';
import '../model/Appointment.dart';

class AppointmentService {
  final AppointmentRepository _appointmentRepository = AppointmentRepository();

  Future<bool> makeAppointment({
    required String doctorId,
    required String? patientId,
    required DateTime appointmentDate,
    required String appointmentTime,
  }) async {
    final appointment = Appointment(
      doctorId: doctorId,
      patientId: patientId,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      state: false,
    );
    return await _appointmentRepository.makeAppointment(appointment);
  }
  Future<List<Map<String, dynamic>>> getPendingAppointmentsForDoctor(String? doctorId) async {
    return await _appointmentRepository.fetchPendingAppointmentsForDoctor(doctorId);
  }
}