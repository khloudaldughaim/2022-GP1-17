import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart" ;
import 'package:nozol_application/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nozol_application/pages/chats.dart';
import 'package:nozol_application/pages/favorite.dart';
import 'package:nozol_application/pages/homapage.dart';
import 'package:nozol_application/pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  List<Widget> widgetList = const [
    HomePage(),
    ChatsPage(),
    FavoritePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetList[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 30, 133, 218),
        //backgroundColor: Color.fromARGB(255, 97, 184, 255),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        onTap: (index) {
          setState(() {
            currentIndex = index ;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "محادثة",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "المفضلة",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "حسابي",
          ),
        ],
      ),
    );
  }
}