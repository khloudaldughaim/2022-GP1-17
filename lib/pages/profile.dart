// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/registration/log_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Text('ProfilePage'),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LogIn())));
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Color.fromARGB(255, 127, 166, 233)),
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27))),
            ),
            child: Text(
              "تسجيل خروج",
              style: TextStyle(fontSize: 20, fontFamily: "Tajawal-l"),
            ),
          ),
        ]),
      ),
    );
  }
}
