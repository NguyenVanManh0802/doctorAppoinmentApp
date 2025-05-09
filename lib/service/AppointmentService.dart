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
      medical_examination: false,
    );
    return await _appointmentRepository.makeAppointment(appointment);
  }
  Future<List<Map<String, dynamic>>> getPendingAppointmentsForDoctor(String? doctorId) async {
    return await _appointmentRepository.fetchPendingAppointmentsForDoctor(doctorId);
  }

  Future<List<Map<String, dynamic>>> getPatientHasStateIsTrue(String? doctorId) async {
    return await _appointmentRepository.fetchScheduleAppointmentsForDoctor(doctorId);
  }

  //lấy dữ liệu theo appointmentId
  Future<Map<String, dynamic>?> getAppointmentDetails(String appointmentId) async {
    return await _appointmentRepository.fetchAppointmentDetails(appointmentId);
  }

  // Hàm này gọi repository để cập nhật trạng thái lịch hẹn
  Future<void> updateAppointmentState(String appointmentId) async {
    await _appointmentRepository.updateAppointmentState(appointmentId);
  }

  // Hàm này gọi repository để xóa lịch hẹn
  Future<void> deleteAppointment(String appointmentId) async {
    await _appointmentRepository.deleteAppointment(appointmentId);
  }

  Future<void> updateMedicalExaminationStatus(String appointmentId, bool isExamined) async {
    await _appointmentRepository.updateMedicalExaminationStatus(appointmentId, isExamined);
  }
  // Hàm lấy tất cả appointment theo ngày được chọn
  Future<List<Map<String, dynamic>>> getAppointmentsByDate(DateTime selectedDate) async {
    return await _appointmentRepository.fetchAppointmentsByDate(selectedDate);
  }

}