import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/pages/apartmentdetailes.dart';
import 'package:nozol_application/pages/complaintdetails.dart';
import 'package:nozol_application/pages/navigationbar.dart';
import 'package:nozol_application/pages/villadetailes.dart';
import 'package:nozol_application/pages/buildingdetailes.dart';
import 'package:nozol_application/pages/landdetailes.dart';
import 'package:nozol_application/pages/apartment.dart';
import 'package:nozol_application/pages/villa.dart';
import 'package:nozol_application/pages/building.dart';
import 'package:nozol_application/pages/land.dart';

class MyComplaints extends StatefulWidget {
  const MyComplaints({super.key});

  @override
  State<MyComplaints> createState() => _MyComplaintsState();
}

class _MyComplaintsState extends State<MyComplaints> {
  @override
  Widget build(BuildContext context) {
    String id = getuser();
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: 110,
                width: MediaQuery.of(context).size.width,
                child: AppBar(
                  backgroundColor: const Color.fromARGB(255, 127, 166, 233),
                  automaticallyImplyLeading: false,
                  title: const Padding(
                    padding: EdgeInsets.only(left: 155),
                    child: Text("بلاغاتي",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: "Tajawal-m",
                          color: Color.fromARGB(255, 231, 232, 233),
                        )),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const NavigationBarPage()));
                        },
                        child: const Icon(
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
                        text: 'تمت المعالجة',
                      ),
                      Tab(
                        text: 'قيد المعالجة',
                      ),
                      Tab(
                        text: 'بانتظار المعالجة',
                      ),
                    ],
                  ),
                  toolbarHeight: 60,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: TabBarView(children: [
                  // tab 1 (تمت المعالجة)
                  FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('Complaints')
                          .where('user_id', isEqualTo: id)
                          .where('status', isEqualTo: 3)
                          .get(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                      ) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("لا يوجد بلاغات"),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => Card(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                              clipBehavior: Clip.antiAlias,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              )),
                              child: Container(
                                height: 115,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(119, 110, 110, 110),
                                    width: 1,
                                  ),
                                  color: const Color.fromARGB(235, 202, 222, 245),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10, left: 10, bottom: 5),
                                          child: SizedBox(
                                            width: 150,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ComplaintDetailes(
                                                            complaint_id: snapshot.data!.docs[index]
                                                                .data()['complaint_id'])));
                                              },
                                              child: const Text('تفاصيل البلاغ'),
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(
                                                  const Color.fromARGB(255, 127, 166, 233),
                                                ),
                                                shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(27))),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 17, right: 10, bottom: 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'بلاغ تمت معالجته',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Tajawal-m",
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text("تاريخ البلاغ : " +
                                                snapshot.data!.docs[index].data()['date']),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:5, left : 20, right: 20, bottom: 5),
                                      child: Text('العقار المبلغ عنه : ' 
                                        + snapshot.data!.docs[index].data()['type'] + ", "
                                        + snapshot.data!.docs[index].data()['city'] + ", "
                                        + snapshot.data!.docs[index].data()['neighborhood'],
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                  // tab 2 (قيد المعالجة)
                  FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('Complaints')
                          .where('user_id', isEqualTo: id)
                          .where('status', isEqualTo: 2)
                          .get(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                      ) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("لا يوجد بلاغات"),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => Card(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                              clipBehavior: Clip.antiAlias,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              )),
                              child: Container(
                                height: 115,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(119, 110, 110, 110),
                                    width: 1,
                                  ),
                                  color: const Color.fromARGB(235, 202, 222, 245),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10, left: 10, bottom: 5),
                                          child: SizedBox(
                                            width: 150,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ComplaintDetailes(
                                                            complaint_id: snapshot.data!.docs[index]
                                                                .data()['complaint_id'])));
                                              },
                                              child: const Text('تفاصيل البلاغ'),
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(
                                                  const Color.fromARGB(255, 127, 166, 233),
                                                ),
                                                shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(27))),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 17, right: 10, bottom: 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'بلاغ قيد المعالجة',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Tajawal-m",
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text("تاريخ البلاغ : " +
                                                snapshot.data!.docs[index].data()['date']),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:5, left : 20, right: 20, bottom: 5),
                                      child: Text('العقار المبلغ عنه : ' 
                                        + snapshot.data!.docs[index].data()['type'] + ", "
                                        + snapshot.data!.docs[index].data()['city'] + ", "
                                        + snapshot.data!.docs[index].data()['neighborhood'],
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                      //tab3 (بانتظار المعالجة)
                      FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('Complaints')
                          .where('user_id', isEqualTo: id)
                          .where('status', isEqualTo: 1)
                          .get(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                      ) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("لا يوجد بلاغات"),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => Card(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                              clipBehavior: Clip.antiAlias,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              )),
                              child: Container(
                                height: 115,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(119, 110, 110, 110),
                                    width: 1,
                                  ),
                                  color: const Color.fromARGB(235, 202, 222, 245),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10, left: 10, bottom: 5),
                                          child: SizedBox(
                                            width: 150,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ComplaintDetailes(
                                                            complaint_id: snapshot.data!.docs[index]
                                                                .data()['complaint_id'])));
                                              },
                                              child: const Text('تفاصيل البلاغ'),
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(
                                                  const Color.fromARGB(255, 127, 166, 233),
                                                ),
                                                shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(27))),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 17, right: 10, bottom: 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'بلاغ بانتظار المعالجة',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Tajawal-m",
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text("تاريخ البلاغ : " +
                                                snapshot.data!.docs[index].data()['date']),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:5, left : 20, right: 20, bottom: 5),
                                      child: Text('العقار المبلغ عنه : ' 
                                        + snapshot.data!.docs[index].data()['type'] + ", "
                                        + snapshot.data!.docs[index].data()['city'] + ", "
                                        + snapshot.data!.docs[index].data()['neighborhood'],
                                        textAlign: TextAlign.right,
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
          if (element.data()["type"] == "شقة") {
            Apartment apartment = Apartment.fromMap(element.data());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ApartmentDetailes(apartment: apartment)),
            );
          }
          if (element.data()["type"] == "عمارة") {
            Building building = Building.fromMap(element.data());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BuildingDetailes(building: building)),
            );
          }
          if (element.data()["type"] == "ارض") {
            Land land = Land.fromJson(element.data());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LandDetailes(land: land)),
            );
          }
        });
      });
    });
  }

  String getuser() {
    late FirebaseAuth auth = FirebaseAuth.instance;
    late User? user = auth.currentUser;
    var cpuid = user!.uid;
    return cpuid;
  }
}
