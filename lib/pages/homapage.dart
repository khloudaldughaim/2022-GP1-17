// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
       return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
           // bottom: const 
            title: Center(child: const Text('NOZOL')),
            toolbarHeight: 60,
            backgroundColor:  Color.fromARGB(255, 127, 166, 233),
            
          ),
          body: Column(
            children: [
              SizedBox(height: 15,),
              TabBar(
                labelColor: Color.fromARGB(255, 57, 64, 141),
                  tabs: [
                    Tab(text:'ALL',),
                    Tab(text: 'FOR RENT',),
                    Tab(text: 'For SALE',),
                  ],
                ),
            ],
          ),
          // body: const TabBarView(
          //   children: [
          //     Icon(Icons.directions_car),
          //     Icon(Icons.directions_transit),
          //     Icon(Icons.directions_bike),
          //   ],
          // ),
        ),
      ),
    );
   
  }
}
