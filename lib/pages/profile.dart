// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, unnecessary_null_comparison, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/registration/log_in.dart';
import '../registration/sign_up.dart';
import 'my-property.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // bottom: const
        title: Center(
          child: Text("حسابي               ",
              style: TextStyle(
                fontSize: 17,
                fontFamily: "Tajawal-m",
              )),
        ),
        toolbarHeight: 60,
        backgroundColor: Color.fromARGB(255, 127, 166, 233),
      ),
      body: SafeArea(
        child: Column(children: [
          FutureBuilder(
            future: getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                final cuuser = snapshot.data!;
                return Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "المعلومات الشخصية",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 127, 166, 233),
                          fontFamily: "Tajawal-b",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 229, 229, 232),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 400,
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(children: [
                        Icon(Icons.person,
                            color: Color.fromARGB(255, 127, 166, 233)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          cuuser.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Tajawal-m",
                          ),
                        )
                      ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 229, 229, 232),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 400,
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(children: [
                        Icon(Icons.mail,
                            color: Color.fromARGB(255, 127, 166, 233)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          cuuser.email,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Tajawal-m",
                          ),
                        )
                      ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 229, 229, 232),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 400,
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(children: [
                        Icon(Icons.phone_android,
                            color: Color.fromARGB(255, 127, 166, 233)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          cuuser.phoneNumber,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Tajawal-m",
                          ),
                        )
                      ]),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                          width: 350,
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ))),
                          child: Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                myProperty()));
                                  },
                                  child: Text(
                                    "عقاراتي",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                      fontFamily: "Tajawal-b",
                                    ),
                                  )),
                              SizedBox(
                                width: 210,
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => myProperty()));
                                },
                                icon: const Icon(Icons.keyboard_arrow_right),
                                color: Colors.grey,
                                iconSize: 30,
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) =>
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LogIn())));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 127, 166, 233)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27))),
                      ),
                      child: Text(
                        "تسجيل خروج",
                        style: TextStyle(fontSize: 20, fontFamily: "Tajawal-m"),
                      ),
                    )
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 127, 166, 233)),
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
      ),
    );
  }
}

// get the id of the curent user
Future getCurrentUser() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user!.uid;
  print(uid);

  final docStanderUser = await FirebaseFirestore.instance
      .collection('Standard_user')
      .doc(uid)
      .get();
  if (docStanderUser.exists) {
    return Suser.fromJson(docStanderUser.data()!);
  }
}
