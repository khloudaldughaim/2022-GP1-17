// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, unnecessary_import, unused_import, camel_case_types, non_constant_identifier_names

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nozol_application/pages/BuyerBooking.dart';
import 'package:nozol_application/pages/navigationbar.dart';
import 'package:nozol_application/pages/profile.dart';
import 'package:nozol_application/pages/villa.dart';
import 'package:nozol_application/registration/sign_up.dart';
import 'package:uuid/uuid.dart';
import '../registration/log_in.dart';
import 'apartment.dart';
import 'apartmentdetailes.dart';
import 'building.dart';
import 'buildingdetailes.dart';
import 'filter.dart';
import 'land.dart';
import 'landdetailes.dart';
import 'ownerBooking.dart';
import 'villadetailes.dart';
import 'mapPage.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:http/http.dart' as http;

class boookingPage extends StatefulWidget {
  final String property_id;
  final String user_id;

  final String Pimge;
  boookingPage({required this.property_id, required this.user_id, required this.Pimge});

  //const boookingPage({Key? key, required Apartment Apartment}) : super(key: key);
  @override
  State<boookingPage> createState() => _BookingPagestate();
}

enum booktype { inperson, online }

enum videoChat { zoom, skype, googelduo }

class _BookingPagestate extends State<boookingPage> {
//'${widget.User_id}' to call User_id from up
  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String curentId = user!.uid;
  List book = [];
  String book_id = '';
  final now = DateTime.now();
  DateTime Reseve = DateTime.now();
  final bookformkey = GlobalKey<FormState>();
  String _valueChanged1 = '';
  String _valueToValidate1 = '';
  String _valueSaved1 = '';
  booktype? _book = booktype.inperson;
  String Booktype = 'حضوري';
  videoChat? video = videoChat.zoom;
  String videochat = 'Zoom';
  List<Suser> curentuserInfo = [];

//  DateTime dt = DateTime.parse('2020-01-02 03:04:05');
  final datecontrolar = TextEditingController(
      text: DateTime.now().year.toString() +
          "-" +
          DateTime.now().month.toString() +
          "-" +
          DateTime.now().day.toString() +
          " " +
          DateTime.now().hour.toString() +
          ":" +
          DateTime.now().minute.toString());
  var nameB = TextEditingController();
  var phoneB = TextEditingController();
  var emailB = TextEditingController();
  // text controllers

  @override
  void initState() {
    getCuser();
    initInfo();
    super.initState();
  }

///////////////////////////////////////////////////////////////////////

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  initInfo() async {
    var androidInitialize = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettings = InitializationSettings(android: androidInitialize);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        final String? payload = notificationResponse.payload;
        if (notificationResponse.payload != null) {
          debugPrint('notification payload: $payload');
        }
        await Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => ownerBooking()),
        );
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("...................onMessage................");
      print("onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);

      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "dbfood",
        "dbfood",
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0, message.notification?.title, message.notification?.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  void sendPushMessege(String token, String Fname) async {
    print(token);
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAxBBGpRg:APA91bEFd4TNo4jbmY-3hnkWBd994HqIlQqhy0OLhHeZkdXYHGDBLIUO-c11XqtDFy5-J_7S1qYnlG7XsgYdW6SV1__7LA760i6kevCTTEG-UywJDXRYKPUNzwg6iTdvM9jWSTdZ89aj'
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': 'your appointment has been canceled with ',
              'title': 'appointment cancelation',
            },
            "notification": <String, dynamic>{
              "title": "حجز جديد",
              "body": "وصلك حجز جديد",
              "android_channel_id": "dbfood",
            },
            "to": token,
          },
        ),
      );
      print(token);
    } catch (e) {
      if (kDebugMode) {
        print("Error push notifcathion");
      }
    }
  }

///////////////////////////////////////////////////////////////////////
  Future<void> getCuser() async {
    var docs = await FirebaseFirestore.instance.collection('Standard_user').get();
    curentuserInfo = [];
    nameB = TextEditingController();
    phoneB = TextEditingController();
    emailB = TextEditingController();
    docs.docs.forEach((element) {
      if (element["userId"] == curentId) {
        curentuserInfo.add(Suser.fromJson(element.data()));
        nameB = TextEditingController(text: curentuserInfo[0].name);
        phoneB = TextEditingController(text: curentuserInfo[0].phoneNumber);
        emailB = TextEditingController(text: curentuserInfo[0].email);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 127, 166, 233),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 130),
            child: const Text('حجز جولة عقارية ',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Tajawal-b",
                )),
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
        body: SafeArea(
            child: SingleChildScrollView(
                child: SingleChildScrollView(
                    child: Stack(children: [
          SizedBox(
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Form(
                      key: bookformkey,
                      child: Column(children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                controller: nameB,
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
                                validator: (value) {
                                  if (value!.length < 2) {
                                    return "الأسم يجب ان يكون خانتين فأكثر ";
                                  }
                                },
                              ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: DateTimePicker(
                                type: DateTimePickerType.dateTime,
                                dateMask: 'hh:mma -  d MMM, yyyy ',
                                controller: datecontrolar,
                                //initialValue: _initialValue,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2024),

                                decoration: InputDecoration(
                                  labelText: "التاريخ  :",
                                  labelStyle: TextStyle(fontFamily: "Tajawal-b"),
                                  prefixIcon: Icon(
                                    Icons.calendar_month,
                                    color: Color.fromARGB(255, 127, 166, 233),
                                  ),
                                  fillColor: Color.fromARGB(255, 225, 225, 228),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(66.0),
                                      borderSide:
                                          const BorderSide(width: 0, style: BorderStyle.none)),
                                ),

                                onChanged: (val) {
                                  _valueChanged1 = val;
                                },
                                validator: (val) {
                                  _valueToValidate1 = val ?? '';
                                  return null;
                                },
                                onSaved: (val) => () => _valueSaved1 = val ?? '',
                              ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                controller: emailB,
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
                                validator: (value) {
                                  if (value!.isEmpty || emailB.text.trim() == "") {
                                    return "البريد الألكتروني مطلوب ";
                                  } else if (!RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(value)) {
                                    return '  أدخل البريد الأكلتروني بالشكل الصحيح \n(exampel@exampel.com)';
                                  }
                                },
                              ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                controller: phoneB,
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
                                validator: (value) {
                                  if (!RegExp(r'^((?:[+?0?0?966]+)(?:\s?\d{2})(?:\s?\d{7}))$')
                                      .hasMatch(value!)) {
                                    return 'أدخل رقم الجوال بالشكل الصحيح\n (05xxxxxxxx)';
                                  }
                                },
                              ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('   تفضل ان تكون الجولة   : ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: "Tajawal-b",
                                ),
                                textDirection: TextDirection.rtl),
                            Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: RadioListTile(
                                      title: const Text(
                                        'حضورية',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: "Tajawal-m",
                                            color: Color.fromARGB(255, 73, 75, 82)),
                                        textAlign: TextAlign.start,
                                      ),
                                      value: booktype.inperson,
                                      groupValue: _book,
                                      onChanged: (booktype? value) {
                                        setState(() {
                                          _book = value;
                                          if (_book == booktype.inperson) Booktype = 'حضورية';
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: RadioListTile(
                                      title: const Text(
                                        'افتراضية',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: "Tajawal-m",
                                            color: Color.fromARGB(255, 73, 75, 82)),
                                        textAlign: TextAlign.start,
                                      ),
                                      value: booktype.online,
                                      groupValue: _book,
                                      onChanged: (booktype? value) {
                                        setState(() {
                                          _book = value;
                                          if (_book == booktype.online) Booktype = 'افتراضية';
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Booktype == 'افتراضية'
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '   تفضل ان تكون الجولة على ؟  ',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: "Tajawal-b",
                                    ),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Column(
                                      children: [
                                        RadioListTile(
                                          title: Text(
                                            'Zoom',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontFamily: "Tajawal-m",
                                                color: Color.fromARGB(255, 73, 75, 82)),
                                            textAlign: TextAlign.start,
                                          ),
                                          value: videoChat.zoom,
                                          groupValue: video,
                                          onChanged: (videoChat? value) {
                                            setState(() {
                                              video = value;
                                              if (video == videoChat.zoom) videochat = 'Zoom';
                                            });
                                          },
                                        ),
                                        RadioListTile(
                                          title: const Text(
                                            'Skype',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontFamily: "Tajawal-m",
                                                color: Color.fromARGB(255, 73, 75, 82)),
                                            textAlign: TextAlign.start,
                                          ),
                                          value: videoChat.skype,
                                          groupValue: video,
                                          onChanged: (videoChat? value) {
                                            setState(() {
                                              video = value;
                                              if (video == videoChat.skype) videochat = 'Skype';
                                            });
                                          },
                                        ),
                                        RadioListTile(
                                          title: const Text(
                                            'Google Duo',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontFamily: "Tajawal-m",
                                                color: Color.fromARGB(255, 73, 75, 82)),
                                            textAlign: TextAlign.start,
                                          ),
                                          value: videoChat.googelduo,
                                          groupValue: video,
                                          onChanged: (videoChat? value) {
                                            setState(() {
                                              video = value;
                                              if (video == videoChat.googelduo)
                                                videochat = 'Google Duo';
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (bookformkey.currentState!.validate()) {
                              // DateTime dt =
                              //     DateTime.parse(datecontrolar.text);
                              book_id = Uuid().v4();
                              FirebaseFirestore.instance
                                  .collection('bookings')
                                  .where('Date', isEqualTo: datecontrolar.text)
                                  .where("owner_id", isEqualTo: '${widget.user_id}')
                                  .where("isAvailable", isEqualTo: false)
                                  .get()
                                  .then((element) async {
                                if (element.docs.isEmpty) {
                                  try {
                                    FirebaseFirestore.instance
                                        .collection('bookings')
                                        .doc(book_id)
                                        .set({
                                      "Date": datecontrolar.text,
                                      "property_id": '${widget.property_id}',
                                      "buyer_id": curentId,
                                      "buyer_name": nameB.text,
                                      "buyer_email": emailB.text,
                                      "buyer_phone": phoneB.text,
                                      "book_type": Booktype,
                                      "videochat": videochat,
                                      "status": "pending",
                                      "owner_id": '${widget.user_id}',
                                      "Pimage": '${widget.Pimge}',
                                      "book_id": book_id,
                                      "isExpired": false,
                                      "isAvailable": false,
                                      "reason": " ",
                                    });
                                    final ref = FirebaseFirestore.instance
                                        .collection('bookings')
                                        .doc(book_id);

                                    book.add(ref);
                                    print(book);
                                    FirebaseFirestore.instance
                                        .collection('properties')
                                        .doc('${widget.property_id}')
                                        .update({
                                      "ArrayOfbooking": book,
                                    });
                                    Fluttertoast.showToast(
                                      msg: "تم الحجز بنجاح",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Color.fromARGB(255, 127, 166, 233),
                                      textColor: Color.fromARGB(255, 248, 249, 250),
                                      fontSize: 18.0,
                                    );
                                    var Otoken = await FirebaseFirestore.instance
                                        .collection('Standard_user')
                                        .doc('${widget.user_id}')
                                        .get();
                                    print('IT WORKS !!!! ' + Otoken['token']);

                                    sendPushMessege(Otoken['token'], Otoken['name']);
                                  } catch (e, stack) {
                                    Fluttertoast.showToast(
                                      msg: "هناك خطأ ما",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: Color.fromARGB(255, 127, 166, 233),
                                      textColor: Color.fromARGB(255, 252, 253, 255),
                                      fontSize: 18.0,
                                    );
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "التاريخ محجوز مسبقاً",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: Color.fromARGB(255, 127, 166, 233),
                                    textColor: Color.fromARGB(255, 252, 253, 255),
                                    fontSize: 18.0,
                                  );
                                }
                              });
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color.fromARGB(255, 127, 166, 233)),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                          ),
                          child: Text(
                            "حجز",
                            style: TextStyle(fontSize: 18, fontFamily: "Tajawal-m"),
                          ),
                        ),
                      ]))))
        ])))));
  }
}
