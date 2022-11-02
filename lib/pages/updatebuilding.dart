// import 'package:flutter/cupertino.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:nozol_application/pages/building.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:csc_picker/csc_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import '../registration/log_in.dart';
import '../registration/sign_up.dart';
import 'building.dart';

class UpdateBuilding extends StatefulWidget {
  final Building building;

  UpdateBuilding({required this.building});

  @override
  State<UpdateBuilding> createState() => _UpdateBuildingState();
}

enum classification { rent, sale }

enum propertyUse { residental, commercial }

enum choice { yes, no }

LatLng mapLatLng = LatLng(23.88, 45.0792);

class _UpdateBuildingState extends State<UpdateBuilding> {
  @override
  Widget build(BuildContext context) {

    String type = '${widget.building.properties.type}' ;
    final _formKey = GlobalKey<FormState>();
    String property_id = '${widget.building.properties.property_id}';
    classification? _class = classification.rent;
    String classification1 = '${widget.building.properties.classification}';
    String price = '${widget.building.properties.price}';
    String space = '${widget.building.properties.space}';
    double property_age = 0.0;
    choice? _poolCH = choice.no; 
    choice? _elevatorCH = choice.no;
    bool pool = widget.building.pool ;
    bool elevator = widget.building.elevator;
    String city = '${widget.building.properties.city}';
    String? address = "";
    int number_of_floors = widget.building.number_of_floor;
    int number_of_apartments = widget.building.number_of_apartment;

    final ImagePicker _picker = ImagePicker();
    List<XFile> selectedFiles = [];

    GoogleMapController? controller;

    // showAlertDialog(BuildContext context) {
    //   // set up the buttons
    //   Widget cancelButton = TextButton(
    //     child: Text("إلغاء"),
    //     onPressed: () async {
    //       Navigator.of(context).pop();
    //     },
    //   );
    //   Widget continueButton = TextButton(
    //     child: Text("تأكيد"),
    //     onPressed: () async {
    //       final FirebaseAuth auth = FirebaseAuth.instance;
    //       final User? user = auth.currentUser;
    //       final User_id = user!.uid;
    //       print(User_id);

    //       List<String> arrImage = [];
    //       for (int i = 0; i < selectedFiles.length; i++) {
    //         var imageUrl = await uploadFile(selectedFiles[i], User_id);
    //         arrImage.add(imageUrl.toString());
    //       }

    //       _formKey.currentState!.save();

    //         FirebaseFirestore.instance.collection('properties').add({
    //           'classification': classification1,
    //           'latitude': mapLatLng.latitude,
    //           'longitude': mapLatLng.longitude,
    //           'price': price,
    //           'space': space,
    //           'city': city,
    //           'neighborhood': address,
    //           'images': arrImage,
    //           'property_age': property_age,
    //           'number_of_floors': number_of_floors,
    //           'elevator': elevator,
    //           'pool': pool,
    //           'number_of_apartments': number_of_apartments
    //         });

    //       Navigator.of(context).pop();
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(content: Text(' تمت إضافة العقار بنجاح!')),
    //       );
    //     },
    //   );
    //   // set up the AlertDialog
    //   AlertDialog alert = AlertDialog(
    //     title: Text("تأكيد"),
    //     content: Text("هل أنت متأكد من أنك تريد إضافة هذا العقار؟"),
    //     actions: [
    //       cancelButton,
    //       continueButton,
    //     ],
    //   );
    //   // show the dialog
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return alert;
    //     },
    //   );
    // }

    const appTitle = 'تحديث عقار';

        return MaterialApp(
          home: SafeArea(
              child: Scaffold(
                appBar: AppBar(
          // bottom: const
                title: Center(
                  child: const Text(appTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Tajawal-b",
                      )),
                ),
                toolbarHeight: 60,
                backgroundColor: Color.fromARGB(255, 127, 166, 233),
              ),
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(' عقارك: ',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: "Tajawal-b",
                                              ),
                                              textDirection: TextDirection.rtl),
                                          Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                child: RadioListTile(
                                                  title: const Text(
                                                    'للبيع',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontFamily: "Tajawal-m",
                                                        color: Color.fromARGB(
                                                            255, 73, 75, 82)),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  value: classification.sale,
                                                  groupValue: _class,
                                                  onChanged:
                                                      (classification? value) {
                                                    setState(() {
                                                      _class = value;
                                                      if (_class ==
                                                          classification.sale)
                                                        classification1 = 'للبيع';
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.5,
                                                child: RadioListTile(
                                                  title: const Text(
                                                    'للإيجار',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontFamily: "Tajawal-m",
                                                        color: Color.fromARGB(
                                                            255, 73, 75, 82)),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  value: classification.rent,
                                                  groupValue: _class,
                                                  onChanged:
                                                      (classification? value) {
                                                    setState(() {
                                                      _class = value;
                                                      if (_class ==
                                                          classification.rent)
                                                        classification1 =
                                                            'للإيجار';
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(15),
                                    ),
                                    
                                    //space
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(' *المساحة: ',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: "Tajawal-b",
                                              ),
                                              textDirection: TextDirection.rtl),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0)),
                                          Row(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 16, right: 9),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300,
                                                          width: 1)),
                                                  height: 40,
                                                  width: 150,
                                                  child: TextFormField(
                                                    controller: TextEditingController(text : space),
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText: 'متر ² '),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'الرجاء عدم ترك الخانة فارغة!';
                                                      }
                                                      if (!RegExp(r'[0-9]')
                                                          .hasMatch(value)) {
                                                        return 'الرجاء إدخال أرقام فقط';
                                                      }
                                                    },
                                                    onSaved: (val) {
                                                      space = val!;
                                                    },
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(30),
                                    ),
                                    //price
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(' *السعر: ',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: "Tajawal-b",
                                              ),
                                              textDirection: TextDirection.rtl),
                                          Container(
                                            margin: const EdgeInsets.all(19),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0)),
                                          Row(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 16, right: 9),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300,
                                                          width: 1)),
                                                  height: 40,
                                                  width: 150,
                                                  child: TextFormField(
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText: 'ريال '),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'الرجاء عدم ترك الخانة فارغة!';
                                                      }
                                                      if (!RegExp(r'[0-9]')
                                                          .hasMatch(value)) {
                                                        return 'الرجاء إدخال أرقام فقط';
                                                      }
                                                    },
                                                    onSaved: (val) {
                                                      price = val!;
                                                    },
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(25),
                                    ),
                                    
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(' *الحي: ',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: "Tajawal-b",
                                              ),
                                              textDirection: TextDirection.rtl),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0)),
                                          Row(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 16, right: 9),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300,
                                                          width: 1)),
                                                  height: 40,
                                                  width: 150,
                                                  child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText: 'القيروان'),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'الرجاء عدم ترك الخانة فارغة!';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (val) {
                                                      address = val!;
                                                    },
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(20),
                                    ),
                                    //location
                                    Container(
                                        alignment: Alignment.topRight,
                                        child: Text(' الموقع: ',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: "Tajawal-b",
                                            ),
                                            textDirection: TextDirection.rtl)),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                    ),
                                    //map
                                    SizedBox(
                                      height: 400.0,
                                      width: MediaQuery.of(context).size.width,
                                      child: Stack(
                                        children: [
                                          GoogleMap(
                                            onMapCreated: (mapController) {
                                              controller = mapController;
                                            },
                                            myLocationButtonEnabled: true,
                                            myLocationEnabled: true,
                                            initialCameraPosition: CameraPosition(
                                                target: mapLatLng, zoom: 14),
                                          ),
                                          Container(
                                              alignment: Alignment.bottomRight,
                                              margin: EdgeInsets.only(
                                                  right: 6, bottom: 108),
                                              child: FloatingActionButton(
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  Icons.location_on,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () async {
                                                  LocationData currentLocation;
                                                  var location = new Location();
        
                                                  currentLocation = await location
                                                      .getLocation();
        
                                                  LatLng latLng = LatLng(
                                                      currentLocation.latitude!,
                                                      currentLocation.longitude!);
        
                                                  controller!.animateCamera(
                                                      CameraUpdate
                                                          .newCameraPosition(
                                                    CameraPosition(
                                                      bearing: 0,
                                                      target: LatLng(
                                                          currentLocation
                                                              .latitude!,
                                                          currentLocation
                                                              .longitude!),
                                                      zoom: 17.0,
                                                    ),
                                                  ));
        
                                                  setState(() {
                                                    mapLatLng = latLng;
                                                  });
                                                },
                                              )),
                                          Container(
                                              alignment: Alignment.topCenter,
                                              margin: EdgeInsets.only(top: 5),
                                              child: SearchMapPlaceWidget(
                                                strictBounds: true,
                                                apiKey:
                                                    "AIzaSyDKNtlGQXbyJBJYvBx-OrWqMbjln4NxTxs",
                                                bgColor: Colors.white,
                                                textColor: Colors.black,
                                                hasClearButton: true,
                                                placeholder: "إبحث عن مدينة، حي",
                                                placeType: PlaceType.address,
                                                onSelected: (place) async {
                                                  Geolocation? geolocation =
                                                      await place.geolocation;
        
                                                  controller!.animateCamera(
                                                      CameraUpdate.newLatLng(
                                                          geolocation!
                                                              .coordinates));
                                                  controller!.animateCamera(
                                                      CameraUpdate
                                                          .newLatLngBounds(
                                                              geolocation.bounds,
                                                              0));
                                                  setState(() {
                                                    mapLatLng =
                                                        geolocation.coordinates;
                                                  });
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                            margin: const EdgeInsets.all(25),
                                          ),
                                        //propertyAge
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "عمر عقارك:",
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily: "Tajawal-b",
                                                ),
                                                textDirection: TextDirection.rtl,
                                              ),
                                              Text("(من شهر إلى 100+ سنة)",
                                                  style: const TextStyle(
                                                      fontSize: 15.0,
                                                      fontFamily: "Tajawal-m",
                                                      color: Color.fromARGB(
                                                          255, 120, 122, 129)),
                                                  textDirection:
                                                      TextDirection.rtl),
                                              Container(
                                                height: 100,
                                                width: 380,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                        color:
                                                            Colors.grey.shade300,
                                                        width: 1)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(3),
                                                    ),
                                                    Slider(
                                                      label: "عمر عقارك:",
                                                      value:
                                                          property_age.toDouble(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          property_age =
                                                              value.toDouble();
                                                        });
                                                      },
                                                      min: 0.0,
                                                      max: 100.0,
                                                    ),
                                                    Text(
                                                      " (شهر.سنة) " +
                                                          property_age
                                                              .toStringAsFixed(1),
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          fontFamily: "Tajawal-m",
                                                          color: Color.fromARGB(
                                                              255, 73, 75, 82)),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(5),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                    Container(
                                      margin: const EdgeInsets.all(20),
                                    ),
                                     Container(
                                            margin: const EdgeInsets.all(20),
                                          ),
                                    Column(
                                            children: [
                                              Text("عدد الشقق:",
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontFamily: "Tajawal-b")),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                        color:
                                                            Colors.grey.shade300,
                                                        width: 1)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          number_of_apartments++;
        
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(
                                                          Icons
                                                              .add_circle_outline,
                                                          color: Color.fromARGB(
                                                              255, 127, 166, 233),
                                                        )),
                                                    Text("$number_of_apartments",
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                "Tajawal-b",
                                                            color: Color.fromARGB(
                                                                255, 73, 75, 82)),
                                                        textDirection:
                                                            TextDirection.rtl),
                                                    IconButton(
                                                        onPressed: () {
                                                          number_of_apartments ==
                                                                  0
                                                              ? null
                                                              : number_of_apartments--;
        
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(
                                                          Icons
                                                              .remove_circle_outline,
                                                          color: Color.fromARGB(
                                                              255, 127, 166, 233),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        
                                     Container(
                                            margin: const EdgeInsets.all(20),
                                          ),
                                     Column(
                                            children: [
                                              Text("عدد الأدوار:",
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontFamily: "Tajawal-b")),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                        color:
                                                            Colors.grey.shade300,
                                                        width: 1)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          number_of_floors++;
        
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(
                                                          Icons
                                                              .add_circle_outline,
                                                          color: Color.fromARGB(
                                                              255, 127, 166, 233),
                                                        )),
                                                    Text("$number_of_floors",
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                "Tajawal-b",
                                                            color: Color.fromARGB(
                                                                255, 73, 75, 82)),
                                                        textDirection:
                                                            TextDirection.rtl),
                                                    IconButton(
                                                        onPressed: () {
                                                          number_of_floors == 0
                                                              ? null
                                                              : number_of_floors--;
        
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(
                                                          Icons
                                                              .remove_circle_outline,
                                                          color: Color.fromARGB(
                                                              255, 127, 166, 233),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                    Container(
                                            margin: const EdgeInsets.all(20),
                                          ),
                                    Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('يوجد مسبح : ',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: "Tajawal-b",
                                                  ),
                                                  textDirection:
                                                      TextDirection.rtl),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2,
                                                    child: RadioListTile(
                                                      title: const Text(
                                                        'نعم',
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color: Color.fromARGB(
                                                                255, 73, 75, 82)),
                                                      ),
                                                      value: choice.yes,
                                                      groupValue: _poolCH,
                                                      onChanged: (choice? value) {
                                                        setState(() {
                                                          _poolCH = value;
                                                          if (_poolCH ==
                                                              choice.yes)
                                                            pool = true;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2.5,
                                                    child: RadioListTile(
                                                      title: const Text(
                                                        'لا',
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color: Color.fromARGB(
                                                                255, 73, 75, 82)),
                                                      ),
                                                      value: choice.no,
                                                      groupValue: _poolCH,
                                                      onChanged: (choice? value) {
                                                        setState(() {
                                                          _poolCH = value;
                                                          if (_poolCH ==
                                                              choice.no)
                                                            pool = false;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                     Container(
                                            margin: const EdgeInsets.all(10),
                                          ),
                                    Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('يوجد مصعد : ',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: "Tajawal-b",
                                                  ),
                                                  textDirection:
                                                      TextDirection.rtl),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2,
                                                    child: RadioListTile(
                                                      title: const Text(
                                                        'نعم',
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color: Color.fromARGB(
                                                                255, 73, 75, 82)),
                                                      ),
                                                      value: choice.yes,
                                                      groupValue: _elevatorCH,
                                                      onChanged: (choice? value) {
                                                        setState(() {
                                                          _elevatorCH = value;
                                                          if (_elevatorCH ==
                                                              choice.yes)
                                                            elevator = true;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2.5,
                                                    child: RadioListTile(
                                                      title: const Text(
                                                        'لا',
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color: Color.fromARGB(
                                                                255, 73, 75, 82)),
                                                      ),
                                                      value: choice.no,
                                                      groupValue: _elevatorCH,
                                                      onChanged: (choice? value) {
                                                        setState(() {
                                                          _elevatorCH = value;
                                                          if (_elevatorCH ==
                                                              choice.no)
                                                            elevator = false;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                    Container(
                                      margin: const EdgeInsets.all(15),
                                    ),
        
                                    //upload images
                                    Container(
                                      height: 190,
                                      width: 350,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Color.fromARGB(
                                                255, 127, 126, 126),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: SizedBox(
                                          height: 100,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            children: [
                                              selectedFiles.isEmpty
                                                  ? Container(
                                                      alignment: Alignment.center,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.1,
                                                      child: TextButton(
                                                        child: Text(
                                                          '+إرفع صور للعقار',
                                                          style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  "Tajawal-m",
                                                              color:
                                                                  Color.fromARGB(
                                                                      255,
                                                                      127,
                                                                      166,
                                                                      233)),
                                                        ),
                                                        onPressed: () {
                                                          //selectImage();
                                                        },
                                                      ),
                                                    )
                                                  : Container(
                                                      margin: EdgeInsets.only(
                                                        top:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height /
                                                                100,
                                                        right:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height /
                                                                100,
                                                        bottom:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height /
                                                                100,
                                                      ),
                                                      height: 100,
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        children: selectedFiles
                                                            .map((e) => Stack(
                                                                  alignment:
                                                                      AlignmentDirectional
                                                                          .topEnd,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              3.0),
                                                                      child:
                                                                          Container(
                                                                        color: Colors
                                                                            .blue,
                                                                        child: Image
                                                                            .file(
                                                                          File(e
                                                                              .path),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          height:
                                                                              100,
                                                                          width:
                                                                              100,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            selectedFiles
                                                                                .remove(e);
                                                                          });
                                                                        },
                                                                        child:
                                                                            const Padding(
                                                                          padding:
                                                                              EdgeInsets.all(.02),
                                                                          child:
                                                                              Icon(
                                                                            Icons
                                                                                .cancel,
                                                                            size:
                                                                                15,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ))
                                                            .toList(),
                                                      ),
                                                    ),
                                            ],
                                          )),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(20),
                                    ),
                                    //submit button
                                    SizedBox(
                                      width: 300.0,
                                      height: 90.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              //showAlertDialog(context);
                                            }
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color.fromARGB(
                                                        255, 127, 166, 233)),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                    vertical: 10)),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            27))),
                                          ),
                                          child: const Text(
                                            'إضافة',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "Tajawal-m"),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
              ),
            ),
        );

  Future<void> selectImage() async {
    try {
      final List<XFile>? imgs = await _picker.pickMultiImage();
      if (imgs != null) {
        selectedFiles.addAll(imgs);
      }
    } catch (e) {
      rethrow;
    }
    setState(() {});
  }

  Future<String> uploadFile(XFile _image, String userId) async {
    FirebaseStorage imageRef = FirebaseStorage.instance;
    Reference reference =
        imageRef.ref().child("propertyImages/$userId/${_image.name}");
    File file = File(_image.path);
    await reference.putFile(file);
    String downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
  }

  }
}