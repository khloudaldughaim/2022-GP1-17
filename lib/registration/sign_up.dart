// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/homapage.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
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
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Text(
                        "إنشاء حساب",
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Tajawal-b",
                            color: Color.fromARGB(255, 127, 166, 233)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        "assets/images/logo.png",
                        width: 200,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 212, 214, 219),
                          borderRadius: BorderRadius.circular(66),
                        ),
                        width: 310,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            controller: _usernameController,
                            obscureText: false,
                            enableSuggestions: true,
                            autocorrect: true,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  color: Color.fromARGB(255, 127, 166, 233),
                                ),
                                labelText: "  الأسم  :",
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 23,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 212, 214, 219),
                          borderRadius: BorderRadius.circular(66),
                        ),
                        width: 310,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            controller: _emailController,
                            obscureText: false,
                            enableSuggestions: true,
                            autocorrect: true,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.mail,
                                  color: Color.fromARGB(255, 127, 166, 233),
                                ),
                                labelText: " البريد الإلكتروني :",
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 23,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 212, 214, 219),
                          borderRadius: BorderRadius.circular(66),
                        ),
                        width: 310,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                                suffix: Icon(
                                  Icons.visibility,
                                  color: Color.fromARGB(255, 127, 166, 233),
                                ),
                                icon: Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 127, 166, 233),
                                  size: 19,
                                ),
                                labelText: "كلمة المرور:",
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 23,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 212, 214, 219),
                          borderRadius: BorderRadius.circular(66),
                        ),
                        width: 310,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                suffix: Icon(
                                  Icons.visibility,
                                  color: Color.fromARGB(255, 127, 166, 233),
                                ),
                                icon: Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 127, 166, 233),
                                  size: 19,
                                ),
                                labelText: "تأكيد كلمة المرور:",
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim())
                              .then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage())));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 127, 166, 233)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27))),
                        ),
                        child: Text(
                          "إنشاء حساب",
                          style:
                              TextStyle(fontSize: 20, fontFamily: "Tajawal-l"),
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
                    ],
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
