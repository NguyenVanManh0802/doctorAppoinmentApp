import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/authController.dart';
import '../../model/user_model.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final AuthController _authController = Get.find();

  @override
  void initState() {
    super.initState();
    _authController.fetchScheduleAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch Khám Bệnh',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xff053F5E),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_authController.getPatientBySchedule.isEmpty) {
          return Center(
            child: Text(
              'Không có lịch hẹn nào.',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: _authController.getPatientBySchedule.length,
            itemBuilder: (context, index) {
              final appointment = _authController.getPatientBySchedule[index];
              return FutureBuilder<User?>(
                future: _authController.fetchUserByUid(appointment['patientId']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Lỗi: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final patientName = snapshot.data!.fullName;
                    String appointmentTime = appointment['appointmentTime'];
                    String appointmentDate = appointment['appointmentDate'];
                    bool isCompleted = appointment['medical_examination'] ?? false;
                    String appointmentId = appointment['appointmentId'];

                    return InkWell(
                      onTap: isCompleted
                          ? null
                          : () async {
                        // Cập nhật trạng thái medical_examination khi bác sĩ nhấn vào
                        await _authController.markAppointmentAsExamined(appointmentId);
                        // Tải lại danh sách lịch hẹn để cập nhật UI
                        await _authController.fetchScheduleAppointments();
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patientName,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Ngày: $appointmentDate',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Giờ: $appointmentTime',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              _buildStatusIcon(isCompleted),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Text(
                        'Không tìm thấy thông tin bệnh nhân');
                  }
                },
              );
            },
          );
        }
      }),
    );
  }

  Widget _buildStatusIcon(bool isCompleted) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        isCompleted ? Icons.check_circle : Icons.pending,
        color: isCompleted ? Colors.green : Colors.orange,
      ),
    );
  }
}