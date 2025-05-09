import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/SpecialtyController.dart';
import '../../controller/authController.dart';
import '../../widget/ChangeInfoScreen.dart';
import 'CategoryDisease.dart';
import '../auth/login.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthController _authController = Get.put(AuthController());
  final SpecialtyController _specialtyController = Get.put(SpecialtyController());

  @override
  void initState() {
    super.initState();
    _specialtyController.fetchAllSpecialties();
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
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
                    print("Lỗi khi tải thông tin người dùng: ${snapshot.error}");
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
                margin:
                const EdgeInsets.only(top: 25, left: 20, right: 20),
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
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: const TextField(
                          maxLines: 1,
                          autofocus: false,
                          style:
                          TextStyle(color: Color(0xff107163), fontSize: 20),
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
                  ],
                )),
            Container(
              width: size.width,
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Stack(
                fit: StackFit.loose,
                children: [
                  const Text(
                    'Category',
                    style: TextStyle(
                      color: Color(0xff363636),
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
            Container(
              height: 120,
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Obx(() {
                if (_specialtyController.specialties.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _specialtyController.specialties.length,
                  itemBuilder: (context, index) {
                    final specialty = _specialtyController.specialties[index];
                    return demoCategories(
                      specialty.imageUrl ?? "assets/images/default_specialty.png",
                      specialty.name,
                      "${specialty.doctorIds.length} Doctors",
                      specialty.specialtyId ?? '1',
                    );
                  },
                );
              }),
            ),
            Container(
              width: size.width,
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Stack(
                fit: StackFit.loose,
                children: [
                  const Text(
                    'Top Rated',
                    style: TextStyle(
                      color: Color(0xff363636),
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
                child: ListView(
                  children: [
                    demoTopRatedDr(
                      "assets/images/dr_1.png",
                      "Dr. Fred Mask",
                      "Heart surgen",
                      "4.1",
                      "",
                    ),
                    demoTopRatedDr(
                      "assets/images/dr_2.png",
                      "Dr. Stella Kane",
                      "Bone Specialist",
                      "4.2",
                      "",
                    ),
                    demoTopRatedDr(
                      "assets/images/dr_3.png",
                      "Dr. Zac Wolff",
                      "Eyes Specialist",
                      "4.4",
                      "",
                    ),
                    demoTopRatedDr("assets/images/dr_2.png", "Dr. Fred Mask",
                        "Heart surgen", "4.3", ""),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //custom widget
  Widget demoCategories(String img, String name, String drCount, String SpecialtyId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CategoryDisease(specialtyId: SpecialtyId)));
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: const Color(0xff107163),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: img.startsWith('http')
                  ? Image.network(
                img,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset("assets/images/default_specialty.png");
                },
              )
                  : Image.asset(
                img,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset("assets/images/default_specialty.png");
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xffd9fffa).withOpacity(0.07),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                drCount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget demoTopRatedDr(String img, String name, String speciality,
      String rating, String distance) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
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
              width: 50,
              child: Image.asset(img),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xff363636),
                        fontSize: 17,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          speciality,
                          style: const TextStyle(
                            color: Color(0xffababab),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 3, left: size.width * 0.25),
                          child: Row(
                            children: [
                              const Text(
                                "Rating: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              Text(
                                rating,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
