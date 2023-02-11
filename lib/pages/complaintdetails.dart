import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import '../registration/sign_up.dart';

class ComplaintDetailes extends StatefulWidget {
  final String complaint_id;

  ComplaintDetailes({required this.complaint_id});

  @override
  State<ComplaintDetailes> createState() => _ComplaintDetailesState();
}

class _ComplaintDetailesState extends State<ComplaintDetailes> {
  final complaintformkey = GlobalKey<FormState>();

  var name = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var reason = TextEditingController();

  @override
  void initState() {
    getCcomplaint();
    super.initState();
  }

  Future<void> getCcomplaint() async {
    var docs = await FirebaseFirestore.instance.collection('Complaints').get();
    name = TextEditingController();
    phone = TextEditingController();
    email = TextEditingController();
    reason = TextEditingController();
    docs.docs.forEach((element) {
      if (element["complaint_id"] == widget.complaint_id) {
        name = TextEditingController(text: element["name"]);
        phone = TextEditingController(text: element["phone"]);
        email = TextEditingController(text: element["email"]);
        reason = TextEditingController(text: element["reason"]);
      }
    });
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 127, 166, 233),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 140),
            child: Text("تفاصيل البلاغ",
              style: TextStyle(
                fontSize: 17,
                fontFamily: "Tajawal-m",
                color: Color.fromARGB(255, 231, 232, 233),
              )
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Form(
                      key: complaintformkey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                controller: name,
                                readOnly: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: "الأسم :",
                                  labelStyle: TextStyle(fontFamily: "Tajawal-b"),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Color.fromARGB(255, 127, 166, 233),
                                  ),
                                  fillColor: Color.fromARGB(255, 225, 225, 228),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(66.0),
                                      borderSide:
                                        const BorderSide(width: 0, style: BorderStyle.none)),
                                ),
                              ),
                            )
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  controller: email,
                                  readOnly: true,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: "الإيميل  :",
                                    labelStyle: TextStyle(fontFamily: "Tajawal-b"),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                    ),
                                    fillColor: Color.fromARGB(255, 225, 225, 228),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(66.0),
                                        borderSide:
                                          const BorderSide(width: 0, style: BorderStyle.none)),
                                  ),
                                ),
                              )
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                controller: phone,
                                readOnly: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: "رقم الجوال  :",
                                  labelStyle: TextStyle(fontFamily: "Tajawal-b"),
                                  prefixIcon: Icon(
                                    Icons.phone_android,
                                    color: Color.fromARGB(255, 127, 166, 233),
                                  ),
                                  fillColor: Color.fromARGB(255, 225, 225, 228),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(66.0),
                                      borderSide:
                                        const BorderSide(width: 0, style: BorderStyle.none)),
                                ),
                              ),
                            )
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  maxLines: 6,
                                  controller: reason,
                                  readOnly: true,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: "سبب البلاغ  :",
                                    labelStyle: TextStyle(fontFamily: "Tajawal-b"),
                                    contentPadding:EdgeInsets.all(40.0),
                                    fillColor: Color.fromARGB(255, 225, 225, 228),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(33.0),
                                        borderSide:
                                          const BorderSide(width: 0, style: BorderStyle.none)),
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}