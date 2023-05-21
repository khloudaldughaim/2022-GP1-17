// import 'dart:html';

//import 'dart:convert';

// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unused_local_variable, prefer_const_literals_to_create_immutables, unused_import, file_names, camel_case_types, sort_child_properties_last, unrelated_type_equality_checks
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/pages/BuyerBooking.dart';
import 'package:nozol_application/pages/apartment.dart';
import 'package:nozol_application/pages/building.dart';
import 'package:nozol_application/pages/land.dart';
import 'package:nozol_application/pages/villa.dart';
import '../Chat/ChatBody.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ownerBooking extends StatefulWidget {
  // const myBookings({super.key});
  // final String property_id;
  //myBookings({required this.property_id});

  const ownerBooking({Key? key}) : super(key: key);
  @override
  State<ownerBooking> createState() => _myBookingsState();
}

class _myBookingsState extends State<ownerBooking> {
  List<bool> isSelected = [true, false, false];
  var property;
  var reason = TextEditingController();
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
    // Notifications step 3
    initInfo();
    // end of Notifications step 3
  }

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
          MaterialPageRoute<void>(builder: (context) => BuyerBooking()),
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
              "title": "قبول طلب",
              "body": "تم قبول طلب زيارتك من قبل صاحب العقار $Fname",
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

  void RejectsendPushMessege(String token, String Fname) async {
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
              "title": "رفض طلب",
              "body": "تم رفض طلب زيارتك من قبل صاحب العقار $Fname",
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

////////////////// END OF NOTIFICATIONS step 2 ///////////////

  Future<void> getBookings() async {
    var docs = await FirebaseFirestore.instance.collection('bookings').get();
    newBookings = [];
    accepted = [];
    canceled = [];
    rejected = [];
    finished = [];
    docs.docs.forEach((element) {
      if (element["owner_id"] == curentId) {
        if (element["status"] == "pending" && element["isExpired"] == false) {
          newBookings.add(BookingModel.fromJson(element.data()));
        }
        if (element["status"] == "aproved" && element["isExpired"] == false) {
          accepted.add(BookingModel.fromJson(element.data()));
        }
        if (element["status"] == "cansled" && element["isExpired"] == false) {
          canceled.add(BookingModel.fromJson(element.data()));
        }
        if (element["status"] == "dicline" && element["isExpired"] == false) {
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
          body: DefaultTabController(
        initialIndex: 2,
        length: 3,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 110,
              width: MediaQuery.of(context).size.width,
              child: AppBar(
                backgroundColor: Color.fromARGB(255, 127, 166, 233),
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Text("طلبات الجولة العقارية",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Tajawal-b",
                        color: Color.fromARGB(255, 255, 255, 255),
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
                bottom: const TabBar(
                  isScrollable: true,
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
                          child: Text(" "), //no data
                        );
                      } else if (snapshot.data!.docs.length < 1) {
                        return Center(
                          child: Text(
                            "لا توجد حجوزات ماضية",
                            style: TextStyle(fontFamily: "Tajawal-m", fontSize: 17),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => Card(
                            margin: EdgeInsets.fromLTRB(5, 10, 10, 5),
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            )),
                            shadowColor: Color.fromARGB(255, 0, 0, 0),
                            child: Container(
                              height: 220,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 180, 178, 178),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  )),
                              // ignore: prefer_const_constructors
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 130,
                                          width: 140,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  snapshot.data!.docs[index].data()['Pimage']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            realtyDetails(
                                                snapshot.data!.docs[index].data()['property_id']);
                                          },
                                          child: Text(
                                            'تفاصيل العقار',
                                            style: TextStyle(fontFamily: "Tajawal-m"),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(
                                              Color.fromARGB(255, 127, 166, 233),
                                            ),
                                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(27))),
                                          ),
                                        ),
                                      ],
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
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            height: 9,
                                          ),
                                          if (snapshot.data!.docs[index].data()['status'] ==
                                              'aproved')
                                            Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(193, 203, 238, 204),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    width: 150,
                                                    padding: EdgeInsets.symmetric(vertical: 4),
                                                    child: Center(
                                                      child: Text(
                                                        'حجز مقبول',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(255, 31, 92, 40),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      ),
                                                    )),

                                                ////////////////
                                                SizedBox(
                                                  width: 0,
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 36,
                                                      width: 30,
                                                      // margin: EdgeInsets.fromLTRB(0,0,1,0),
                                                      decoration: BoxDecoration(
                                                        // color: Color.fromARGB(121, 182, 201, 235),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: IconButton(
                                                            // Here the Massage button
                                                            hoverColor: Colors.grey,
                                                            icon: Icon(
                                                              Icons.message,
                                                              color: Color.fromARGB(
                                                                  255, 127, 166, 233),
                                                              size: 21,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ChatBody(
                                                                            Freind_id: snapshot
                                                                                .data!.docs[index]
                                                                                .data()['buyer_id'],
                                                                          )));
                                                            }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ////////////////
                                              ],
                                            ),
                                          if (snapshot.data!.docs[index].data()['status'] ==
                                              'pending')
                                            Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(199, 231, 217, 164),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    width: 145,
                                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                                    child: Center(
                                                      child: Text(
                                                        'حجز لم تتم معالجته',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(221, 69, 57, 17),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      ),
                                                    )),
                                                ////////////////
                                                SizedBox(
                                                  width: 1,
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 36,
                                                      width: 30,
                                                      // margin: EdgeInsets.fromLTRB(0,0,1,0),
                                                      decoration: BoxDecoration(
                                                        // color: Color.fromARGB(121, 182, 201, 235),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: IconButton(
                                                            // Here the Massage button
                                                            hoverColor: Colors.grey,
                                                            icon: Icon(
                                                              Icons.message,
                                                              color: Color.fromARGB(
                                                                  255, 127, 166, 233),
                                                              size: 21,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ChatBody(
                                                                            Freind_id: snapshot
                                                                                .data!.docs[index]
                                                                                .data()['buyer_id'],
                                                                          )));
                                                            }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ////////////////
                                              ],
                                            ),
                                          if (snapshot.data!.docs[index].data()['status'] ==
                                              'cansled')
                                            Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(180, 207, 208, 212),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    width: 150,
                                                    padding: EdgeInsets.symmetric(vertical: 4),
                                                    child: Center(
                                                      child: Text(
                                                        'حجز ملغي',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(255, 50, 50, 50),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      ),
                                                    )),

                                                ////////////////
                                                SizedBox(
                                                  width: 1,
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 36,
                                                      width: 30,
                                                      // margin: EdgeInsets.fromLTRB(0,0,1,0),
                                                      decoration: BoxDecoration(
                                                        // color: Color.fromARGB(121, 182, 201, 235),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: IconButton(
                                                            // Here the Massage button
                                                            hoverColor: Colors.grey,
                                                            icon: Icon(
                                                              Icons.message,
                                                              color: Color.fromARGB(
                                                                  255, 127, 166, 233),
                                                              size: 21,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ChatBody(
                                                                            Freind_id: snapshot
                                                                                .data!.docs[index]
                                                                                .data()['buyer_id'],
                                                                          )));
                                                            }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ////////////////
                                              ],
                                            ),
                                          if (snapshot.data!.docs[index].data()['status'] ==
                                              'dicline')
                                            Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(187, 234, 193, 193),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    width: 150,
                                                    padding: EdgeInsets.symmetric(vertical: 4),
                                                    child: Center(
                                                      child: Text(
                                                        'حجز مرفوض',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(255, 124, 38, 38),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      ),
                                                    )),

                                                ////////////////
                                                SizedBox(
                                                  width: 1,
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 36,
                                                      width: 30,
                                                      // margin: EdgeInsets.fromLTRB(0,0,1,0),
                                                      decoration: BoxDecoration(
                                                        // color: Color.fromARGB(121, 182, 201, 235),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: IconButton(
                                                            // Here the Massage button
                                                            hoverColor: Colors.grey,
                                                            icon: Icon(
                                                              Icons.message,
                                                              color: Color.fromARGB(
                                                                  255, 127, 166, 233),
                                                              size: 21,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ChatBody(
                                                                            Freind_id: snapshot
                                                                                .data!.docs[index]
                                                                                .data()['buyer_id'],
                                                                          )));
                                                            }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ////////////////
                                              ],
                                            ),
                                          if (snapshot.data!.docs[index].data()['status'] ==
                                              'deleted')
                                            Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(146, 171, 171, 171),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    width: 150,
                                                    padding: EdgeInsets.symmetric(vertical: 4),
                                                    child: Center(
                                                      child: Text(
                                                        'عقار محذوف ',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      ),
                                                    )),

                                                ////////////////
                                                SizedBox(
                                                  width: 1,
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 36,
                                                      width: 30,
                                                      // margin: EdgeInsets.fromLTRB(0,0,1,0),
                                                      decoration: BoxDecoration(
                                                        // color: Color.fromARGB(121, 182, 201, 235),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: IconButton(
                                                            // Here the Massage button
                                                            hoverColor: Colors.grey,
                                                            icon: Icon(
                                                              Icons.message,
                                                              color: Color.fromARGB(
                                                                  255, 127, 166, 233),
                                                              size: 21,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ChatBody(
                                                                            Freind_id: snapshot
                                                                                .data!.docs[index]
                                                                                .data()['buyer_id'],
                                                                          )));
                                                            }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ////////////////
                                              ],
                                            ),
                                          if (snapshot.data!.docs[index].data()['status'] ==
                                              'suspended')
                                            Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(255, 227, 207, 176),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    width: 140,
                                                    padding: EdgeInsets.symmetric(vertical: 4),
                                                    child: Center(
                                                      child: Text(
                                                        'عقار موقوف ',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(255, 84, 59, 22),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      ),
                                                    )),

                                                ////////////////
                                                SizedBox(
                                                  width: 1,
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 36,
                                                      width: 30,
                                                      // margin: EdgeInsets.fromLTRB(0,0,1,0),
                                                      decoration: BoxDecoration(
                                                        // color: Color.fromARGB(121, 182, 201, 235),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        child: IconButton(
                                                            // Here the Massage button
                                                            hoverColor: Colors.grey,
                                                            icon: Icon(
                                                              Icons.message,
                                                              color: Color.fromARGB(
                                                                  255, 127, 166, 233),
                                                              size: 21,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ChatBody(
                                                                            Freind_id: snapshot
                                                                                .data!.docs[index]
                                                                                .data()['buyer_id'],
                                                                          )));
                                                            }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ////////////////
                                              ],
                                            ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          RegExp("[a-zA-Z]").hasMatch(
                                                  snapshot.data!.docs[index].data()['buyer_name'])
                                              ? Text("" +
                                                  snapshot.data!.docs[index].data()['buyer_name'] +
                                                  "    : صاحب الحجز ")
                                              : Text(" صاحب الحجز :   " +
                                                  snapshot.data!.docs[index].data()['buyer_name']),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(" نوع الجولة :   " +
                                              snapshot.data!.docs[index].data()['book_type']),
                                          if (snapshot.data!.docs[index].data()['book_type'] ==
                                              'افتراضية')
                                            Text("" +
                                                snapshot.data!.docs[index].data()['videochat'] +
                                                "    : التطبيق"),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(" رقم الحاجز :   " +
                                              snapshot.data!.docs[index].data()['buyer_phone']),
                                          if (snapshot.data!.docs[index].data()['status'] ==
                                              'dicline')
                                            Text(" سبب الرفض :   " +
                                                snapshot.data!.docs[index].data()['reason']),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(" التاريخ :   " +
                                              snapshot.data!.docs[index].data()['Date']),
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
                        color: Color.fromARGB(255, 193, 216, 255),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ToggleButtons(
                        isSelected: isSelected,
                        selectedColor: Colors.white,
                        color: Color.fromARGB(255, 2, 73, 144),
                        fillColor: Color.fromARGB(255, 127, 166, 233),
                        renderBorder: false,
                        borderWidth: 1,
                        borderRadius: BorderRadius.circular(50),
                        // highlightColor: Color.fromARGB(255, 238, 238, 243),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('ملغاة ',
                                style: TextStyle(fontSize: 18, fontFamily: "Tajawal-m")),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('مرفوضة',
                                style: TextStyle(fontSize: 18, fontFamily: "Tajawal-m")),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('مقبولة',
                                style: TextStyle(fontSize: 18, fontFamily: "Tajawal-m")),
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
                              if (newIndex == 0 && isSelected[newIndex]) {
                                // Fluttertoast.showToast(msg: " عدد العقارات الملغاة من قبل المشترين هو " + canceled.length.toString(),
                                //             toastLength: Toast.LENGTH_SHORT,
                                //             gravity: ToastGravity.CENTER,
                                //             timeInSecForIosWeb: 1,
                                //             backgroundColor: Color.fromARGB(211, 38, 93, 171),
                                //             textColor: Color.fromARGB(255, 226, 226, 227),
                                //             fontSize: 15);

                                MotionToast(
                                  icon: Icons.light,
                                  title: Text(
                                    "تنبيه",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  description: Text(
                                    " عدد العقارات الملغاة من قبل المشترين هو " +
                                        canceled.length.toString(),
                                  ),
                                  primaryColor: Color.fromARGB(255, 216, 201, 151),
                                  barrierColor: Colors.transparent,
                                  toastDuration: Duration(seconds: 4),
                                  // width: 3,
                                ).show(context);
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
                              if (canceled.isEmpty) {
                                return Center(
                                  child: Text(
                                    "لا توجد حجوزات ملغاة",
                                    style: TextStyle(fontFamily: "Tajawal-m", fontSize: 17),
                                  ),
                                );
                              }
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
                              if (rejected.isEmpty) {
                                return Center(
                                  child: Text(
                                    "لا توجد حجوزات مرفوضة",
                                    style: TextStyle(fontFamily: "Tajawal-m", fontSize: 17),
                                  ),
                                );
                              }
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
                              if (accepted.isEmpty) {
                                return Center(
                                  child: Text(
                                    "لا توجد حجوزات مقبولة",
                                    style: TextStyle(fontFamily: "Tajawal-m", fontSize: 17),
                                  ),
                                );
                              }
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
                    // Tap 2
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
                          child: Text(" "), //no data
                        );
                      } else if (snapshot.data!.docs.length < 1) {
                        return Center(
                          child: Text(
                            "لا توجد حجوزات جديدة",
                            style: TextStyle(fontFamily: "Tajawal-m", fontSize: 17),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => Card(
                            margin: EdgeInsets.fromLTRB(5, 10, 10, 5),
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            )),
                            shadowColor: Color.fromARGB(255, 0, 0, 0),
                            child: Container(
                              height: 235,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 180, 178, 178),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  )),
                              // ignore: prefer_const_constructors
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                        child: Container(
                                          height: 130,
                                          width: 140,
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
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              height: 9,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(189, 203, 216, 240),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    width: 85,
                                                    padding: EdgeInsets.symmetric(vertical: 4),
                                                    child: Center(
                                                      child: Text(
                                                        'حجز جديد',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(255, 42, 42, 43),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      ),
                                                    )),

                                                ////////////////
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    // color: Color.fromARGB(121, 182, 201, 235),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                                                    child: IconButton(
                                                        // Here the Massage button
                                                        hoverColor: Colors.grey,
                                                        icon: Icon(
                                                          Icons.message,
                                                          color: Color.fromARGB(255, 127, 166, 233),
                                                          size: 20,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => ChatBody(
                                                                        Freind_id: snapshot
                                                                            .data!.docs[index]
                                                                            .data()['buyer_id'],
                                                                      )));
                                                        }),
                                                  ),
                                                ),

                                                ////////////////
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            RegExp("[a-zA-Z]").hasMatch(
                                                    snapshot.data!.docs[index].data()['buyer_name'])
                                                ? Text("" +
                                                    snapshot.data!.docs[index]
                                                        .data()['buyer_name'] +
                                                    "    : صاحب الحجز ")
                                                : Text(" صاحب الحجز :   " +
                                                    snapshot.data!.docs[index]
                                                        .data()['buyer_name']),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(" نوع الجولة :   " +
                                                snapshot.data!.docs[index].data()['book_type']),
                                            if (snapshot.data!.docs[index].data()['book_type'] ==
                                                "افتراضية")
                                              Text("" +
                                                  snapshot.data!.docs[index].data()['videochat'] +
                                                  "    : التطبيق"),
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(45, 0, 45, 0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            realtyDetails(
                                                snapshot.data!.docs[index].data()['property_id']);
                                          },
                                          child: Text(
                                            'تفاصيل العقار',
                                            style: TextStyle(fontFamily: "Tajawal-m"),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(
                                              Color.fromARGB(255, 127, 166, 233),
                                            ),
                                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(27))),
                                          ),
                                        ),
                                      ),
                                      // Column(
                                      // children: [
                                      // Row(
                                      //children: [
                                      ElevatedButton(
                                        //APPROVE BUTTON
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(
                                                    " هل انت متأكد من رغبتك بقبول الحجز؟",
                                                    style: TextStyle(
                                                        fontFamily: "Tajawal-m", fontSize: 17),
                                                    textDirection: TextDirection.rtl,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(
                                                        "إلغاء",
                                                        style: TextStyle(
                                                          fontFamily: "Tajawal-m",
                                                          fontSize: 17,
                                                          color: Color.fromARGB(255, 127, 166, 233),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                        "تأكيد",
                                                        style: TextStyle(
                                                          fontFamily: "Tajawal-m",
                                                          fontSize: 17,
                                                          color: Color.fromARGB(255, 127, 166, 233),
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        await FirebaseFirestore.instance
                                                            .collection('bookings')
                                                            .doc(snapshot.data!.docs[index]
                                                                .data()['book_id'])
                                                            .update({
                                                          "status": "aproved",
                                                        });
                                                        // Notifications step 4
                                                        var Otoken = await FirebaseFirestore
                                                            .instance
                                                            .collection('Standard_user')
                                                            .doc(snapshot.data!.docs[index]
                                                                .data()['buyer_id'])
                                                            .get();
                                                        print('IT WORKS !!!! ' + Otoken['token']);
                                                        // end of Notifications step 4

                                                        // setState(() {});

                                                        var ONwerName = await FirebaseFirestore
                                                            .instance
                                                            .collection('Standard_user')
                                                            .doc(snapshot.data!.docs[index]
                                                                .data()['owner_id'])
                                                            .get();

                                                        // Notifications step 5
                                                        sendPushMessege(
                                                            Otoken['token'], ONwerName['name']);
                                                        //end of  Notifications step 5
                                                        getBookings();

                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },

                                        child: Text(
                                          'قبول',
                                          style: TextStyle(fontFamily: "Tajawal-m"),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              Color.fromARGB(255, 72, 169, 138)),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(27))),
                                        ),
                                      ),
                                      //  ],
                                      //),

                                      SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        // REJECT BUTTON
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: ((context) => AlertDialog(
                                                    title: Text(
                                                      "اذا كنت متأكدًا من رغبتك برفض الحجز فما هو سبب الرفض من فضلك ؟",
                                                      style: TextStyle(
                                                          fontFamily: "Tajawal-m", fontSize: 17),
                                                      textDirection: TextDirection.rtl,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    content: TextField(
                                                      autofocus: true,
                                                      controller: reason,
                                                      decoration: InputDecoration(
                                                          hintText: "الوقت غير مناسب "),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text(
                                                          "إالغاء",
                                                          style: TextStyle(
                                                            fontFamily: "Tajawal-m",
                                                            fontSize: 17,
                                                            color:
                                                                Color.fromARGB(255, 127, 166, 233),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                          onPressed: () async {
                                                            await FirebaseFirestore.instance
                                                                .collection('bookings')
                                                                .doc(snapshot.data!.docs[index]
                                                                    .data()['book_id'])
                                                                .update({
                                                              "reason": reason.text,
                                                              "status": "dicline",
                                                            });
                                                            Navigator.of(context).pop();
                                                            var btoken = await FirebaseFirestore
                                                                .instance
                                                                .collection('Standard_user')
                                                                .doc(snapshot.data!.docs[index]
                                                                    .data()['buyer_id'])
                                                                .get();
                                                            print(
                                                                'IT WORKS !!!! ' + btoken['token']);

                                                            var ONwerName = await FirebaseFirestore
                                                                .instance
                                                                .collection('Standard_user')
                                                                .doc(snapshot.data!.docs[index]
                                                                    .data()['owner_id'])
                                                                .get();

                                                            RejectsendPushMessege(
                                                                btoken['token'], ONwerName['name']);
                                                            getBookings();
                                                          },
                                                          child: Text(
                                                            "حفظ",
                                                            style: TextStyle(
                                                              fontFamily: "Tajawal-m",
                                                              fontSize: 17,
                                                              color: Color.fromARGB(
                                                                  255, 127, 166, 233),
                                                            ),
                                                          ))
                                                    ],
                                                  )));

                                          getBookings();
                                        },
                                        child: Text(
                                          'رفض',
                                          style: TextStyle(fontFamily: "Tajawal-m"),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              Color.fromARGB(255, 245, 68, 82)),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(27))),
                                        ),
                                      ),

                                      //         ]),

                                      // ],
                                      //   ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }), // end of Tap 3
              ]),
            ),
          ],
        ),
      )),
    );
  }

//////////  EXTERNAL METHODS
  Card _buildAcceptedItem(BookingModel bookingModel) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 10, 10, 5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(15),
      )),
      shadowColor: Color.fromARGB(255, 0, 0, 0),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 180, 178, 178),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            )),
        // ignore: prefer_const_constructors
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Column(
                children: [
                  Container(
                    height: 130,
                    width: 140,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(bookingModel.pimage ?? ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      realtyDetails(bookingModel.propertyId ?? "");
                    },
                    child: Text(
                      'تفاصيل العقار',
                      style: TextStyle(fontFamily: "Tajawal-m"),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 127, 166, 233),
                      ),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 9,
                  ),
                  Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(193, 203, 238, 204),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          width: 150,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Center(
                            child: Text(
                              'حجز مقبول',
                              style: TextStyle(
                                color: Color.fromARGB(255, 31, 92, 40),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Tajawal-m",
                              ),
                            ),
                          )),
                      ////////////////
                      SizedBox(
                        width: 1,
                      ),
                      Column(
                        children: [
                          Container(
                            height: 36,
                            width: 30,
                            // margin: EdgeInsets.fromLTRB(0,0,1,0),
                            decoration: BoxDecoration(
                              // color: Color.fromARGB(121, 182, 201, 235),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: IconButton(
                                  // Here the Massage button
                                  hoverColor: Colors.grey,
                                  icon: Icon(
                                    Icons.message,
                                    color: Color.fromARGB(255, 127, 166, 233),
                                    size: 21,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatBody(
                                                  Freind_id: bookingModel.buyerId ?? "",
                                                )));
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RegExp("[a-zA-Z]").hasMatch(bookingModel.buyerName.toString())
                      ? Text("" + (bookingModel.buyerName ?? "") + "    : صاحب الحجز ")
                      : Text(" صاحب الحجز :   " + (bookingModel.buyerName ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" نوع الجولة : " + (bookingModel.bookType ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  if (bookingModel.bookType == "افتراضية")
                    Text("" + (bookingModel.videochat ?? "") + "    : التطبيق"),
                  Text(" رقم الحاجز :  " + (bookingModel.buyerPhone ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" التاريخ :   " + (bookingModel.date ?? "")),
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
      margin: EdgeInsets.fromLTRB(5, 10, 10, 5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(15),
      )),
      shadowColor: Color.fromARGB(255, 0, 0, 0),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 180, 178, 178),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            )),
        // ignore: prefer_const_constructors
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Column(
                children: [
                  Container(
                    height: 130,
                    width: 140,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(bookingModel.pimage ?? ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      realtyDetails(bookingModel.propertyId ?? "");
                    },
                    child: Text(
                      'تفاصيل العقار',
                      style: TextStyle(fontFamily: "Tajawal-m"),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 127, 166, 233),
                      ),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 9,
                  ),
                  Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(187, 234, 193, 193),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          width: 150,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Center(
                            child: Text(
                              'حجز مرفوض',
                              style: TextStyle(
                                color: Color.fromARGB(255, 124, 38, 38),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Tajawal-m",
                              ),
                            ),
                          )),
                      ////////////////
                      SizedBox(
                        width: 1,
                      ),
                      Column(
                        children: [
                          Container(
                            height: 36,
                            width: 30,
                            // margin: EdgeInsets.fromLTRB(0,0,1,0),
                            decoration: BoxDecoration(
                              // color: Color.fromARGB(121, 182, 201, 235),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: IconButton(
                                  // Here the Massage button
                                  hoverColor: Colors.grey,
                                  icon: Icon(
                                    Icons.message,
                                    color: Color.fromARGB(255, 127, 166, 233),
                                    size: 21,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatBody(
                                                  Freind_id: bookingModel.buyerId ?? "",
                                                )));
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RegExp("[a-zA-Z]").hasMatch(bookingModel.buyerName.toString())
                      ? Text("" + (bookingModel.buyerName ?? "") + "    : صاحب الحجز ")
                      : Text(" صاحب الحجز :   " + (bookingModel.buyerName ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" نوع الجولة :   " + (bookingModel.bookType ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  if (bookingModel.bookType == "افتراضية")
                    Text("" + (bookingModel.videochat ?? "") + "    : التطبيق"),
                  Text(" رقم الحاجز :   " + (bookingModel.buyerPhone ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" التاريخ :   " + (bookingModel.date ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" سبب الرفض :   " + (bookingModel.reason ?? "")),
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
      margin: EdgeInsets.fromLTRB(5, 10, 10, 5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(15),
      )),
      shadowColor: Color.fromARGB(255, 0, 0, 0),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 180, 178, 178),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            )),
        // ignore: prefer_const_constructors
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Column(
                children: [
                  Container(
                    height: 130,
                    width: 140,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(bookingModel.pimage ?? ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      realtyDetails(bookingModel.propertyId ?? "");
                    },
                    child: Text(
                      'تفاصيل العقار',
                      style: TextStyle(fontFamily: "Tajawal-m"),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 127, 166, 233),
                      ),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                      width: 150,
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
                  RegExp("[a-zA-Z]").hasMatch(bookingModel.buyerName.toString())
                      ? Text("" + (bookingModel.buyerName ?? "") + "    : صاحب الحجز ")
                      : Text(" صاحب الحجز :   " + (bookingModel.buyerName ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" نوع الجولة :   " + (bookingModel.bookType ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  if (bookingModel.bookType == "افتراضية")
                    Text("" + (bookingModel.videochat ?? "") + "    : التطبيق"),
                  Text(" رقم الحاجز :   " + (bookingModel.buyerPhone ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" التاريخ :   " + (bookingModel.date ?? "")),
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
      margin: EdgeInsets.fromLTRB(5, 10, 10, 5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(15),
      )),
      shadowColor: Color.fromARGB(255, 0, 0, 0),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 180, 178, 178),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            )),
        // ignore: prefer_const_constructors
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Column(
                children: [
                  Container(
                    height: 130,
                    width: 140,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(bookingModel.pimage ?? ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      realtyDetails(bookingModel.propertyId ?? "");
                    },
                    child: Text(
                      'تفاصيل العقار',
                      style: TextStyle(fontFamily: "Tajawal-m"),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 127, 166, 233),
                      ),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 9,
                  ),
                  Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(180, 207, 208, 212),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          width: 150,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Center(
                            child: Text(
                              'حجز ملغي',
                              style: TextStyle(
                                color: Color.fromARGB(255, 50, 50, 50),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Tajawal-m",
                              ),
                            ),
                          )),
                      ////////////////
                      SizedBox(
                        width: 1,
                      ),
                      Column(
                        children: [
                          Container(
                            height: 36,
                            width: 30,
                            // margin: EdgeInsets.fromLTRB(0,0,1,0),
                            decoration: BoxDecoration(
                              // color: Color.fromARGB(121, 182, 201, 235),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: IconButton(
                                  // Here the Massage button
                                  hoverColor: Colors.grey,
                                  icon: Icon(
                                    Icons.message,
                                    color: Color.fromARGB(255, 127, 166, 233),
                                    size: 21,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatBody(
                                                  Freind_id: bookingModel.buyerId ?? "",
                                                )));
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RegExp("[a-zA-Z]").hasMatch(bookingModel.buyerName.toString())
                      ? Text("" + (bookingModel.buyerName ?? "") + "    : صاحب الإلغاء ")
                      : Text(" صاحب الإلغاء :   " + (bookingModel.buyerName ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" نوع الجولة :   " + (bookingModel.bookType ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  if (bookingModel.bookType == "افتراضية")
                    Text("" + (bookingModel.videochat ?? "") + "    : التطبيق"),
                  Text(" رقم الحاجز :   " + (bookingModel.buyerPhone ?? "")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(" التاريخ :   " + (bookingModel.date ?? "")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void realtyDetails(Object isEqualTo) {
    print(isEqualTo);
    FirebaseFirestore.instance
        .collection('properties')
        .where('property_id', isEqualTo: isEqualTo)
        .get()
        .then((querySnapshot) async {
      if (querySnapshot.docs.isEmpty) {
        FirebaseFirestore.instance
            .collection('Hidden_properties')
            .where('property_id', isEqualTo: isEqualTo)
            .get()
            .then((Snapshot) async {
          if (Snapshot.docs.isEmpty) {
            Fluttertoast.showToast(
              msg: "عذرًا تم حذف هذا العقار ",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Color.fromARGB(255, 127, 166, 233),
              textColor: Color.fromARGB(255, 248, 249, 250),
              fontSize: 18.0,
            );
          } else {
            Fluttertoast.showToast(
              msg: "عذرًا هذا العقار موقوف",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Color.fromARGB(255, 127, 166, 233),
              textColor: Color.fromARGB(255, 248, 249, 250),
              fontSize: 18.0,
            );
          }
        });
      } else {
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
      }
    });
  }
}
