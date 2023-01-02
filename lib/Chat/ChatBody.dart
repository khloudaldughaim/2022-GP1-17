import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nozol_application/Chat/SingleMessage.dart';
import 'MessageTextField.dart';

class ChatBody extends StatefulWidget {
  //const ChatBody({super.key});
  final String Freind_id; //حق العقار 
  ChatBody(
  {required this.Freind_id});
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
  }
String Name =" ";

Future<void> FriendName() async {
final ref = await FirebaseFirestore.instance.collection('Standard_user').doc(widget.Freind_id).get();
Name = ref["name"];
setState(() {});

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 174, 222),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: CachedNetworkImage(
                            imageUrl:"https://wallpapercave.com/wp/wp9566480.png",
                            placeholder: (conteext,url)=>CircularProgressIndicator(),
                            errorWidget: (context,url,error)=>Icon(Icons.error,),
                            height: 40,
                          ),
            ),
            SizedBox(width: 5,),
            Text(Name,style: TextStyle(fontSize: 20),)
          ],
        ),
      ),

      body: Column(
        children: [
           Expanded(child: Container(
             padding: EdgeInsets.all(10),
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(25),
                 topRight: Radius.circular(25)
               )
             ),
             child: StreamBuilder(
               stream: FirebaseFirestore.instance.collection("Standard_user").doc(curentId).collection('messages').doc(widget.Freind_id).collection('chats').orderBy("date",descending: true).snapshots(),
               builder: (context,AsyncSnapshot snapshot){
                   if(snapshot.hasData){
                     if(snapshot.data.docs.length < 1){
                       return Center(
                         child: Text("Say Hi"),
                       );
                     }
                     return ListView.builder(
                       itemCount:snapshot.data.docs.length,
                       reverse: true,
                       physics: BouncingScrollPhysics(),
                       itemBuilder: (context,index){
                          bool isMe = snapshot.data.docs[index]['senderId'] == curentId;
                          return SingleMessage(message: snapshot.data.docs[index]['message'], isMe: isMe);
                       });
                   }
                   return Center(
                     child: CircularProgressIndicator()
                   );
               }),
           )),
           MessageTextField(curentId, widget.Freind_id),
        ],
      ),
      
    );
  }
}
