// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, unnecessary_null_comparison, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nozol_application/pages/ownerBooking.dart';
import 'package:nozol_application/registration/log_in.dart';
import '../registration/sign_up.dart';
import 'BuyerBooking.dart';
import 'my-property.dart';

class editProfile extends StatefulWidget {
  const editProfile({Key? key}) : super(key: key);

  @override
  State<editProfile> createState() => _editProfileState();
}

late FirebaseAuth auth = FirebaseAuth.instance;
late User? user = auth.currentUser;
late String curentId = user!.uid;

class _editProfileState extends State<editProfile> {
  final profileformkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 127, 166, 233),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Text("تعديل المعلومات الشخصية ",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: "Tajawal-b",
                )),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
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

                          return Column(children: [
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
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    controller: nameControlar,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Color.fromARGB(255, 127, 166, 233),
                                      ),
                                      suffixIcon: Icon(
                                        Icons.edit,
                                        color: Color.fromARGB(255, 127, 166, 233),
                                      ),
                                      fillColor: Color.fromARGB(255, 225, 225, 228),
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(66.0),
                                          borderSide:
                                              const BorderSide(width: 0, style: BorderStyle.none)),
                                    ),
                                    validator: (value) {
                                      if (value!.length < 2) {
                                        return "الأسم يجب ان يكون خانتين فأكثر ";
                                      }
                                    },
                                  ),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: emailcontrolar,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Color.fromARGB(255, 127, 166, 233),
                                      ),
                                      fillColor: Color.fromARGB(255, 225, 225, 228),
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(66.0),
                                          borderSide:
                                              const BorderSide(width: 0, style: BorderStyle.none)),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    controller: phoneControlar,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.phone_android,
                                        color: Color.fromARGB(255, 127, 166, 233),
                                      ),
                                      suffixIcon: Icon(
                                        Icons.edit,
                                        color: Color.fromARGB(255, 127, 166, 233),
                                      ),
                                      fillColor: Color.fromARGB(255, 225, 225, 228),
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(66.0),
                                          borderSide:
                                              const BorderSide(width: 0, style: BorderStyle.none)),
                                    ),
                                    validator: (value) {
                                      if (!RegExp(r'^((?:[+?0?0?966]+)(?:\s?\d{2})(?:\s?\d{7}))$')
                                          .hasMatch(value!)) {
                                        return 'أدخل رقم الجوال بالشكل الصحيح\n (05xxxxxxxx)';
                                      }
                                    },
                                  ),
                                )),
                            SizedBox(
                              height: 50,
                            ),
                            SizedBox(
                              height: 120,
                            ),
                            SizedBox(
                              width: 210.0,
                              height: 70.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (profileformkey.currentState!.validate()) {
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('Standard_user')
                                            .doc(curentId)
                                            .update({
                                          'name': nameControlar.text,
                                          'phoneNumber': phoneControlar.text,
                                        });

                                        Fluttertoast.showToast(
                                          msg: "تم التحديث بنجاح",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 2,
                                          backgroundColor: Color.fromARGB(255, 127, 166, 233),
                                          textColor: Color.fromARGB(255, 248, 249, 250),
                                          fontSize: 18.0,
                                        );
                                      } catch (e, stack) {
                                        Fluttertoast.showToast(
                                          msg: "هناك خطأ ما",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Color.fromARGB(255, 127, 166, 233),
                                          textColor: Color.fromARGB(255, 252, 253, 255),
                                          fontSize: 18.0,
                                        );
                                      }
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 127, 166, 233)),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(horizontal: 40, vertical: 5)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(27))),
                                  ),
                                  child: Text(
                                    "حفظ التغيرات",
                                    style: TextStyle(fontSize: 18, fontFamily: "Tajawal-m"),
                                  ),
                                ),
                              ),
                            ),
                          ]);
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
