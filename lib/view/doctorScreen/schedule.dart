import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:intl/intl.dart'; // Import thư viện intl để định dạng ngày giờ

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  // Dữ liệu mẫu cho lịch khám (thay thế bằng dữ liệu thực tế của bạn)
  final List<Appointment> _appointments = [
    Appointment(
      patientName: 'Nguyễn Văn A',
      appointmentTime: DateTime(2025, 4, 20, 10, 0),
      isCompleted: true,
    ),
    Appointment(
      patientName: 'Trần Thị B',
      appointmentTime: DateTime(2025, 4, 20, 11, 30),
      isCompleted: false,
    ),
    Appointment(
      patientName: 'Lê Công C',
      appointmentTime: DateTime(2025, 4, 21, 9, 0),
      isCompleted: false,
    ),
    Appointment(
      patientName: 'Phạm Thu D',
      appointmentTime: DateTime(2025, 4, 21, 14, 0),
      isCompleted: true,
    ),
    Appointment(
      patientName: 'Hoàng Minh E',
      appointmentTime: DateTime(2025, 4, 22, 16, 30),
      isCompleted: false,
    ),
    // Thêm các lịch hẹn khác vào đây
  ];

  // Hàm để cập nhật trạng thái hoàn thành của lịch hẹn
  void _toggleAppointmentStatus(int index) {
    setState(() {
      _appointments[index].isCompleted = !_appointments[index].isCompleted;
    });
    // Trong ứng dụng thực tế, bạn có thể gọi API để cập nhật trạng thái trên server/database
    print('Lịch hẹn của ${_appointments[index].patientName} đã được chuyển sang trạng thái ${_appointments[index].isCompleted ? 'hoàn thành' : 'chưa hoàn thành'}');
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
      body: _appointments.isEmpty
          ? Center(
        child: Text(
          'Không có lịch hẹn nào.',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: _appointments.length,
        itemBuilder: (context, index) {
          final appointment = _appointments[index];
          return InkWell( // Sử dụng InkWell để có hiệu ứng khi nhấn
            onTap: () {
              _toggleAppointmentStatus(index); // Gọi hàm cập nhật trạng thái mà không cần kiểm tra trạng thái hiện tại
            },
            child: Card(
              margin:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.patientName,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Thời gian: ${DateFormat('HH:mm - dd/MM/yyyy').format(appointment.appointmentTime)}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildStatusIcon(appointment.isCompleted),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  // Widget hiển thị icon trạng thái khám
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

// Model đơn giản cho một lịch hẹn
class Appointment {
  final String patientName;
  final DateTime appointmentTime;
  bool isCompleted; // Thay đổi từ final sang có thể thay đổi

  Appointment({
    required this.patientName,
    required this.appointmentTime,
    this.isCompleted = false, // Giá trị mặc định là false (chưa hoàn thành)
  });
}