// import 'package:flutter/cupertino.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nozol_application/pages/villa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nozol_application/pages/my-property.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';

class UpdateVilla extends StatefulWidget {
  final Villa villa;

  UpdateVilla({required this.villa});

  @override
  State<UpdateVilla> createState() => _UpdateVillaState();
}

enum classification { rent, sale }

enum propertyUse { residental, commercial }

enum choice { yes, no }

LatLng mapLatLng = LatLng(23.88, 45.0792);

class _UpdateVillaState extends State<UpdateVilla> {
  late String type;
  final _formKey = GlobalKey<FormState>();
  late String property_id;
  classification? _class;
  late String classification1;
  late num property_age;
  choice? _elevatorCH;
  choice? _poolCH;
  choice? _basementCH = choice.no;
  late bool pool;
  late bool basement;
  late bool elevator;
  late String city;
  late String? address;
  late int number_of_floors;
  late int number_of_room;
  late int number_of_bathroom;
  late int number_of_livingRooms;
  late double longitude;
  late double latitude;
  late TextEditingController TourTime;

  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedFiles = [];
  List<String> arrImage = [];

  GoogleMapController? googleMapController;
  late TextEditingController spaceController;
  late TextEditingController priceController;
  late TextEditingController neighborhoodController;
  late TextEditingController location;
  late TextEditingController description;

  @override
  void initState() {
    spaceController = TextEditingController(text: widget.villa.properties.space);
    priceController = TextEditingController(text: widget.villa.properties.price);
    neighborhoodController = TextEditingController(text: widget.villa.properties.neighborhood);
    location = TextEditingController(text: widget.villa.properties.Location);
    description = TextEditingController(text: widget.villa.properties.description);
    TourTime = TextEditingController(text: widget.villa.properties.TourTime);

    type = '${widget.villa.properties.type}';
    property_id = '${widget.villa.properties.property_id}';
    classification1 = '${widget.villa.properties.classification}';
    property_age = widget.villa.property_age;
    elevator = widget.villa.elevator;
    pool = widget.villa.pool;
    basement = widget.villa.basement;
    city = '${widget.villa.properties.city}';
    address = "";
    number_of_floors = widget.villa.number_of_floor;
    number_of_room = widget.villa.number_of_room;
    number_of_bathroom = widget.villa.number_of_bathroom;
    number_of_livingRooms = widget.villa.number_of_livingRooms;
    arrImage = widget.villa.properties.images;
    //longitude = widget.villa.properties.longitude;
    //latitude = widget.villa.properties.latitude;

    if (classification1 == '??????????????') {
      _class = classification.rent;
    } else {
      _class = classification.sale;
    }

    if (widget.villa.pool == false) {
      _poolCH = choice.no;
    } else {
      _poolCH = choice.yes;
    }
    if (widget.villa.pool == false) {
      _poolCH = choice.no;
    } else {
      _poolCH = choice.yes;
    }
    if (widget.villa.elevator == false) {
      _elevatorCH = choice.no;
    } else {
      _elevatorCH = choice.yes;
    }

    super.initState();
  }

  @override
  void dispose() {
    spaceController.dispose();
    priceController.dispose();
    neighborhoodController.dispose();
    googleMapController?.dispose();
    description.dispose();
    location.dispose();
    TourTime.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    updateData(List<XFile> fileImages) async {
      for (int i = 0; i < fileImages.length; i++) {
        var imageUrl =
            await uploadFile(fileImages[i], widget.villa.properties.User_id);
        arrImage.add(imageUrl.toString());
      }

      if (_formKey.currentState!.validate()) {
        try {
          FirebaseFirestore.instance
              .collection('properties')
              .doc(property_id)
              .update({
            'classification': classification1,
            'latitude': mapLatLng.latitude,
            'longitude': mapLatLng.longitude,
            'price': priceController.text,
            'space': spaceController.text,
            'city': city,
            'neighborhood': neighborhoodController.text,
            'images': arrImage,
            'property_age': property_age,
            'number_of_floors': number_of_floors,
            'elevator': elevator,
            'pool': pool,
            'basement': basement,
            'number_of_room': number_of_room,
            'number_of_livingRooms': number_of_livingRooms,
            'number_of_bathroom': number_of_bathroom,
            'Location': location.text,
            'description': description.text,
            'TourTime': TourTime.text
          });

          Fluttertoast.showToast(
            msg: "???? ?????????????? ??????????",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Color.fromARGB(255, 127, 166, 233),
            textColor: Color.fromARGB(255, 248, 249, 250),
            fontSize: 18.0,
          );
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => myProperty()));
        } catch (e, stack) {
          Fluttertoast.showToast(
            msg: "???????? ?????? ????",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Color.fromARGB(255, 127, 166, 233),
            textColor: Color.fromARGB(255, 252, 253, 255),
            fontSize: 18.0,
          );
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 127, 166, 233),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 145),
            child: const Text('?????????? ????????',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Tajawal-b",
                )),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Directionality(
                textDirection: TextDirection.rtl,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' ??????????: ',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Tajawal-b",
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              title: const Text(
                                '??????????',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Tajawal-m",
                                    color: Color.fromARGB(255, 73, 75, 82)),
                                textAlign: TextAlign.start,
                              ),
                              value: classification.sale,
                              groupValue: _class,
                              onChanged: (classification? value) {
                                setState(() {
                                  _class = value;
                                  if (_class == classification.sale)
                                    classification1 = '??????????';
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: const Text(
                                '??????????????',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Tajawal-m",
                                    color: Color.fromARGB(255, 73, 75, 82)),
                                textAlign: TextAlign.start,
                              ),
                              value: classification.rent,
                              groupValue: _class,
                              onChanged: (classification? value) {
                                setState(() {
                                  _class = value;
                                  if (_class == classification.rent)
                                    classification1 = '??????????????';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // space
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100,
                            child: Text(
                              ' *??????????????: ',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Tajawal-b",
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: spaceController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: '?????? ?? ',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(6),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 0.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '???????????? ?????? ?????? ???????????? ??????????!';
                                }
                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return '???????????? ?????????? ?????????? ??????';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      //  price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100,
                            child: Text(
                              ' *??????????: ',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Tajawal-b",
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: priceController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: '???????? ',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(6),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 0.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '???????????? ?????? ?????? ???????????? ??????????!';
                                }
                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return '???????????? ?????????? ?????????? ??????';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100,
                            child: Text(
                              ' *????????: ',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Tajawal-b",
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: neighborhoodController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: '????????????????',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(6),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 0.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '???????????? ?????? ?????? ???????????? ??????????!';
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30),
                      //location
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            ' *????????????: ',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Tajawal-b",
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextFormField(
                                      controller: location,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        hintText: '???????? ???????????? ??????????..',
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.all(6),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 167, 166, 166),
                                            width: 0.0,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '???????????? ?????? ?????? ???????????? ??????????!';
                                        }
                                      },
                                    ),
                                  ))),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "???????????? ?????? ??????????????",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontFamily: "Tajawal-m",
                              ),
                            ),
                          ]),
                      //map
                      SizedBox(
                        height: 400.0,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            GoogleMap(
                              onMapCreated: (mapController) {
                                googleMapController = mapController;
                              },
                              myLocationButtonEnabled: true,
                              myLocationEnabled: true,
                              initialCameraPosition:
                                  CameraPosition(target: mapLatLng, zoom: 14),
                            ),
                            Container(
                                alignment: Alignment.bottomRight,
                                margin: EdgeInsets.only(right: 6, bottom: 108),
                                child: FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    LocationData currentLocation;
                                    var location = new Location();

                                    currentLocation =
                                        await location.getLocation();

                                    LatLng latLng = LatLng(
                                        currentLocation.latitude!,
                                        currentLocation.longitude!);

                                    googleMapController!.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        bearing: 0,
                                        target: LatLng(
                                            currentLocation.latitude!,
                                            currentLocation.longitude!),
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
                                  placeholder: "???????? ???? ???????????? ????",
                                  placeType: PlaceType.address,
                                  onSelected: (place) async {
                                    Geolocation? geolocation =
                                        await place.geolocation;

                                    googleMapController!.animateCamera(
                                        CameraUpdate.newLatLng(
                                            geolocation!.coordinates));
                                    googleMapController!.animateCamera(
                                        CameraUpdate.newLatLngBounds(
                                            geolocation.bounds, 0));
                                    setState(() {
                                      mapLatLng = geolocation.coordinates;
                                    });
                                  },
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      //propertyAge
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "?????? ??????????:",
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Tajawal-b",
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          Text("(???? ?????? ?????? 100+ ??????)",
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: "Tajawal-m",
                                  color: Color.fromARGB(255, 120, 122, 129)),
                              textDirection: TextDirection.rtl),
                          Container(
                            height: 100,
                            width: 380,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(3),
                                ),
                                Slider(
                                  label: "?????? ??????????:",
                                  value: property_age.toDouble(),
                                  onChanged: (value) {
                                    setState(() {
                                      property_age = value.toDouble();
                                    });
                                  },
                                  min: 0.0,
                                  max: 100.0,
                                ),
                                Text(
                                  " (??????.??????) " +
                                      property_age.toStringAsFixed(1),
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: "Tajawal-m",
                                      color: Color.fromARGB(255, 73, 75, 82)),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(5),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Column(
                        children: [
                          Text("?????? ??????????",
                              style: TextStyle(
                                  fontSize: 20.0, fontFamily: "Tajawal-b")),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      number_of_room++;

                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                    )),
                                Text("$number_of_room",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "Tajawal-b",
                                        color: Color.fromARGB(255, 73, 75, 82)),
                                    textDirection: TextDirection.rtl),
                                IconButton(
                                    onPressed: () {
                                      number_of_room == 0
                                          ? null
                                          : number_of_room--;

                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Column(
                        children: [
                          Text("?????? ?????????? ????????????",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Tajawal-b",
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      number_of_bathroom++;

                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                    )),
                                Text("$number_of_bathroom",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "Tajawal-m",
                                        color: Color.fromARGB(255, 73, 75, 82)),
                                    textDirection: TextDirection.rtl),
                                IconButton(
                                    onPressed: () {
                                      number_of_bathroom == 0
                                          ? null
                                          : number_of_bathroom--;

                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Column(
                        children: [
                          Text("?????? ??????????????",
                              style: TextStyle(
                                  fontSize: 20.0, fontFamily: "Tajawal-b")),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      number_of_livingRooms++;

                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                    )),
                                Text("$number_of_livingRooms",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "Tajawal-b",
                                        color: Color.fromARGB(255, 73, 75, 82)),
                                    textDirection: TextDirection.rtl),
                                IconButton(
                                    onPressed: () {
                                      number_of_livingRooms == 0
                                          ? null
                                          : number_of_livingRooms--;

                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Column(
                        children: [
                          Text("?????? ??????????????:",
                              style: TextStyle(
                                  fontSize: 20.0, fontFamily: "Tajawal-b")),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      number_of_floors++;

                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                    )),
                                Text("$number_of_floors",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "Tajawal-b",
                                        color: Color.fromARGB(255, 73, 75, 82)),
                                    textDirection: TextDirection.rtl),
                                IconButton(
                                    onPressed: () {
                                      number_of_floors == 0
                                          ? null
                                          : number_of_floors--;

                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Color.fromARGB(255, 127, 166, 233),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text('???????? ???????? : ',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Tajawal-b",
                          ),
                          textDirection: TextDirection.rtl),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              title: const Text(
                                '??????',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Tajawal-m",
                                    color: Color.fromARGB(255, 73, 75, 82)),
                              ),
                              value: choice.yes,
                              groupValue: _poolCH,
                              onChanged: (choice? value) {
                                setState(() {
                                  _poolCH = value;
                                  if (_poolCH == choice.yes) pool = true;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RadioListTile(
                              title: const Text(
                                '????',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Tajawal-m",
                                    color: Color.fromARGB(255, 73, 75, 82)),
                              ),
                              value: choice.no,
                              groupValue: _poolCH,
                              onChanged: (choice? value) {
                                setState(() {
                                  _poolCH = value;
                                  if (_poolCH == choice.no) pool = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30),

                      Text('???????? ?????? : ',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Tajawal-b",
                          ),
                          textDirection: TextDirection.rtl),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              title: const Text(
                                '??????',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Tajawal-m",
                                    color: Color.fromARGB(255, 73, 75, 82)),
                              ),
                              value: choice.yes,
                              groupValue: _basementCH,
                              onChanged: (choice? value) {
                                setState(() {
                                  _basementCH = value;
                                  if (_basementCH == choice.yes)
                                    basement = true;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RadioListTile(
                              title: const Text(
                                '????',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Tajawal-m",
                                    color: Color.fromARGB(255, 73, 75, 82)),
                              ),
                              value: choice.no,
                              groupValue: _basementCH,
                              onChanged: (choice? value) {
                                setState(() {
                                  _basementCH = value;
                                  if (_basementCH == choice.no)
                                    basement = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30),
                      Text(
                        '???????? ???????? : ',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Tajawal-b",
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              title: const Text(
                                '??????',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Tajawal-m",
                                    color: Color.fromARGB(255, 73, 75, 82)),
                              ),
                              value: choice.yes,
                              groupValue: _elevatorCH,
                              onChanged: (choice? value) {
                                setState(() {
                                  _elevatorCH = value;
                                  if (_elevatorCH == choice.yes)
                                    elevator = true;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: const Text(
                                '????',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Tajawal-m",
                                    color: Color.fromARGB(255, 73, 75, 82)),
                              ),
                              value: choice.no,
                              groupValue: _elevatorCH,
                              onChanged: (choice? value) {
                                setState(() {
                                  _elevatorCH = value;
                                  if (_elevatorCH == choice.no)
                                    elevator = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(15),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.width / 50,
                          ),
                          child: Text(
                            ' ?????????? ???????? ???? ??????????: ',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Tajawal-b",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 190,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromARGB(255, 127, 126, 126),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                arrImage.isEmpty
                                    ? Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        child: Text(
                                          "???? ?????? ?????? ???? ??????",
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              40,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              70,
                                        ),
                                        height: 100,
                                        child: ListView(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          children: arrImage
                                              .map((e) => Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topEnd,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Container(
                                                          color: Colors.blue,
                                                          child: Image.network(
                                                            e,
                                                            fit: BoxFit.cover,
                                                            height: 100,
                                                            width: 100,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              arrImage
                                                                  .remove(e);
                                                            });
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    .02),
                                                            child: Icon(
                                                              Icons.cancel,
                                                              size: 15,
                                                              color: Colors.red,
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

                      //upload images
                      Container(
                        height: 190,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromARGB(255, 127, 126, 126),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                selectedFiles.isEmpty
                                    ? Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        child: TextButton(
                                          child: Text(
                                            '+???????? ?????? ????????????',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: "Tajawal-m",
                                                color: Color.fromARGB(
                                                    255, 127, 166, 233)),
                                          ),
                                          onPressed: () {
                                            selectImage();
                                          },
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              100,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              100,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              100,
                                        ),
                                        height: 100,
                                        child: ListView(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          children: selectedFiles
                                              .map((e) => Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topEnd,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: Container(
                                                          color: Colors.blue,
                                                          child: Image.file(
                                                            File(e.path),
                                                            fit: BoxFit.cover,
                                                            height: 100,
                                                            width: 100,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedFiles
                                                                  .remove(e);
                                                            });
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    .02),
                                                            child: Icon(
                                                              Icons.cancel,
                                                              size: 15,
                                                              color: Colors.red,
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
                      //description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ' ?????????????? ????????????: ',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Tajawal-b",
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  controller: description,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.all(6),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 0.0,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                      ),
                      //TourTime
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '?????????????? ?????????????? ?????????????? ???????????????? :',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Tajawal-b",
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  controller: TourTime,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.all(6),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 0.0,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      //submit button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 110),
                        child: ElevatedButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content:
                                        Text("???? ?????? ?????????? ???? ?????????? ??????????????"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("????"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("??????"),
                                        onPressed: () {
                                          try {
                                            updateData(selectedFiles);
                                          } catch (e, stack) {
                                            Fluttertoast.showToast(
                                              msg: "???????? ?????? ????",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor: Color.fromARGB(
                                                  255, 127, 166, 233),
                                              textColor: Color.fromARGB(
                                                  255, 252, 253, 255),
                                              fontSize: 18.0,
                                            );
                                          }
                                          ;
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 127, 166, 233)),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 10)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27))),
                          ),
                          child: Text(
                            "??????????",
                            style: TextStyle(
                                fontSize: 18, fontFamily: "Tajawal-m"),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
