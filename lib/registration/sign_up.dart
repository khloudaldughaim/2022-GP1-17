// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../pages/navigationbar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final signformkey = GlobalKey<FormState>();
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phonenumberController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _phonenumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Form(
                    key: signformkey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "إنشاء حساب",
                          style: TextStyle(
                              fontSize: 26,
                              fontFamily: "Tajawal-b",
                              color: Color.fromARGB(255, 127, 166, 233)),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Image.asset(
                          "assets/images/logo.png",
                          width: 200,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                controller: _usernameController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Color.fromARGB(255, 127, 166, 233),
                                  ),
                                  labelText: "  الأسم  :",
                                  labelStyle:
                                      TextStyle(fontFamily: "Tajawal-m"),
                                  fillColor: Color.fromARGB(255, 225, 225, 228),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(66.0),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      _usernameController.text.trim() == "") {
                                    return "الأسم مطلوب ";
                                  } else if (value.length < 2) {
                                    return "الأسم يجب ان يكون خانتين فأكثر ";
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
                                controller: _emailController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: Color.fromARGB(255, 127, 166, 233),
                                  ),
                                  labelText: " البريد الإلكتروني :",
                                  labelStyle:
                                      TextStyle(fontFamily: "Tajawal-m"),
                                  hintText: "exampel@gmail.com",
                                  hintStyle: TextStyle(fontSize: 10),
                                  fillColor: Color.fromARGB(255, 225, 225, 228),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(66.0),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                ),
                                validator: (MultiValidator) {
                                  if (MultiValidator!.isEmpty ||
                                      _emailController.text.trim() == "") {
                                    return "البريد الألكتروني مطلوب ";
                                  } else if (!RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(MultiValidator)) {
                                    return '  أدخل البريد الأكلتروني بالشكل الصحيح \n(exampel@gmail.com)';
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
                                  controller: _phonenumberController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.phone_android,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                      size: 19,
                                    ),
                                    labelText: "رقم الجوال :",
                                    labelStyle:
                                        TextStyle(fontFamily: "Tajawal-m"),
                                    hintText: "05xxxxxxxx",
                                    hintStyle: TextStyle(fontSize: 10),
                                    fillColor:
                                        Color.fromARGB(255, 225, 225, 228),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(66.0),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "رقم الجوال مطلوب ";
                                    }
                                    if (!RegExp(
                                            r'^((?:[+?0?0?966]+)(?:\s?\d{2})(?:\s?\d{7}))$')
                                        .hasMatch(value)) {
                                      return 'أدخل رقم الجوال بالشكل الصحيح\n (05xxxxxxxx)';
                                    }
                                  }),
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
                                controller: _passwordController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Color.fromARGB(255, 127, 166, 233),
                                    size: 19,
                                  ),
                                  labelText: "كلمة المرور:",
                                  labelStyle:
                                      TextStyle(fontFamily: "Tajawal-m"),
                                  hintText:
                                      "كلمة المرور يجب ان يكون من 8 خانات واحرف كبيرة وصغيرة ",
                                  hintStyle: TextStyle(fontSize: 10),
                                  fillColor: Color.fromARGB(255, 225, 225, 228),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(66.0),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                ),
                                validator: (value) {
                                  RegExp uper = RegExp(r"(?=.*[A-Z])");
                                  RegExp small = RegExp(r"(?=.*[a-z])");
                                  if (value!.isEmpty ||
                                      _passwordController.text.trim() == "") {
                                    return "كلمة السر مطلوبة";
                                  } else if (value.length < 8 &&
                                      !uper.hasMatch(value) &&
                                      !small.hasMatch(value)) {
                                    return "كلمة المرور يجب ان يكون من 8 خانات واحرف كبيرة وصغيرة ";
                                  } else if (value.length < 8 &&
                                      !uper.hasMatch(value)) {
                                    return "كلمة المرور يجب ان يكون من 8 خانات واحرف كبيرة ";
                                  } else if (value.length < 8 &&
                                      !small.hasMatch(value)) {
                                    return "كلمة المرور يجب ان يكون من 8 خانات واحرف وصغيرة ";
                                  } else if (!uper.hasMatch(value) &&
                                      !small.hasMatch(value)) {
                                    return "كلمة المرور يجب ان تحتوي على احرف كبيرة و وصغيرة ";
                                  } else if (value.length < 8) {
                                    return "كلمة المرور يجب ان تكون من 8 خانات فأكثر";
                                  } else if (!uper.hasMatch(value)) {
                                    return "كلمة المرور يجب ان تحتوي على احرف كبيرة";
                                  } else if (!small.hasMatch(value)) {
                                    return "كلمة المرور يجب ان تحتوي على احرف صغيرة";
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    //suffix: Icon(
                                    // Icons.visibility,
                                    // color: Color.fromARGB(
                                    // 255, 127, 166, 233),
                                    //  ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                      size: 19,
                                    ),
                                    labelText: "تأكيد كلمة المرور:",
                                    labelStyle:
                                        TextStyle(fontFamily: "Tajawal-m"),
                                    fillColor:
                                        Color.fromARGB(255, 225, 225, 228),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(66.0),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "تأكيد كلمة المرور مطلوب ";
                                    } else if (value !=
                                        _passwordController.text.trim()) {
                                      return "كلمة المرور غير مطابقة ";
                                    }
                                  }),
                            )),
                        SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              if (signformkey.currentState!.validate()) {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim())
                                    .then((value) {
                                  final suser = Suser(
                                    name: _usernameController.text,
                                    phoneNumber: _phonenumberController.text,
                                    email: _emailController.text,
                                  ); //creat user in database
                                  Fluttertoast.showToast(
                                    msg: "تم تسجيل حسابك بنجاح",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor:
                                        Color.fromARGB(255, 127, 166, 233),
                                    textColor:
                                        Color.fromARGB(255, 248, 249, 250),
                                    fontSize: 18.0,
                                  );
                                  createSuser(suser);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NavigationBarPage()));
                                });
                              }
                            } on FirebaseAuthException catch (error) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("خطأ"),
                                      content: Text(
                                          "البريد الألكتروني موجود مسبقاً"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("حسناً"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 127, 166, 233)),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 10)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27))),
                          ),
                          child: Text(
                            "إنشاء حساب",
                            style: TextStyle(
                                fontSize: 20, fontFamily: "Tajawal-m"),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/login");
                              },
                              child: Text(
                                "تسجيل الدخول ",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Tajawal-b",
                                    color: Color.fromARGB(255, 127, 166, 233)),
                              ),
                            ),
                            Text(
                              "  لديك حساب ؟     ",
                              style: TextStyle(
                                  fontSize: 14, fontFamily: "Tajawal-l"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future createSuser(Suser suser) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final Uid = user!.uid;
  suser.userid = Uid;

  final json = suser.toJson();
  final docSuser =
      FirebaseFirestore.instance.collection('Standard_user').doc(Uid);
  await docSuser.set(json);
}

class Suser {
  late String userid;
  late final String name;
  late final String phoneNumber;
  late final String email;

  Suser({
    this.userid = '',
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'userId': userid,
        'name': name,
        'phoneNumber': phoneNumber,
        'Email': email,
      };

  static Suser fromJson(Map<String, dynamic> json) => Suser(
        userid: json['userId'],
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        email: json['Email'],
      );
}
