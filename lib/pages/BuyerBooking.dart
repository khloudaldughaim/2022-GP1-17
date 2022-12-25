// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unused_local_variable, prefer_const_literals_to_create_immutables, unused_import, file_names, camel_case_types, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/pages/apartment.dart';
import 'package:nozol_application/pages/building.dart';
import 'package:nozol_application/pages/land.dart';
import 'package:nozol_application/pages/villa.dart';
import 'apartmentdetailes.dart';
import 'buildingdetailes.dart';
import 'filter.dart';
import 'homapage.dart';
import 'landdetailes.dart';
import 'navigationbar.dart';
import 'villadetailes.dart';
import 'package:label_marker/label_marker.dart';
import 'profile.dart';
import 'booking_model.dart';

class BuyerBooking extends StatefulWidget {
  // const myBookings({super.key});
  // final String property_id;
  //myBookings({required this.property_id});

  const BuyerBooking({Key? key}) : super(key: key);
  @override
  State<BuyerBooking> createState() => _BuyerBookingsState();
}

class _BuyerBookingsState extends State<BuyerBooking> {
  List<bool> isSelected = [false, false, true];
  var property;

  List<BookingModel> newBookings = []; // 1
  List<BookingModel> canceled = []; // 2
  List<BookingModel> finished = []; // 3
  List<BookingModel> rejected = []; // 4
  List<BookingModel> accepted = []; // 5

  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String curentId = user!.uid;

  @override
  void initState() {
    super.initState();
    getBookings();
  }

  Future<void> getBookings() async {
    var docs = await FirebaseFirestore.instance.collection('bookings').get();
    newBookings = [];
    accepted = [];
    canceled = [];
    rejected = [];
    finished = [];
    docs.docs.forEach((element) {
      if (element["owner_id"] == curentId) {
        if (element["status"] == "pending") {
          newBookings.add(BookingModel.fromJson(element.data()));
        }
        if (element["status"] == "aproved") {
          accepted.add(BookingModel.fromJson(element.data()));
        }
        if (element["status"] == "cansled") {
          canceled.add(BookingModel.fromJson(element.data()));
        }
        if (element["status"] == "dicline") {
          rejected.add(BookingModel.fromJson(element.data()));
        }
        if (element["status"] == "finshed") {
          finished.add(BookingModel.fromJson(element.data()));
        }
      }
    });
    setState(() {});
  }

  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromARGB(235, 202, 222, 245),
          body: DefaultTabController(
            length: 3,
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
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => NavigationBarPage()));
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                    bottom: const TabBar(
                      labelStyle: TextStyle(
                        fontFamily: "Tajawal-b",
                        fontWeight: FontWeight.w100,
                      ),
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          text: 'الزيارات الماضية',
                        ),
                        Tab(
                          text: 'الزيارات القادمة',
                        ),
                        Tab(
                          text: 'قيد المعالجة',
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
                    FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        // tap 1
                        future: FirebaseFirestore.instance
                            .collection('bookings')
                            .where('owner_id', isEqualTo: curentId)
                            .where("isExpired", isEqualTo: true)
                            .get(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
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
                                  height: 250,

                                  // ignore: prefer_const_constructors
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                        child: Container(
                                          height: 140,
                                          width: 160,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  snapshot.data!.docs[index].data()['Pimage']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 3),
                                        child: SizedBox(
                                          height: 300,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 9,
                                              ),
                                              if (snapshot.data!.docs[index].data()['status'] ==
                                                  'aproved')
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                      border: Border.all(
                                                        width: 1.5,
                                                        color: Color.fromARGB(255, 19, 238, 30),
                                                      ),
                                                    ),
                                                    width: 85,
                                                    padding: EdgeInsets.symmetric(vertical: 4),
                                                    child: Center(
                                                      child: Text(
                                                        'حجز مقبول',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      ),
                                                    )),
                                              if (snapshot.data!.docs[index].data()['status'] ==
                                                  'cansled')
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                      border: Border.all(
                                                        width: 1.5,
                                                        color: Color.fromARGB(255, 115, 116, 121),
                                                      ),
                                                    ),
                                                    width: 85,
                                                    padding: EdgeInsets.symmetric(vertical: 4),
                                                    child: Center(
                                                      child: Text(
                                                        'حجز ملغي',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      ),
                                                    )),
                                              if (snapshot.data!.docs[index].data()['status'] ==
                                                  'dicline')
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                      border: Border.all(
                                                        width: 1.5,
                                                        color: Color.fromARGB(255, 245, 11, 11),
                                                      ),
                                                    ),
                                                    width: 85,
                                                    padding: EdgeInsets.symmetric(vertical: 4),
                                                    child: Center(
                                                      child: Text(
                                                        'حجز مرفوض',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      ),
                                                    )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(" صاحب الحجز :   " +
                                                  snapshot.data!.docs[index].data()['buyer_name']),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(" نوع الجولة :   " +
                                                  snapshot.data!.docs[index].data()['book_type']),
                                              if (snapshot.data!.docs[index].data()['book_type'] ==
                                                  'افتراضية')
                                                Text(" التطبيق :   " +
                                                    snapshot.data!.docs[index].data()['videochat']),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(" رقم الحاجز :   " +
                                                  snapshot.data!.docs[index].data()['buyer_phone']),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(" التاريخ :   " +
                                                  snapshot.data!.docs[index].data()['Date']),
                                              ElevatedButton(
                                                onPressed: () {
                                                  realtyDetails(snapshot.data!.docs[index]
                                                      .data()['property_id']);
                                                },
                                                child: Text('تفاصيل العقار'),
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all(
                                                    Color.fromARGB(255, 82, 155, 210),
                                                  ),
                                                  shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(27))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }), // end of tap 1

                    Column(
                      // tap 2
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
                                child: Text('ملغاة ', style: TextStyle(fontSize: 18)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('مرفوضة', style: TextStyle(fontSize: 18)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('مقبولة', style: TextStyle(fontSize: 18)),
                              ),
                            ],
                            onPressed: (int newIndex) async {
                              setState(() {
                                currentIndex = newIndex;
                                for (int index = 0; index < isSelected.length; index++) {
                                  if (index == newIndex) {
                                    isSelected[index] = true;
                                  } else {
                                    isSelected[index] = false;
                                  }
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 300,
                            child: Builder(
                              builder: (context) {
                                if (currentIndex == 0) {
                                  return ListView.separated(
                                    itemCount: canceled.length,
                                    separatorBuilder: (BuildContext context, int index) {
                                      return SizedBox(height: 10);
                                    },
                                    itemBuilder: (BuildContext context, int index) {
                                      return _buildCanceledItem(canceled[index]);
                                    },
                                  );
                                }
                                if (currentIndex == 1) {
                                  return ListView.separated(
                                    itemCount: rejected.length,
                                    separatorBuilder: (BuildContext context, int index) {
                                      return SizedBox(height: 10);
                                    },
                                    itemBuilder: (BuildContext context, int index) {
                                      return _buildRejectedItem(rejected[index]);
                                    },
                                  );
                                }
                                if (currentIndex == 2) {
                                  return ListView.separated(
                                    itemCount: accepted.length,
                                    separatorBuilder: (BuildContext context, int index) {
                                      return SizedBox(height: 10);
                                    },
                                    itemBuilder: (BuildContext context, int index) {
                                      return _buildAcceptedItem(accepted[index]);
                                    },
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ) // toogle buttons list
                      ],
                    ), // end of tap1
                    FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('bookings')
                            .where('buyer_id', isEqualTo: curentId)
                            .where('status', isEqualTo: 'pending')
                            .where("isExpired", isEqualTo: false)
                            .get(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
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
                                  height: 270,

                                  // ignore: prefer_const_constructors
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                        child: Container(
                                          height: 140,
                                          width: 160,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  snapshot.data!.docs[index].data()['Pimage']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 3),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 9,
                                            ),
                                            Text(
                                              'حجز قيد المعالجة',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Tajawal-m",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(" صاحب الحجز :   " +
                                                snapshot.data!.docs[index].data()['buyer_name']),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(" نوع الجولة :   " +
                                                snapshot.data!.docs[index].data()['book_type']),
                                            if (snapshot.data!.docs[index].data()['book_type'] ==
                                                'افتراضية')
                                              Text(" التطبيق :   " +
                                                  snapshot.data!.docs[index].data()['videochat']),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(" رقم الحاجز :   " +
                                                snapshot.data!.docs[index].data()['buyer_phone']),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(" التاريخ :   " +
                                                snapshot.data!.docs[index].data()['Date']),
                                            Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      FirebaseFirestore.instance
                                                          .collection('bookings')
                                                          .doc(snapshot.data!.docs[index]
                                                              .data()['book_id'])
                                                          .update({
                                                        "status": "cansled",
                                                        "isAvailable": true,
                                                      });
                                                    });
                                                  },
                                                  child: Text('إلغاء الحجز'),
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(
                                                        Color.fromARGB(255, 245, 68, 82)),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(27))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                realtyDetails(snapshot.data!.docs[index]
                                                    .data()['property_id']);
                                              },
                                              child: Text('تفاصيل العقار'),
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(
                                                  Color.fromARGB(255, 82, 155, 210),
                                                ),
                                                shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(27))),
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

  Card _buildAcceptedItem(BookingModel bookingModel) {
    return Card(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(15),
      )),
      child: Container(
        height: 290,

        // ignore: prefer_const_constructors
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Container(
                height: 140,
                width: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(bookingModel.pimage ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Column(
                children: [
                  SizedBox(
                    height: 9,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(
                          width: 1.5,
                          color: Color.fromARGB(255, 19, 238, 30),
                        ),
                      ),
                      width: 85,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Center(
                        child: Text(
                          'حجز مقبول',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal-m",
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(" صاحب الحجز :   " + (bookingModel.buyerName ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" نوع الجولة : " + (bookingModel.bookType ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  if (bookingModel.bookType == "افتراضية")
                    Text(" التطبيق :  " + (bookingModel.videochat ?? "")),
                  Text(" رقم الحاجز :  " + (bookingModel.buyerPhone ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" التاريخ :   " + (bookingModel.date ?? "")),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        FirebaseFirestore.instance
                            .collection('bookings')
                            .doc(bookingModel.bookId)
                            .update({
                          "status": "cansled",
                          "isAvailable": true,
                        });
                      });
                    },
                    child: Text('إلغاء الحجز'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 245, 68, 82)),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      realtyDetails(bookingModel.propertyId ?? "");
                    },
                    child: Text('تفاصيل العقار'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 82, 155, 210),
                      ),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildRejectedItem(BookingModel bookingModel) {
    return Card(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(15),
      )),
      child: Container(
        height: 250,

        // ignore: prefer_const_constructors
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Container(
                height: 140,
                width: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(bookingModel.pimage ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Column(
                children: [
                  SizedBox(
                    height: 9,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(
                          width: 1.5,
                          color: Color.fromARGB(255, 245, 11, 11),
                        ),
                      ),
                      width: 85,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Center(
                        child: Text(
                          'حجز مرفوض',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal-m",
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(" صاحب الحجز :   " + (bookingModel.buyerName ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" نوع الجولة :   " + (bookingModel.bookType ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  if (bookingModel.bookType == "افتراضية")
                    Text(" التطبيق :  " + (bookingModel.videochat ?? "")),
                  Text(" رقم الحاجز :   " + (bookingModel.buyerPhone ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" التاريخ :   " + (bookingModel.date ?? "")),
                  ElevatedButton(
                    onPressed: () {
                      realtyDetails(bookingModel.propertyId ?? "");
                    },
                    child: Text('تفاصيل العقار'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 82, 155, 210),
                      ),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildFinishedItem(BookingModel bookingModel) {
    return Card(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(15),
      )),
      child: Container(
        height: 250,

        // ignore: prefer_const_constructors
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Container(
                height: 140,
                width: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(bookingModel.pimage ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Column(
                children: [
                  SizedBox(
                    height: 9,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(
                          width: 1.5,
                          color: Color.fromARGB(255, 238, 212, 19),
                        ),
                      ),
                      width: 85,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Center(
                        child: Text(
                          'حجز منتهي',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal-m",
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(" صاحب الحجز :   " + (bookingModel.buyerName ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" نوع الجولة :   " + (bookingModel.bookType ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  if (bookingModel.bookType == "افتراضية")
                    Text(" التطبيق :  " + (bookingModel.videochat ?? "")),
                  Text(" رقم الحاجز :   " + (bookingModel.buyerPhone ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" التاريخ :   " + (bookingModel.date ?? "")),
                  ElevatedButton(
                    onPressed: () {
                      realtyDetails(bookingModel.propertyId ?? "");
                    },
                    child: Text('تفاصيل العقار'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 82, 155, 210),
                      ),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildCanceledItem(BookingModel bookingModel) {
    return Card(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(15),
      )),
      child: Container(
        height: 250,

        // ignore: prefer_const_constructors
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Container(
                height: 140,
                width: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(bookingModel.pimage ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Column(
                children: [
                  SizedBox(
                    height: 9,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(
                          width: 1.5,
                          color: Color.fromARGB(255, 238, 103, 19),
                        ),
                      ),
                      width: 85,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Center(
                        child: Text(
                          'حجز ملغي',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal-m",
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(" صاحب الحجز :   " + (bookingModel.buyerName ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" نوع الجولة :   " + (bookingModel.bookType ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" رقم الحاجز :   " + (bookingModel.buyerPhone ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" التاريخ :   " + (bookingModel.date ?? "")),
                  ElevatedButton(
                    onPressed: () {
                      realtyDetails(bookingModel.propertyId ?? "");
                    },
                    child: Text('تفاصيل العقار'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 82, 155, 210),
                      ),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void realtyDetails(Object isEqualTo) {
    FirebaseFirestore.instance
        .collection('properties')
        .where('property_id', isEqualTo: isEqualTo)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        setState(() {
          if (element["type"] == "فيلا") {
            Villa villa = Villa.fromMap(element.data());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VillaDetailes(villa: villa)),
            );
          }
          ;
          if (element.data()["type"] == "شقة") {
            Apartment apartment = Apartment.fromMap(element.data());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ApartmentDetailes(apartment: apartment)),
            );
          }
          ;
          if (element.data()["type"] == "عمارة") {
            Building building = Building.fromMap(element.data());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BuildingDetailes(building: building)),
            );
          }
          ;
          if (element.data()["type"] == "ارض") {
            Land land = Land.fromJson(element.data());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LandDetailes(land: land)),
            );
          }
          ;
        });
      });
    });
  }
}
