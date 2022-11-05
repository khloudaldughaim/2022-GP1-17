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
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 115),
            child: const Text('استعادة كلمة المرور',
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Tajawal-b",
              )),
          ),
          actions:[
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
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || email.text.trim() == "") {
                          return "البريد الألكتروني مطلوب ";
                        } else if (!RegExp(
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                            .hasMatch(value)) {
                          return '  أدخل البريد الأكلتروني بالشكل الصحيح \n(exampel@gmail.com)';
                        }
                      },
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
                      timeInSecForIosWeb: 4,
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
                      msg: "البريد الإلكتروني غير مسجل لدينا",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 5,
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
