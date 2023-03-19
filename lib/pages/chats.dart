import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:nozol_application/Chat/ChatBody.dart';

import '../registration/log_in.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String curentId = user!.uid;

  showAlertDialog(BuildContext context, friendId) {
    Widget cancelButton = TextButton(
      child: Text("إلغاء"),
      onPressed: () async {
        Navigator.of(context).pop();
      },
    );

    Widget DeleteButton = TextButton(
        onPressed: () async {
          try {
            await FirebaseFirestore.instance
                .collection('Standard_user')
                .doc(curentId)
                .collection('messages')
                .doc(friendId)
                .collection("chats")
                .get()
                .then((value) {
              value.docs.forEach((element) {
                element.reference.delete();
              });
            });
            print("move to the next");
            await FirebaseFirestore.instance
                .collection('Standard_user')
                .doc(curentId)
                .collection('messages')
                .doc(friendId)
                .delete()
                .then((value) => print('messages Deleted'));

            print('delete button');
            Navigator.of(context).pop();
            print("it passed the naveigator");
          } catch (e) {
            print(e);
          }
        },
        child: Text('حذف'));
    AlertDialog alert = AlertDialog(
        title: Text("حذف محادثة"),
        content: Text("هل تريد حذف المحادثة؟"),
        actions: [cancelButton, DeleteButton]);

    return alert;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'المحادثات',
          style: TextStyle(
            fontSize: 17,
            fontFamily: "Tajawal-b",
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 127, 166, 233),
        actions: [],
      ),
      body: FirebaseAuth.instance.currentUser == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(height: 70),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 79),
                    child: Text(
                      "عذراً لابد من تسجيل الدخول ",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Tajawal-b",
                          color: Color.fromARGB(255, 127, 166, 233)),
                      textAlign: TextAlign.center,
                    )),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 127, 166, 233)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                  ),
                  child: Text(
                    "تسجيل الدخول",
                    style: TextStyle(fontSize: 20, fontFamily: "Tajawal-m"),
                  ),
                )
              ],
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Standard_user')
                  .doc(curentId)
                  .collection('messages')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length < 1) {
                    return Center(
                      child: Text("لا توجد محادثات بعد"),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        var friendId = snapshot.data.docs[index].id;
                        var lastMsg = snapshot.data.docs[index]['last_msg'];
                        var BadgeCounter = snapshot.data.docs[index]['count_messages_unseen'];

                        //       FirebaseFirestore.instance
                        //     .collection('Standard_user')
                        //     .doc(curentId)
                        //     .collection('messages')
                        //     .doc(friendId)
                        //     .collection("chats")
                        //     .get()
                        //     .then(
                        //   (value) {
                        //     value.docs.forEach((element) async {
                        //           if (element['message'] == lastMsg) {
                        //         if (element['senderId'] == curentId) {
                        //        lastMsg = lastMsg + " : أنت  ";
                        //         }
                        //          else if (element['senderId'] == friendId){
                        //                var frind =  await FirebaseFirestore.instance
                        //               .collection('Standard_user')
                        //               .doc(friendId)
                        //               .get();
                        //               print(frind['name']);
                        //                   lastMsg = lastMsg + " : " + frind['name'];
                        //         }
                        //       }

                        //     });
                        //   },
                        // );

                        //  print(lastMsg);
                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('Standard_user')
                              .doc(friendId)
                              .get(),
                          builder: (context, AsyncSnapshot asyncSnapshot) {
                            if (asyncSnapshot.hasData) {
                              var friend = asyncSnapshot.data;
                              return ListTile(
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return showAlertDialog(context, friendId);
                                      },
                                    );
                                  },
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: CachedNetworkImage(
                                      imageUrl: "https://wallpapercave.com/wp/wp9566480.png",
                                      placeholder: (conteext, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(
                                        Icons.error,
                                      ),
                                      height: 50,
                                    ),
                                  ),
                                  title: Text(
                                    friend['name'],
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: "Tajawal-m",
                                    ),
                                  ),
                                  subtitle: Container(
                                    child: Text(
                                      "$lastMsg",
                                      style: TextStyle(color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatBody(
                                                  Freind_id: friend['userId'],
                                                )));
                                  },
                                  trailing: BadgeCounter == 0
                                      ? SizedBox()
                                      : Material(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Color.fromARGB(255, 127, 166, 233),
                                          child: SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                                top: 2,
                                                bottom: 1,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${BadgeCounter > 99 ? '99+' : BadgeCounter}',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        shape: Border(
        bottom: BorderSide( width : 0.6, color: Colors.grey),
    ),
                                        );
                            }
                            return LinearProgressIndicator();
                          },
                        );
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
    );
  } //
}
