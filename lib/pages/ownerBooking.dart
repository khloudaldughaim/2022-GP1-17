// import 'dart:html';

//import 'dart:convert';

// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unused_local_variable, prefer_const_literals_to_create_immutables, unused_import, file_names, camel_case_types, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/pages/villa.dart';
import 'apartment.dart';
import 'apartmentdetailes.dart';
import 'building.dart';
import 'buildingdetailes.dart';
import 'filter.dart';
import 'homapage.dart';
import 'land.dart';
import 'landdetailes.dart';
import 'villadetailes.dart';
import 'package:label_marker/label_marker.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:nozol_application/pages/property.dart';

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

  late FutureBuilder<QuerySnapshot<Map<String, dynamic>>> prviosBookings =
      FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('bookings')
              .where('owner_id', isEqualTo: curentId)
              .where('status', isEqualTo: 'aproved')
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
                itemBuilder: (context, index) => Card(),
              );
            }
          });
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
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('ملغاة ', style: TextStyle(fontSize: 18)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('منتهية', style: TextStyle(fontSize: 18)),
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
                            onPressed: (int newIndex) {
                              setState(() {
                                for (int index = 0; index < isSelected.length; index++) {
                                  if (index == newIndex) {
                                    isSelected[index] = true;
                                  } else {
                                    isSelected[index] = false;
                                  }
                                  if (newIndex == 0 && isSelected[newIndex]) {
                                    prviosBookings = FutureBuilder<
                                            QuerySnapshot<Map<String, dynamic>>>(
                                        future: FirebaseFirestore.instance
                                            .collection('bookings')
                                            .where('owner_id', isEqualTo: curentId)
                                            .where('status', isEqualTo: 'cansled')
                                            .where("isExpired", isEqualTo: false)
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
                                                              image: NetworkImage(snapshot
                                                                  .data!.docs[index]
                                                                  .data()['Pimage']),
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
                                                                    color: Color.fromARGB(
                                                                        255, 238, 103, 19),
                                                                  ),
                                                                ),
                                                                width: 85,
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: 4),
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
                                                            Text(" صاحب الحجز :   " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['buyer_name']),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(" نوع الجولة :   " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['book_type']),
                                                            if (snapshot.data!.docs[index]
                                                                    .data()['book_type'] ==
                                                                'افتراضية')
                                                              Text(" التطبيق :   " +
                                                                  snapshot.data!.docs[index]
                                                                      .data()['videochat']),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(" رقم الحاجز :   " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['buyer_phone']),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(" التاريخ :   " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['Date']),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                FirebaseFirestore.instance
                                                                    .collection('properties')
                                                                    .where('property_id',
                                                                        isEqualTo: snapshot
                                                                            .data!.docs[index]
                                                                            .data()['property_id'])
                                                                    .get()
                                                                    .then((querySnapshot) {
                                                                  querySnapshot.docs
                                                                      .forEach((element) {
                                                                    setState(() {
                                                                      if (element["type"] ==
                                                                          "فيلا") {
                                                                        Villa villa = Villa.fromMap(
                                                                            element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  VillaDetailes(
                                                                                      villa:
                                                                                          villa)),
                                                                        );
                                                                      }
                                                                      ;
                                                                      if (element.data()["type"] ==
                                                                          "شقة") {
                                                                        Apartment apartment =
                                                                            Apartment.fromMap(
                                                                                element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  ApartmentDetailes(
                                                                                      apartment:
                                                                                          apartment)),
                                                                        );
                                                                      }
                                                                      ;
                                                                      if (element.data()["type"] ==
                                                                          "عمارة") {
                                                                        Building building =
                                                                            Building.fromMap(
                                                                                element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  BuildingDetailes(
                                                                                      building:
                                                                                          building)),
                                                                        );
                                                                      }
                                                                      ;
                                                                      if (element.data()["type"] ==
                                                                          "ارض") {
                                                                        Land land = Land.fromJson(
                                                                            element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  LandDetailes(
                                                                                      land: land)),
                                                                        );
                                                                      }
                                                                      ;
                                                                    });
                                                                  });
                                                                });
                                                              },
                                                              child: Text('تفاصيل العقار'),
                                                              style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                  Color.fromARGB(255, 82, 155, 210),
                                                                ),
                                                                shape: MaterialStateProperty.all(
                                                                    RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                27))),
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
                                        });
                                  } else if (newIndex == 1 && isSelected[newIndex]) {
                                    prviosBookings = FutureBuilder<
                                            QuerySnapshot<Map<String, dynamic>>>(
                                        future: FirebaseFirestore.instance
                                            .collection('bookings')
                                            .where('owner_id', isEqualTo: curentId)
                                            .where("isExpired", isEqualTo: true)
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
                                                              image: NetworkImage(snapshot
                                                                  .data!.docs[index]
                                                                  .data()['Pimage']),
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
                                                            if (snapshot.data!.docs[index]
                                                                    .data()['status'] ==
                                                                'aproved')
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(5),
                                                                    ),
                                                                    border: Border.all(
                                                                      width: 1.5,
                                                                      color: Color.fromARGB(
                                                                          255, 19, 238, 30),
                                                                    ),
                                                                  ),
                                                                  width: 85,
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical: 4),
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
                                                            if (snapshot.data!.docs[index]
                                                                    .data()['status'] ==
                                                                'cansled')
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(5),
                                                                    ),
                                                                    border: Border.all(
                                                                      width: 1.5,
                                                                      color: Color.fromARGB(
                                                                          255, 238, 103, 19),
                                                                    ),
                                                                  ),
                                                                  width: 85,
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical: 4),
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
                                                            if (snapshot.data!.docs[index]
                                                                    .data()['status'] ==
                                                                'dicline')
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(5),
                                                                    ),
                                                                    border: Border.all(
                                                                      width: 1.5,
                                                                      color: Color.fromARGB(
                                                                          255, 245, 11, 11),
                                                                    ),
                                                                  ),
                                                                  width: 85,
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical: 4),
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
                                                                snapshot.data!.docs[index]
                                                                    .data()['buyer_name']),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(" نوع الجولة :   " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['book_type']),
                                                            if (snapshot.data!.docs[index]
                                                                    .data()['book_type'] ==
                                                                'افتراضية')
                                                              Text(" التطبيق :   " +
                                                                  snapshot.data!.docs[index]
                                                                      .data()['videochat']),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(" رقم الحاجز :   " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['buyer_phone']),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(" التاريخ :   " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['Date']),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                FirebaseFirestore.instance
                                                                    .collection('properties')
                                                                    .where('property_id',
                                                                        isEqualTo: snapshot
                                                                            .data!.docs[index]
                                                                            .data()['property_id'])
                                                                    .get()
                                                                    .then((querySnapshot) {
                                                                  querySnapshot.docs
                                                                      .forEach((element) {
                                                                    setState(() {
                                                                      if (element["type"] ==
                                                                          "فيلا") {
                                                                        Villa villa = Villa.fromMap(
                                                                            element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  VillaDetailes(
                                                                                      villa:
                                                                                          villa)),
                                                                        );
                                                                      }
                                                                      ;
                                                                      if (element.data()["type"] ==
                                                                          "شقة") {
                                                                        Apartment apartment =
                                                                            Apartment.fromMap(
                                                                                element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  ApartmentDetailes(
                                                                                      apartment:
                                                                                          apartment)),
                                                                        );
                                                                      }
                                                                      ;
                                                                      if (element.data()["type"] ==
                                                                          "عمارة") {
                                                                        Building building =
                                                                            Building.fromMap(
                                                                                element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  BuildingDetailes(
                                                                                      building:
                                                                                          building)),
                                                                        );
                                                                      }
                                                                      ;
                                                                      if (element.data()["type"] ==
                                                                          "ارض") {
                                                                        Land land = Land.fromJson(
                                                                            element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  LandDetailes(
                                                                                      land: land)),
                                                                        );
                                                                      }
                                                                      ;
                                                                    });
                                                                  });
                                                                });
                                                              },
                                                              child: Text('تفاصيل العقار'),
                                                              style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                  Color.fromARGB(255, 82, 155, 210),
                                                                ),
                                                                shape: MaterialStateProperty.all(
                                                                    RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                27))),
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
                                        });
                                  } else if (newIndex == 2 && isSelected[newIndex]) {
                                    prviosBookings = FutureBuilder<
                                            QuerySnapshot<Map<String, dynamic>>>(
                                        future: FirebaseFirestore.instance
                                            .collection('bookings')
                                            .where('owner_id', isEqualTo: curentId)
                                            .where('status', isEqualTo: 'dicline')
                                            .where("isExpired", isEqualTo: false)
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
                                                              image: NetworkImage(snapshot
                                                                  .data!.docs[index]
                                                                  .data()['Pimage']),
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
                                                                    color: Color.fromARGB(
                                                                        255, 245, 11, 11),
                                                                  ),
                                                                ),
                                                                width: 85,
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: 4),
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
                                                                snapshot.data!.docs[index]
                                                                    .data()['buyer_name']),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(" نوع الجولة :   " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['book_type']),
                                                            if (snapshot.data!.docs[index]
                                                                    .data()['book_type'] ==
                                                                'افتراضية')
                                                              Text(" التطبيق :   " +
                                                                  snapshot.data!.docs[index]
                                                                      .data()['videochat']),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(" رقم الحاجز :   " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['buyer_phone']),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(" التاريخ :   " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['Date']),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                FirebaseFirestore.instance
                                                                    .collection('properties')
                                                                    .where('property_id',
                                                                        isEqualTo: snapshot
                                                                            .data!.docs[index]
                                                                            .data()['property_id'])
                                                                    .get()
                                                                    .then((querySnapshot) {
                                                                  querySnapshot.docs
                                                                      .forEach((element) {
                                                                    setState(() {
                                                                      if (element["type"] ==
                                                                          "فيلا") {
                                                                        Villa villa = Villa.fromMap(
                                                                            element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  VillaDetailes(
                                                                                      villa:
                                                                                          villa)),
                                                                        );
                                                                      }
                                                                      ;
                                                                      if (element.data()["type"] ==
                                                                          "شقة") {
                                                                        Apartment apartment =
                                                                            Apartment.fromMap(
                                                                                element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  ApartmentDetailes(
                                                                                      apartment:
                                                                                          apartment)),
                                                                        );
                                                                      }
                                                                      ;
                                                                      if (element.data()["type"] ==
                                                                          "عمارة") {
                                                                        Building building =
                                                                            Building.fromMap(
                                                                                element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  BuildingDetailes(
                                                                                      building:
                                                                                          building)),
                                                                        );
                                                                      }
                                                                      ;
                                                                      if (element.data()["type"] ==
                                                                          "ارض") {
                                                                        Land land = Land.fromJson(
                                                                            element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  LandDetailes(
                                                                                      land: land)),
                                                                        );
                                                                      }
                                                                      ;
                                                                    });
                                                                  });
                                                                });
                                                              },
                                                              child: Text('تفاصيل العقار'),
                                                              style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                  Color.fromARGB(255, 82, 155, 210),
                                                                ),
                                                                shape: MaterialStateProperty.all(
                                                                    RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                27))),
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
                                        });
                                  } else if (newIndex == 3 && isSelected[newIndex]) {
                                    prviosBookings = FutureBuilder<
                                            QuerySnapshot<Map<String, dynamic>>>(
                                        future: FirebaseFirestore.instance
                                            .collection('bookings')
                                            .where('owner_id', isEqualTo: curentId)
                                            .where('status', isEqualTo: 'aproved')
                                            .where("isExpired", isEqualTo: false)
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
                                                  height: 250,

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
                                                              image: NetworkImage(snapshot
                                                                  .data!.docs[index]
                                                                  .data()['Pimage']),
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
                                                                    color: Color.fromARGB(
                                                                        255, 19, 238, 30),
                                                                  ),
                                                                ),
                                                                width: 85,
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: 4),
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
                                                            Text(" صاحب الحجز :   " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['buyer_name']),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(" نوع الجولة : " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['book_type']),
                                                            if (snapshot.data!.docs[index]
                                                                    .data()['book_type'] ==
                                                                'افتراضية')
                                                              Text(" التطبيق :   " +
                                                                  snapshot.data!.docs[index]
                                                                      .data()['videochat']),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(" رقم الحاجز :  " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['buyer_phone']),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(" التاريخ :   " +
                                                                snapshot.data!.docs[index]
                                                                    .data()['Date']),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                FirebaseFirestore.instance
                                                                    .collection('properties')
                                                                    .where('property_id',
                                                                        isEqualTo: snapshot
                                                                            .data!.docs[index]
                                                                            .data()['property_id'])
                                                                    .get()
                                                                    .then((querySnapshot) {
                                                                  querySnapshot.docs
                                                                      .forEach((element) {
                                                                    setState(() {
                                                                      if (element["type"] ==
                                                                          "فيلا") {
                                                                        Villa villa = Villa.fromMap(
                                                                            element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  VillaDetailes(
                                                                                      villa:
                                                                                          villa)),
                                                                        );
                                                                      }
                                                                      ;
                                                                      if (element.data()["type"] ==
                                                                          "شقة") {
                                                                        Apartment apartment =
                                                                            Apartment.fromMap(
                                                                                element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  ApartmentDetailes(
                                                                                      apartment:
                                                                                          apartment)),
                                                                        );
                                                                      }
                                                                      ;
                                                                      if (element.data()["type"] ==
                                                                          "عمارة") {
                                                                        Building building =
                                                                            Building.fromMap(
                                                                                element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  BuildingDetailes(
                                                                                      building:
                                                                                          building)),
                                                                        );
                                                                      }
                                                                      ;
                                                                      if (element.data()["type"] ==
                                                                          "ارض") {
                                                                        Land land = Land.fromJson(
                                                                            element.data());
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  LandDetailes(
                                                                                      land: land)),
                                                                        );
                                                                      }
                                                                      ;
                                                                    });
                                                                  });
                                                                });
                                                              },
                                                              child: Text('تفاصيل العقار'),
                                                              style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                  Color.fromARGB(255, 82, 155, 210),
                                                                ),
                                                                shape: MaterialStateProperty.all(
                                                                    RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                27))),
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
                                        });
                                  }
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                            child:
                                SizedBox(height: 300, child: prviosBookings)) // toogle buttons list
                      ],
                    ),
                    FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('bookings')
                            .where('owner_id', isEqualTo: curentId)
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
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 9,
                                            ),
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
                                                  onPressed: () async {
                                                    await FirebaseFirestore.instance
                                                        .collection('bookings')
                                                        .doc(snapshot.data!.docs[index]
                                                            .data()['book_id'])
                                                        .update({
                                                      "status": "aproved",
                                                    });
                                                    setState(() {});
                                                  },
                                                  child: Text('قبول'),
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(
                                                        Color.fromARGB(255, 72, 169, 138)),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(27))),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      FirebaseFirestore.instance
                                                          .collection('bookings')
                                                          .doc(snapshot.data!.docs[index]
                                                              .data()['book_id'])
                                                          .update({
                                                        "status": "dicline",
                                                      });
                                                    });
                                                  },
                                                  child: Text('رفض'),
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
                                                FirebaseFirestore.instance
                                                    .collection('properties')
                                                    .where('property_id',
                                                        isEqualTo: snapshot.data!.docs[index]
                                                            .data()['property_id'])
                                                    .get()
                                                    .then((querySnapshot) {
                                                  querySnapshot.docs.forEach((element) {
                                                    setState(() {
                                                      if (element["type"] == "فيلا") {
                                                        Villa villa = Villa.fromMap(element.data());
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  VillaDetailes(villa: villa)),
                                                        );
                                                      }
                                                      ;
                                                      if (element.data()["type"] == "شقة") {
                                                        Apartment apartment =
                                                            Apartment.fromMap(element.data());
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ApartmentDetailes(
                                                                      apartment: apartment)),
                                                        );
                                                      }
                                                      ;
                                                      if (element.data()["type"] == "عمارة") {
                                                        Building building =
                                                            Building.fromMap(element.data());
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BuildingDetailes(
                                                                      building: building)),
                                                        );
                                                      }
                                                      ;
                                                      if (element.data()["type"] == "ارض") {
                                                        Land land = Land.fromJson(element.data());
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LandDetailes(land: land)),
                                                        );
                                                      }
                                                      ;
                                                    });
                                                  });
                                                });
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
}
