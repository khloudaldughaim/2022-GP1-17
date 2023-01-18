import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nozol_application/Chat/SingleMessage.dart';
import 'package:nozol_application/pages/chats.dart';
import 'MessageTextField.dart';

class ChatBody extends StatefulWidget {
  //const ChatBody({super.key});
  final String Freind_id; //حق العقار
  ChatBody({required this.Freind_id});
  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String curentId = user!.uid;

  void initState() {
    super.initState();
    FriendName();
    saveToken();
   ///Problem 
    // FirebaseFirestore.instance
    //     .collection('Standard_user')
    //     .doc(curentId)
    //     .collection('messages')
    //     .doc(widget.Freind_id)
    //     .snapshots()
    //     .listen((event) {
    //     print("in listen function");
    //   event.reference.update({
    //     "count_messages_unseen": 0,
    //     "is_show_last_message": true,
    //   });
    // });
  }

    String Name = " ";

  Future<void> FriendName() async {
    final ref = await FirebaseFirestore.instance
        .collection('Standard_user')
        .doc(widget.Freind_id)
        .get();
    Name = ref["name"];
    print(widget.Freind_id);
    setState(() {});
  }

  void saveToken() async {
    // futuer
    await FirebaseFirestore.instance
        .collection("Standard_user")
        .doc(curentId)
        .update({'token': ''});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 138, 174, 222),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: CachedNetworkImage(
                imageUrl: "https://wallpapercave.com/wp/wp9566480.png",
                placeholder: (conteext, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                ),
                height: 40,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              Name,
              style: TextStyle(fontSize: 20),
            )
          ],
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
      body: Column(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Standard_user")
                    .doc(curentId)
                    .collection('messages')
                    .doc(widget.Freind_id)
                    .collection('chats')
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return Center(
                        child: Text("لا توجد رسائل بعد"),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isMe =
                              snapshot.data.docs[index]['senderId'] == curentId;
                          return SingleMessage(
                              message: snapshot.data.docs[index]['message'],
                              isMe: isMe);
                        });
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          )),
          MessageTextField(widget.Freind_id),
        ],
      ),
    );
  }
}
