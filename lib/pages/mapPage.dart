import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = [];

  void initState() {
    intilize();
    super.initState();
  }

  intilize() async {
    try {
      FirebaseFirestore.instance
          .collection('properties')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            markers.add(Marker(
              markerId: MarkerId(element['property_id']),
              position: LatLng(element['latitude'], element['longitude']),
              onTap: () {
                if (element["type"] == "فيلا") {
                  Villa villa = Villa.fromMap(element.data());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VillaDetailes(villa: villa)),
                  );
                }
                if (element.data()["type"] == "شقة") {
                  Apartment apartment = Apartment.fromMap(element.data());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ApartmentDetailes(apartment: apartment)),
                  );
                }
                if (element.data()["type"] == "عمارة") {
                  Building building = Building.fromMap(element.data());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BuildingDetailes(building: building)),
                  );
                }
                if (element.data()["type"] == "ارض") {
                  Land land = Land.fromJson(element.data());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LandDetailes(land: land)),
                  );
                }
              },
            ));
          });
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 127, 166, 233),
            title: Text("MAP"),
          ),

          body: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(23.885942, 45.079162),
              zoom: 5,
            ),
            onMapCreated: (GoogleController) {
              _controller.complete(GoogleController);
            },
            markers: markers.map((e) => e).toSet(),
          ),

// this the button of swithing
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: SizedBox(
            width: 75,
            height: 75,
            child: FloatingActionButton(
              child: Icon(
                Icons.home,
                size: 35,
              ), //Text("View map", style: TextStyle(fontSize: 15, fontFamily: "Tajawal-b", ), textAlign: TextAlign.center, ),
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
