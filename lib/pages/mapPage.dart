// ignore_for_file: dead_code, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names, unused_import
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nozol_application/pages/filter_map.dart';
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

  static String? filter_val;

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
              backgroundColor: filter_val == "type"
                  ? Color.fromARGB(255, 166, 212, 243)
                  : filter_val == "price"
                      ? price_colored(villa.properties.price)
                      : filter_val == "space"
                          ? space_colored(villa.properties.space)
                          : Color.fromARGB(255, 42, 45, 237),
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
              backgroundColor: filter_val == "type"
                  ? Color.fromARGB(255, 243, 204, 166)
                  : filter_val == "price"
                      ? price_colored(apartment.properties.price)
                      : filter_val == "space"
                          ? space_colored(apartment.properties.space)
                          : Color.fromARGB(255, 42, 45, 237),
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
              backgroundColor: filter_val == "type"
                  ? Color.fromARGB(255, 243, 166, 240)
                  : filter_val == "price"
                      ? price_colored(building.properties.price)
                      : filter_val == "space"
                          ? space_colored(building.properties.space)
                          : Color.fromARGB(255, 42, 45, 237),
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
              backgroundColor: filter_val == "type"
                  ? Color.fromARGB(255, 166, 243, 220)
                  : filter_val == "price"
                      ? price_colored(land.properties!.price)
                      : filter_val == "space"
                          ? space_colored(land.properties!.space)
                          : Color.fromARGB(255, 42, 45, 237),
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
                  onPressed: () async {
                    final res = await showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => filterMap(),
                    );
                    setState(() {
                      filter_val = res["filter_val"];
                      initState();
                    });

                    print(filter_val);
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

  price_colored(String price) {
    var num = int.parse(price);

    if (num <= 9999) {
      return Color.fromARGB(255, 166, 212, 243);
    }
    if (num > 9999 && num <= 49999) {
      return Color.fromARGB(255, 243, 166, 240);
    }
    if (num > 49999 && num <= 99999) {
      return Color.fromARGB(255, 243, 204, 166);
    }
    if (num > 99999 && num <= 499999) {
      return Color.fromARGB(255, 180, 166, 243);
    }
    if (num > 499999 && num <= 999999) {
      return Color.fromARGB(255, 243, 166, 166);
    }
    if (num > 999999 && num <= 1999999) {
      return Color.fromARGB(255, 166, 240, 243);
    }
    if (num > 1999999 && num <= 2999999) {
      return Color.fromARGB(255, 119, 124, 118);
    }
    if (num > 2999999 && num <= 3999999) {
      return Color.fromARGB(255, 119, 52, 107);
    }
    if (num > 3999999 && num <= 4999999) {
      return Color.fromARGB(255, 115, 107, 99);
    }
    if (num > 4999999 && num <= 5999999) {
      return Color.fromARGB(255, 72, 107, 131);
    }
    if (num > 5999999 && num <= 6999999) {
      return Color.fromARGB(255, 223, 65, 57);
    }
    if (num > 6999999) {
      return Color.fromARGB(255, 211, 175, 103);
    }
  }

  space_colored(String space) {
    var num = int.parse(space);

    if (num <= 299) {
      return Color.fromARGB(255, 127, 218, 183);
    }
    if (num > 299 && num <= 599) {
      return Color.fromARGB(255, 20, 160, 90);
    }
    if (num > 599 && num <= 899) {
      return Color.fromARGB(255, 2, 85, 43);
    }
    if (num > 899 && num <= 1199) {
      return Color.fromARGB(255, 230, 222, 17);
    }
    if (num > 1199 && num <= 1499) {
      return Color.fromARGB(255, 182, 143, 36);
    }
    if (num > 1499 && num <= 1799) {
      return Color.fromARGB(255, 235, 117, 7);
    }
    if (num > 1799 && num <= 2199) {
      return Color.fromARGB(255, 240, 38, 38);
    }
    if (num > 2199 && num <= 2499) {
      return Color.fromARGB(255, 170, 6, 6);
    }
    if (num > 2499) {
      return Color.fromARGB(255, 77, 41, 14);
    }
  }

  change_color(String value) {
    setState(() {
      filter_val = value;
      initState();
    });
  }
}
