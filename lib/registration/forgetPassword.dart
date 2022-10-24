// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nozol_application/registration/log_in.dart';

class forgetPassword extends StatefulWidget {
  const forgetPassword({super.key});

  @override
  State<forgetPassword> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {
  final email = TextEditingController();

  @override
  void dispose() {
    //for momery mangment
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 127, 166, 233),
            elevation: 0,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "أدخل البريد الألكتروني وسنرسل لك رابط اعادة ضبط كلمة المرور",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Tajawal-b",
                        color: Color.fromARGB(255, 127, 166, 233)),
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                height: 15,
              ),
              //email textfield
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: email,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 212, 214, 219),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 127, 166, 233),
                          ),
                        ),
                        hintText: "البريد الألكتروني ",
                        fillColor: Color.fromARGB(255, 212, 214, 219),
                        filled: true,
                      ),
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email.text);
                    Fluttertoast.showToast(
                      msg: "تم ارسال الرابط",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Color.fromARGB(255, 127, 166, 233),
                      textColor: Color.fromARGB(255, 248, 249, 250),
                      fontSize: 18.0,
                    );
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LogIn();
                    }));
                  } on FirebaseAuthException catch (e) {
                    Fluttertoast.showToast(
                      msg: "أدخل البريد الألكتروني بالشكل الصحيح",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Color.fromARGB(255, 127, 166, 233),
                      textColor: Color.fromARGB(255, 248, 249, 250),
                      fontSize: 18.0,
                    );
                  }
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
                  "إرسال",
                  style: TextStyle(fontSize: 20, fontFamily: "Tajawal-l"),
                ),
              ),
            ],
          )),
    );
  }
}
