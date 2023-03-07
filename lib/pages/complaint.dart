import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nozol_application/pages/mycomplaints.dart';
import 'package:uuid/uuid.dart';
import '../registration/sign_up.dart';

class Complaints extends StatefulWidget {
  final String property_id;
  final String user_id;
  final String type;
  final String city;
  final String neighborhood;

  Complaints({required this.property_id, required this.user_id, required this.type, required this.city, required this.neighborhood});

  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  final complaintformkey = GlobalKey<FormState>();
  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String curentId = user!.uid;
  String complaint_id = '';
  List<Suser> curentuserInfo = [];
  int status = 1;

  var name = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var reason = TextEditingController();

  @override
  void initState() {
    getCuser();
    super.initState();
  }

  Future<void> getCuser() async {
    var docs = await FirebaseFirestore.instance.collection('Standard_user').get();
    curentuserInfo = [];
    name = TextEditingController();
    phone = TextEditingController();
    email = TextEditingController();
    reason = TextEditingController();
    docs.docs.forEach((element) {
      if (element["userId"] == curentId) {
        curentuserInfo.add(Suser.fromJson(element.data()));
        name = TextEditingController(text: curentuserInfo[0].name);
        phone = TextEditingController(text: curentuserInfo[0].phoneNumber);
        email = TextEditingController(text: curentuserInfo[0].email);
        reason = TextEditingController(text: " ");
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
            padding: EdgeInsets.only(left: 155),
            child: Text('رفع بلاغ',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Tajawal-b",
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
                                validator: (value) {
                                  if (value!.length < 2) {
                                    return "الأسم يجب ان يكون خانتين فأكثر ";
                                  }
                                },
                              ),
                            )
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  controller: email,
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
                                  validator: (value) {
                                    if (value!.isEmpty || email.text.trim() == "") {
                                      return "البريد الألكتروني مطلوب ";
                                    } else if (!RegExp(
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                        .hasMatch(value)) {
                                      return '  أدخل البريد الأكلتروني بالشكل الصحيح \n(exampel@exampel.com)';
                                    }
                                  },
                                ),
                              )
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                controller: phone,
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
                                validator: (value) {
                                  if (!RegExp(r'^((?:[+?0?0?966]+)(?:\s?\d{2})(?:\s?\d{7}))$')
                                      .hasMatch(value!)) {
                                    return 'أدخل رقم الجوال بالشكل الصحيح\n (05xxxxxxxx)';
                                  }
                                },
                              ),
                            )
                          ),
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
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: "سبب البلاغ  :",
                                    labelStyle: const TextStyle(fontFamily: "Tajawal-b"),
                                    contentPadding:const EdgeInsets.all(40.0),
                                    hintText: 'الإعلان مخالف لشروط الهيئة العامة للعقار',
                                    fillColor: const Color.fromARGB(255, 225, 225, 228),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(33.0),
                                        borderSide:
                                          const BorderSide(width: 0, style: BorderStyle.none)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty || reason.text.trim() == "") {
                                      return "يرجى ذكر السبب ";
                                    }
                                  },
                                ),
                              )
                          ),
                          const SizedBox(
                          height: 30,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content:
                                        const Text("هل أنت متأكد من أنك ترغب في رفع بلاغ على هذا الإعلان ؟"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("لا"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("نعم"),
                                        onPressed: () {
                                          if (complaintformkey.currentState!.validate()) {
                                            complaint_id = const Uuid().v4();
                                            try {
                                              FirebaseFirestore.instance
                                                .collection('Complaints')
                                                .doc(complaint_id)
                                                .set({
                                                "complaint_id": complaint_id,
                                                "property_id": widget.property_id,
                                                "user_id": curentId,
                                                "name": name.text,
                                                "email": email.text,
                                                "phone": phone.text,
                                                "reason": reason.text,
                                                "status": status,
                                                "date": "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}",
                                                "type": widget.type,
                                                "city": widget.city,
                                                "neighborhood": widget.neighborhood,
                                              });
                                              
                                              Fluttertoast.showToast(
                                                msg: "تم رفع البلاغ بنجاح ، سيتواصل معك فريق الدعم قريبا !",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 2,
                                                backgroundColor: const Color.fromARGB(255, 127, 166, 233),
                                                textColor: const Color.fromARGB(255, 248, 249, 250),
                                                fontSize: 18.0,
                                              );

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const MyComplaints()
                                                )
                                              );

                                            } catch (e) {
                                              Fluttertoast.showToast(
                                                msg: "هناك خطأ ما",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 5,
                                                backgroundColor: const Color.fromARGB(255, 127, 166, 233),
                                                textColor: const Color.fromARGB(255, 252, 253, 255),
                                                fontSize: 18.0,
                                              );
                                            }
                                          }else{
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                }
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(const Color.fromARGB(255, 127, 166, 233)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                            ),
                            child: const Text(
                              "رفع البلاغ",
                              style: TextStyle(fontSize: 18, fontFamily: "Tajawal-m"),
                            ),
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