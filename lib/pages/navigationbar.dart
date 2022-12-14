// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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

  List<Widget> widgetList = [
    HomePage(),
    ChatsPage(),
    AddPage(),
    FavoritePage(),
    ProfilePage(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomePage();

  // New Lines
  late StreamSubscription<bool> keyboardSubscription;
  late bool isKeyboardOpening;

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print('Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');
    isKeyboardOpening = keyboardVisibilityController.isVisible;
    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      setState(() {
        isKeyboardOpening = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentScreen, //PageStorage(
        //   child: currentScreen,
        //   bucket: bucket,
        // ),
        floatingActionButton: isKeyboardOpening
            ? Container()
            : FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Color.fromARGB(255, 127, 166, 233),
                onPressed: () {
                  setState(() {
                    currentScreen = AddPage();
                    currentIndex = 3;
                  });
                },
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = HomePage();
                          currentIndex = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            color: currentIndex == 0
                                ? Color.fromARGB(255, 127, 166, 233)
                                : Colors.grey,
                          ),
                          Text(
                            '????????????????',
                            style: TextStyle(
                              fontFamily: "Tajawal-b",
                              color: currentIndex == 0
                                  ? Color.fromARGB(255, 127, 166, 233)
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = ChatsPage();
                          currentIndex = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat,
                            color: currentIndex == 1
                                ? Color.fromARGB(255, 127, 166, 233)
                                : Colors.grey,
                          ),
                          Text(
                            '????????????',
                            style: TextStyle(
                              fontFamily: "Tajawal-b",
                              color: currentIndex == 1
                                  ? Color.fromARGB(255, 127, 166, 233)
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ), // right tab bar

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = FavoritePage();
                          currentIndex = 4;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: currentIndex == 4
                                ? Color.fromARGB(255, 127, 166, 233)
                                : Colors.grey,
                          ),
                          Text(
                            '??????????????',
                            style: TextStyle(
                              fontFamily: "Tajawal-b",
                              color: currentIndex == 4
                                  ? Color.fromARGB(255, 127, 166, 233)
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = ProfilePage();
                          currentIndex = 5;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: currentIndex == 5
                                ? Color.fromARGB(255, 127, 166, 233)
                                : Colors.grey,
                          ),
                          Text(
                            '??????????',
                            style: TextStyle(
                              fontFamily: "Tajawal-b",
                              color: currentIndex == 5
                                  ? Color.fromARGB(255, 127, 166, 233)
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        // bottomNavigationBar: BottomNavigationBar(
        //   selectedLabelStyle: TextStyle(fontFamily: "Tajawal-b"),
        //   unselectedLabelStyle: TextStyle(fontFamily: "Tajawal-b"),
        //   type: BottomNavigationBarType.fixed,
        //   backgroundColor: const Color.fromARGB(255, 127, 166, 233),
        //   selectedItemColor: Colors.white,
        //   unselectedItemColor: Colors.white60,
        //   onTap: (index) {
        //     setState(() {
        //       currentIndex = index;
        //     });
        //   },
        //   currentIndex: currentIndex,
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: "????????????????",
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.chat),
        //       label: "????????????",
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.add),
        //       label: "??????????",
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.favorite),
        //       label: "??????????????",
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.person),
        //       label: "??????????",
        //     ),
        //   ],
        // ),
        );
  }
}
