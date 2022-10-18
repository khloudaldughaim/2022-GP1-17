import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nozol_application/firebase_options.dart';
import 'package:nozol_application/pages/homapage.dart';
import 'package:nozol_application/pages/navigationbar.dart';
import 'package:nozol_application/registration/log_in.dart';
import 'package:nozol_application/registration/sign_up.dart';
import 'package:nozol_application/registration/welcom_page.dart';

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
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => const Welcome(),
      '/signup': (context) => const SignUp(),
      '/login': (context) => const LogIn(),
      '/NavigationBar': (context) => const NavigationBarPage(),
    });
  }
}
