import 'package:flutter/material.dart';
import 'package:nozol_application/registration/welcom_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetowelcom();
  }

  _navigatetowelcom() async {
    await Future.delayed(Duration(microseconds: 1700), () {});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Welcome()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo2.png",
          width: 300,
        ),
      ),
    );
  }
}
