// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

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

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'إضافة عقار';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
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
        body: const MyCustomForm(),
      ),
    );
  }
}

// get the id of the curent user
Future getCurrentUser() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user!.uid;
  print(uid);

  final docStanderUser = await FirebaseFirestore.instance
      .collection('Standard_user')
      .doc(uid)
      .get();
  if (docStanderUser.exists) {
    return Suser.fromJson(docStanderUser.data()!);
  }
}

enum classification { rent, sale }

enum propertyUse { residental, commercial }

enum choice { yes, no }

LatLng mapLatLng = LatLng(23.88, 45.0792);

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  static int i = 1;
  String property_id = '';
  classification? _class = classification.rent;
  String classification1 = '';
  int type = 1;
  String type1 = 'villa';
  propertyUse? _pUse = propertyUse.residental;
  String propertyUse1 = '';
  String price = '';
  String in_floor = '';
  String space = '';
  double property_age = 0.0;
  choice? _poolCH = choice.no;
  choice? _basementCH = choice.no;
  choice? _elevatorCH = choice.no;
  bool pool = false;
  bool basement = false;
  bool elevator = false;
  String countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String? city = "Riyadh";
  String? address = "";
  int number_of_bathrooms = 0;
  int number_of_rooms = 0;
  int number_of_livingRooms = 0;
  int number_of_floors = 0;
  int number_of_apartments = 0;

  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedFiles = [];

  GoogleMapController? controller;

  @override
  Widget build(BuildContext context) {
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
    void getCities() async {}

    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: Text("إلغاء"),
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
      Widget continueButton = TextButton(
        child: Text("تأكيد"),
        onPressed: () async {
          List<String> arrImage = [];
          for (int i = 0; i < selectedFiles.length; i++) {
            var imageUrl = await uploadFile(selectedFiles[i], "1234");
            arrImage.add(imageUrl.toString());
          }

          _formKey.currentState!.save();
          i++;
          property_id = "p$i";
          print(
              "property_id: $property_id , classification: $classification1 , type: $type1 ");

          if (type1 == 'villa')
            FirebaseFirestore.instance.collection('properties').add({
              'property_id': property_id,
              'user_id': '',
              'classification': classification1,
              'latitude': mapLatLng.latitude,
              'longitude': mapLatLng.longitude,
              'price': price,
              'space': space,
              'city': city,
              'neighborhood': address,
              'images': arrImage,
              'type': type1, //
              'property_age': property_age,
              'number_of_floors': number_of_floors,
              'elevator': elevator,
              'number_of_bathrooms': number_of_bathrooms,
              'number_of_rooms': number_of_rooms,
              'pool': pool,
              'basement': basement,
              'number_of_livingRooms': number_of_livingRooms
            });

          if (type1 == 'apartment')
            FirebaseFirestore.instance.collection('properties').add({
              'property_id': property_id,
              'user_id': '',
              'classification': classification1,
              'latitude': mapLatLng.latitude,
              'longitude': mapLatLng.longitude,
              'price': price,
              'space': space,
              'city': city,
              'neighborhood': address,
              'images': arrImage,
              'type': type1,
              'property_age': property_age,
              'number_of_floors': number_of_floors,
              'elevator': elevator,
              'number_of_bathrooms': number_of_bathrooms,
              'number_of_rooms': number_of_rooms,
              'in_floor': in_floor,
              'number_of_livingRooms': number_of_livingRooms
            });

          if (type1 == 'land')
            FirebaseFirestore.instance.collection('properties').add({
              'property_id': property_id,
              'user_id': '',
              'classification': classification1,
              'latitude': mapLatLng.latitude,
              'longitude': mapLatLng.longitude,
              'price': price,
              'space': space,
              'city': city,
              'neighborhood': address,
              'images': arrImage,
              'type': type1,
              'propertyUse': propertyUse1
            });

          if (type1 == 'building')
            FirebaseFirestore.instance.collection('properties').add({
              'property_id': property_id,
              'user_id': '',
              'classification': classification1,
              'latitude': mapLatLng.latitude,
              'longitude': mapLatLng.longitude,
              'price': price,
              'space': space,
              'city': city,
              'neighborhood': address,
              'images': arrImage,
              'type': type1,
              'property_age': property_age,
              'number_of_floors': number_of_floors,
              'elevator': elevator,
              'pool': pool,
              'number_of_apartments': number_of_apartments
            });

          Navigator.of(context).pop();
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("تأكيد"),
        content: Text("هل أنت متأكد من أنك تريد إضافة هذا العقار؟"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: Column(children: [
            FutureBuilder(
              future: getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  final cuuser = snapshot.data!;
                  return SizedBox(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                                      textDirection:
                                                          TextDirection.rtl),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        child: RadioListTile(
                                                          title: const Text(
                                                            'للبيع',
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                fontFamily:
                                                                    "Tajawal-m",
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        73,
                                                                        75,
                                                                        82)),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          value: classification
                                                              .sale,
                                                          groupValue: _class,
                                                          onChanged:
                                                              (classification?
                                                                  value) {
                                                            setState(() {
                                                              _class = value;
                                                              if (_class ==
                                                                  classification
                                                                      .sale)
                                                                classification1 =
                                                                    'sale';
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        child: RadioListTile(
                                                          title: const Text(
                                                            'للإيجار',
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                fontFamily:
                                                                    "Tajawal-m",
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        73,
                                                                        75,
                                                                        82)),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          value: classification
                                                              .rent,
                                                          groupValue: _class,
                                                          onChanged:
                                                              (classification?
                                                                  value) {
                                                            setState(() {
                                                              _class = value;
                                                              if (_class ==
                                                                  classification
                                                                      .rent)
                                                                classification1 =
                                                                    'rent';
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
                                            //type
                                            Container(
                                              child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    children: [
                                                      Text('نوع عقارك: ',
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                "Tajawal-b",
                                                          ),
                                                          textDirection:
                                                              TextDirection
                                                                  .rtl),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0)),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 7),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                width: 1)),
                                                        height: 40,
                                                        width: 150,
                                                        child: DropdownButton(
                                                            value: type,
                                                            items: [
                                                              DropdownMenuItem(
                                                                child: Text(
                                                                  "فيلا",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18.0,
                                                                      fontFamily:
                                                                          "Tajawal-m",
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          73,
                                                                          75,
                                                                          82)),
                                                                ),
                                                                value: 1,
                                                              ),
                                                              DropdownMenuItem(
                                                                child: Text(
                                                                  "شقة",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18.0,
                                                                      fontFamily:
                                                                          "Tajawal-m",
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          73,
                                                                          75,
                                                                          82)),
                                                                ),
                                                                value: 2,
                                                              ),
                                                              DropdownMenuItem(
                                                                child: Text(
                                                                  "ارض",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18.0,
                                                                      fontFamily:
                                                                          "Tajawal-m",
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          73,
                                                                          75,
                                                                          82)),
                                                                ),
                                                                value: 3,
                                                              ),
                                                              DropdownMenuItem(
                                                                child: Text(
                                                                  "عمارة",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18.0,
                                                                      fontFamily:
                                                                          "Tajawal-m",
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          73,
                                                                          75,
                                                                          82)),
                                                                ),
                                                                value: 4,
                                                              )
                                                            ],
                                                            onChanged:
                                                                (int? value) {
                                                              setState(() {
                                                                type = value!;
                                                                if (type == 1)
                                                                  type1 =
                                                                      'villa';
                                                                if (type == 2)
                                                                  type1 =
                                                                      'apartment';
                                                                if (type == 3)
                                                                  type1 =
                                                                      'land';
                                                                if (type == 4)
                                                                  type1 =
                                                                      'building';
                                                              });
                                                            }),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(20),
                                            ),
                                            type == 3
                                                ? Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            ' استخدام العقار: ',
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  "Tajawal-b",
                                                            ),
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2,
                                                              child:
                                                                  RadioListTile(
                                                                title:
                                                                    const Text(
                                                                  'سكني',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18.0,
                                                                      fontFamily:
                                                                          "Tajawal-m",
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          73,
                                                                          75,
                                                                          82)),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                                value: propertyUse
                                                                    .residental,
                                                                groupValue:
                                                                    _pUse,
                                                                onChanged:
                                                                    (propertyUse?
                                                                        value) {
                                                                  setState(() {
                                                                    _pUse =
                                                                        value;
                                                                    if (_pUse ==
                                                                        propertyUse
                                                                            .residental)
                                                                      propertyUse1 =
                                                                          'residental';
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2.5,
                                                              child:
                                                                  RadioListTile(
                                                                title:
                                                                    const Text(
                                                                  'تجاري',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18.0,
                                                                      fontFamily:
                                                                          "Tajawal-m",
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          73,
                                                                          75,
                                                                          82)),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                                value: propertyUse
                                                                    .commercial,
                                                                groupValue:
                                                                    _pUse,
                                                                onChanged:
                                                                    (propertyUse?
                                                                        value) {
                                                                  setState(() {
                                                                    _pUse =
                                                                        value;
                                                                    if (_pUse ==
                                                                        propertyUse
                                                                            .commercial)
                                                                      propertyUse1 =
                                                                          'commercial';
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                                            Container(
                                              margin: const EdgeInsets.all(15),
                                            ),
                                            type == 2
                                                ? Container(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(' رقم الدور: ',
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  "Tajawal-b",
                                                            ),
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0)),
                                                        Row(
                                                          children: [
                                                            Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 16,
                                                                        right:
                                                                            9),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                7),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300,
                                                                        width:
                                                                            1)),
                                                                height: 40,
                                                                width: 150,
                                                                child:
                                                                    TextFormField(
                                                                  autovalidateMode:
                                                                      AutovalidateMode
                                                                          .onUserInteraction,
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                        .isEmpty) {
                                                                      return 'الرجاء عدم ترك الخانة فارغة!';
                                                                    }
                                                                    if (!RegExp(
                                                                            r'[0-9]')
                                                                        .hasMatch(
                                                                            value)) {
                                                                      return 'الرجاء إدخال أرقام فقط';
                                                                    }
                                                                  },
                                                                  onSaved:
                                                                      (val) {
                                                                    in_floor =
                                                                        val!;
                                                                  },
                                                                ))
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                                            type == 2
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            30),
                                                  )
                                                : Container(),
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
                                                      textDirection:
                                                          TextDirection.rtl),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(7),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0)),
                                                  Row(
                                                    children: [
                                                      Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 16,
                                                                  right: 9),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 1)),
                                                          height: 40,
                                                          width: 150,
                                                          child: TextFormField(
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                            decoration:
                                                                const InputDecoration(
                                                                    hintText:
                                                                        'متر ² '),
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return 'الرجاء عدم ترك الخانة فارغة!';
                                                              }
                                                              if (!RegExp(
                                                                      r'[0-9]')
                                                                  .hasMatch(
                                                                      value)) {
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
                                                      textDirection:
                                                          TextDirection.rtl),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            16),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0)),
                                                  Row(
                                                    children: [
                                                      Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 16,
                                                                  right: 9),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 1)),
                                                          height: 40,
                                                          width: 150,
                                                          child: TextFormField(
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                            decoration:
                                                                const InputDecoration(
                                                                    hintText:
                                                                        'ريال '),
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return 'الرجاء عدم ترك الخانة فارغة!';
                                                              }
                                                              if (!RegExp(
                                                                      r'[0-9]')
                                                                  .hasMatch(
                                                                      value)) {
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
                                            /*Container(
                                    margin: const EdgeInsets.all(20),
                                    child: Text(' : ',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: "Tajawal-b",
                                            ),
                                            textDirection: TextDirection.rtl),
                                  ),*/

                                            //city
                                            Column(
                                              children: [
                                                CSCPicker(
                                                  showCities: true,
                                                  flagState:
                                                      CountryFlag.DISABLE,
                                                  stateSearchPlaceholder:
                                                      "المنطقة",
                                                  citySearchPlaceholder:
                                                      "المدينة",
                                                  stateDropdownLabel:
                                                      "*المنطقة",
                                                  cityDropdownLabel: "*المدينة",
                                                  defaultCountry: DefaultCountry
                                                      .Saudi_Arabia,
                                                  disableCountry: true,
                                                  dropdownDecoration:
                                                      BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              width: 1)),
                                                  selectedItemStyle: TextStyle(
                                                      fontSize: 17.0,
                                                      fontFamily: "Tajawal-m",
                                                      color: Color.fromARGB(
                                                          255, 21, 21, 21)),
                                                  onCountryChanged: (value) {
                                                    setState(() {
                                                      countryValue = value;
                                                    });
                                                  },
                                                  onStateChanged: (value) {
                                                    setState(() {
                                                      stateValue = value;
                                                    });
                                                  },
                                                  onCityChanged: (value) {
                                                    setState(() {
                                                      cityValue = value;
                                                      city = cityValue;
                                                    });
                                                  },
                                                )
                                              ],
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(15),
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
                                                      textDirection:
                                                          TextDirection.rtl),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            22),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0)),
                                                  Row(
                                                    children: [
                                                      Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 16,
                                                                  right: 9),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 1)),
                                                          height: 40,
                                                          width: 150,
                                                          child: TextFormField(
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                            decoration:
                                                                const InputDecoration(
                                                                    hintText:
                                                                        'القيروان'),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
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
                                                    textDirection:
                                                        TextDirection.rtl)),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                            ),
                                            //map
                                            SizedBox(
                                              height: 400.0,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Stack(
                                                children: [
                                                  GoogleMap(
                                                    onMapCreated:
                                                        (mapController) {
                                                      controller =
                                                          mapController;
                                                    },
                                                    myLocationButtonEnabled:
                                                        true,
                                                    myLocationEnabled: true,
                                                    initialCameraPosition:
                                                        CameraPosition(
                                                            target: mapLatLng,
                                                            zoom: 14),
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      margin: EdgeInsets.only(
                                                          right: 6,
                                                          bottom: 108),
                                                      child:
                                                          FloatingActionButton(
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.location_on,
                                                          color: Colors.blue,
                                                        ),
                                                        onPressed: () async {
                                                          LocationData
                                                              currentLocation;
                                                          var location =
                                                              new Location();

                                                          currentLocation =
                                                              await location
                                                                  .getLocation();

                                                          LatLng latLng = LatLng(
                                                              currentLocation
                                                                  .latitude!,
                                                              currentLocation
                                                                  .longitude!);

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
                                                      alignment:
                                                          Alignment.topCenter,
                                                      margin: EdgeInsets.only(
                                                          top: 5),
                                                      child:
                                                          SearchMapPlaceWidget(
                                                        strictBounds: true,
                                                        apiKey:
                                                            "AIzaSyDKNtlGQXbyJBJYvBx-OrWqMbjln4NxTxs",
                                                        bgColor: Colors.white,
                                                        textColor: Colors.black,
                                                        hasClearButton: true,
                                                        placeholder:
                                                            "إبحث عن مدينة، حي",
                                                        placeType:
                                                            PlaceType.address,
                                                        onSelected:
                                                            (place) async {
                                                          Geolocation?
                                                              geolocation =
                                                              await place
                                                                  .geolocation;

                                                          controller!.animateCamera(
                                                              CameraUpdate.newLatLng(
                                                                  geolocation!
                                                                      .coordinates));
                                                          controller!.animateCamera(
                                                              CameraUpdate
                                                                  .newLatLngBounds(
                                                                      geolocation
                                                                          .bounds,
                                                                      0));
                                                          setState(() {
                                                            mapLatLng =
                                                                geolocation
                                                                    .coordinates;
                                                          });
                                                        },
                                                      )),
                                                ],
                                              ),
                                            ),
                                            type == 3
                                                ? Container()
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            25),
                                                  ),
                                            type == 3
                                                ? Container()
                                                :
                                                //propertyAge
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "عمر عقارك:",
                                                        style: const TextStyle(
                                                          fontSize: 20.0,
                                                          fontFamily:
                                                              "Tajawal-b",
                                                        ),
                                                        textDirection:
                                                            TextDirection.rtl,
                                                      ),
                                                      Text(
                                                          "(من شهر إلى 100+ سنة)",
                                                          style: const TextStyle(
                                                              fontSize: 15.0,
                                                              fontFamily:
                                                                  "Tajawal-m",
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      120,
                                                                      122,
                                                                      129)),
                                                          textDirection:
                                                              TextDirection
                                                                  .rtl),
                                                      Container(
                                                        height: 100,
                                                        width: 380,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                width: 1)),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(3),
                                                            ),
                                                            Slider(
                                                              label:
                                                                  "عمر عقارك:",
                                                              value: property_age
                                                                  .toDouble(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  property_age =
                                                                      value
                                                                          .toDouble();
                                                                });
                                                              },
                                                              min: 0.0,
                                                              max: 100.0,
                                                            ),
                                                            Text(
                                                              " (شهر.سنة) " +
                                                                  property_age
                                                                      .toStringAsFixed(
                                                                          1),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontFamily:
                                                                      "Tajawal-m",
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          73,
                                                                          75,
                                                                          82)),
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            Container(
                                              margin: const EdgeInsets.all(20),
                                            ),
                                            type == 3 || type == 4
                                                ? Container()
                                                : Column(
                                                    children: [
                                                      Text("عدد الغرف",
                                                          style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  "Tajawal-b")),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                width: 1)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  number_of_rooms++;

                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .add_circle_outline,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          127,
                                                                          166,
                                                                          233),
                                                                )),
                                                            Text(
                                                                "$number_of_rooms",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    fontFamily:
                                                                        "Tajawal-b",
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            73,
                                                                            75,
                                                                            82)),
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl),
                                                            IconButton(
                                                                onPressed: () {
                                                                  number_of_rooms ==
                                                                          0
                                                                      ? null
                                                                      : number_of_rooms--;

                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .remove_circle_outline,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          127,
                                                                          166,
                                                                          233),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            type == 3 || type == 4
                                                ? Container()
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            20),
                                                  ),
                                            type == 3 || type == 4
                                                ? Container()
                                                : Column(
                                                    children: [
                                                      Text("عدد دورات المياه",
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                "Tajawal-b",
                                                          )),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                width: 1)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  number_of_bathrooms++;

                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .add_circle_outline,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          127,
                                                                          166,
                                                                          233),
                                                                )),
                                                            Text(
                                                                "$number_of_bathrooms",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    fontFamily:
                                                                        "Tajawal-m",
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            73,
                                                                            75,
                                                                            82)),
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl),
                                                            IconButton(
                                                                onPressed: () {
                                                                  number_of_bathrooms ==
                                                                          0
                                                                      ? null
                                                                      : number_of_bathrooms--;

                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .remove_circle_outline,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          127,
                                                                          166,
                                                                          233),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            type == 3 || type == 4
                                                ? Container()
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            20),
                                                  ),
                                            type == 3 || type == 4
                                                ? Container()
                                                : Column(
                                                    children: [
                                                      Text("عدد الصالات",
                                                          style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  "Tajawal-b")),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                width: 1)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  number_of_livingRooms++;

                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .add_circle_outline,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          127,
                                                                          166,
                                                                          233),
                                                                )),
                                                            Text(
                                                                "$number_of_livingRooms",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    fontFamily:
                                                                        "Tajawal-b",
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            73,
                                                                            75,
                                                                            82)),
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl),
                                                            IconButton(
                                                                onPressed: () {
                                                                  number_of_livingRooms ==
                                                                          0
                                                                      ? null
                                                                      : number_of_livingRooms--;

                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .remove_circle_outline,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          127,
                                                                          166,
                                                                          233),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            type == 3 || type == 4
                                                ? Container()
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            20),
                                                  ),
                                            type == 4
                                                ? Column(
                                                    children: [
                                                      Text("عدد الشقق:",
                                                          style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  "Tajawal-b")),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                width: 1)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  number_of_apartments++;

                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .add_circle_outline,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          127,
                                                                          166,
                                                                          233),
                                                                )),
                                                            Text(
                                                                "$number_of_apartments",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    fontFamily:
                                                                        "Tajawal-b",
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            73,
                                                                            75,
                                                                            82)),
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl),
                                                            IconButton(
                                                                onPressed: () {
                                                                  number_of_apartments ==
                                                                          0
                                                                      ? null
                                                                      : number_of_apartments--;

                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .remove_circle_outline,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          127,
                                                                          166,
                                                                          233),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                            type == 3
                                                ? Container()
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            20),
                                                  ),
                                            type == 3
                                                ? Container()
                                                : Column(
                                                    children: [
                                                      Text("عدد الأدوار:",
                                                          style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontFamily:
                                                                  "Tajawal-b")),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                width: 1)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  number_of_floors++;

                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .add_circle_outline,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          127,
                                                                          166,
                                                                          233),
                                                                )),
                                                            Text(
                                                                "$number_of_floors",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    fontFamily:
                                                                        "Tajawal-b",
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            73,
                                                                            75,
                                                                            82)),
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl),
                                                            IconButton(
                                                                onPressed: () {
                                                                  number_of_floors ==
                                                                          0
                                                                      ? null
                                                                      : number_of_floors--;

                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .remove_circle_outline,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          127,
                                                                          166,
                                                                          233),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            type == 3
                                                ? Container()
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            20),
                                                  ),
                                            type == 2 || type == 3
                                                ? Container()
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text('يوجد مسبح : ',
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                "Tajawal-b",
                                                          ),
                                                          textDirection:
                                                              TextDirection
                                                                  .rtl),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            child:
                                                                RadioListTile(
                                                              title: const Text(
                                                                'نعم',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontFamily:
                                                                        "Tajawal-m",
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            73,
                                                                            75,
                                                                            82)),
                                                              ),
                                                              value: choice.yes,
                                                              groupValue:
                                                                  _poolCH,
                                                              onChanged:
                                                                  (choice?
                                                                      value) {
                                                                setState(() {
                                                                  _poolCH =
                                                                      value;
                                                                  if (_poolCH ==
                                                                      choice
                                                                          .yes)
                                                                    pool = true;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.5,
                                                            child:
                                                                RadioListTile(
                                                              title: const Text(
                                                                'لا',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontFamily:
                                                                        "Tajawal-m",
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            73,
                                                                            75,
                                                                            82)),
                                                              ),
                                                              value: choice.no,
                                                              groupValue:
                                                                  _poolCH,
                                                              onChanged:
                                                                  (choice?
                                                                      value) {
                                                                setState(() {
                                                                  _poolCH =
                                                                      value;
                                                                  if (_poolCH ==
                                                                      choice.no)
                                                                    pool =
                                                                        false;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                            type == 3
                                                ? Container()
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                  ),
                                            type == 1
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text('يوجد قبو : ',
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                "Tajawal-b",
                                                          ),
                                                          textDirection:
                                                              TextDirection
                                                                  .rtl),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            child:
                                                                RadioListTile(
                                                              title: const Text(
                                                                'نعم',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontFamily:
                                                                        "Tajawal-m",
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            73,
                                                                            75,
                                                                            82)),
                                                              ),
                                                              value: choice.yes,
                                                              groupValue:
                                                                  _basementCH,
                                                              onChanged:
                                                                  (choice?
                                                                      value) {
                                                                setState(() {
                                                                  _basementCH =
                                                                      value;
                                                                  if (_basementCH ==
                                                                      choice
                                                                          .yes)
                                                                    basement =
                                                                        true;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.5,
                                                            child:
                                                                RadioListTile(
                                                              title: const Text(
                                                                'لا',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontFamily:
                                                                        "Tajawal-m",
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            73,
                                                                            75,
                                                                            82)),
                                                              ),
                                                              value: choice.no,
                                                              groupValue:
                                                                  _basementCH,
                                                              onChanged:
                                                                  (choice?
                                                                      value) {
                                                                setState(() {
                                                                  _basementCH =
                                                                      value;
                                                                  if (_basementCH ==
                                                                      choice.no)
                                                                    basement =
                                                                        false;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                            type == 3
                                                ? Container()
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                  ),
                                            type == 3
                                                ? Container()
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text('يوجد مصعد : ',
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                "Tajawal-b",
                                                          ),
                                                          textDirection:
                                                              TextDirection
                                                                  .rtl),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            child:
                                                                RadioListTile(
                                                              title: const Text(
                                                                'نعم',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontFamily:
                                                                        "Tajawal-m",
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            73,
                                                                            75,
                                                                            82)),
                                                              ),
                                                              value: choice.yes,
                                                              groupValue:
                                                                  _elevatorCH,
                                                              onChanged:
                                                                  (choice?
                                                                      value) {
                                                                setState(() {
                                                                  _elevatorCH =
                                                                      value;
                                                                  if (_elevatorCH ==
                                                                      choice
                                                                          .yes)
                                                                    elevator =
                                                                        true;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.5,
                                                            child:
                                                                RadioListTile(
                                                              title: const Text(
                                                                'لا',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontFamily:
                                                                        "Tajawal-m",
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            73,
                                                                            75,
                                                                            82)),
                                                              ),
                                                              value: choice.no,
                                                              groupValue:
                                                                  _elevatorCH,
                                                              onChanged:
                                                                  (choice?
                                                                      value) {
                                                                setState(() {
                                                                  _elevatorCH =
                                                                      value;
                                                                  if (_elevatorCH ==
                                                                      choice.no)
                                                                    elevator =
                                                                        false;
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
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: SizedBox(
                                                  height: 100,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    physics:
                                                        const AlwaysScrollableScrollPhysics(),
                                                    children: [
                                                      selectedFiles.isEmpty
                                                          ? Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  1.1,
                                                              child: TextButton(
                                                                child: Text(
                                                                  '+إرفع صور للعقار',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20.0,
                                                                      fontFamily:
                                                                          "Tajawal-m",
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          127,
                                                                          166,
                                                                          233)),
                                                                ),
                                                                onPressed: () {
                                                                  selectImage();
                                                                },
                                                              ),
                                                            )
                                                          : Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                top: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    100,
                                                                right: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    100,
                                                                bottom: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    100,
                                                              ),
                                                              height: 100,
                                                              child: ListView(
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                children:
                                                                    selectedFiles
                                                                        .map((e) =>
                                                                            Stack(
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
                                            //submit button
                                            SizedBox(
                                              width: 300.0,
                                              height: 90.0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    getCities();

                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      showAlertDialog(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                ' تمت إضافة العقار بنجاح!')),
                                                      );
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Color.fromARGB(
                                                                255,
                                                                127,
                                                                166,
                                                                233)),
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        30,
                                                                    vertical:
                                                                        10)),
                                                    shape: MaterialStateProperty
                                                        .all(RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        27))),
                                                  ),
                                                  child: const Text(
                                                    'إضافة',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily:
                                                            "Tajawal-m"),
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
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(height: 290),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 79),
                          child: Text(
                            "عذراً لابد من تسجيل الدخول ",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Tajawal-b",
                                color: Color.fromARGB(255, 127, 166, 233)),
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => LogIn()));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 127, 166, 233)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27))),
                        ),
                        child: Text(
                          "تسجيل الدخول",
                          style:
                              TextStyle(fontSize: 20, fontFamily: "Tajawal-m"),
                        ),
                      )
                    ],
                  );
                }
              },
            ),
          ]),
        ),
      ),
    );
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
}
