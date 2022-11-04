// import 'package:flutter/cupertino.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
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
  classification? _class = classification.rent;
  late String classification1;
  late num property_age;
  choice? _elevatorCH;
  choice? _poolCH;
  choice? _basementCH = choice.no;
  late String in_floor;
  late bool pool;
  late bool basement;
  late bool elevator;
  late String city;
  late String? address;
  late int number_of_floors;
  late int number_of_room;
  late int number_of_bathroom;
  late int number_of_livingRooms;
  late List<String> arrImage ;
  late double longitude ;
  late double latitude ;

  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedFiles = [];

  GoogleMapController? googleMapController;
  late TextEditingController spaceController;
  late TextEditingController priceController;
  late TextEditingController neighborhoodController;
  late TextEditingController in_floorController;


  @override
  void initState() {
    spaceController =
        TextEditingController(text: widget.villa.properties.space);
    priceController =
        TextEditingController(text: widget.villa.properties.price);
    neighborhoodController =
        TextEditingController(text: widget.villa.properties.neighborhood);

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

    //       FirebaseFirestore.instance
    //           .collection('properties')
    //           .doc(property_id)
    //           .update({
    //         'classification': classification1,
    //         'latitude': mapLatLng.latitude,
    //         'longitude': mapLatLng.longitude,
    //         'price': priceController.text,
    //         'space': spaceController.text,
    //         'city': city,
    //         'neighborhood': neighborhoodController.text,
    //         'images': arrImage,
    //         'property_age': property_age,
    //         'number_of_floors': number_of_floors,
    //         'elevator': elevator,
    //         'pool': pool,
    //         'number_of_villas': number_of_villas
    //       });

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
    // } //show

    const appTitle = 'تحديث عقار';

    return SafeArea(
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
                                  if (_class == classification.sale)
                                    classification1 = 'للبيع';
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
                                  if (_class == classification.rent)
                                    classification1 = 'للإيجار';
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100,
                            child: Text(
                              ' *الحي: ',
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
                                hintText: 'القيروان',
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
                                return null;
                              },

                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'الرجاء عدم ترك الخانة فارغة!';
                              //   }
                              //   if (!RegExp(r'[0-9]').hasMatch(value)) {
                              //     return 'الرجاء إدخال أرقام فقط';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30),

                      // Container(
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Text(' *الحي: ',
                      //           style: TextStyle(
                      //             fontSize: 20.0,
                      //             fontFamily: "Tajawal-b",
                      //           ),
                      //           textDirection: TextDirection.rtl),
                      //       Container(
                      //         margin: const EdgeInsets.all(10),
                      //       ),
                      //       Padding(padding: const EdgeInsets.all(10.0)),
                      //       Row(
                      //         children: [
                      //           Container(
                      //             padding: EdgeInsets.only(top: 16, right: 9),
                      //             decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 borderRadius: BorderRadius.circular(7),
                      //                 border: Border.all(color: Colors.grey.shade300, width: 1)),
                      //             height: 40,
                      //             width: 150,
                      //             child: TextFormField(
                      //               controller: neighborhoodController,
                      //               decoration: const InputDecoration(hintText: 'القيروان'),
                      //               validator: (value) {
                      //                 if (value == null || value.isEmpty) {
                      //                   return 'الرجاء عدم ترك الخانة فارغة!';
                      //                 }
                      //                 return null;
                      //               },
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   margin: const EdgeInsets.all(20),
                      // ),
                      //location
                      Text(
                        ' الموقع: ',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Tajawal-b",
                        ),
                      ),
                      SizedBox(height: 10),
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
                                  placeholder: "إبحث عن مدينة، حي",
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
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
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
                                  " (شهر.سنة) " +
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
                          Text("عدد الغرف",
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
                                      number_of_room++;

                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons
                                          .add_circle_outline,
                                      color: Color.fromARGB(
                                          255, 127, 166, 233),
                                    )),
                                Text("$number_of_room",
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
                                      number_of_room == 0
                                          ? null
                                          : number_of_room--;

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
                                      number_of_bathroom++;

                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons
                                          .add_circle_outline,
                                      color: Color.fromARGB(
                                          255, 127, 166, 233),
                                    )),
                                Text("$number_of_bathroom",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily:
                                            "Tajawal-m",
                                        color: Color.fromARGB(
                                            255, 73, 75, 82)),
                                    textDirection:
                                        TextDirection.rtl),
                                IconButton(
                                    onPressed: () {
                                      number_of_bathroom == 0
                                          ? null
                                          : number_of_bathroom--;

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
                      SizedBox(height: 30),
                      Column(
                        children: [
                          Text("عدد الصالات",
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
                                      number_of_livingRooms++;

                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons
                                          .add_circle_outline,
                                      color: Color.fromARGB(
                                          255, 127, 166, 233),
                                    )),
                                Text("$number_of_livingRooms",
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
                                      number_of_livingRooms ==
                                              0
                                          ? null
                                          : number_of_livingRooms--;

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
                      SizedBox(height: 30),
                      Column(
                        children: [
                          Text("عدد الأدوار:",
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
                      SizedBox(height: 30),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('يوجد قبو : ',
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
                                  groupValue: _basementCH,
                                  onChanged: (choice? value) {
                                    setState(() {
                                      _basementCH = value;
                                      if (_basementCH ==
                                          choice.yes)
                                        basement = true;
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
                                  groupValue: _basementCH,
                                  onChanged: (choice? value) {
                                    setState(() {
                                      _basementCH = value;
                                      if (_basementCH ==
                                          choice.no)
                                        basement = false;
                                    });
                                  },
                                ),
                              ),
                            ],
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
                                  if (_elevatorCH == choice.yes)
                                    elevator = true;
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
                                            '+إرفع صور للعقار',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: "Tajawal-m",
                                                color: Color.fromARGB(
                                                    255, 127, 166, 233)),
                                          ),
                                          onPressed: () {
                                            //selectImage();
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
                      //submit button
                      ElevatedButton(
                        onPressed: () async {
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
                                // 'images': arrImage,
                                'property_age': property_age,
                                'number_of_floors': number_of_floors,
                                'elevator': elevator,
                                'pool': pool,
                                'basement': basement,
                                'number_of_room': number_of_room,
                                'number_of_livingRooms': number_of_livingRooms,
                                'number_of_bathroom': number_of_bathroom,
                              });

                              Fluttertoast.showToast(
                                msg: "تم التحديث بنجاح",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor:
                                    Color.fromARGB(255, 127, 166, 233),
                                textColor: Color.fromARGB(255, 248, 249, 250),
                                fontSize: 18.0,
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => myProperty()));
                            } catch (e, stack) {
                              Fluttertoast.showToast(
                                msg: "هناك خطأ ما",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 5,
                                backgroundColor:
                                    Color.fromARGB(255, 127, 166, 233),
                                textColor: Color.fromARGB(255, 252, 253, 255),
                                fontSize: 18.0,
                              );
                            }
                          }
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
                          "تحديث",
                          style:
                              TextStyle(fontSize: 18, fontFamily: "Tajawal-m"),
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
