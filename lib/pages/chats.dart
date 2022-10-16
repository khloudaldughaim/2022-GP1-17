import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
   const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('ChatsPage'),
        ),
      ),
    );
  }
}
