import 'package:doctor_app/view/doctorScreen/DetailPatientEnroll.dart';
import 'package:flutter/material.dart';

import '../patienceScreen/DoctorDetailPage.dart';

class Homedoctor extends StatefulWidget {
  const Homedoctor({super.key});

  @override
  State<Homedoctor> createState() => _HomedoctorState();
}

class _HomedoctorState extends State<Homedoctor> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
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
          leading: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          actions: [
            GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.notifications_rounded,
                    color: Colors.white,
                  ),
                )
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.asset("assets/images/profile_img.png"),
              ),
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    "Hi, Olivia",
                    style: TextStyle(
                      color: Color(0xff363636),
                      fontSize: 25,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, left: 20),
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Color(0xff363636),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                SizedBox(height: 30,),

                Container(
                  width: size.width,
                  margin: EdgeInsets.only(top: 20, left: 20),
                  child: Stack(
                    fit: StackFit.loose,
                    children: [

                      Container(
                        margin: EdgeInsets.only(right: 20, top: 1),
                        child: Align(
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
                    margin: EdgeInsets.only(left: 20, right: 20),
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
                        demoTopRatedDr("assets/images/dr_2.png", "Dr. Fred Mask",
                            "Heart surgen", "4.3", ""),
                        demoTopRatedDr("assets/images/dr_2.png", "Dr. Fred Mask",
                            "Heart surgen", "4.3", ""),
                        demoTopRatedDr("assets/images/dr_2.png", "Dr. Fred Mask",
                            "Heart surgen", "4.3", ""),
                        demoTopRatedDr("assets/images/dr_2.png", "Dr. Fred Mask",
                            "Heart surgen", "4.3", ""),
                        demoTopRatedDr("assets/images/dr_2.png", "Dr. Fred Mask",
                            "Heart surgen", "4.3", ""),
                        demoTopRatedDr("assets/images/dr_2.png", "Dr. Fred Mask",
                            "Heart surgen", "4.3", ""),
                        demoTopRatedDr("assets/images/dr_2.png", "Dr. Fred Mask",
                            "Heart surgen", "4.3", ""),
                        demoTopRatedDr("assets/images/dr_2.png", "Dr. Fred Mask",
                            "Heart surgen", "4.3", ""),
                      ],
                    ),
                  ),
                )


              ]
          ),
        )
    );
  }



  //custom widget
  Widget demoCategories(String img, String name, String drCount) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Color(0xff107163),
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
            margin: EdgeInsets.only(top: 10),
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Color(0xffd9fffa).withOpacity(0.07),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              drCount,
              style: TextStyle(
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




  Widget demoTopRatedDr(String img, String name, String speciality,
      String rating, String distance) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPatientEnroll()));
      },
      child: Container(
        height: 90,
        // width: size.width,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              height: 90,
              width: 50,
              child: Image.asset(img),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Color(0xff363636),
                        fontSize: 17,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Color(0xffababab),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3, left: size.width * 0.25),
                          child: Row(
                            children: [
                              Container(
                                child: Text(
                                  "Rating: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  rating,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              )
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
