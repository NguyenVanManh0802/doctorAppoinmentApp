import 'package:doctor_app/view/doctorScreen/DetailPatientEnroll.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_user;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/authController.dart';
import '../../model/user_model.dart';
import '../../widget/ChangeInfoScreen.dart';
import '../auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for DocumentSnapshot

class Homedoctor extends StatefulWidget {
  const Homedoctor({super.key});
  @override
  State<Homedoctor> createState() => _HomedoctorState();
}

class _HomedoctorState extends State<Homedoctor> {
  final firebase_user.User? user = firebase_user.FirebaseAuth.instance.currentUser;
  final AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _authController.fetchPendingAppointments();
  }
  signout() async {
    await firebase_user.FirebaseAuth.instance.signOut();
    Get.offAll(Login());
  }
  void _showPopupMenu(BuildContext context, TapDownDetails details) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero);

    try {
      await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx,
          details.globalPosition.dy,
        ).shift(const Offset(0, -5)),
        items: [
          PopupMenuItem<String>(
            value: 'change_info',
            child: const Text('Đổi thông tin'),
            onTap: () {
              Future.delayed(Duration.zero, () {
                Get.to(() => const ChangeInfoScreen());
              });
            },
          ),
          const PopupMenuItem<String>(
            value: 'change_password',
            child: Text('Đổi mật khẩu'),
          ),
          PopupMenuItem<String>(
            value: 'sign_out',
            child: Text('Đăng xuất'),
            onTap: () {
              Future.delayed(Duration.zero, () {
                signout();
              });
            },
          ),
          const PopupMenuItem<String>(
            value: 'delete_account',
            child: Text('Xóa tài khoản'),
          ),
        ],
      ).then((value) {
        if (value == 'change_info') {
          print('Đổi thông tin được chọn');
        } else if (value == 'change_password') {
          print('Đổi mật khẩu được chọn');
        } else if (value == 'delete_account') {
          print('Xóa tài khoản được chọn');
        }
      });
    } catch (e) {
      print("Lỗi khi hiển thị menu: $e");
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
                )),
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                _showPopupMenu(context, details);
              },
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
                  topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: FutureBuilder(
                    future: user != null && user!.uid.isNotEmpty
                        ? _authController.fetchUserByUid(user!.uid)
                        : Future.value(null), // Trả về null nếu không có user
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          "Hi, Loading...",
                          style: TextStyle(
                            color: Color(0xff363636),
                            fontSize: 25,
                            fontFamily: 'Roboto',
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print(
                            "Lỗi khi tải thông tin người dùng: ${snapshot.error}");
                        return const Text(
                          "Hi, Error",
                          style: TextStyle(
                            color: Color(0xff363636),
                            fontSize: 25,
                            fontFamily: 'Roboto',
                          ),
                        );
                      } else if (snapshot.data != null) {
                        final fullName = snapshot.data!.fullName;
                        return Text(
                          "Hi, $fullName",
                          style: const TextStyle(
                            color: Color(0xff363636),
                            fontSize: 25,
                            fontFamily: 'Roboto',
                          ),
                        );
                      } else {
                        return const Text(
                          "Hi, User", // Giá trị mặc định nếu không có user hoặc lỗi
                          style: TextStyle(
                            color: Color(0xff363636),
                            fontSize: 25,
                            fontFamily: 'Roboto',
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding:
                  EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Danh sách bệnh nhân",
                        style: TextStyle(
                          color: Color(0xff363636),
                          fontSize: 22,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  margin: const EdgeInsets.only(top: 20, left: 20),
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 20, top: 1),
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'See all',
                            style: TextStyle(
                              color: Color(0xff5e5d5d),
                              fontSize: 19,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Obx(() {
                      if (_authController.pendingAppointments.isEmpty) {
                        return const Center(
                          child: Text("Không có bệnh nhân nào đăng ký."),
                        );
                      }
                      return ListView.builder(
                        itemCount: _authController.pendingAppointments.length,
                        itemBuilder: (context, index) {
                          // Get the appointment object.
                          final appointment =
                          _authController.pendingAppointments[index];
                          print('Toàn bộ đối tượng appointment: $appointment');
                          final patientId =
                              appointment['patientId'] ??
                                  '12345'; // Provide a default value

                          final Future<User?> patientFuture =
                          _authController.fetchUserByUid(patientId);
                          final appointmentTime =
                              appointment['appointmentTime'] ?? 'N/A';
                          // Assuming _authController.pendingAppointments is a List<DocumentSnapshot>
                          String appointmentId = appointment['appointmentId'] ?? '';
                          print('Appointment ID: $appointmentId');
                          return FutureBuilder<User?>(
                            future: patientFuture, // Use the future here to get user data.
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator(); // Show loading indicator.
                              } else if (snapshot.hasError) {
                                return Text(
                                    "Error: ${snapshot.error}"); // show the error
                              } else if (snapshot.hasData &&
                                  snapshot.data != null) {
                                final patientName =
                                    snapshot.data!.fullName; // Access fullName
                                return demoPatientCard(
                                  "assets/images/profile_img.png",
                                  patientName,
                                  "Thời gian: $appointmentTime",
                                  patientId,
                                  appointmentId, // Pass the appointmentId
                                );
                              } else {

                                //if snapshot.data is null or no data.
                                return demoPatientCard(
                                  "assets/images/profile_img.png",
                                  "Unknown User", // show unknown user
                                  "Thời gian: $appointmentTime",
                                  patientId,
                                  appointmentId, // Pass the appointmentId
                                );
                              }
                            },
                          );
                        },
                      );
                    }),
                  ),
                )
              ]),
        ));
  }

  Widget demoPatientCard(String img, String name, String time, String? patientId,
      String appointmentId) { // Add appointmentId parameter
    return GestureDetector(
      onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPatientEnroll(
                      appointmentId:
                      appointmentId,))); // Pass appointmentId to the detail page
      },
      child: Container(
        height: 90,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20),
              height: 60,
              width: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  img,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Color(0xff363636),
                      fontSize: 17,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

