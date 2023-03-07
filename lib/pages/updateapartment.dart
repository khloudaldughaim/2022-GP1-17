// import 'package:flutter/cupertino.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nozol_application/pages/apartment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nozol_application/pages/my-property.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';

import '../Cities/cities.dart';
import '../Cities/neighborhood.dart';

class UpdateApartment extends StatefulWidget {
  final Apartment apartment;

  UpdateApartment({required this.apartment});

  @override
  State<UpdateApartment> createState() => _UpdateApartmentState();
}

enum classification { rent, sale }

enum propertyUse { residental, commercial }

enum choice { yes, no }

//LatLng mapLatLng = LatLng(23.88, 45.0792);

class _UpdateApartmentState extends State<UpdateApartment> {
  var citiesList = [
    "الرياض",
    "جدة",
    "مكة",
    "المدينة",
    "الدمام",
    "الهفوف",
    "الطايف",
    "تبوك",
    "بريدة",
    "خميس مشيط",
    "الجبيل",
    "نجران",
    "المبرز",
    "حائل",
    "أبها",
    "ينبع",
    "عرعر",
    "عنيزة",
    "سكاكا",
    "جازان",
    "القريات",
    "الباحة",
    "بيشة",
    "الرس",
    "الشفا",
  ];
  List areasList = [];
  late String type;
  final _formKey = GlobalKey<FormState>();
  late String property_id;
  classification? _class;
  late String classification1;
  late num property_age;
  choice? _elevatorCH;
  choice? _poolCH;
  late String in_floor;
  late bool elevator;
  late String city;
  late String neighborhood;
  late String? address;
  late int number_of_floors;
  late int number_of_room;
  late int number_of_bathroom;
  late int number_of_livingRooms;
  late double longitude;
  late double latitude;
  final GlobalKey<FormFieldState> _AddressKey = GlobalKey<FormFieldState>();
  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedFiles = [];
  List<String> arrImage = [];

  late TextEditingController spaceController;
  late TextEditingController priceController;
  late TextEditingController neighborhoodController;
  late TextEditingController in_floorController;
  late TextEditingController location;
  late TextEditingController description;
  late TextEditingController TourTime;

  late Position position;
  GoogleMapController? mapController;
  List<Marker> markers = <Marker>[];

  @override
  void initState() {
    spaceController = TextEditingController(text: widget.apartment.properties.space);
    priceController = TextEditingController(text: widget.apartment.properties.price);
    neighborhoodController = TextEditingController(text: widget.apartment.properties.neighborhood);
    in_floorController = TextEditingController(text: widget.apartment.in_floor);
    location = TextEditingController(text: widget.apartment.properties.Location);
    description = TextEditingController(text: widget.apartment.properties.description);
    TourTime = TextEditingController(text: widget.apartment.properties.TourTime);
    position = Position.fromMap({
      'latitude': widget.apartment.properties.latitude,
      'longitude': widget.apartment.properties.longitude
    });
    type = '${widget.apartment.properties.type}';
    property_id = '${widget.apartment.properties.property_id}';
    classification1 = '${widget.apartment.properties.classification}';
    property_age = widget.apartment.property_age;
    elevator = widget.apartment.elevator;
    city = '${widget.apartment.properties.city}';
    neighborhood = '${widget.apartment.properties.neighborhood}';
    address = "";
    number_of_floors = widget.apartment.number_of_floor;
    number_of_room = widget.apartment.number_of_room;
    number_of_bathroom = widget.apartment.number_of_bathroom;
    number_of_livingRooms = widget.apartment.number_of_livingRooms;
    arrImage = widget.apartment.properties.images;
    //longitude = widget.apartment.properties.longitude;
    //latitude = widget.apartment.properties.latitude;
    if (classification1 == 'للإيجار') {
      _class = classification.rent;
    } else {
      _class = classification.sale;
    }

    if (widget.apartment.elevator == false) {
      _elevatorCH = choice.no;
    } else {
      _elevatorCH = choice.yes;
    }

    markers.add(Marker(
      markerId: MarkerId(position.latitude.toString() + position.longitude.toString()),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: const InfoWindow(
        title: 'موقع العقار',
      ),
      icon: BitmapDescriptor.defaultMarker,
      draggable: true,
    ));

    super.initState();
  }

  @override
  void dispose() {
    spaceController.dispose();
    priceController.dispose();
    neighborhoodController.dispose();
    mapController?.dispose();
    in_floorController.dispose();
    description.dispose();
    TourTime.dispose();
    location.dispose();
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
    Reference reference = imageRef.ref().child("propertyImages/$userId/${_image.name}");
    File file = File(_image.path);
    await reference.putFile(file);
    String downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    updateData(List<XFile> fileImages) async {
      for (int i = 0; i < fileImages.length; i++) {
        var imageUrl = await uploadFile(fileImages[i], widget.apartment.properties.User_id);
        arrImage.add(imageUrl.toString());
      }

      if (_formKey.currentState!.validate()) {
        try {
          FirebaseFirestore.instance.collection('properties').doc(property_id).update({
            'classification': classification1,
            'latitude': position.latitude,
            'longitude': position.longitude,
            'price': priceController.text,
            "in_floor": in_floorController.text,
            'space': spaceController.text,
            'city': city,
            'neighborhood': neighborhood,
            'images': arrImage,
            'property_age': property_age,
            'number_of_floor': number_of_floors,
            'elevator': elevator,
            'number_of_room': number_of_room,
            'number_of_livingRooms': number_of_livingRooms,
            'number_of_bathroom': number_of_bathroom,
            'Location': location.text,
            'description': description.text,
            'TourTime': TourTime.text
          });

          Fluttertoast.showToast(
            msg: "تم التحديث بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Color.fromARGB(255, 127, 166, 233),
            textColor: Color.fromARGB(255, 248, 249, 250),
            fontSize: 18.0,
          );
          Navigator.push(context, MaterialPageRoute(builder: (context) => myProperty()));
        } catch (e, stack) {
          Fluttertoast.showToast(
            msg: "هناك خطأ ما",
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
            child: const Text('تحديث عقار',
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
                        ' عقارك: ',
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
                                'للبيع',
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
                                  if (_class == classification.sale) classification1 = 'للبيع';
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: const Text(
                                'للإيجار',
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
                                  if (_class == classification.rent) classification1 = 'للإيجار';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100,
                            child: Text(
                              ' *رقم الدور: ',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Tajawal-b",
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: in_floorController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: '5',
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
                                  return 'الرجاء عدم ترك الخانة فارغة!';
                                }
                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return 'الرجاء إدخال أرقام فقط';
                                }
                                return null;
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
                              ' *المساحة: ',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Tajawal-b",
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: spaceController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: 'متر ² ',
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
                                  return 'الرجاء عدم ترك الخانة فارغة!';
                                }
                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return 'الرجاء إدخال أرقام فقط';
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
                              ' *السعر: ',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Tajawal-b",
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: priceController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: 'ريال ',
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
                                  return 'الرجاء عدم ترك الخانة فارغة!';
                                }
                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return 'الرجاء إدخال أرقام فقط';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Text('*المدينة : ',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: "Tajawal-b",
                                    ),
                                    textDirection: TextDirection.rtl),
                                Container(
                                  margin: const EdgeInsets.all(7),
                                ),
                                Padding(padding: const EdgeInsets.all(1.0)),
                                Container(
                                  padding: EdgeInsets.only(right: 7),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey.shade300, width: 1)),
                                  height: 55,
                                  width: 240,
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    menuMaxHeight: 400,
                                    items: citiesList.map((value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (_selectedValue) async {
                                      var tempCity = await cities.where(
                                          (element) => (element['name_ar'] == _selectedValue));
                                      var tempArea = await areas.where((element) =>
                                          (element['city_id'] == tempCity.first['city_id']));
                                      _AddressKey.currentState?.reset();
                                      areasList.clear();
                                      areasList.addAll(tempArea);
                                      setState(() {
                                        city = _selectedValue.toString();
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'الرجاء اختيار المدينة';
                                      }
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: "Tajawal-m",
                                        color: Color.fromARGB(255, 73, 75, 82)),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(7),
                                      hintText: city,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            ' *الحي: ',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Tajawal-b",
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(14),
                          ),
                          Padding(padding: const EdgeInsets.all(5.0)),
                          Container(
                            padding: EdgeInsets.only(right: 7),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300, width: 1)),
                            height: 55,
                            width: 243,
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              key: _AddressKey,
                              items: areasList.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value['name_ar']),
                                );
                              }).toList(),
                              onChanged: (dynamic value) {
                                setState(() {
                                  neighborhood = value['name_ar'];
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'الرجاء اختيار الحي';
                                }
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Tajawal-m",
                                  color: Color.fromARGB(255, 73, 75, 82)),
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(7),
                                hintText: neighborhood,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: <Widget>[
                      //     Container(
                      //       width: 100,
                      //       child: Text(
                      //         ' *الحي: ',
                      //         style: TextStyle(
                      //           fontSize: 20.0,
                      //           fontFamily: "Tajawal-b",
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: TextFormField(
                      //         controller: neighborhoodController,
                      //         autovalidateMode: AutovalidateMode.onUserInteraction,
                      //         decoration: InputDecoration(
                      //           hintText: 'القيروان',
                      //           filled: true,
                      //           fillColor: Colors.white,
                      //           contentPadding: EdgeInsets.all(6),
                      //           enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(8),
                      //             borderSide: const BorderSide(
                      //               color: Colors.grey,
                      //               width: 0.0,
                      //             ),
                      //           ),
                      //         ),
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return 'الرجاء عدم ترك الخانة فارغة!';
                      //           }
                      //           return null;
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      SizedBox(height: 30),

                      //location
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            ' *الموقع: ',
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
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        hintText: 'شارع المذيب مقابل..',
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.all(6),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: Color.fromARGB(255, 167, 166, 166),
                                            width: 0.0,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء عدم ترك الخانة فارغة!';
                                        }
                                      },
                                    ),
                                  ))),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                        Text(
                          "الموقع على الخريطة",
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
                              markers: markers.toSet(),
                              onTap: (tapped) async {
                                markers.removeAt(0);
                                markers.insert(
                                    0,
                                    Marker(
                                      markerId: MarkerId(
                                          tapped.latitude.toString() + tapped.longitude.toString()),
                                      position: LatLng(tapped.latitude, tapped.longitude),
                                      infoWindow: const InfoWindow(
                                        title: 'موقع العقار',
                                      ),
                                      draggable: true,
                                      icon: BitmapDescriptor.defaultMarker,
                                    ));
                                setState(() {
                                  markers = markers;
                                  position = Position.fromMap(
                                      {'latitude': tapped.latitude, 'longitude': tapped.longitude});
                                  print("items ready and set state");
                                });

                                print(markers);
                              },
                              zoomGesturesEnabled: true,
                              mapType: MapType.normal,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              onMapCreated: (controller) {
                                setState(() {
                                  mapController = controller;
                                });
                              },
                              initialCameraPosition: CameraPosition(
                                target: LatLng(position.latitude, position.longitude),
                                zoom: 10.0,
                              ),
                            ),
                            Container(
                                alignment: Alignment.topCenter,
                                margin: EdgeInsets.only(top: 5),
                                child: SearchMapPlaceWidget(
                                  strictBounds: true,
                                  apiKey: "AIzaSyDKNtlGQXbyJBJYvBx-OrWqMbjln4NxTxs",
                                  bgColor: Colors.white,
                                  textColor: Colors.black,
                                  hasClearButton: true,
                                  placeholder: "إبحث عن مدينة، حي",
                                  placeType: PlaceType.address,
                                  onSelected: (place) async {
                                    Geolocation? geolocation = await place.geolocation;

                                    mapController!.animateCamera(
                                        CameraUpdate.newLatLng(geolocation!.coordinates));
                                    mapController!.animateCamera(
                                        CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                                    setState(() {
                                      //mapLatLng = geolocation.coordinates;
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
                                  color: Color.fromARGB(255, 120, 122, 129)),
                              textDirection: TextDirection.rtl),
                          Container(
                            height: 100,
                            width: 380,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey.shade300, width: 1)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(3),
                                ),
                                Slider(
                                  label: "عمر عقارك:",
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
                                  " (شهر.سنة) " + property_age.toStringAsFixed(1),
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
                          Text("عدد الغرف",
                              style: TextStyle(fontSize: 20.0, fontFamily: "Tajawal-b")),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey.shade300, width: 1)),
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
                                      number_of_room == 0 ? null : number_of_room--;

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
                          Text("عدد دورات المياه",
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
                                border: Border.all(color: Colors.grey.shade300, width: 1)),
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
                                      number_of_bathroom == 0 ? null : number_of_bathroom--;

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
                          Text("عدد الصالات",
                              style: TextStyle(fontSize: 20.0, fontFamily: "Tajawal-b")),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey.shade300, width: 1)),
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
                                      number_of_livingRooms == 0 ? null : number_of_livingRooms--;

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
                          Text("عدد الأدوار:",
                              style: TextStyle(fontSize: 20.0, fontFamily: "Tajawal-b")),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey.shade300, width: 1)),
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
                                      number_of_floors == 0 ? null : number_of_floors--;

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
                      Text(
                        'يوجد مصعد : ',
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
                                'نعم',
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
                                  if (_elevatorCH == choice.yes) elevator = true;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: const Text(
                                'لا',
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
                                  if (_elevatorCH == choice.no) elevator = false;
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
                            ' الصور التي تم رفعها: ',
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
                                        width: MediaQuery.of(context).size.width / 1.1,
                                        child: Text(
                                          "لم يتم رفع أي صور",
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context).size.height / 40,
                                          bottom: MediaQuery.of(context).size.height / 70,
                                        ),
                                        height: 100,
                                        child: ListView(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          children: arrImage
                                              .map((e) => Stack(
                                                    alignment: AlignmentDirectional.topEnd,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(4.0),
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
                                                              arrImage.remove(e);
                                                            });
                                                          },
                                                          child: const Padding(
                                                            padding: EdgeInsets.all(.02),
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
                                        width: MediaQuery.of(context).size.width / 1.1,
                                        child: TextButton(
                                          child: Text(
                                            '+إرفع صور للعقار',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: "Tajawal-m",
                                                color: Color.fromARGB(255, 127, 166, 233)),
                                          ),
                                          onPressed: () {
                                            selectImage();
                                          },
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context).size.height / 100,
                                          right: MediaQuery.of(context).size.height / 100,
                                          bottom: MediaQuery.of(context).size.height / 100,
                                        ),
                                        height: 100,
                                        child: ListView(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          children: selectedFiles
                                              .map((e) => Stack(
                                                    alignment: AlignmentDirectional.topEnd,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(3.0),
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
                                                              selectedFiles.remove(e);
                                                            });
                                                          },
                                                          child: const Padding(
                                                            padding: EdgeInsets.all(.02),
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
                            ' معلومات اضافية: ',
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
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            'الوقت الذي تفضله للجولات العقارية:',
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
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                    content: Text("هل أنت متأكد من تحديث العقار؟"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("لا"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("نعم"),
                                        onPressed: () {
                                          try {
                                            updateData(selectedFiles);
                                          } catch (e, stack) {
                                            Fluttertoast.showToast(
                                              msg: "هناك خطأ ما",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor: Color.fromARGB(255, 127, 166, 233),
                                              textColor: Color.fromARGB(255, 252, 253, 255),
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
                            backgroundColor:
                                MaterialStateProperty.all(Color.fromARGB(255, 127, 166, 233)),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                          ),
                          child: Text(
                            "تحديث",
                            style: TextStyle(fontSize: 18, fontFamily: "Tajawal-m"),
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
