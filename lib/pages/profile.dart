// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, unnecessary_null_comparison, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nozol_application/pages/mycomplaints.dart';
import 'package:nozol_application/pages/ownerBooking.dart';
import 'package:nozol_application/registration/log_in.dart';
import '../registration/sign_up.dart';
import 'BuyerBooking.dart';
import 'edit-profile-info.dart';
import 'my-property.dart';
import 'affordCalculator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

late FirebaseAuth auth = FirebaseAuth.instance;
late User? user = auth.currentUser;
late String curentId = user!.uid;

class _ProfilePageState extends State<ProfilePage> {
  final profileformkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 127, 166, 233),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 155),
            child: Text("حسابي               ",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: "Tajawal-m",
                )),
          ),
          actions: [
            new IconButton(
                icon: new Icon(Icons.logout),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn())));
                })
          ],
          toolbarHeight: 60,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: SingleChildScrollView(
              child: Stack(children: [
            SizedBox(
                width: double.infinity,
                child: Form(
                  key: profileformkey,
                  child: Column(children: [
                    FutureBuilder(
                      future: getCurrentUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData) {
                          final cuuser = snapshot.data!;
                          final nameControlar = TextEditingController(text: cuuser.name);
                          final phoneControlar = TextEditingController(text: cuuser.phoneNumber);
                          final emailcontrolar = TextEditingController(text: cuuser.email);

                          return Column(
                            children: [
                              SizedBox(
                                height: 40,
                              ),

                              Container(
                                  width: 350,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(119, 110, 110, 110),
                                      width: 1,
                                    ),
                                    color: Color.fromARGB(33, 215, 215, 218),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => editProfile()));
                                        },
                                        icon: const Icon(Icons.keyboard_arrow_left),
                                        color: Colors.grey,
                                        iconSize: 30,
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => editProfile()));
                                          },
                                          child: Text(
                                            "تعديل المعلومات الشخصية",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(255, 127, 166, 233),
                                              fontFamily: "Tajawal-b",
                                            ),
                                          )),
                                      Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Color.fromARGB(255, 137, 139, 145),
                                      )
                                    ],
                                  )),

                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                  width: 350,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(119, 110, 110, 110),
                                      width: 1,
                                    ),
                                    color: Color.fromARGB(33, 215, 215, 218),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => myProperty()));
                                        },
                                        icon: const Icon(Icons.keyboard_arrow_left),
                                        color: Colors.grey,
                                        iconSize: 30,
                                      ),
                                      SizedBox(
                                        width: 190,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => myProperty()));
                                          },
                                          child: Text(
                                            "عقاراتي",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(255, 127, 166, 233),
                                              fontFamily: "Tajawal-b",
                                            ),
                                          )),
                                      Icon(
                                        Icons.villa,
                                        size: 20,
                                        color: Color.fromARGB(255, 137, 139, 145),
                                      )
                                    ],
                                  )),

                              //this for booking page [start]
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                  width: 350,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(119, 110, 110, 110),
                                      width: 1,
                                    ),
                                    color: Color.fromARGB(33, 215, 215, 218),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('bookings')
                                              .where('owner_id', isEqualTo: curentId)
                                              .get()
                                              .then((querySnapshot) {
                                            querySnapshot.docs.forEach((element) {
                                              DateTime d = DateTime.parse(element["Date"]);
                                              DateTime t = DateTime.now();
                                              print(d);
                                              bool s = d.isBefore(t);
                                              print(s);
                                              if (d.isBefore(t)) {
                                                print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
                                                FirebaseFirestore.instance
                                                    .collection('bookings')
                                                    .doc(element["book_id"])
                                                    .update({
                                                  "isExpired": true,
                                                });
                                              }
                                            });
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ownerBooking()));
                                        },
                                        icon: const Icon(Icons.keyboard_arrow_left),
                                        color: Colors.grey,
                                        iconSize: 30,
                                      ),
                                      SizedBox(
                                        width: 65,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('bookings')
                                                .where('owner_id', isEqualTo: curentId)
                                                .get()
                                                .then((querySnapshot) {
                                              querySnapshot.docs.forEach((element) {
                                                DateTime d = DateTime.parse(element["Date"]);
                                                DateTime t = DateTime.now();
                                                print(d);
                                                if (d.isBefore(t)) {
                                                  print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
                                                  FirebaseFirestore.instance
                                                      .collection('bookings')
                                                      .doc(element["book_id"])
                                                      .update({
                                                    "isExpired": true,
                                                  });
                                                }
                                              });
                                            });
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ownerBooking()));
                                          },
                                          child: Text(
                                            "طلبات الجولات العقارية",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(255, 127, 166, 233),
                                              fontFamily: "Tajawal-b",
                                            ),
                                          )),
                                      Icon(
                                        Icons.call_made,
                                        size: 20,
                                        color: Color.fromARGB(255, 137, 139, 145),
                                      )
                                    ],
                                  )),

                              //this for owner booking page [End]
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                  width: 350,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(119, 110, 110, 110),
                                      width: 1,
                                    ),
                                    color: Color.fromARGB(33, 215, 215, 218),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('bookings')
                                              .where('buyer_id', isEqualTo: curentId)
                                              .get()
                                              .then((querySnapshot) {
                                            querySnapshot.docs.forEach((element) {
                                              DateTime d = DateTime.parse(element["Date"]);
                                              DateTime t = DateTime.now();
                                              print(d);
                                              bool s = d.isBefore(t);
                                              print(s);
                                              if (d.isBefore(t)) {
                                                print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
                                                FirebaseFirestore.instance
                                                    .collection('bookings')
                                                    .doc(element["book_id"])
                                                    .update({
                                                  "isExpired": true,
                                                });
                                              }
                                            });
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => BuyerBooking()));
                                        },
                                        icon: const Icon(Icons.keyboard_arrow_left),
                                        color: Colors.grey,
                                        iconSize: 30,
                                      ),
                                      SizedBox(
                                        width: 180,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('bookings')
                                                .where('buyer_id', isEqualTo: curentId)
                                                .get()
                                                .then((querySnapshot) {
                                              querySnapshot.docs.forEach((element) {
                                                DateTime d = DateTime.parse(element["Date"]);
                                                DateTime t = DateTime.now();
                                                print(d);
                                                if (d.isBefore(t)) {
                                                  print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
                                                  FirebaseFirestore.instance
                                                      .collection('bookings')
                                                      .doc(element["book_id"])
                                                      .update({
                                                    "isExpired": true,
                                                  });
                                                }
                                              });
                                            });
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => BuyerBooking()));
                                          },
                                          child: Text(
                                            "حجوزاتي",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(255, 127, 166, 233),
                                              fontFamily: "Tajawal-b",
                                            ),
                                          )),
                                      Icon(
                                        Icons.calendar_month,
                                        size: 20,
                                        color: Color.fromARGB(255, 137, 139, 145),
                                      )
                                    ],
                                  )),
                              //this for buyer booking page [End]
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                  width: 350,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(119, 110, 110, 110),
                                      width: 1,
                                    ),
                                    color: Color.fromARGB(33, 215, 215, 218),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MyComplaints()));
                                        },
                                        icon: const Icon(Icons.keyboard_arrow_left),
                                        color: Colors.grey,
                                        iconSize: 30,
                                      ),
                                      SizedBox(
                                        width: 187,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => MyComplaints()));
                                          },
                                          child: Text(
                                            "بلاغاتي",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(255, 127, 166, 233),
                                              fontFamily: "Tajawal-b",
                                            ),
                                          )),
                                      Icon(
                                        Icons.flag,
                                        size: 20,
                                        color: Color.fromARGB(255, 137, 139, 145),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                  width: 350,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(119, 110, 110, 110),
                                      width: 1,
                                    ),
                                    color: Color.fromARGB(33, 215, 215, 218),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => affordCalcPage()));
                                        },
                                        icon: const Icon(Icons.keyboard_arrow_left),
                                        color: Colors.grey,
                                        iconSize: 30,
                                      ),
                                      SizedBox(
                                        width: 110,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => affordCalcPage()));
                                          },
                                          child: Text(
                                            "  حاسبة التكاليف",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(255, 127, 166, 233),
                                              fontFamily: "Tajawal-b",
                                            ),
                                          )),
                                      Icon(
                                        Icons.calculate,
                                        size: 20,
                                        color: Color.fromARGB(255, 137, 139, 145),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 120,
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              SizedBox(height: 290),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 79),
                                  child: Text(
                                    "عذراً لابد من تسجيل الدخول ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Tajawal-b",
                                        color: Color.fromARGB(255, 127, 166, 233)),
                                    textAlign: TextAlign.center,
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => LogIn()));
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Color.fromARGB(255, 127, 166, 233)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(27))),
                                ),
                                child: Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(fontSize: 20, fontFamily: "Tajawal-m"),
                                ),
                              )
                            ],
                          );
                        }
                      },
                    ),
                  ]),
                ))
          ])),
        )));
  }
}

// get the id of the curent user
Future getCurrentUser() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final kuid = user!.uid;

  final docStanderUser =
      await FirebaseFirestore.instance.collection('Standard_user').doc(kuid).get();
  if (docStanderUser.exists) {
    return Suser.fromJson(docStanderUser.data()!);
  }
}
