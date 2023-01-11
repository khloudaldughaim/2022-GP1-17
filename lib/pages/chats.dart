import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/Chat/ChatBody.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String curentId = user!.uid;
  void initState() {
    super.initState();
    // Notifications step 3
    requestPremission();
    getToken();
    // end of Notifications step 3
  }

  void requestPremission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
      print("User granted premission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
      print("User granted provisional permission");
    } else {
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
      print("User declined or has not accepted premission");
    }
  }

  String? mtoken = " ";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("Standard_user")
        .doc(curentId)
        .update({'token': token});
  }
///////////////////////////////////////////////////////////////////

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

        return alert ;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('المحادثات'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 138, 174, 222),
        actions: [],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Standard_user')
              .doc(curentId)
              .collection('messages')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length < 1) {
                return Center(
                  child: Text("No Chats Available!"),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var friendId = snapshot.data.docs[index].id;
                    var lastMsg = snapshot.data.docs[index]['last_msg'];

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

                              // AlertDialog alert = AlertDialog(
                              //   title: Text("حذف محادثة"),
                              //   content: Text("هل تريد حذف المحادثة؟"),
                              //   actions: [
                              //     TextButton(
                              //         onPressed: () async {
                              //           try {
                              //             await FirebaseFirestore.instance
                              //                 .collection('Standard_user')
                              //                 .doc(curentId)
                              //                 .collection('messages')
                              //                 .doc(friendId)
                              //                 .collection("chats")
                              //                 .get()
                              //                 .then((value) {
                              //               value.docs.forEach((element) {
                              //                 element.reference.delete();
                              //               });
                              //             });
                              //             print("move to the next");
                              //             await FirebaseFirestore.instance
                              //                 .collection('Standard_user')
                              //                 .doc(curentId)
                              //                 .collection('messages')
                              //                 .doc(friendId)
                              //                 .delete()
                              //                 .then((value) =>
                              //                     print('messages Deleted'));

                              //             print('delete button');
                              //             Navigator.of(context).pop();
                              //             print("it passed the naveigator");
                              //           } catch (e) {
                              //             print(e);
                              //           }
                              //         },
                              //         child: Text('حذف')),
                              //     TextButton(
                              //       child: Text("إلغاء"),
                              //       onPressed: () async {
                              //         Navigator.of(context).pop();
                              //       },
                              //     )
                              //   ],
                              // );
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return alert;
                              //   },
                              // );
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://wallpapercave.com/wp/wp9566480.png",
                                placeholder: (conteext, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                ),
                                height: 50,
                              ),
                            ),
                            title: Text(friend['name']),
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
