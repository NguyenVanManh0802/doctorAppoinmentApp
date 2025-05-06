import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/user_model.dart';
import 'doctorScreen.dart';
import '../../controller/authController.dart';

class DetailPatientEnroll extends StatefulWidget {
  final String appointmentId;
  const DetailPatientEnroll({super.key, required this.appointmentId});

  @override
  State<DetailPatientEnroll> createState() => _DetailPatientEnrollState();
}

class _DetailPatientEnrollState extends State<DetailPatientEnroll> {
  final AuthController _authController = Get.find(); // Lấy instance của AuthController

  @override
  void initState() {
    super.initState();
    print('Appointment ID received: ${widget.appointmentId}');
    _authController.fetchAppointmentDetails(widget.appointmentId); // Gọi để lấy chi tiết
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff053F5E),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Get.offAll(() => const Doctorscreen());
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle notification logic
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          final appointmentData = _authController.appointmentDetails.value;

          if (appointmentData == null) {
            return const Center(child: CircularProgressIndicator()); // Hiển thị loading
          }

          final String appointmentDate = appointmentData['appointmentDate'] ;
          final String appointmentTime = appointmentData['appointmentTime'];
          final String patientId = appointmentData['patientId'] ;

          return FutureBuilder<User?>(
            future: _authController.fetchUserByUid(patientId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi tải thông tin bệnh nhân: ${snapshot.error}'));
              } else if (snapshot.data != null) {
                final patientName = snapshot.data!.fullName;
                // final patientProblem = appointmentData['problem'] ?? "N/A"; // Nếu có trường problem

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 220,
                      decoration: const BoxDecoration(
                        color: Color(0xff053F5E),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, bottom: 30, right: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                              AssetImage("assets/images/profile_img.png"), // Replace with actual patient image
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patientName,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'New Appointment',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white70,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Ho Chi Minh City', // Lấy từ thông tin bệnh nhân nếu có
                                        style: GoogleFonts.poppins(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, top: 30.0, right: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appointment Details',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow('Date', appointmentDate),
                          const SizedBox(height: 15),
                          _buildInfoRow('Time', appointmentTime),
                          const SizedBox(height: 25),
                          Text(
                            'Patient Information',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildInfoRow('Name', patientName),
                          _buildInfoRow('Phone Number', snapshot.data?.phoneNumber ?? "N/A"),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle reject logic
                                    print('Rejected');
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text('Reject Appointment'),
                                        content: const Text('Are you sure you want to reject this appointment?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back(); // Close the dialog
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _authController.deleteAppointment(widget.appointmentId); // Gọi hàm xóa
                                              Get.offAll(() => const Doctorscreen());
                                            },
                                            child: const Text('Confirm'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: Text(
                                    'Reject',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle accept logic
                                    print('Accepted');
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text('Accept Appointment'),
                                        content: const Text('Are you sure you want to accept this appointment?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back(); // Close the dialog
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _authController.acceptAppointment(widget.appointmentId);
                                              Get.offAll(() => const Doctorscreen());
                                            },
                                            child: const Text('Confirm'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: Text(
                                    'Accept',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('Không tìm thấy thông tin bệnh nhân.'));
              }
            },
          );
        }),
      ),
    );
  }


  Widget _buildInfoRow( String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Thêm padding cho dễ nhìn
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều dọc
        children: [
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xff053F5E), // Màu chủ đạo cho label
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
