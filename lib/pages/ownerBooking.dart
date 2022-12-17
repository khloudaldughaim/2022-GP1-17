// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ownerBooking extends StatefulWidget {
  // const myBookings({super.key});
 // final String property_id;
  //myBookings({required this.property_id});

  const ownerBooking({Key? key}) : super(key: key);
  @override
  State<ownerBooking> createState() => _myBookingsState();
}

class _myBookingsState extends State<ownerBooking> {
  // tthis is the toogle button lable
  List<String> lables = ['مرفوضة', 'مقبولة', 'منتهية', 'ملغاة'];
  List<bool> isSelected = [true, false, false, false];
  var tt = Text("hello");

  List<dynamic> newBookings = []; //1
  List<dynamic> cansled = []; //2
  List<dynamic> expired = []; //3
  List<dynamic> rejected = []; //4
  List<dynamic> accepted = []; //5


  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String curentId = user!.uid;
  



  Widget _handleSnapshot(   // step 1
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Text("حصل خطأً ما");
    }
    if (!snapshot.hasData) {
      return Text("لا يوجد بيانات");
    }
    if (snapshot.hasData) {
      if (newBookings.isEmpty) {
        _handleData(snapshot.data!);
      }
    }
    return Container();
  }


  void _handleData(QuerySnapshot<Map<String, dynamic>> data) async { // step 2
    try {
      newBookings.clear();
      cansled.clear();
      expired.clear();
      rejected.clear();
      accepted.clear();

     data.docs.forEach ((element)  {
        if (element.data()["status"] == "pending") {
         newBookings.add(element.data());
           print(element.data()['status']);
        }
       
      });
      // Future.delayed(Duration(seconds: 10), () {
      //   setState(() {});
      // });
    } catch (e) {
      debugPrint(e.toString());
    }
  }


//  Widget _handleListItems(List<dynamic> listItem) {
//     return ListView.separated(
//       itemCount: listItem.length,
//       separatorBuilder: (BuildContext context, int index) {
//         return SizedBox(height: 10);
//       },
//       itemBuilder: (BuildContext context, int index) {
//         if (listItem[index] is Villa) {
//           return _buildVillaItem(listItem[index] as Villa, context);
//         }
//         return Container();
//       },
//     );
//   }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 110,
              width: MediaQuery.of(context).size.width,
              child: AppBar(
                backgroundColor: Color.fromARGB(255, 138, 174, 222),
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.only(left: 155),
                  child: Text("حجوزاتي",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Tajawal-m",
                        color: Color.fromARGB(255, 231, 232, 233),
                      )),
                ),
                actions: const [],
                bottom: const TabBar(
                  labelStyle: TextStyle(
                    fontFamily: "Tajawal-b",
                    fontWeight: FontWeight.w100,
                  ),
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      text: 'السابقة',
                    ),
                    Tab(
                      text: 'الجديدة',
                    ),
                  ],
                ),
                toolbarHeight: 60,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: TabBarView(children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 185, 217, 243),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ToggleButtons(
                        isSelected: isSelected,
                        selectedColor: Colors.white,
                        color: Color.fromARGB(255, 2, 73, 144),
                        fillColor: Color.fromARGB(255, 82, 155, 210),
                        renderBorder: false,
                        borderWidth: 1,
                        borderColor: Colors.lightBlue.shade900,
                        selectedBorderColor: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(50),
                        // highlightColor: Color.fromARGB(255, 238, 238, 243),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child:
                                Text('ملغاة ', style: TextStyle(fontSize: 18)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child:
                                Text('منتهية', style: TextStyle(fontSize: 18)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child:
                                Text('مرفوضة', style: TextStyle(fontSize: 18)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child:
                                Text('مقبولة', style: TextStyle(fontSize: 18)),
                          ),
                        ],
                        onPressed: (int newIndex) {
                          setState(() {
                            for (int index = 0;
                                index < isSelected.length;
                                index++) {
                              if (index == newIndex) {
                                isSelected[index] = true;
                              } else {
                                isSelected[index] = false;
                              }
                              if (newIndex == 0 && isSelected[newIndex]) {
                                Text("i am index 0");
                              } else if (newIndex == 1 &&
                                  isSelected[newIndex]) {
                                Text("i am index 1");
                              } else if (newIndex == 2 &&
                                  isSelected[newIndex]) {
                                Text("i am index 2");
                              } else if (newIndex == 3 &&
                                  isSelected[newIndex]) {
                                Text("i am index 3");
                              }
                            }
                          });
                        },
                      ),
                    ),
                    // tt
                  ],
                ),
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance.collection('bookings').where('owner_id', isEqualTo: curentId )
                        .where('status', isEqualTo: 'pending')
                        .get(),
                       builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                  ) {
                    return _handleSnapshot(snapshot);
                  },
                ),
              ]),
            ),
          ],
        ),
      )),
    );
  }
}
