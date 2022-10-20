import 'package:flutter/material.dart';
import 'package:nozol_application/pages/add.dart';
import 'package:nozol_application/pages/chats.dart';
import 'package:nozol_application/pages/favorite.dart';
import 'package:nozol_application/pages/homapage.dart';
import 'package:nozol_application/pages/profile.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({Key? key}) : super(key: key);

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int currentIndex = 0;

  List<Widget> widgetList = const [
    HomePage(),
    ChatsPage(),
    AddPage(),
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
        selectedLabelStyle: TextStyle(fontFamily: "Tajawal-b"),
        unselectedLabelStyle: TextStyle(fontFamily: "Tajawal-b"),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 127, 166, 233),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        onTap: (index) {
          setState(() {
            currentIndex = index;
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
            icon: Icon(Icons.add),
            label: "إضافة",
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
