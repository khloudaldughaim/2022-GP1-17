// import 'dart:html';

//import 'dart:convert';

// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:nozol_application/pages/property.dart';

//import 'OwnerBookingDetails.dart';

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
  var property;

  List<dynamic> newBookings = []; //1
  List<dynamic> cansled = []; //2
  List<dynamic> expired = []; //3
  List<dynamic> rejected = []; //4
  List<dynamic> accepted = []; //5

  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String curentId = user!.uid;

  var i = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromARGB(235, 202, 222, 245),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('ملغاة ',
                                    style: TextStyle(fontSize: 18)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('منتهية',
                                    style: TextStyle(fontSize: 18)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('مرفوضة',
                                    style: TextStyle(fontSize: 18)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('مقبولة',
                                    style: TextStyle(fontSize: 18)),
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
                        future: FirebaseFirestore.instance
                            .collection('bookings')
                            .where('owner_id', isEqualTo: curentId)
                            .where('status', isEqualTo: 'pending')
                            .get(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot,
                        ) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text("no data"),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) => Card(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                )),
                                child: Container(
                                  height: 160,

                                  // ignore: prefer_const_constructors
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(snapshot
                                                  .data!.docs[index]
                                                  .data()['Pimage']),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'حجز جديد',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Tajawal-m",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            Text("نوع الحجز " +
                                                snapshot.data!.docs[index]
                                                    .data()['book_type']),
                                            SizedBox(
                                              height: 20,
                                              width: 120,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             OwnerBookingDetails(
                                                  //               property_id: snapshot
                                                  //                       .data!
                                                  //                       .docs[index]
                                                  //                       .data()[
                                                  //                   'property_id'],
                                                  //               owner_id: snapshot
                                                  //                       .data!
                                                  //                       .docs[index]
                                                  //                       .data()[
                                                  //                   'owner_id'],
                                                  //               buyer_id: snapshot
                                                  //                       .data!
                                                  //                       .docs[index]
                                                  //                       .data()[
                                                  //                   'buyer_id'],
                                                  //               // Booking_id: snapshot
                                                  //               //         .data!
                                                  //               //         .docs[index]
                                                  //               //         .data()[
                                                  //               //     'booking_id'],
                                                  //             )));
                                                  FirebaseFirestore.instance
                                                      .collection('bookings')
                                                      .doc(snapshot
                                                          .data!.docs[index]
                                                          .data()['book_id'])
                                                      .update({
                                                    "status": "aproved",
                                                  });
                                                });
                                              },
                                              child: Text('قبول'),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Color.fromARGB(
                                                            255, 72, 125, 169)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  ]),
                ),
              ],
            ),
          )),
    );
  }
}

//  FirebaseFirestore.instance
//     .collection('properties')
//     .where('User_id', isEqualTo: curentId)
//     .get().then((querySnapshot) {
//    querySnapshot.docs.forEach((element)
//    {
//       if(element.data()["property_id"] == snapshot.data!.docs[9].data()['property_id'])
//       {
//        property = element.data()["images"][0] ;
//       }

//    });
//    i = 0;
//     });
