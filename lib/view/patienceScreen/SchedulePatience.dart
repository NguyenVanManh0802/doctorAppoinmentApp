import 'package:doctor_app/controller/ScheduleController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/authController.dart';

class Schedulepatience extends StatelessWidget {
  final ScheduleController _scheduleController = Get.put(ScheduleController());

  Schedulepatience({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch Khám Của Bạn',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo, // Màu chủ đạo
        elevation: 2, // Độ nổi nhẹ
      ),
      backgroundColor: Colors.grey[100], // Nền nhạt
      body: Obx(() {
        if (_scheduleController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo)));
        } else if (_scheduleController.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
                const SizedBox(height: 16),
                Text(
                  _scheduleController.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          );
        } else if (_scheduleController.patientAppointments.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 60),
                SizedBox(height: 16),
                Text(
                  'Bạn chưa có lịch khám nào.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        } else {
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: _scheduleController.patientAppointments.length,
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final appointment = _scheduleController.patientAppointments[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ngày: ${DateFormat('dd/MM/yyyy').format(appointment.appointmentDate!)}',
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          Row(
                            children: [
                              Icon(
                                appointment.state == true ? Icons.check_circle : Icons.pending,
                                color: appointment.state == true ? Colors.green : Colors.orange,
                                size: 20.0,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                appointment.state == true ? 'Đã duyệt' : 'Đang chờ',
                                style: TextStyle(
                                  color: appointment.state == true ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          const Icon(Icons.schedule_outlined, color: Colors.grey, size: 18),
                          const SizedBox(width: 8),
                          Text('Thời gian: ${appointment.appointmentTime ?? 'Chưa xác định'}', style: const TextStyle(color: Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, color: Colors.grey, size: 18),
                          const SizedBox(width: 8),
                          FutureBuilder(
                            future: Get.find<AuthController>().fetchDoctorById(appointment.doctorId!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text('Đang tải...', style: TextStyle(color: Colors.black54));
                              } else if (snapshot.hasError) {
                                return Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent));
                              } else if (snapshot.data != null) {
                                return Text('Bác sĩ: ${snapshot.data!.fullName}', style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.indigo));
                              } else {
                                return const Text('Không tìm thấy', style: TextStyle(color: Colors.black54));
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}