import 'package:doctor_app/controller/authController.dart';
import 'package:doctor_app/model/Specialty.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/SpecialtyController.dart';
import 'DoctorDetailPage.dart';
import 'homepage.dart';

class CategoryDisease extends StatefulWidget {
  final String specialtyId;
  const CategoryDisease({super.key, required this.specialtyId});

  @override
  State<CategoryDisease> createState() => _CategoryDiseaseState();
}

class _CategoryDiseaseState extends State<CategoryDisease> {
  final AuthController _authController = Get.put(AuthController());
  final SpecialtyController _specialtyController = Get.put(SpecialtyController());
  late Future<Specialty?> _specialtyFuture; // Sử dụng Future
  @override
  void initState() {
    super.initState();
    _authController.fetchDoctorsBySpecialty(widget.specialtyId);
    _specialtyFuture =
        _specialtyController.getSpecialtyById(widget.specialtyId); // Lưu Future
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff053F5E),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.offAll(() => const Homepage()); // Navigate back to Homepage
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Doctors',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Obx(() => _authController.doctorsBySpecialty.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _authController.doctorsBySpecialty.length,
          itemBuilder: (context, index) {
            final doctor = _authController.doctorsBySpecialty[index];
            // Sử dụng FutureBuilder ở đây
            return FutureBuilder<Specialty?>(
              future: _specialtyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox
                      .shrink(); // Tránh hiển thị loading cho mỗi item
                } else if (snapshot.hasError) {
                  return Text(
                      'Lỗi: ${snapshot.error}'); // Xử lý lỗi (có thể hiển thị một lần ở ngoài ListView)
                } else if (snapshot.data == null) {
                  return Text(
                      'Không tìm thấy chuyên khoa'); // Xử lý trường hợp không tìm thấy
                } else {
                  final Specialty specialty =
                  snapshot.data!; // Lấy Specialty từ snapshot
                  return demoTopRatedDr(
                    "assets/images/dr_1.png",
                    // Replace with actual doctor image
                    doctor.fullName,
                    specialty.name,
                    '4.4',
                    doctor.uid ??"",
                    specialty.specialtyId ?? ""// Truy cập specialty.name khi có dữ liệu
                  );
                }
              },
            );
          },
        )),
      ),
    );
  }

  //custom widget
  Widget demoTopRatedDr(String img, String name, String nameSpecialty, String rating,String doctorId,String SpecialId) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Doctordetailpage(doctorId:doctorId,SpecialId : SpecialId)));
      },
      child: Container(
        height: 90,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
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
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(img),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20),
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
                      nameSpecialty,
                      style: const TextStyle(
                        color: Color(0xff363636),
                        fontSize: 17,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 3), // Thêm padding
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                    // You can display more doctor information here if needed
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