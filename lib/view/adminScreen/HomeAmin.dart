import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/view/adminScreen/DoctorDetail.dart';
import 'package:doctor_app/view/doctorScreen/doctorScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_user
    show FirebaseAuth, User;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/SpecialtyController.dart';
import '../../controller/authController.dart';
import '../../model/Specialty.dart';
import '../../widget/ChangeInfoScreen.dart';
import '../auth/login.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final AuthController _authController = Get.put(AuthController());
  final firebase_user.User? user =
      firebase_user.FirebaseAuth.instance.currentUser;
  final SpecialtyController _specialtyController =
  Get.put(SpecialtyController()); // Get SpecialtyController

  @override
  void initState() {
    super.initState();
    _loadDoctors();
    _loadSpecialties(); // Load specialties
  }

  Future<void> _loadDoctors() async {
    await _authController.fetchAllDoctors(); // Đảm bảo đợi future hoàn thành
  }

  Future<void> _loadSpecialties() async {
    await _specialtyController.fetchAllSpecialties();
  }

  signout() async {
    await firebase_user.FirebaseAuth.instance.signOut();
    Get.offAll(const Login());
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
            ),
          ),
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
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
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
            Container(
              margin: const EdgeInsets.only(top: 5, left: 20),
              child: const Text(
                "Welcome Back",
                style: TextStyle(
                  color: Color(0xff363636),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
                width: size.width,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      offset: Offset(0, 10),
                      blurRadius: 15,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: const TextField(
                        maxLines: 1,
                        autofocus: false,
                        style: TextStyle(
                            color: Color(0xff107163), fontSize: 20),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search..',
                        ),
                        cursorColor: Color(0xff107163),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff107163),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ])),
            Container(
              width: size.width,
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Stack(
                fit: StackFit.loose,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Danh sách bác sĩ',
                      style: TextStyle(
                        color: Color(0xff363636),
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20, top: 1),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Xem tất cả',
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
              child: Obx(
                    () => Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: ListView.builder(
                    itemCount: _authController.allDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = _authController.allDoctors[index];
                      return _buildDoctorCard(doctor, context); // Pass the context
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //custom widget


  Widget _buildDoctorCard(User doctor, BuildContext context) { // Add context parameter
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DoctorDetail(doctorId: doctor.uid)));
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20),
              height: 90,
              width: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/dr_1.png"), // Thay bằng hình ảnh thực tế của bác sĩ nếu có
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20, top: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            doctor.fullName,
                            style: const TextStyle(
                              color: Color(0xff363636),
                              fontSize: 17,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<String?>( // Use FutureBuilder to handle the async operation
                      future: _getSpecialtyName(doctor.SpecialtyId), // Call the async function
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text(
                            "Loading...", // Show a loading indicator
                            style: TextStyle(
                              color: Color(0xffababab),
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w300,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            "Error: ${snapshot.error}", // Show the error
                            style: const TextStyle(
                              color: Colors.red,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w300,
                            ),
                          );
                        } else {
                          final specialtyName = snapshot.data ?? "Unknown"; // Get the data or a default value
                          return Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              specialtyName,
                              style: const TextStyle(
                                color: Color(0xffababab),
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _getSpecialtyName(String specialtyId) async {
    final Specialty? specialty = await _specialtyController.getSpecialtyById(specialtyId);
    return specialty?.name;
  }
}

