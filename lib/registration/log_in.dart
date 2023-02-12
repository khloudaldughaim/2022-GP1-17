// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/pages/navigationbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nozol_application/registration/welcom_page.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final loginformkey = GlobalKey<FormState>();
  // text controllers
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    //for momery mangment
    email.dispose();
    password.dispose();
    super.dispose();
  }

  var AdminId;
  late bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                      width: double.infinity,
                      child: Form(
                        key: loginformkey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 70,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "تسجيل الدخول ",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: "Tajawal-b",
                                      color: Color.fromARGB(255, 127, 166, 233)),
                                ),
                                SizedBox(
                                  width: 45,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Welcome()),
                                      );
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Image.asset(
                              "assets/images/logo.png",
                              width: 200,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    controller: email,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.mail,
                                        color: Color.fromARGB(255, 127, 166, 233),
                                      ),
                                      labelText: " البريد الإلكتروني :",
                                      labelStyle: TextStyle(fontFamily: "Tajawal-m"),
                                      hintText: "exampel@gmail.com",
                                      hintStyle: TextStyle(fontSize: 10),
                                      fillColor: Color.fromARGB(255, 225, 225, 228),
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(66.0),
                                          borderSide:
                                              const BorderSide(width: 0, style: BorderStyle.none)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty || email.text.trim() == "") {
                                        return "البريد الألكتروني مطلوب ";
                                      }
                                    },
                                  ),
                                )),
                            SizedBox(
                              height: 23,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: password,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Color.fromARGB(255, 127, 166, 233),
                                        size: 19,
                                      ),
                                      labelText: "كلمة المرور:",
                                      labelStyle: TextStyle(fontFamily: "Tajawal-m"),
                                      hintText: "أدخل كلمة مرور صالحة ",
                                      hintStyle: TextStyle(fontSize: 10),
                                      fillColor: Color.fromARGB(255, 225, 225, 228),
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(66.0),
                                          borderSide:
                                              const BorderSide(width: 0, style: BorderStyle.none)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty || password.text.trim() == "") {
                                        return "كلمة السر مطلوبة ";
                                      }
                                    },
                                  ),
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/forgetPassword");
                                  },
                                  child: Text(
                                    "نسيت كلمة المرور ؟        ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Tajawal-b",
                                        color: Color.fromARGB(255, 127, 166, 233)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (loginformkey.currentState!.validate()) {
                                  try {
                                    UserCredential userCredential = await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: email.text, password: password.text);
                                    FirebaseFirestore.instance
                                        .collection('Standard_user')
                                        .where('Email', isEqualTo: email.text)
                                        .get()
                                        .then((element) async {
                                      if (element.docs.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "عذرًا حسابك موقوف ",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Color.fromARGB(255, 127, 166, 233),
                                          textColor: Color.fromARGB(255, 252, 253, 255),
                                          fontSize: 18.0,
                                        );
                                      } else {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                          return NavigationBarPage();
                                        }));
                                      }
                                    });
                                  } catch (e, stack) {
                                    Fluttertoast.showToast(
                                      msg: "البريد الألكتروني او كلمة المرور غير صحيحة",
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
                                backgroundColor:
                                    MaterialStateProperty.all(Color.fromARGB(255, 127, 166, 233)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27))),
                              ),
                              child: Text(
                                "تسجيل الدخول",
                                style: TextStyle(fontSize: 18, fontFamily: "Tajawal-m"),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/signup");
                                  },
                                  child: Text(
                                    "إنشاء حساب ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Tajawal-b",
                                        color: Color.fromARGB(255, 127, 166, 233)),
                                  ),
                                ),
                                Text(
                                  " ليس لديك حساب ؟     ",
                                  style: TextStyle(fontSize: 14, fontFamily: "Tajawal-l"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
