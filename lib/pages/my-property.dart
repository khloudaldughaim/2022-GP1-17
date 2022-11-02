import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/pages/profile.dart';
import 'package:nozol_application/pages/property.dart';

import 'homapage.dart';

class myProperty extends StatefulWidget {
  const myProperty({super.key});

  @override
  State<myProperty> createState() => _myPropertyState();
}

class _myPropertyState extends State<myProperty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 127, 166, 233),
        title: const Text('عقارتي',
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Tajawal-b",
            )),
      ),
      // body: StreamBuilder<List<Property>>(
      //   stream: readmyPropertys(),
      //   builder: ((context, snapshot) {
      //     if (snapshot.hasError) {
      //       return Text('Something went wrong! ${snapshot.error}');
      //     } else if (snapshot.hasData) {
      //       final properties = snapshot.data!;
      //       return ListView(
      //           children: List.generate(properties.length, (index) {
      //         return buildProperty(properties[index], context);
      //       }));
      //     } else {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   }),
      // ),
    );
  }
}

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final nuid = user!.uid;

// Stream<List<Property>> readmyPropertys() => FirebaseFirestore.instance
//     .collection('properties')
//     .where('user_id', isEqualTo: nuid)
//     .snapshots()
//     .map((snapshot) =>
//         snapshot.docs.map((doc) => Property.fromJson(doc.data())).toList());
