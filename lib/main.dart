// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nozol_application/firebase_options.dart';
import 'package:nozol_application/pages/homapage.dart';
import 'package:nozol_application/pages/navigationbar.dart';
import 'package:nozol_application/registration/forgetPassword.dart';
import 'package:nozol_application/registration/log_in.dart';
import 'package:nozol_application/registration/sign_up.dart';
import 'package:nozol_application/registration/welcom_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root
  // of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ar', 'AE'),
        ],
        initialRoute: '/',
        routes: {
          '/': (context) => const Welcome(),
          '/signup': (context) => const SignUp(),
          '/login': (context) => const LogIn(),
          '/homepage': (context) => const HomePage(),
          '/NavigationBar': (context) => const NavigationBarPage(),
          '/forgetPassword': (context) => const forgetPassword(),
        });
  }
}
