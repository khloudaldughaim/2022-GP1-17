// ignore_for_file: dead_code, prefer_const_constructors
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
import 'land.dart';
import 'landdetailes.dart';
import 'villadetailes.dart';
import 'package:label_marker/label_marker.dart';

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

  void initState() {
    intilize();
    super.initState();
  }

  Future<void> intilize() async {
    try {
      await FirebaseFirestore.instance
          .collection('properties')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            var titel = element['price'];
            markers.addLabelMarker(LabelMarker(
              label: titel,
              markerId: MarkerId(element['property_id']),
              position: LatLng(element['latitude'], element['longitude']),
              onTap: () {
                if (element["type"] == "فيلا") {
                  Villa villa = Villa.fromMap(element.data());
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
                                          color: Color.fromARGB(
                                              255, 226, 237, 255),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: const Color.fromARGB(
                                                255, 127, 166, 233),
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
                                      decoration:
                                          '${villa.properties.images.length}' ==
                                                  '0'
                                              ? BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          'https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg'),
                                                      fit: BoxFit.cover),
                                                )
                                              : BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          '${villa.properties.images[0]}'),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                                border: Border.all(
                                                  width: 1.5,
                                                  color: Color.fromARGB(
                                                      255, 127, 166, 233),
                                                ),
                                              ),
                                              width: 85,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4),
                                              child: Center(
                                                  child:
                                                      '${villa.properties.classification}' ==
                                                              'للإيجار'
                                                          ? Text(
                                                              '${villa.properties.type} للإيجار',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Tajawal-m",
                                                              ),
                                                            )
                                                          : Text(
                                                              '${villa.properties.type} للبيع',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Tajawal-m",
                                                              ),
                                                            )),
                                            ),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${villa.properties.type}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Tajawal-l",
                                                      ),
                                                    ),
                                                    Text(
                                                      'ريال ${villa.properties.price}',
                                                      style: TextStyle(
                                                        height: 2,
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Tajawal-l",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Tajawal-l",
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
                                                VillaDetailes(villa: villa)),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color.fromARGB(
                                                  255, 127, 166, 233)),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 10)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(27))),
                                    ),
                                    child: Text(
                                      " التفاصيل",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Tajawal-m"),
                                    ),
                                  ),
                                ]),
                              ));
                        },
                      );
                    },
                  );
                }
                if (element.data()["type"] == "شقة") {
                  Apartment apartment = Apartment.fromMap(element.data());

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
                                          color: Color.fromARGB(
                                              255, 226, 237, 255),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: const Color.fromARGB(
                                                255, 127, 166, 233),
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
                                      decoration:
                                          '${apartment.properties.images.length}' ==
                                                  '0'
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                                border: Border.all(
                                                  width: 1.5,
                                                  color: Color.fromARGB(
                                                      255, 127, 166, 233),
                                                ),
                                              ),
                                              width: 85,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4),
                                              child: Center(
                                                  child:
                                                      '${apartment.properties.classification}' ==
                                                              'للإيجار'
                                                          ? Text(
                                                              '${apartment.properties.type} للإيجار',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Tajawal-m",
                                                              ),
                                                            )
                                                          : Text(
                                                              '${apartment.properties.type} للبيع',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Tajawal-m",
                                                              ),
                                                            )),
                                            ),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${apartment.properties.type}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Tajawal-l",
                                                      ),
                                                    ),
                                                    Text(
                                                      'ريال ${apartment.properties.price}',
                                                      style: TextStyle(
                                                        height: 2,
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Tajawal-l",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Tajawal-l",
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
                                                ApartmentDetailes(
                                                    apartment: apartment)),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color.fromARGB(
                                                  255, 127, 166, 233)),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 10)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(27))),
                                    ),
                                    child: Text(
                                      " التفاصيل",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Tajawal-m"),
                                    ),
                                  ),
                                ]),
                              ));
                        },
                      );
                    },
                  );
                }
                if (element.data()["type"] == "عمارة") {
                  Building building = Building.fromMap(element.data());
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
                                          color: Color.fromARGB(
                                              255, 226, 237, 255),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: const Color.fromARGB(
                                                255, 127, 166, 233),
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
                                      decoration:
                                          '${building.properties.images.length}' ==
                                                  '0'
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                                border: Border.all(
                                                  width: 1.5,
                                                  color: Color.fromARGB(
                                                      255, 127, 166, 233),
                                                ),
                                              ),
                                              width: 85,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4),
                                              child: Center(
                                                  child:
                                                      '${building.properties.classification}' ==
                                                              'للإيجار'
                                                          ? Text(
                                                              '${building.properties.type} للإيجار',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Tajawal-m",
                                                              ),
                                                            )
                                                          : Text(
                                                              '${building.properties.type} للبيع',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Tajawal-m",
                                                              ),
                                                            )),
                                            ),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${building.properties.type}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Tajawal-l",
                                                      ),
                                                    ),
                                                    Text(
                                                      'ريال ${building.properties.price}',
                                                      style: TextStyle(
                                                        height: 2,
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Tajawal-l",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Tajawal-l",
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
                                                BuildingDetailes(
                                                    building: building)),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color.fromARGB(
                                                  255, 127, 166, 233)),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 10)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(27))),
                                    ),
                                    child: Text(
                                      " التفاصيل",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Tajawal-m"),
                                    ),
                                  ),
                                ]),
                              ));
                        },
                      );
                    },
                  );
                }
                if (element.data()["type"] == "ارض") {
                  Land land = Land.fromJson(element.data());
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
                                          color: Color.fromARGB(
                                              255, 226, 237, 255),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: const Color.fromARGB(
                                                255, 127, 166, 233),
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
                                      decoration:
                                          '${land.properties!.images.length}' ==
                                                  '0'
                                              ? BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          'https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg'),
                                                      fit: BoxFit.cover),
                                                )
                                              : BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          '${land.properties!.images[0]}'),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                                border: Border.all(
                                                  width: 1.5,
                                                  color: Color.fromARGB(
                                                      255, 127, 166, 233),
                                                ),
                                              ),
                                              width: 85,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4),
                                              child: Center(
                                                  child:
                                                      '${land.properties!.classification}' ==
                                                              'للإيجار'
                                                          ? Text(
                                                              '${land.properties!.type} للإيجار',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Tajawal-m",
                                                              ),
                                                            )
                                                          : Text(
                                                              '${land.properties!.type} للبيع',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Tajawal-m",
                                                              ),
                                                            )),
                                            ),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${land.properties!.type}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Tajawal-l",
                                                      ),
                                                    ),
                                                    Text(
                                                      'ريال ${land.properties!.price}',
                                                      style: TextStyle(
                                                        height: 2,
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Tajawal-l",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Tajawal-l",
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
                                                LandDetailes(land: land)),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color.fromARGB(
                                                  255, 127, 166, 233)),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 10)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(27))),
                                    ),
                                    child: Text(
                                      " التفاصيل",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Tajawal-m"),
                                    ),
                                  ),
                                ]),
                              ));
                        },
                      );
                    },
                  );
                }
              },
            ));
          });
        });
        Future.delayed(Duration(seconds: 2), () {
          setState(() {});
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          margin: EdgeInsets.all(24),
          child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 225, 231, 255),
            radius: 30,
            child: IconButton(
              icon: Icon(Icons.home, color: Color.fromARGB(255, 127, 166, 233)),
              onPressed: widget.onPressed,
            ),
          ),
        ),
      ],
    );
  }
}
