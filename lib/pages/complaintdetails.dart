import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  var Admin_Response = TextEditingController();

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
    Admin_Response = TextEditingController();
    docs.docs.forEach((element) {
      if (element["complaint_id"] == widget.complaint_id) {
        name = TextEditingController(text: element["name"]);
        phone = TextEditingController(text: element["phone"]);
        email = TextEditingController(text: element["email"]);
        reason = TextEditingController(text: element["reason"]);
        try {
          Admin_Response = TextEditingController(text: element["Admin_Respnse"]);
        } catch (e) {
          Admin_Response = TextEditingController(text: "");
        }
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 127, 166, 233),
          automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.only(left: 140),
            child: Text("تفاصيل البلاغ",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: "Tajawal-b",
                  color: Color.fromARGB(255, 231, 232, 233),
                )),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
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
                    padding: const EdgeInsets.only(top: 20),
                    child: Form(
                      key: complaintformkey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  controller: name,
                                  readOnly: true,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: "الأسم :",
                                    labelStyle: const TextStyle(fontFamily: "Tajawal-b"),
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                    ),
                                    fillColor: const Color.fromARGB(255, 225, 225, 228),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(66.0),
                                        borderSide:
                                            const BorderSide(width: 0, style: BorderStyle.none)),
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  controller: email,
                                  readOnly: true,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: "الإيميل  :",
                                    labelStyle: const TextStyle(fontFamily: "Tajawal-b"),
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                    ),
                                    fillColor: const Color.fromARGB(255, 225, 225, 228),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(66.0),
                                        borderSide:
                                            const BorderSide(width: 0, style: BorderStyle.none)),
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  controller: phone,
                                  readOnly: true,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: "رقم الجوال  :",
                                    labelStyle: const TextStyle(fontFamily: "Tajawal-b"),
                                    prefixIcon: const Icon(
                                      Icons.phone_android,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                    ),
                                    fillColor: const Color.fromARGB(255, 225, 225, 228),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(66.0),
                                        borderSide:
                                            const BorderSide(width: 0, style: BorderStyle.none)),
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  maxLines: 4,
                                  controller: reason,
                                  readOnly: true,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: "سبب البلاغ  :",
                                    labelStyle: const TextStyle(fontFamily: "Tajawal-b"),
                                    contentPadding: const EdgeInsets.all(40.0),
                                    fillColor: const Color.fromARGB(255, 225, 225, 228),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(33.0),
                                        borderSide:
                                            const BorderSide(width: 0, style: BorderStyle.none)),
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          Admin_Response.text != ""
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextFormField(
                                      maxLines: 4,
                                      controller: Admin_Response,
                                      readOnly: true,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        labelText: "نتائج البلاغ  :",
                                        labelStyle: const TextStyle(fontFamily: "Tajawal-b"),
                                        contentPadding: const EdgeInsets.all(40.0),
                                        fillColor: const Color.fromARGB(255, 225, 225, 228),
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(33.0),
                                            borderSide: const BorderSide(
                                                width: 0, style: BorderStyle.none)),
                                      ),
                                    ),
                                  ))
                              : Container(),
                          const SizedBox(
                            height: 30,
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
