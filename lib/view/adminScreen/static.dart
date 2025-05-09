import 'package:doctor_app/controller/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Statics extends StatefulWidget {
  const Statics({super.key});

  @override
  State<Statics> createState() => _StaticsState();
}

class _StaticsState extends State<Statics> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final AuthController _authController = Get.find();
  final appointmentsForSelectedDate = <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now(); // Initialize with today's date
    _loadAppointmentsForSelectedDate(_selectedDay!);
  }

  Future<void> _loadAppointmentsForSelectedDate(DateTime date) async {
    try {
      await _authController.fetchAppointmentsForSelectedDate(date );
      appointmentsForSelectedDate.assignAll( _authController.appointmentsByDate);
    } catch (e) {
      print('Lỗi khi tải lịch hẹn theo ngày: $e');
      Get.snackbar('Lỗi', 'Không thể tải lịch hẹn cho ngày đã chọn.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        actions: [
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: Image.asset("assets/images/profile_img.png"),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: const Text(
                "Hi, Admin", // Assuming the user is an admin
                style: TextStyle(
                  color: Color(0xff363636),
                  fontSize: 25,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, left: 20),
              width: size.width,
              child: const Text(
                "Thống kê",
                style: TextStyle(
                  color: Color(0xff363636),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                _selectedDay != null
                    ? "Lịch hẹn ngày ${DateFormat('dd-MM-yyyy').format(_selectedDay!)}"
                    : "Chọn một ngày để xem lịch hẹn",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _loadAppointmentsForSelectedDate(selectedDay);
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(color: Colors.white),
                ),
                headerStyle: HeaderStyle(
                  formatButtonTextStyle: const TextStyle(color: Colors.white),
                  formatButtonDecoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Thống kê ngày ${DateFormat('dd-MM-yyyy').format(_selectedDay!)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (appointmentsForSelectedDate.isEmpty) {
                  return const Center(
                    child: Text("Không có thông kê nào cho ngày này."),
                  );
                }
                return ListView.builder(
                  itemCount: appointmentsForSelectedDate.length,
                  itemBuilder: (context, index) {
                    final appointment = appointmentsForSelectedDate[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ID : ${appointment['appointmentId']}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("Bác sĩ ID: ${appointment['doctorId']}"),
                            Text("Bệnh nhân ID: ${appointment['patientId']}"),
                            Text(
                                "Thời gian: ${appointment['appointmentTime']}"),
                            Text("Trạng thái: ${appointment['state'] ? 'Đã xác nhận' : 'Chờ xác nhận'}"),
                            Text("Đã khám: ${appointment['medical_examination'] ? 'Rồi' : 'Chưa'}"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}