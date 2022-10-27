// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:csc_picker/csc_picker.dart';

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

enum classification { rent, sale }

enum choice { yes, no }

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  static int i = 1;
  String property_id = '';
  classification? _class = classification.rent;
  String classification1 = '';
  choice? _poolCH = choice.no;
  choice? _basementCH = choice.no;
  choice? _elevatorCH = choice.no;
  int type = 1;
  String type1 = 'villa';
  String age = '';
  String city = '';
  String address1 = '';
  String location = '';
  String price = '';
  String space = '';
  bool pool = false;
  bool basement = false;
  bool elevator = false;
  String imageUrl = '';
  String countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String? address = "";
  int bathNo = 0;
  int roomNo = 0;
  TextEditingController rentController = TextEditingController();
  TextEditingController saleController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  int rentDuration = 1;
  String rentDuration1 = "Per Year";

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
          if (imageUrl.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please upload an image')));

            return;
          }
          _formKey.currentState!.save();
          i++;
          property_id = "p$i";
          print(
              "property_id: $property_id , classification: $classification1 , type: $type1 , property_age: $age , city: $cityValue , neighborhood: $address , location: $location , price: $price , space: $space , number_of_bathroom: $bathNo , number_of_room: $roomNo , pool: $pool , basement: $basement , elevator: $elevator  ");
          FirebaseFirestore.instance.collection('properties').add({
            'property_id': property_id,
            'classification': classification1,
            'type': type1,
            'property_age': age,
            'city': cityValue,
            'neighborhood': address,
            'location': location,
            'price': price,
            'space': space,
            'number_of_bathroom': bathNo,
            'number_of_room': roomNo,
            'pool': pool,
            'basement': basement,
            'elevator': elevator,
            'image': imageUrl
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
                                                      classification1 = 'sale';
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
                                                value: classification.sale,
                                                groupValue: _class,
                                                onChanged:
                                                    (classification? value) {
                                                  setState(() {
                                                    _class = value;
                                                    if (_class ==
                                                        classification.sale)
                                                      classification1 = 'sale';
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
                                  Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Text('نوع عقارك: ',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontFamily: "Tajawal-b",
                                                ),
                                                textDirection:
                                                    TextDirection.rtl),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0)),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 7),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
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
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color:
                                                                Color.fromARGB(
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
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color:
                                                                Color.fromARGB(
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
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color:
                                                                Color.fromARGB(
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
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    73,
                                                                    75,
                                                                    82)),
                                                      ),
                                                      value: 4,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        "استراحة",
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    73,
                                                                    75,
                                                                    82)),
                                                      ),
                                                      value: 5,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        "مزرعة",
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    73,
                                                                    75,
                                                                    82)),
                                                      ),
                                                      value: 6,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        "مكتب",
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    73,
                                                                    75,
                                                                    82)),
                                                      ),
                                                      value: 7,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text("محل تجاري",
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontFamily:
                                                                  "Tajawal-m",
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      73,
                                                                      75,
                                                                      82))),
                                                      value: 8,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text("مستودع",
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontFamily:
                                                                  "Tajawal-m",
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      73,
                                                                      75,
                                                                      82))),
                                                      value: 9,
                                                    ),
                                                  ],
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      type = value!;
                                                      if (type == 1)
                                                        type1 = 'villa';
                                                      if (type == 2)
                                                        type1 = 'apartment';
                                                      if (type == 3)
                                                        type1 = 'land';
                                                      if (type == 4)
                                                        type1 = 'building';
                                                      if (type == 5)
                                                        type1 = 'chalet';
                                                      if (type == 6)
                                                        type1 = 'farm';
                                                      if (type == 7)
                                                        type1 = 'office';
                                                      if (type == 8)
                                                        type1 = 'store';
                                                      if (type == 9)
                                                        type1 = 'warehouse';
                                                    });
                                                  }),
                                            ),
                                          ],
                                        )),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'سنة',
                                      labelText: 'عمر العقار',
                                      labelStyle: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: "Tajawal-m",
                                          color:
                                              Color.fromARGB(255, 73, 75, 82)),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء عدم ترك الخانة فارغة!';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      age = val!;
                                    },
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(20),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      icon: const Icon(
                                        Icons.square_foot,
                                        color:
                                            Color.fromARGB(255, 127, 166, 233),
                                      ),
                                      hintText: '500 م2',
                                      labelText: 'المساحة',
                                      labelStyle: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: "Tajawal-m",
                                          color:
                                              Color.fromARGB(255, 73, 75, 82)),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء عدم ترك الخانة فارغة!';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      space = val!;
                                    },
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(30),
                                  ),
                                  Column(
                                    children: [
                                      CSCPicker(
                                        showCities: true,
                                        flagState: CountryFlag.DISABLE,
                                        stateSearchPlaceholder: "المنطقة",
                                        citySearchPlaceholder: "المدينة",
                                        stateDropdownLabel: "*المنطقة",
                                        cityDropdownLabel: "*المدينة",
                                        defaultCountry:
                                            DefaultCountry.Saudi_Arabia,
                                        disableCountry: true,
                                        dropdownDecoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey.shade300,
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
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(15),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'القيروان',
                                        labelText: 'الحي',
                                        labelStyle: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: "Tajawal-m",
                                            color: Color.fromARGB(
                                                255, 73, 75, 82))),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء عدم ترك الخانة فارغة!';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      address = val!;
                                    },
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(15),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      icon: const Icon(
                                        Icons.location_on,
                                        color:
                                            Color.fromARGB(255, 127, 166, 233),
                                      ),
                                      hintText: 'العنوان',
                                      labelText: 'الموقع',
                                      labelStyle: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: "Tajawal-m",
                                          color:
                                              Color.fromARGB(255, 73, 75, 82)),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء عدم ترك الخانة فارغة!';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      location = val!;
                                    },
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(20),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(' السعر: ',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: "Tajawal-b",
                                            ),
                                            textDirection: TextDirection.rtl),
                                        Container(
                                          margin: const EdgeInsets.all(5),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 7),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1)),
                                              height: 45,
                                              width: 160,
                                              child: TextField(
                                                controller: rentController,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'ريال',
                                                  labelStyle: TextStyle(
                                                      fontSize: 16.0,
                                                      fontFamily: "Tajawal-m",
                                                      color: Color.fromARGB(
                                                          255, 73, 75, 82)),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 7),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 1)),
                                              height: 45,
                                              width: 160,
                                              child: DropdownButton(
                                                  value: type,
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        "سنوياً",
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    73,
                                                                    75,
                                                                    82)),
                                                      ),
                                                      value: 1,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        "شهرياً",
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    73,
                                                                    75,
                                                                    82)),
                                                      ),
                                                      value: 2,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        "أسبوعياً",
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    73,
                                                                    75,
                                                                    82)),
                                                      ),
                                                      value: 3,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        "يومياً",
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                "Tajawal-m",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    73,
                                                                    75,
                                                                    82)),
                                                      ),
                                                      value: 4,
                                                    )
                                                  ],
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      rentDuration = value!;
                                                      if (rentDuration == 1)
                                                        rentDuration1 =
                                                            'Per Year';
                                                      if (rentDuration == 2)
                                                        rentDuration1 =
                                                            'Per Month';
                                                      if (rentDuration == 3)
                                                        rentDuration1 =
                                                            'Per Week';
                                                      if (rentDuration == 4)
                                                        rentDuration1 =
                                                            'Per Night';
                                                    });
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(20),
                                  ),
                                  Column(
                                    children: [
                                      Text("عددالغرف",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: "Tajawal-b")),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 73, 75, 82),
                                                width: 1)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  roomNo++;

                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  color: Color.fromARGB(
                                                      255, 127, 166, 233),
                                                )),
                                            Text("$roomNo",
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: "Tajawal-b",
                                                    color: Color.fromARGB(
                                                        255, 73, 75, 82)),
                                                textDirection:
                                                    TextDirection.rtl),
                                            IconButton(
                                                onPressed: () {
                                                  roomNo == 0 ? null : roomNo--;

                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                  Icons.remove_circle_outline,
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
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 73, 75, 82),
                                                width: 1)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  bathNo++;

                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  color: Color.fromARGB(
                                                      255, 127, 166, 233),
                                                )),
                                            Text("$bathNo",
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: "Tajawal-m",
                                                    color: Color.fromARGB(
                                                        255, 73, 75, 82)),
                                                textDirection:
                                                    TextDirection.rtl),
                                            IconButton(
                                                onPressed: () {
                                                  bathNo == 0 ? null : bathNo--;

                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                  Icons.remove_circle_outline,
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
                                                'نعم',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontFamily: "Tajawal-m",
                                                    color: Color.fromARGB(
                                                        255, 73, 75, 82)),
                                              ),
                                              value: choice.yes,
                                              groupValue: _poolCH,
                                              onChanged: (choice? value) {
                                                setState(() {
                                                  _poolCH = value;
                                                  if (_poolCH == choice.yes)
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
                                                    fontFamily: "Tajawal-m",
                                                    color: Color.fromARGB(
                                                        255, 73, 75, 82)),
                                              ),
                                              value: choice.no,
                                              groupValue: _poolCH,
                                              onChanged: (choice? value) {
                                                setState(() {
                                                  _poolCH = value;
                                                  if (_poolCH == choice.no)
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
                                      Text('يوجد قبو : ',
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
                                                'نعم',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontFamily: "Tajawal-m",
                                                    color: Color.fromARGB(
                                                        255, 73, 75, 82)),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            child: RadioListTile(
                                              title: const Text(
                                                'لا',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontFamily: "Tajawal-m",
                                                    color: Color.fromARGB(
                                                        255, 73, 75, 82)),
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
                                                'نعم',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontFamily: "Tajawal-m",
                                                    color: Color.fromARGB(
                                                        255, 73, 75, 82)),
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
                                                    fontFamily: "Tajawal-m",
                                                    color: Color.fromARGB(
                                                        255, 73, 75, 82)),
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
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                  ),
                                  Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Text(' إرفع صورة: ',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily: "Tajawal-b",
                                                ),
                                                textDirection:
                                                    TextDirection.rtl),
                                            IconButton(
                                                onPressed: () async {
                                                  ImagePicker imagePicker =
                                                      ImagePicker();
                                                  XFile? file =
                                                      await imagePicker
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                  print('${file?.path}');

                                                  if (file == null) return;
                                                  //Import dart:core
                                                  String uniqueFileName =
                                                      DateTime.now()
                                                          .millisecondsSinceEpoch
                                                          .toString();

                                                  /*Step 2: Upload to Firebase storage*/
                                                  //Install firebase_storage
                                                  //Import the library

                                                  //Get a reference to storage root
                                                  Reference referenceRoot =
                                                      FirebaseStorage.instance
                                                          .ref();
                                                  Reference referenceDirImages =
                                                      referenceRoot
                                                          .child('images');

                                                  //Create a reference for the image to be stored
                                                  Reference
                                                      referenceImageToUpload =
                                                      referenceDirImages
                                                          .child('name');

                                                  //Handle errors/success
                                                  try {
                                                    //Store the file
                                                    await referenceImageToUpload
                                                        .putFile(
                                                            File(file.path));
                                                    //Success: get the download URL
                                                    imageUrl =
                                                        await referenceImageToUpload
                                                            .getDownloadURL();
                                                  } catch (error) {
                                                    //Some error occurred
                                                  }
                                                },
                                                icon: Icon(Icons.photo_camera)),
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                    width: 300.0,
                                    height: 90.0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          getCities();

                                          if (_formKey.currentState!
                                              .validate()) {
                                            showAlertDialog(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'جاري اضافة العقار')),
                                            );
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
    );
  }
}
