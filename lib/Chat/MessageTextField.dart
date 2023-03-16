import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:nozol_application/Chat/ChatBody.dart';

class MessageTextField extends StatefulWidget {
  final String friendId;

  MessageTextField(this.friendId);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _controller = TextEditingController();
  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String curentId = user!.uid;
  late StreamSubscription streamSub;

  void initState() {
    super.initState();
    initInfo();
    streamSub = FirebaseFirestore.instance
        .collection('Standard_user')
        .doc(curentId)
        .collection('messages')
        .doc(widget.friendId)
        .snapshots()
        .listen((event) {
      print("Listening Function");
      event.reference.update({
        "count_messages_unseen": 0,
        "is_show_last_message": true,
      });
    });
  }

  void dispose() {
    // TODO: implement dispose
    streamSub.cancel();
    super.dispose();
  }

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
          MaterialPageRoute<void>(
              builder: (context) => ChatBody(
                    Freind_id: widget.friendId,
                  )),
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

  void sendPushMessege(String token, String Fname, String msg) async {
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
              "title": "رسالة جديدة",
              "body": " $Fname : $msg ",
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(
                labelText: "الرسالة",
                hintStyle: TextStyle(fontWeight: FontWeight.bold),
                fillColor: Colors.grey[100],
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25))),
          )),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              if (!message.isEmpty) {
                _controller.clear();

                var Fr = await FirebaseFirestore.instance
                    .collection('Standard_user')
                    .doc(widget.friendId)
                    .get();
                var Me = await FirebaseFirestore.instance
                    .collection('Standard_user')
                    .doc(curentId)
                    .get();
////////////Current user ////////////
                await FirebaseFirestore.instance
                    .collection('Standard_user')
                    .doc(curentId)
                    .collection('messages')
                    .doc(widget.friendId)
                    .collection('chats')
                    .add({
                  "senderId": curentId,
                  "receiverId": widget.friendId,
                  "message": message,
                  "type": "text",
                  "date": DateTime.now(),
                }).then((value) {
                  print(" PART ONE 111111 curent user");
                  FirebaseFirestore.instance
                      .collection('Standard_user')
                      .doc(curentId)
                      .collection('messages')
                      .doc(widget.friendId)
                      .set({
                    "last_msg": message,
                    'count_messages_unseen': 0,
                    'date': DateTime.now(),
                  });
                  print(" PART ONE 333333 curent user");
                });

                ///////////Friend user //////////////
                await FirebaseFirestore.instance
                    .collection('Standard_user')
                    .doc(widget.friendId)
                    .collection('messages')
                    .doc(curentId)
                    .collection("chats")
                    .add({
                  "senderId": curentId,
                  "receiverId": widget.friendId,
                  "message": message,
                  "type": "text",
                  "date": DateTime.now(),
                }).then((value) {
                  FirebaseFirestore.instance
                      .collection('Standard_user')
                      .doc(widget.friendId)
                      .collection('messages')
                      .get()
                      .then((isExsist) async {
                    if (isExsist.docs.isEmpty) {
                      print(" PART ONE 111111");
                      FirebaseFirestore.instance
                          .collection('Standard_user')
                          .doc(widget.friendId)
                          .collection('messages')
                          .doc(curentId)
                          .set({
                        "last_msg": message,
                        'count_messages_unseen': FieldValue.increment(1),
                        'is_show_last_message': false,
                        'date': DateTime.now(),
                      });
                      print('DDDDDDDDDDONE 11111111');
                    } else {
                      print(" PART two 222222");
                      FirebaseFirestore.instance
                          .collection('Standard_user')
                          .doc(widget.friendId)
                          .collection('messages')
                          .doc(curentId)
                          .update({
                        "last_msg": message,
                        'count_messages_unseen': FieldValue.increment(1),
                        'is_show_last_message': false,
                        'date': DateTime.now(),
                      });
                      print('DDDDDDDDDDONE 222222222');
                    }
                  });
                });

                sendPushMessege(Fr['token'], Me['name'], message);
              }
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 127, 166, 233),
              ),
              child: Icon(
                Icons.send,
                color: Color.fromARGB(255, 238, 241, 244),
              ),
            ),
          )
        ],
      ),
    );
  }
}
