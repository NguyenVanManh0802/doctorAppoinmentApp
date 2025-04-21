import 'package:doctor_app/view/adminScreen/DoctorDetail.dart';
import 'package:doctor_app/view/adminScreen/adminScreen.dart';
import 'package:flutter/material.dart';

import '../patienceScreen/DoctorDetailPage.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  // Dữ liệu mẫu cho danh sách bác sĩ (thay thế bằng dữ liệu thực tế của bạn)
  final List<Doctor> _doctors = [
    Doctor(
        name: "Dr. Fred Mask",
        speciality: "Heart Surgeon",
        rating: "4.1",
        imageUrl: "assets/images/dr_1.png",
        isApproved: true),
    Doctor(
        name: "Dr. Stella Kane",
        speciality: "Bone Specialist",
        rating: "4.2",
        imageUrl: "assets/images/dr_2.png",
        isApproved: false),
    Doctor(
        name: "Dr. Zac Wolff",
        speciality: "Eyes Specialist",
        rating: "4.4",
        imageUrl: "assets/images/dr_3.png",
        isApproved: true),
    Doctor(
        name: "Dr. Jane Smith",
        speciality: "Pediatrician",
        rating: "4.3",
        imageUrl: "assets/images/dr_2.png",
        isApproved: false),
    Doctor(
        name: "Dr. David Lee",
        speciality: "Dermatologist",
        rating: "4.5",
        imageUrl: "assets/images/dr_1.png",
        isApproved: true),
    // Thêm các bác sĩ khác vào đây
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme
              .of(context)
              .primaryColor,
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
                )
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
                  topLeft: Radius.circular(30))),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20),
                  child: const Text(
                    "Hi, Olivia",
                    style: TextStyle(
                      color: Color(0xff363636),
                      fontSize: 25,
                      fontFamily: 'Roboto',
                    ),
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
                      const Text(
                        'Top Rated Doctors',
                        style: TextStyle(
                          color: Color(0xff363636),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
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
                    child: ListView.builder(
                      itemCount: _doctors.length,
                      itemBuilder: (context, index) {
                        return demoTopRatedDr(_doctors[index]);
                      },
                    ),
                  ),
                )
              ]),
        ));
  }

  //custom widget
  Widget demoCategories(String img, String name, String drCount) {
    return Container(
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
          Container(
            child: Image.asset(img),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              name,
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
    );
  }

  Widget demoTopRatedDr(Doctor doctor) {
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
              child: Image.asset(doctor.imageUrl),
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
                            doctor.name,
                            style: const TextStyle(
                              color: Color(0xff363636),
                              fontSize: 17,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (doctor.isApproved)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 18,
                            )
                          else
                            const Icon(
                              Icons.warning_rounded,
                              color: Colors.orange,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            doctor.speciality,
                            style: const TextStyle(
                              color: Color(0xffababab),
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Row(
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
                                doctor.rating,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
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
          ],
        ),
      ),
    );
  }
}

class Doctor {
  final String name;
  final String speciality;
  final String rating;
  final String imageUrl;
  final bool isApproved;

  Doctor({
    required this.name,
    required this.speciality,
    required this.rating,
    required this.imageUrl,
    required this.isApproved,
  });
}