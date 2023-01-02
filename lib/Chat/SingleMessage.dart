import 'package:flutter/material.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  SingleMessage({
    required this.message,
    required this.isMe
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
            color: isMe ? Color.fromARGB(255, 25, 106, 212) : Color.fromARGB(255, 55, 118, 211),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Text(message,style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),)
        ),
      ],
      
    );
  }
}