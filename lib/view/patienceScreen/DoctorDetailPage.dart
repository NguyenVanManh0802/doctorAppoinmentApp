import 'package:doctor_app/view/patienceScreen/patienceScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/SpecialtyController.dart';
import '../../controller/authController.dart';
import '../../model/Specialty.dart';
import '../../model/user_model.dart'; // Import User model
import 'homepage.dart';

class Doctordetailpage extends StatefulWidget {
  final String doctorId;
  final String SpecialId;
  const Doctordetailpage({super.key, required this.doctorId, required this.SpecialId});

  @override
  State<Doctordetailpage> createState() => _DoctordetailpageState();
}

class _DoctordetailpageState extends State<Doctordetailpage> {
  DateTime? _selectedDate = DateTime.now();
  String? _selectedMorningTime;
  String? _selectedEveningTime;

  final AuthController _authController = Get.find();
  final SpecialtyController _specialtyController = Get.put(SpecialtyController());
  late Future<Specialty?> _specialtyFuture;
  Future<User?>? _doctorFuture;

  @override
  void initState() {
    super.initState();
    _doctorFuture = _authController.fetchDoctorById(widget.doctorId);
    _specialtyFuture = _specialtyController.getSpecialtyById(widget.SpecialId);
  }

  Future<void> _selectDateDialog(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectMorningTime(String time) {
    setState(() {
      if (_selectedMorningTime == time) {
        _selectedMorningTime = null;
      } else {
        _selectedMorningTime = time;
      }
    });
  }

  void _selectEveningTime(String time) {
    setState(() {
      if (_selectedEveningTime == time) {
        _selectedEveningTime = null;
      } else {
        _selectedEveningTime = time;
      }
    });
  }

  void _confirmAppointment() async {
    if (_selectedDate == null) {
      Get.snackbar("Lỗi", "Vui lòng chọn ngày khám");
      return;
    }

    String? selectedTime;
    if (_selectedMorningTime != null) {
      selectedTime = _selectedMorningTime;
    } else if (_selectedEveningTime != null) {
      selectedTime = _selectedEveningTime;
    }

    if (selectedTime == null) {
      Get.snackbar("Lỗi", "Vui lòng chọn thời gian khám");
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận đặt lịch'),
        content: Text(
            'Bạn có chắc chắn muốn đặt lịch khám vào ngày ${DateFormat('dd/MM/yyyy').format(_selectedDate!)} lúc $selectedTime?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Đóng hộp thoại xác nhận
            },
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Đóng hộp thoại xác nhận
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              bool success = await _authController.makeAppointment(
                doctorId: widget.doctorId,
                appointmentDate: _selectedDate!,
                appointmentTime: selectedTime ?? "",
              );

              Get.back(); // Đóng loading indicator

              if (success) {
                Get.snackbar("Thành công", "Đặt lịch khám thành công!");
                // Có thể điều hướng đến trang xác nhận hoặc lịch sử khám ở đây
                // Get.off(() => AppointmentConfirmationPage());
              } else {
                Get.snackbar("Lỗi", "Đã có lỗi xảy ra khi đặt lịch khám. Vui lòng thử lại sau.");
              }
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff053F5E),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.offAll(() => patienceScreen());
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xff053F5E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 30, bottom: 30),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Image.asset(
                        "assets/images/dr_1.png", // Cần thay thế bằng URL thực tế
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<User?>(
                            future: _doctorFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator(color: Colors.white);
                              } else if (snapshot.hasError) {
                                return Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.white));
                              } else if (snapshot.data != null) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  child: Text(
                                    snapshot.data!.fullName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                );
                              } else {
                                return const Text('Không tìm thấy bác sĩ', style: TextStyle(color: Colors.white));
                              }
                            },
                          ),
                          FutureBuilder<Specialty?>(
                            future: _specialtyFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator(color: Colors.white);
                              } else if (snapshot.hasError) {
                                return Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.white));
                              } else if (snapshot.data != null) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    snapshot.data!.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                );
                              } else {
                                return const Text('Không tìm thấy chuyên khoa', style: TextStyle(color: Colors.white));
                              }
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: const Text(
                              'Rating: 4.4', // Cần thay thế bằng rating thực tế
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectDateDialog(context),
              child: Container(
                margin: const EdgeInsets.only(left: 20, top: 30, right: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Chọn ngày khám'
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, top: 30),
              child: const Text(
                'Morning',
                style: TextStyle(
                  color: Color(0xff363636),
                  fontSize: 25,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.7,
                children: [
                  doctorTimingsData("08:00 AM", _selectedMorningTime == "08:00 AM", () => _selectMorningTime("08:00 AM")),
                  doctorTimingsData("08:30 AM", _selectedMorningTime == "08:30 AM", () => _selectMorningTime("08:30 AM")),
                  doctorTimingsData("09:00 AM", _selectedMorningTime == "09:00 AM", () => _selectMorningTime("09:00 AM")),
                  doctorTimingsData("09:30 AM", _selectedMorningTime == "09:30 AM", () => _selectMorningTime("09:30 AM")),
                  doctorTimingsData("10:00 AM", _selectedMorningTime == "10:00 AM", () => _selectMorningTime("10:00 AM")),
                  doctorTimingsData("10:30 AM", _selectedMorningTime == "10:30 AM", () => _selectMorningTime("10:30 AM")),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 25, top: 30),
              child: const Text(
                'Evening',
                style: TextStyle(
                  color: Color(0xff363636),
                  fontSize: 25,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.6,
                children: [
                  doctorTimingsData("05:00 PM", _selectedEveningTime == "05:00 PM", () => _selectEveningTime("05:00 PM")),
                  doctorTimingsData("05:30 PM", _selectedEveningTime == "05:30 PM", () => _selectEveningTime("05:30 PM")),
                  doctorTimingsData("06:00 PM", _selectedEveningTime == "06:00 PM", () => _selectEveningTime("06:00 PM")),
                  doctorTimingsData("06:30 PM", _selectedEveningTime == "06:30 PM", () => _selectEveningTime("06:30 PM")),
                  doctorTimingsData("07:00 PM", _selectedEveningTime == "07:00 PM", () => _selectEveningTime("07:00 PM")),
                  doctorTimingsData("07:30 PM", _selectedEveningTime == "07:30 PM", () => _selectEveningTime("07:30 PM")),
                ],
              ),
            ),
            GestureDetector(
              onTap: _confirmAppointment, // Gọi hàm xác nhận thay vì đặt lịch trực tiếp
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 54,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xff107163),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x17000000),
                      offset: Offset(0, 15),
                      blurRadius: 15,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Text(
                  'Make An Appointment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget doctorTimingsData(String time, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 20, top: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff107163) : const Color(0xffEEEEEE),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 2),
              child: Icon(
                Icons.access_time,
                color: isSelected ? Colors.white : Colors.black,
                size: 18,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 2),
              child: Text(
                time,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 17,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}