// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
   int MassageCounter = 0 ;

  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String curentId = user!.uid;


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
                            'الرئيسية',
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
                      child :  FirebaseAuth.instance.currentUser == null ?
                        Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat,
                            color: currentIndex == 1
                                ? Color.fromARGB(255, 127, 166, 233)
                                : Colors.grey,
                          ),
                          Text(
                            'محادثة',
                            style: TextStyle(
                              fontFamily: "Tajawal-b",
                              color: currentIndex == 1
                                  ? Color.fromARGB(255, 127, 166, 233)
                                  : Colors.grey,
                            ),
                          )
                        ],
                      )                     
                      : StreamBuilder(
                              stream:  FirebaseFirestore.instance
                                .collection('Standard_user')
                                .doc(curentId)
                                .collection('messages')
                                .where("is_show_last_message", isEqualTo: false)
                                .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                 if (snapshot.data.docs.length <  1) {
                          MassageCounter = 0;
                          print("this is counter: " + MassageCounter.toString());
                          return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat,
                                        color: currentIndex == 1
                                            ? Color.fromARGB(255, 127, 166, 233)
                                            : Colors.grey,
                                      ),
                                      Text(
                                        'محادثة',
                                        style: TextStyle(
                                          fontFamily: "Tajawal-b",
                                          color: currentIndex == 1
                                              ? Color.fromARGB(255, 127, 166, 233)
                                              : Colors.grey,
                                        ),
                                      )
                                    ],
                                 );
                                  } else {
                                    MassageCounter = snapshot.data.docs.length;
                                    print("this is counter2: " + MassageCounter.toString());
                                    print("this length of snapshot:"+snapshot.data.docs.length.toString());
                                        return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Row(
                                      //   children: [
                                      //     SizedBox(
                                      //       width: 15,
                                      //     ),
                                      //     Material(
                                      //       borderRadius: BorderRadius.circular(8),
                                      //       color: Colors.blue,
                                      //       child: SizedBox(
                                      //         width: 18,
                                      //         height: 18,
                                      //         child: Padding(
                                      //           padding: const EdgeInsets.only(
                                      //             left: 5,
                                      //             right: 5,
                                      //             top: 2,
                                      //             bottom: 1,
                                      //           ),
                                      //           child: Center(
                                      //             child: Text(
                                      //               '${MassageCounter > 99 ? '99+' : MassageCounter}',
                                      //               style: const TextStyle(
                                      //                 fontSize: 10,
                                      //                 color: Colors.white,
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ), // row 
                                       Stack(
                                            children: <Widget>[
                                              Icon(Icons.chat ,  color: currentIndex == 1
                                            ? Color.fromARGB(255, 127, 166, 233)
                                          : Colors.grey,),
                                              Positioned(
                                                right:-1,
                                                top: 0,
                                                child: Container(
                                                  // padding: EdgeInsets.all(1),
                                                 padding : const EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 2,
                                            bottom: 2,
                                          ),
                                                  decoration:  BoxDecoration(
                                                    color: Color.fromARGB(255, 218, 27, 27),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  constraints: BoxConstraints(
                                                    minWidth: 10,
                                                    minHeight: 10,
                                                    maxHeight: 30,
                                                    maxWidth: 30
                                                  ),
                                                  child:  Text(
                                                     '${MassageCounter > 99 ? '99+' : MassageCounter}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                      // Icon(
                                      //   Icons.chat,
                                      //   color: currentIndex == 1
                                      //       ? Color.fromARGB(255, 127, 166, 233)
                                      //       : Colors.grey,
                                      // ),
                                      Text(
                                        'محادثة',
                                        style: TextStyle(
                                          fontFamily: "Tajawal-b",
                                          color: currentIndex == 1
                                              ? Color.fromARGB(255, 127, 166, 233)
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  );
      }
                                // return Column(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Icon(
                                //         Icons.chat,
                                //         color: currentIndex == 1
                                //             ? Color.fromARGB(255, 127, 166, 233)
                                //             : Colors.grey,
                                //       ),
                                //       Text(
                                //         'محادثة',
                                //         style: TextStyle(
                                //           fontFamily: "Tajawal-b",
                                //           color: currentIndex == 1
                                //               ? Color.fromARGB(255, 127, 166, 233)
                                //               : Colors.grey,
                                //         ),
                                //       )
                                //     ],
                                //  );
                              }
                            ), //stream builder 




                      ///////////////////////////////////////////////////////////////////////////
                      // child: Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Icon(
                      //       Icons.chat,
                      //       color: currentIndex == 1
                      //           ? Color.fromARGB(255, 127, 166, 233)
                      //           : Colors.grey,
                      //     ),
                      //     Text(
                      //       'محادثة',
                      //       style: TextStyle(
                      //         fontFamily: "Tajawal-b",
                      //         color: currentIndex == 1
                      //             ? Color.fromARGB(255, 127, 166, 233)
                      //             : Colors.grey,
                      //       ),
                      //     )
                      //   ],
                      // ), //original column
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
                            'المفضله',
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
                            'حسابي',
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
        //       label: "الرئيسية",
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.chat),
        //       label: "محادثة",
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.add),
        //       label: "إضافة",
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.favorite),
        //       label: "المفضلة",
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.person),
        //       label: "حسابي",
        //     ),
        //   ],
        // ),
        );
  }
}
