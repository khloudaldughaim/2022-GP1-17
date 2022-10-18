// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
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
                        child: TextField(
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 127, 166, 233),
                              ),
                              hintText:
                                  "                                               :الأسم",
                              border: InputBorder.none),
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
                        child: TextField(
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.mail,
                                color: Color.fromARGB(255, 127, 166, 233),
                              ),
                              hintText:
                                  "                                : البريد الإلكتروني ",
                              border: InputBorder.none),
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
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.visibility,
                                color: Color.fromARGB(255, 127, 166, 233),
                              ),
                              suffixIcon: Icon(
                                Icons.lock,
                                color: Color.fromARGB(255, 127, 166, 233),
                                size: 19,
                              ),
                              hintText:
                                  "                              :كلمة المرور",
                              border: InputBorder.none),
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
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.visibility,
                                color: Color.fromARGB(255, 127, 166, 233),
                              ),
                              suffixIcon: Icon(
                                Icons.lock,
                                color: Color.fromARGB(255, 127, 166, 233),
                                size: 19,
                              ),
                              hintText:
                                  "                     :تأكيد كلمة المرور",
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        onPressed: () {},
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
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
