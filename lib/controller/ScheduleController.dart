import 'package:get/get.dart';
import '../../model/Appointment.dart';
import '../../service/ScheduleService.dart'; // Đảm bảo bạn đã tạo ScheduleService

class ScheduleController extends GetxController {
  final ScheduleService _scheduleService = ScheduleService();
  RxList<Appointment> patientAppointments = <Appointment>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatientAppointments();
  }

  Future<void> fetchPatientAppointments() async {
    isLoading(true);
    errorMessage('');
    try {
      final String? patientId = _scheduleService.getCurrentPatientId();
      if (patientId != null) {
        final List<Appointment> appointments =
        await _scheduleService.getPatientAppointments(patientId);
        patientAppointments.assignAll(appointments);
      } else {
        errorMessage('Không tìm thấy thông tin người dùng.');
      }
    } catch (e) {
      errorMessage('Đã xảy ra lỗi khi tải lịch hẹn: $e');
    } finally {
      isLoading(false);
    }
  }


  //delete schedule

}