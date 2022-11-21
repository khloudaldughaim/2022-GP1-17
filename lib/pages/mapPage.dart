import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/pages/homapage.dart';
import 'package:nozol_application/pages/navigationbar.dart';
import 'package:nozol_application/pages/villa.dart';
import 'package:nozol_application/registration/log_in.dart';
import 'apartment.dart';
import 'apartmentdetailes.dart';
import 'building.dart';
import 'buildingdetailes.dart';
import 'land.dart';
import 'landdetailes.dart';
import 'villadetailes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class mapPage extends StatefulWidget {
  const mapPage({Key? key}) : super(key: key);

  @override
  State<mapPage> createState() => _MapPageState();

}

class _MapPageState extends State<mapPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
home: SafeArea(
  child:Scaffold(
   appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 127, 166, 233),
              title: Text("MAP"),
            
            ),
  
  body: GoogleMap(
    initialCameraPosition:
     CameraPosition(
      target: LatLng(23.885942, 45.079162),
      //zoom: 19,
      )
     ),
floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
 floatingActionButton: SizedBox(
       width: 75,
        height: 75,
      child: FloatingActionButton(  
          child:  Icon(Icons.home, size: 35,),  //Text("View map", style: TextStyle(fontSize: 15, fontFamily: "Tajawal-b", ), textAlign: TextAlign.center, ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),  
          foregroundColor: Color.fromARGB(255, 93, 119, 185),  
          onPressed: () => {
           Navigator.push(
           context,
          MaterialPageRoute(
          builder: (context) => NavigationBarPage()))
          },  
        ),
    ),  

  ),
),
    );
  }
}