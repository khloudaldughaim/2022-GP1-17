// ignore_for_file: dead_code, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nozol_application/pages/villa.dart';
import 'apartment.dart';
import 'apartmentdetailes.dart';
import 'building.dart';
import 'buildingdetailes.dart';
import 'filter.dart';
import 'homapage.dart';
import 'land.dart';
import 'landdetailes.dart';
import 'villadetailes.dart';
import 'package:label_marker/label_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';

class mapPage extends StatefulWidget {
  const mapPage({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final void Function()? onPressed;

  @override
  State<mapPage> createState() => _MapPageState();
}

class _MapPageState extends State<mapPage> {
  int currentIndex = 0;

  final PageStorageBucket bucket = PageStorageBucket();

  GoogleMapController? controller;
  Set<Marker> markers = {};
  List<dynamic> MapArray = [];

  bool Bspace = false;
  bool Bprice = false;
  bool Btype = false;

  TextEditingController SearchController = TextEditingController();
  String name = '';

  void initState() {
    // if(HomePageState.FilterValue == true){
    //   print(HomePageState.FilterValue) ;
    //   intilize(HomePageState.FilteredItems);
    // }else{
    //   print(HomePageState.FilterValue) ;
    //   intilize(HomePageState.allData);
    // }
    if (HomePageState.indexOfTap == 0 &&
        HomePageState.FilterValue == false &&
        HomePageState.name.isEmpty) {
      print("length : ${HomePageState.allData.length}");
      intilize(HomePageState.allData);
    } else if (HomePageState.indexOfTap == 1 &&
        HomePageState.FilterValue == false &&
        HomePageState.name.isEmpty) {
      print("length : ${HomePageState.forRent.length}");
      intilize(HomePageState.forRent);
    } else if (HomePageState.indexOfTap == 2 &&
        HomePageState.FilterValue == false &&
        HomePageState.name.isEmpty) {
      print("length : ${HomePageState.forSale.length}");
      intilize(HomePageState.forSale);
    } else if (HomePageState.indexOfTap == 0 &&
        HomePageState.FilterValue == true &&
        HomePageState.name.isEmpty) {
      print("length : ${HomePageState.FilteredItems.length}");
      intilize(HomePageState.FilteredItems);
    } else if (HomePageState.indexOfTap == 1 &&
        HomePageState.FilterValue == true &&
        HomePageState.name.isEmpty) {
      print("length : ${HomePageState.FilterForRent.length}");
      intilize(HomePageState.FilterForRent);
    } else if (HomePageState.indexOfTap == 2 &&
        HomePageState.FilterValue == true &&
        HomePageState.name.isEmpty) {
      print("length : ${HomePageState.FilterForSale.length}");
      intilize(HomePageState.FilterForSale);
    } else if (HomePageState.indexOfTap == 0 &&
        HomePageState.FilterValue == false &&
        HomePageState.name.isNotEmpty) {
      print("length : ${HomePageState.searchItems.length}");
      intilize(HomePageState.searchItems);
    } else if (HomePageState.indexOfTap == 1 &&
        HomePageState.FilterValue == false &&
        HomePageState.name.isNotEmpty) {
      print("length : ${HomePageState.searchItemsForRent.length}");
      intilize(HomePageState.searchItemsForRent);
    } else if (HomePageState.indexOfTap == 2 &&
        HomePageState.FilterValue == false &&
        HomePageState.name.isNotEmpty) {
      print("length : ${HomePageState.searchItemsForSale.length}");
      intilize(HomePageState.searchItemsForSale);
    } else if (HomePageState.indexOfTap == 0 &&
        HomePageState.FilterValue == true &&
        HomePageState.name.isNotEmpty) {
      print("length : ${HomePageState.FilteredItems.length}");
      intilize(HomePageState.FilteredItems);
    } else if (HomePageState.indexOfTap == 1 &&
        HomePageState.FilterValue == true &&
        HomePageState.name.isNotEmpty) {
      print("length : ${HomePageState.FilterForRent.length}");
      intilize(HomePageState.FilterForRent);
    } else if (HomePageState.indexOfTap == 2 &&
        HomePageState.FilterValue == true &&
        HomePageState.name.isNotEmpty) {
      print("length : ${HomePageState.FilterForSale.length}");
      intilize(HomePageState.FilterForSale);
    }
    super.initState();
  }

  Future<void> intilize(MapArray) async {
    try {
      MapArray.forEach((element) {
        setState(() {
          if (element is Villa) {
            final villa = element;
            String titel = villa.properties.price;

            var num = int.parse(titel);
            if (titel.length <= 6) {
              var x = num / 1000;
              titel = x.toString() + "K";
            }
            ;
            if (titel.length > 6 && titel.length <= 9) {
              var x = num / 1000000;
              titel = x.toString() + "M";
            }
            ;
            if (titel.length > 9 && titel.length <= 12) {
              var x = num / 1000000000;
              titel = x.toString() + "B";
            }
            ;

            markers.addLabelMarker(LabelMarker(
              label: titel,
              markerId: MarkerId(villa.properties.property_id),
              position: LatLng(villa.properties.latitude, villa.properties.longitude),
              textStyle: TextStyle(
                  fontSize: 35.0,
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontFamily: 'Roboto Bold'),
              backgroundColor:
                  Btype ? Color.fromARGB(255, 166, 212, 243) : Color.fromARGB(255, 83, 111, 249),
              onTap: () {
                Row rowItem = Row(
                  children: [
                    Icon(
                      Icons.hotel,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      '${villa.number_of_room}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Tajawal-l",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.bathtub,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Text(
                      '${villa.number_of_bathroom}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Tajawal-l",
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.square_foot,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      '${villa.properties.space} متر ² ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Tajawal-l",
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.5,
                      maxChildSize: 0.9,
                      minChildSize: 0.5,
                      builder: (context, scrollController) {
                        return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(15),
                                right: Radius.circular(15),
                              ),
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 310),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 226, 237, 255),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          color: const Color.fromARGB(255, 127, 166, 233),
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Card(
                                  margin: EdgeInsets.fromLTRB(12, 12, 12, 6),
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  )),
                                  child: Container(
                                    height: 210,
                                    decoration: '${villa.properties.images.length}' == '0'
                                        ? BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg'),
                                                fit: BoxFit.cover),
                                          )
                                        : BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage('${villa.properties.images[0]}'),
                                                fit: BoxFit.cover),
                                          ),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.5, 1.0],
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.7),
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                              border: Border.all(
                                                width: 1.5,
                                                color: Color.fromARGB(255, 127, 166, 233),
                                              ),
                                            ),
                                            width: 85,
                                            padding: EdgeInsets.symmetric(vertical: 4),
                                            child: Center(
                                                child: '${villa.properties.classification}' ==
                                                        'للإيجار'
                                                    ? Text(
                                                        '${villa.properties.type} للإيجار',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      )
                                                    : Text(
                                                        '${villa.properties.type} للبيع',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      )),
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '${villa.properties.type}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Tajawal-l",
                                                    ),
                                                  ),
                                                  Text(
                                                    'ريال ${villa.properties.price}',
                                                    style: TextStyle(
                                                      height: 2,
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Tajawal-l",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_city,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        '${villa.properties.city}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-l",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  rowItem,
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VillaDetailes(villa: villa)),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 127, 166, 233)),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(27))),
                                  ),
                                  child: Text(
                                    " التفاصيل",
                                    style: TextStyle(fontSize: 18, fontFamily: "Tajawal-m"),
                                  ),
                                ),
                              ]),
                            ));
                      },
                    );
                  },
                );
              },
            ));
          }

          if (element is Apartment) {
            final apartment = element;
            String titel = apartment.properties.price;

            var num = int.parse(titel);
            if (titel.length <= 6) {
              var x = num / 1000;
              titel = x.toString() + "K";
            }
            ;
            if (titel.length > 6 && titel.length <= 9) {
              var x = num / 1000000;
              titel = x.toString() + "M";
            }
            ;
            if (titel.length > 9 && titel.length <= 12) {
              var x = num / 1000000000;
              titel = x.toString() + "B";
            }
            ;

            markers.addLabelMarker(LabelMarker(
              label: titel,
              markerId: MarkerId(apartment.properties.property_id),
              position: LatLng(apartment.properties.latitude, apartment.properties.longitude),
              textStyle: TextStyle(
                  fontSize: 35.0,
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontFamily: 'Roboto Bold'),
              backgroundColor:
                  Btype ? Color.fromARGB(255, 243, 204, 166) : Color.fromARGB(255, 83, 111, 249),
              onTap: () {
                Row rowItem = Row(
                  children: [
                    Icon(
                      Icons.hotel,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      '${apartment.number_of_room}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Tajawal-l",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.bathtub,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Text(
                      '${apartment.number_of_bathroom}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: "Tajawal-l",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.square_foot,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      '${apartment.properties.space} متر ² ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: "Tajawal-l",
                      ),
                    ),
                  ],
                );

                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.5,
                      maxChildSize: 0.9,
                      minChildSize: 0.5,
                      builder: (context, scrollController) {
                        return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(15),
                                right: Radius.circular(15),
                              ),
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 310),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 226, 237, 255),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          color: const Color.fromARGB(255, 127, 166, 233),
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Card(
                                  margin: EdgeInsets.fromLTRB(12, 12, 12, 6),
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  )),
                                  child: Container(
                                    height: 210,
                                    decoration: '${apartment.properties.images.length}' == '0'
                                        ? BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg'),
                                                fit: BoxFit.cover),
                                          )
                                        : BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    '${apartment.properties.images[0]}'),
                                                fit: BoxFit.cover),
                                          ),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.5, 1.0],
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.7),
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                              border: Border.all(
                                                width: 1.5,
                                                color: Color.fromARGB(255, 127, 166, 233),
                                              ),
                                            ),
                                            width: 85,
                                            padding: EdgeInsets.symmetric(vertical: 4),
                                            child: Center(
                                                child: '${apartment.properties.classification}' ==
                                                        'للإيجار'
                                                    ? Text(
                                                        '${apartment.properties.type} للإيجار',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      )
                                                    : Text(
                                                        '${apartment.properties.type} للبيع',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      )),
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '${apartment.properties.type}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Tajawal-l",
                                                    ),
                                                  ),
                                                  Text(
                                                    'ريال ${apartment.properties.price}',
                                                    style: TextStyle(
                                                      height: 2,
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Tajawal-l",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_city,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        '${apartment.properties.city}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-l",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  rowItem,
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ApartmentDetailes(apartment: apartment)),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 127, 166, 233)),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(27))),
                                  ),
                                  child: Text(
                                    " التفاصيل",
                                    style: TextStyle(fontSize: 18, fontFamily: "Tajawal-m"),
                                  ),
                                ),
                              ]),
                            ));
                      },
                    );
                  },
                );
              },
            ));
          }

          if (element is Building) {
            final building = element;
            String titel = building.properties.price;

            var num = int.parse(titel);
            if (titel.length <= 6) {
              var x = num / 1000;
              titel = x.toString() + "K";
            }
            ;
            if (titel.length > 6 && titel.length <= 9) {
              var x = num / 1000000;
              titel = x.toString() + "M";
            }
            ;
            if (titel.length > 9 && titel.length <= 12) {
              var x = num / 1000000000;
              titel = x.toString() + "B";
            }
            ;

            markers.addLabelMarker(LabelMarker(
              label: titel,
              markerId: MarkerId(building.properties.property_id),
              position: LatLng(building.properties.latitude, building.properties.longitude),
              textStyle: TextStyle(
                  fontSize: 35.0,
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontFamily: 'Roboto Bold'),
              backgroundColor:
                  Btype ? Color.fromARGB(255, 243, 166, 240) : Color.fromARGB(255, 83, 111, 249),
              onTap: () {
                Row rowItem = Row(
                  children: [
                    Icon(
                      Icons.square_foot,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      '${building.properties.space} متر ² ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: "Tajawal-l",
                      ),
                    ),
                  ],
                );
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.5,
                      maxChildSize: 0.9,
                      minChildSize: 0.5,
                      builder: (context, scrollController) {
                        return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(15),
                                right: Radius.circular(15),
                              ),
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 310),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 226, 237, 255),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          color: const Color.fromARGB(255, 127, 166, 233),
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Card(
                                  margin: EdgeInsets.fromLTRB(12, 12, 12, 6),
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  )),
                                  child: Container(
                                    height: 210,
                                    decoration: '${building.properties.images.length}' == '0'
                                        ? BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg'),
                                                fit: BoxFit.cover),
                                          )
                                        : BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    '${building.properties.images[0]}'),
                                                fit: BoxFit.cover),
                                          ),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.5, 1.0],
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.7),
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                              border: Border.all(
                                                width: 1.5,
                                                color: Color.fromARGB(255, 127, 166, 233),
                                              ),
                                            ),
                                            width: 85,
                                            padding: EdgeInsets.symmetric(vertical: 4),
                                            child: Center(
                                                child: '${building.properties.classification}' ==
                                                        'للإيجار'
                                                    ? Text(
                                                        '${building.properties.type} للإيجار',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      )
                                                    : Text(
                                                        '${building.properties.type} للبيع',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      )),
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '${building.properties.type}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Tajawal-l",
                                                    ),
                                                  ),
                                                  Text(
                                                    'ريال ${building.properties.price}',
                                                    style: TextStyle(
                                                      height: 2,
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Tajawal-l",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_city,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        '${building.properties.city}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-l",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  rowItem,
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BuildingDetailes(building: building)),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 127, 166, 233)),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(27))),
                                  ),
                                  child: Text(
                                    " التفاصيل",
                                    style: TextStyle(fontSize: 18, fontFamily: "Tajawal-m"),
                                  ),
                                ),
                              ]),
                            ));
                      },
                    );
                  },
                );
              },
            ));
          }

          if (element is Land) {
            final land = element;
            String titel = land.properties!.price;

            var num = int.parse(titel);
            if (titel.length <= 6) {
              var x = num / 1000;
              titel = x.toString() + "K";
            }
            ;
            if (titel.length > 6 && titel.length <= 9) {
              var x = num / 1000000;
              titel = x.toString() + "M";
            }
            ;
            if (titel.length > 9 && titel.length <= 12) {
              var x = num / 1000000000;
              titel = x.toString() + "B";
            }
            ;

            markers.addLabelMarker(LabelMarker(
              label: titel,
              markerId: MarkerId(land.properties!.property_id),
              position: LatLng(land.properties!.latitude, land.properties!.longitude),
              textStyle: TextStyle(
                  fontSize: 35.0,
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontFamily: 'Roboto Bold'),
              backgroundColor:
                  Btype ? Color.fromARGB(255, 166, 243, 220) : Color.fromARGB(255, 83, 111, 249),
              onTap: () {
                Row rowItem = Row(
                  children: [
                    Icon(
                      Icons.square_foot,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      '${land.properties!.space} متر ² ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: "Tajawal-l",
                      ),
                    ),
                  ],
                );

                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.5,
                      maxChildSize: 0.9,
                      minChildSize: 0.5,
                      builder: (context, scrollController) {
                        return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(15),
                                right: Radius.circular(15),
                              ),
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 310),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 226, 237, 255),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          color: const Color.fromARGB(255, 127, 166, 233),
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Card(
                                  margin: EdgeInsets.fromLTRB(12, 12, 12, 6),
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  )),
                                  child: Container(
                                    height: 210,
                                    decoration: '${land.properties!.images.length}' == '0'
                                        ? BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg'),
                                                fit: BoxFit.cover),
                                          )
                                        : BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage('${land.properties!.images[0]}'),
                                                fit: BoxFit.cover),
                                          ),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.5, 1.0],
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.7),
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                              border: Border.all(
                                                width: 1.5,
                                                color: Color.fromARGB(255, 127, 166, 233),
                                              ),
                                            ),
                                            width: 85,
                                            padding: EdgeInsets.symmetric(vertical: 4),
                                            child: Center(
                                                child: '${land.properties!.classification}' ==
                                                        'للإيجار'
                                                    ? Text(
                                                        '${land.properties!.type} للإيجار',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      )
                                                    : Text(
                                                        '${land.properties!.type} للبيع',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-m",
                                                        ),
                                                      )),
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '${land.properties!.type}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Tajawal-l",
                                                    ),
                                                  ),
                                                  Text(
                                                    'ريال ${land.properties!.price}',
                                                    style: TextStyle(
                                                      height: 2,
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Tajawal-l",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_city,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        '${land.properties!.city}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Tajawal-l",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  rowItem,
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LandDetailes(land: land)),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 127, 166, 233)),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(27))),
                                  ),
                                  child: Text(
                                    " التفاصيل",
                                    style: TextStyle(fontSize: 18, fontFamily: "Tajawal-m"),
                                  ),
                                ),
                              ]),
                            ));
                      },
                    );
                  },
                );
              },
            ));
          }
        });
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {});
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(23.885942, 45.079162),
              zoom: 5,
            ),
            onMapCreated: (mapController) {
              controller = mapController;
            },
            markers: markers.map((e) => e).toSet(),
          ),
          Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 20),
              child: SearchMapPlaceWidget(
                strictBounds: true,
                apiKey: "AIzaSyDKNtlGQXbyJBJYvBx-OrWqMbjln4NxTxs",
                bgColor: Colors.white,
                textColor: Color.fromARGB(255, 74, 74, 74),
                hasClearButton: true,
                placeholder: "...إبحث عن مدينة، حي",
                placeType: PlaceType.address,
                onSelected: (place) async {
                  Geolocation? geolocation = await place.geolocation;

                  controller!.animateCamera(CameraUpdate.newLatLng(geolocation!.coordinates));
                  controller!.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                },
              )),
          Container(
            margin: EdgeInsets.only(bottom: 160, left: 20),
            child: CircleAvatar(
              backgroundColor: Color.fromARGB(248, 225, 230, 251),
              radius: 35,
              child: Column(children: [
                IconButton(
                  icon: Icon(
                    Icons.layers,
                    color: Color.fromARGB(255, 127, 166, 233),
                    size: 30,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.5,
                          maxChildSize: 0.9,
                          minChildSize: 0.5,
                          builder: (context, scrollController) {
                            return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(15),
                                    right: Radius.circular(15),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 310),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 226, 237, 255),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.close,
                                              color: const Color.fromARGB(255, 127, 166, 233),
                                              size: 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "خصائص الخريطة",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Tajawal-b",
                                          color: Color.fromARGB(255, 127, 166, 233)),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    //                 Directionality(
                                    // textDirection: TextDirection.rtl,
                                    Padding(
                                        padding: EdgeInsets.only(left: 230),
                                        child: Text(
                                          ": ألوان الخريطة تحدد",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "Tajawal-m",
                                              color: Color.fromARGB(255, 91, 94, 98)),
                                        )),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 180.0,
                                          height: 50.0,
                                          child: Padding(
                                              padding: EdgeInsets.only(left: 30),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Btype = true;
                                                    Bprice = false;
                                                    Bspace = false;
                                                    print("stttt");
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    side: BorderSide(
                                                        color: Color.fromARGB(255, 135, 136, 138)),
                                                    elevation: 3,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10.0)),
                                                    backgroundColor: Btype
                                                        ? Color.fromARGB(255, 135, 165, 203)
                                                        : Color.fromARGB(194, 180, 183, 187)),
                                                child: Center(
                                                    child: Text(
                                                  "نوع العقار",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: "Tajawal-m",
                                                      color: Color.fromARGB(255, 255, 255, 255)),
                                                )),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 180.0,
                                          height: 50.0,
                                          child: Padding(
                                              padding: EdgeInsets.only(left: 30),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Bspace = false;
                                                    Btype = false;
                                                    Bprice = true;
                                                    print("stttt");
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    side: BorderSide(
                                                        color: Color.fromARGB(255, 135, 136, 138)),
                                                    elevation: 3,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10.0)),
                                                    backgroundColor: Bprice
                                                        ? Color.fromARGB(255, 135, 165, 203)
                                                        : Color.fromARGB(194, 180, 183, 187)),
                                                child: Center(
                                                    child: Text(
                                                  "سعر العقار",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: "Tajawal-m",
                                                      color: Color.fromARGB(255, 255, 255, 255)),
                                                )),
                                              )),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 180.0,
                                      height: 50.0,
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                Bspace = true;
                                                Btype = false;
                                                Bprice = false;
                                                print("stttt");
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                side: BorderSide(
                                                    color: Color.fromARGB(255, 135, 136, 138)),
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0)),
                                                backgroundColor: Bspace
                                                    ? Color.fromARGB(255, 135, 165, 203)
                                                    : Color.fromARGB(194, 180, 183, 187)),
                                            child: Center(
                                                child: Text(
                                              "المساحة",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: "Tajawal-m",
                                                  color: Color.fromARGB(255, 255, 255, 255)),
                                            )),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    if (Btype)
                                      Container(
                                        child: Column(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("فيلا",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 166, 212, 243),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("عمارة",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 243, 166, 240),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("شقة",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 243, 204, 166),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(left: 270),
                                                child: Container(
                                                  width: 110,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color.fromARGB(68, 178, 178, 178),
                                                      width: 1,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text("أرض",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily: "Tajawal-m",
                                                          )),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Icon(
                                                        Icons.circle,
                                                        color: Color.fromARGB(255, 166, 243, 220),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    if (Bspace)
                                      Container(
                                        child: Column(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("400-599",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 243, 204, 166),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("200-399",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 243, 166, 240),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("0-199",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 166, 212, 243),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("1000-1199",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 166, 240, 243),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("800-999",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 243, 166, 166),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("600-799",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 180, 166, 243),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("1600-1799",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 115, 107, 99),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("1400-1599",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 119, 116, 52),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("1200-1399",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 119, 124, 118),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text(">2200",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 125, 124, 122),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("2000-2200",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 207, 196, 206),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("1800-1999",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 72, 107, 131),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    if (Bprice)
                                      Container(
                                        child: Column(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("50K - 99.9K",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 243, 204, 166),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("10K - 49.9K",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 243, 166, 240),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("0 - 9.99K",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 166, 212, 243),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("1M - 1.99M",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 166, 240, 243),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("500K - 999K",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 243, 166, 166),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("100K - 499K",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 180, 166, 243),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("4M - 4.99M",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 115, 107, 99),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("3M - 3.99M",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 119, 116, 52),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("2M - 2.99M",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 119, 124, 118),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text(">6,99M",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 125, 124, 122),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("6M - 6.99M",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 207, 196, 206),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Container(
                                                          width: 110,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Color.fromARGB(68, 178, 178, 178),
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.end,
                                                            children: [
                                                              Text("5M - 5.99M",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: "Tajawal-m",
                                                                  )),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.circle,
                                                                color: Color.fromARGB(
                                                                    255, 72, 107, 131),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                  ]),
                                ));
                          },
                        );
                      },
                    );
                  },
                ),
                Text(
                  " خصائص",
                  style: TextStyle(
                      fontSize: 11,
                      fontFamily: "Tajawal-b",
                      color: Color.fromARGB(255, 127, 166, 233)),
                )
              ]),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 80, left: 20),
            child: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 225, 231, 255),
              radius: 35,
              child: IconButton(
                icon: Icon(Icons.list, color: Color.fromARGB(255, 127, 166, 233), size: 30),
                onPressed: widget.onPressed,
              ),
            ),
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
