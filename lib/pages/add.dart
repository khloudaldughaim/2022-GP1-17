// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:csc_picker/csc_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../registration/log_in.dart';
import 'homapage.dart';
import 'my-property.dart';
import 'package:nozol_application/Cities/cities.dart';
import 'package:nozol_application/Cities/neighborhood.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'إضافة عقار';
    return Scaffold(
      appBar: AppBar(
        // bottom: const
        automaticallyImplyLeading: false,
        title: Center(
          child: const Text(appTitle,
              style: TextStyle(
                fontSize: 17,
                fontFamily: "Tajawal-b",
              )),
        ),
        toolbarHeight: 60,
        backgroundColor: Color.fromARGB(255, 127, 166, 233),
      ),
      body: FirebaseAuth.instance.currentUser == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(height: 90),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 127, 166, 233)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                  ),
                  child: Text(
                    "تسجيل الدخول",
                    style: TextStyle(fontSize: 20, fontFamily: "Tajawal-m"),
                  ),
                )
              ],
            )
          : const MyCustomForm(),
    );
  }
}

enum classification { rent, sale }

enum propertyUse { residental, commercial }

enum choice { yes, no }

LatLng mapLatLng = LatLng(24.774265, 46.738586);

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  String property_id = '';
  classification? _class = classification.rent;
  String classification1 = 'للإيجار';
  int type = 1;
  String type1 = 'فيلا';
  propertyUse? _pUse = propertyUse.residental;
  String propertyUse1 = 'سكني';
  final price = TextEditingController();
  final in_floor = TextEditingController();
  final space = TextEditingController();
  double property_age = 0.0;
  choice? _poolCH = choice.no;
  choice? _basementCH = choice.no;
  choice? _elevatorCH = choice.no;
  bool pool = false;
  bool basement = false;
  bool elevator = false;
  String? city = "الرياض";
  String? address;
  final location = TextEditingController();
  final TourTime = TextEditingController();
  int number_of_bathrooms = 0;
  int number_of_rooms = 0;
  int number_of_livingRooms = 0;
  int number_of_floors = 0;
  int number_of_apartments = 0;
  final description = TextEditingController();
  final GlobalKey<FormFieldState> _AddressKey = GlobalKey<FormFieldState>();

  void dispose() {
    price.dispose();
    in_floor.dispose();
    space.dispose();
    location.dispose();
    description.dispose();
    TourTime.dispose();
    super.dispose();
  }

  void initState() {
    getCurrentPosition();

    super.initState();
  }

  GoogleMapController? mapController;
  List<Marker> markers = <Marker>[];

  Position position = Position.fromMap({'latitude': 24.7136, 'longitude': 46.6753});
  @override
  void getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position currentLocation = await Geolocator.getCurrentPosition();
    setState(() {
      position = currentLocation;
    });

    markers.add(Marker(
      markerId: MarkerId(position.latitude.toString() + position.longitude.toString()),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: const InfoWindow(
        title: 'موقع العقار',
      ),
      icon: BitmapDescriptor.defaultMarker,
      draggable: true,
    ));
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedFiles = [];

  //String _currentAddress = "";

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
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          final User_id = user!.uid;
          List<String> arrImage = [];
          for (int i = 0; i < selectedFiles.length; i++) {
            var imageUrl = await uploadFile(selectedFiles[i], User_id);
            arrImage.add(imageUrl.toString());
          }
          _formKey.currentState!.save();
          property_id = Uuid().v4();
          if (type1 == 'فيلا') {
            await FirebaseFirestore.instance.collection('properties').doc(property_id).set({
              'property_id': property_id,
              'User_id': User_id,
              'classification': classification1,
              'latitude': position.latitude,
              'longitude': position.longitude,
              'price': price.text,
              'space': space.text,
              'city': city,
              'neighborhood': address,
              'images': arrImage,
              'type': type1,
              'property_age': property_age,
              'number_of_floor': number_of_floors,
              'elevator': elevator,
              'number_of_bathroom': number_of_bathrooms,
              'number_of_room': number_of_rooms,
              'pool': pool,
              'basement': basement,
              'number_of_livingRooms': number_of_livingRooms,
              'Location': location.text,
              'description': description.text,
              "TourTime": TourTime.text
            });
            await FirebaseFirestore.instance.collection('Standard_user').doc(User_id).update({
              "ArrayOfProperty": FieldValue.arrayUnion([property_id])
            });
            setState(() {
              HomePageState.isDownloadedData = false;
            });
          }

          if (type1 == 'شقة') {
            await FirebaseFirestore.instance.collection('properties').doc(property_id).set({
              'property_id': property_id,
              'User_id': User_id,
              'classification': classification1,
              'latitude': position.latitude,
              'longitude': position.longitude,
              'price': price.text,
              'space': space.text,
              'city': city,
              'neighborhood': address,
              'images': arrImage,
              'type': type1,
              'property_age': property_age,
              'number_of_floor': number_of_floors,
              'elevator': elevator,
              'number_of_bathroom': number_of_bathrooms,
              'number_of_room': number_of_rooms,
              'in_floor': in_floor.text,
              'number_of_livingRooms': number_of_livingRooms,
              'Location': location.text,
              'description': description.text,
              "TourTime": TourTime.text
            });
            await FirebaseFirestore.instance.collection('Standard_user').doc(User_id).update({
              "ArrayOfProperty": FieldValue.arrayUnion([property_id])
            });
            setState(() {
              HomePageState.isDownloadedData = false;
            });
          }

          if (type1 == 'ارض') {
            await FirebaseFirestore.instance.collection('properties').doc(property_id).set({
              'property_id': property_id,
              'User_id': User_id,
              'classification': classification1,
              'latitude': position.latitude,
              'longitude': position.longitude,
              'price': price.text,
              'space': space.text,
              'city': city,
              'neighborhood': address,
              'images': arrImage,
              'type': type1,
              'propertyUse': propertyUse1,
              'Location': location.text,
              'description': description.text,
              "TourTime": TourTime.text
            });
            await FirebaseFirestore.instance.collection('Standard_user').doc(User_id).update({
              "ArrayOfProperty": FieldValue.arrayUnion([property_id])
            });
            setState(() {
              HomePageState.isDownloadedData = false;
            });
          }

          if (type1 == 'عمارة') {
            await FirebaseFirestore.instance.collection('properties').doc(property_id).set({
              'property_id': property_id,
              'User_id': User_id,
              'classification': classification1,
              'latitude': position.latitude,
              'longitude': position.longitude,
              'price': price.text,
              'space': space.text,
              'city': city,
              'neighborhood': address,
              'images': arrImage,
              'type': type1,
              'property_age': property_age,
              'number_of_floor': number_of_floors,
              'elevator': elevator,
              'pool': pool,
              'number_of_apartment': number_of_apartments,
              'Location': location.text,
              'description': description.text,
              "TourTime": TourTime.text
            });
            await FirebaseFirestore.instance.collection('Standard_user').doc(User_id).update({
              "ArrayOfProperty": FieldValue.arrayUnion([property_id])
            });
            setState(() {
              HomePageState.isDownloadedData = false;
            });
          }

          Fluttertoast.showToast(
            msg: "تم اضافة العقار بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Color.fromARGB(255, 127, 166, 233),
            textColor: Color.fromARGB(255, 248, 249, 250),
            fontSize: 18.0,
          );

          Navigator.push(context, MaterialPageRoute(builder: (context) => myProperty()));
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('  عقارك: ',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: "Tajawal-b",
                                            ),
                                            textDirection: TextDirection.rtl),
                                        Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width / 2,
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
                                            Container(
                                              width: MediaQuery.of(context).size.width / 2.5,
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
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(15),
                                  ),
                                  //type
                                  Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Text('نوع عقارك: ',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily: "Tajawal-b",
                                                ),
                                                textDirection: TextDirection.rtl),
                                            Padding(padding: const EdgeInsets.all(10.0)),
                                            Container(
                                              padding: EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(Radius.circular(10)),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.grey.shade300, width: 1)),
                                              height: 50,
                                              width: 150,
                                              child: DropdownButtonFormField(
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.all(7),
                                                  ),
                                                  value: type,
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        "فيلا",
                                                        style: TextStyle(
                                                            fontSize: 17.0,
                                                            fontFamily: "Tajawal-m",
                                                            color: Color.fromARGB(255, 73, 75, 82)),
                                                      ),
                                                      value: 1,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        "شقة",
                                                        style: TextStyle(
                                                            fontSize: 17.0,
                                                            fontFamily: "Tajawal-m",
                                                            color: Color.fromARGB(255, 73, 75, 82)),
                                                      ),
                                                      value: 2,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        "ارض",
                                                        style: TextStyle(
                                                            fontSize: 17.0,
                                                            fontFamily: "Tajawal-m",
                                                            color: Color.fromARGB(255, 73, 75, 82)),
                                                      ),
                                                      value: 3,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        "عمارة",
                                                        style: TextStyle(
                                                            fontSize: 17.0,
                                                            fontFamily: "Tajawal-m",
                                                            color: Color.fromARGB(255, 73, 75, 82)),
                                                      ),
                                                      value: 4,
                                                    )
                                                  ],
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      type = value!;
                                                      if (type == 1) type1 = 'فيلا';
                                                      if (type == 2) type1 = 'شقة';
                                                      if (type == 3) type1 = 'ارض';
                                                      if (type == 4) type1 = 'عمارة';
                                                    });
                                                  }),
                                            ),
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  type == 3
                                      ? Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('  استخدام العقار: ',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: "Tajawal-b",
                                                  ),
                                                  textDirection: TextDirection.rtl),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width / 2,
                                                    child: RadioListTile(
                                                      title: const Text(
                                                        'سكني',
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontFamily: "Tajawal-m",
                                                            color: Color.fromARGB(255, 73, 75, 82)),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      value: propertyUse.residental,
                                                      groupValue: _pUse,
                                                      onChanged: (propertyUse? value) {
                                                        setState(() {
                                                          _pUse = value;
                                                          if (_pUse == propertyUse.residental)
                                                            propertyUse1 = "سكني";
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width / 2.5,
                                                    child: RadioListTile(
                                                      title: const Text(
                                                        'تجاري',
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontFamily: "Tajawal-m",
                                                            color: Color.fromARGB(255, 73, 75, 82)),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      value: propertyUse.commercial,
                                                      groupValue: _pUse,
                                                      onChanged: (propertyUse? value) {
                                                        setState(() {
                                                          _pUse = value;
                                                          if (_pUse == propertyUse.commercial)
                                                            propertyUse1 = 'تجاري';
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
                                  type == 3
                                      ? Container(
                                          margin: const EdgeInsets.all(15),
                                        )
                                      : type == 2
                                          ? Container(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '  *رقم الدور: ',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontFamily: "Tajawal-b",
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(left: 83, right: 25),
                                                          child: Directionality(
                                                            textDirection: TextDirection.rtl,
                                                            child: TextFormField(
                                                              controller: in_floor,
                                                              autovalidateMode: AutovalidateMode
                                                                  .onUserInteraction,
                                                              decoration: InputDecoration(
                                                                hintText: '5 ',
                                                                filled: true,
                                                                fillColor: Colors.white,
                                                                contentPadding: EdgeInsets.all(6),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(8),
                                                                  borderSide: const BorderSide(
                                                                    color: Colors.grey,
                                                                    width: 0.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              validator: (value) {
                                                                if (value == null ||
                                                                    value.isEmpty) {
                                                                  return 'الرجاء عدم ترك الخانة فارغة!';
                                                                } else if (value.length > 3) {
                                                                  return 'الرقم يجب الا يزيد عن 3 خانات';
                                                                }
                                                                if (!RegExp(r'[0-9]')
                                                                    .hasMatch(value)) {
                                                                  return 'الرجاء إدخال أرقام فقط';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ))),
                                                ],
                                              ),
                                            )
                                          : Container(),

                                  type == 2
                                      ? Container(
                                          margin: const EdgeInsets.all(20),
                                        )
                                      : Container(),
                                  //space
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '  *المساحة: ',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: "Tajawal-b",
                                        ),
                                      ),
                                      Expanded(
                                          child: Padding(
                                              padding: EdgeInsets.only(left: 83, right: 25),
                                              child: Directionality(
                                                textDirection: TextDirection.rtl,
                                                child: TextFormField(
                                                  controller: space,
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
                                                    if (value == null || value.isEmpty) {
                                                      return 'الرجاء عدم ترك الخانة فارغة!';
                                                    } else if (value.length > 6) {
                                                      return 'الرقم يجب الا يزيد عن 6 خانات';
                                                    }
                                                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                                                      return 'الرجاء إدخال أرقام فقط';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ))),
                                    ],
                                  ),
                                  SizedBox(height: 40),
                                  //  price
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '  *السعر: ',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: "Tajawal-b",
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                      ),
                                      Expanded(
                                          child: Padding(
                                              padding: EdgeInsets.only(left: 83, right: 25),
                                              child: Directionality(
                                                textDirection: TextDirection.rtl,
                                                child: TextFormField(
                                                  controller: price,
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
                                              ))),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(' *إذا كان العقار للإيجار الرجاء إدخال الإيجار الشهري',
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                fontFamily: "Tajawal-b",
                                                color: Colors.grey),
                                            textDirection: TextDirection.rtl),
                                      ]),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  //city
                                  Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
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
                                            Padding(padding: const EdgeInsets.all(10.0)),
                                            Container(
                                              padding: EdgeInsets.only(right: 7),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(Radius.circular(10)),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.grey.shade300, width: 1)),
                                              height: 50,
                                              width: 155,
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
                                                  var tempCity = await cities.where((element) =>
                                                      (element['name_ar'] == _selectedValue));
                                                  var tempArea = await areas.where((element) =>
                                                      (element['city_id'] ==
                                                          tempCity.first['city_id']));
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
                                                autovalidateMode:
                                                    AutovalidateMode.onUserInteraction,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: "Tajawal-m",
                                                    color: Color.fromARGB(255, 73, 75, 82)),
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  border: InputBorder.none,
                                                  contentPadding: EdgeInsets.all(7),
                                                  hintText: 'اختر المدينة',
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
                                        '  *الحي: ',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: "Tajawal-b",
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(21),
                                      ),
                                      Padding(padding: const EdgeInsets.all(10.0)),
                                      Container(
                                        padding: EdgeInsets.only(right: 7),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.grey.shade300, width: 1)),
                                        height: 50,
                                        width: 155,
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
                                              address = value['name_ar'];
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
                                            hintText: 'اختر الحي ',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(20),
                                  ),
                                  //location
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '  *الموقع: ',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: "Tajawal-b",
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                      ),
                                      Expanded(
                                          child: Padding(
                                              padding: EdgeInsets.only(left: 83, right: 25),
                                              child: Directionality(
                                                textDirection: TextDirection.rtl,
                                                child: TextFormField(
                                                  controller: location,
                                                  autovalidateMode:
                                                      AutovalidateMode.onUserInteraction,
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
                                    height: 30,
                                  ),
                                  Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "الموقع على الخريطة",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontFamily: "Tajawal-m",
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(20),
                                        )
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
                                                  markerId: MarkerId(tapped.latitude.toString() +
                                                      tapped.longitude.toString()),
                                                  position:
                                                      LatLng(tapped.latitude, tapped.longitude),
                                                  infoWindow: const InfoWindow(
                                                    title: 'موقع العقار',
                                                  ),
                                                  draggable: true,
                                                  icon: BitmapDescriptor.defaultMarker,
                                                ));
                                            setState(() {
                                              markers = markers;
                                              position = Position.fromMap({
                                                'latitude': tapped.latitude,
                                                'longitude': tapped.longitude
                                              });
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
//                                         Container(
//                                             alignment: Alignment.bottomRight,
//                                             margin: EdgeInsets.only(right: 6, bottom: 108),
//                                             child: FloatingActionButton(
//                                               backgroundColor: Colors.white,
//                                               child: Icon(
//                                                 Icons.location_on,
//                                                 color: Colors.blue,
//                                               ),
//                                               onPressed: () async {
//                                                 LocationData currentLocation;
//                                                 var location = new Location();

//                                                 currentLocation = await location.getLocation();

//                                                 LatLng latLng = LatLng(currentLocation.latitude!,
//                                                     currentLocation.longitude!);

//                                                 mapController!
//                                                     .animateCamera(CameraUpdate.newCameraPosition(
//                                                   CameraPosition(
//                                                     bearing: 0,
//                                                     target: LatLng(currentLocation.latitude!,
//                                                         currentLocation.longitude!),
//                                                     zoom: 17.0,
//                                                   ),
//                                                 ));

//                                                 setState(() {
//                                                   mapLatLng = latLng;
//                                                 });
// /*
//                                                 List<geo.Placemark> places = await geo.placemarkFromCoordinates(
//         mapLatLng.latitude, mapLatLng.longitude);
//     _currentAddress =
//         places.first.name! +
//         "1-" +
//         places.first.subAdministrativeArea! +
//         "2-" +
//         places.first.subLocality! +
//         "3-" +
//         places.first.subThoroughfare! +
//         "4-" +
//         places.first.thoroughfare!;

//         places.first.administrativeArea! +
//         "3-" +
//         places.first.postalCode! +
//         "4-" +*/
//                                               },
//                                             )),
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

                                                mapController!.animateCamera(CameraUpdate.newLatLng(
                                                    geolocation!.coordinates));
                                                mapController!.animateCamera(
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
                                  type == 3
                                      ? Container()
                                      : Container(
                                          margin: const EdgeInsets.all(25),
                                        ),
                                  type == 3
                                      ? Container()
                                      :
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
                                  Container(
                                    margin: const EdgeInsets.all(20),
                                  ),
                                  type == 3 || type == 4
                                      ? Container()
                                      : Column(
                                          children: [
                                            Text("عدد الغرف",
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
                                                        number_of_rooms++;

                                                        setState(() {});
                                                      },
                                                      icon: const Icon(
                                                        Icons.add_circle_outline,
                                                        color: Color.fromARGB(255, 127, 166, 233),
                                                      )),
                                                  Text("$number_of_rooms",
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontFamily: "Tajawal-b",
                                                          color: Color.fromARGB(255, 73, 75, 82)),
                                                      textDirection: TextDirection.rtl),
                                                  IconButton(
                                                      onPressed: () {
                                                        number_of_rooms == 0
                                                            ? null
                                                            : number_of_rooms--;

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
                                  type == 3 || type == 4
                                      ? Container()
                                      : Container(
                                          margin: const EdgeInsets.all(20),
                                        ),
                                  type == 3 || type == 4
                                      ? Container()
                                      : Column(
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
                                                  border: Border.all(
                                                      color: Colors.grey.shade300, width: 1)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        number_of_bathrooms++;

                                                        setState(() {});
                                                      },
                                                      icon: const Icon(
                                                        Icons.add_circle_outline,
                                                        color: Color.fromARGB(255, 127, 166, 233),
                                                      )),
                                                  Text("$number_of_bathrooms",
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontFamily: "Tajawal-m",
                                                          color: Color.fromARGB(255, 73, 75, 82)),
                                                      textDirection: TextDirection.rtl),
                                                  IconButton(
                                                      onPressed: () {
                                                        number_of_bathrooms == 0
                                                            ? null
                                                            : number_of_bathrooms--;

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
                                  type == 3 || type == 4
                                      ? Container()
                                      : Container(
                                          margin: const EdgeInsets.all(20),
                                        ),
                                  type == 3 || type == 4
                                      ? Container()
                                      : Column(
                                          children: [
                                            Text("عدد الصالات",
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
                                  type == 3 || type == 4
                                      ? Container()
                                      : Container(
                                          margin: const EdgeInsets.all(20),
                                        ),
                                  type == 4
                                      ? Column(
                                          children: [
                                            Text("عدد الشقق",
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
                                                        number_of_apartments++;

                                                        setState(() {});
                                                      },
                                                      icon: const Icon(
                                                        Icons.add_circle_outline,
                                                        color: Color.fromARGB(255, 127, 166, 233),
                                                      )),
                                                  Text("$number_of_apartments",
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontFamily: "Tajawal-b",
                                                          color: Color.fromARGB(255, 73, 75, 82)),
                                                      textDirection: TextDirection.rtl),
                                                  IconButton(
                                                      onPressed: () {
                                                        number_of_apartments == 0
                                                            ? null
                                                            : number_of_apartments--;

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
                                        )
                                      : Container(),
                                  type == 4
                                      ? Container(
                                          margin: const EdgeInsets.all(10),
                                        )
                                      : Container(
                                          margin: const EdgeInsets.all(5),
                                        ),
                                  type == 3
                                      ? Container()
                                      : Column(
                                          children: [
                                            Text("عدد الأدوار",
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
                                  type == 3
                                      ? Container()
                                      : Container(
                                          margin: const EdgeInsets.all(20),
                                        ),
                                  type == 2 || type == 3
                                      ? Container()
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(' يوجد مسبح : ',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily: "Tajawal-b",
                                                ),
                                                textDirection: TextDirection.rtl),
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width / 2,
                                                  child: RadioListTile(
                                                    title: const Text(
                                                      'نعم',
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
                                                      'لا',
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
                                          ],
                                        ),
                                  type == 3 || type == 2
                                      ? Container()
                                      : Container(
                                          margin: const EdgeInsets.all(15),
                                        ),
                                  type == 1
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(' يوجد قبو : ',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily: "Tajawal-b",
                                                ),
                                                textDirection: TextDirection.rtl),
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width / 2,
                                                  child: RadioListTile(
                                                    title: const Text(
                                                      'نعم',
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
                                                      'لا',
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
                                          ],
                                        )
                                      : Container(),
                                  type == 3 || type == 2 || type == 4
                                      ? Container()
                                      : Container(
                                          margin: const EdgeInsets.all(15),
                                        ),
                                  type == 3
                                      ? Container()
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(' يوجد مصعد : ',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily: "Tajawal-b",
                                                ),
                                                textDirection: TextDirection.rtl),
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width / 2,
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
                                                Container(
                                                  width: MediaQuery.of(context).size.width / 2.5,
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
                                        borderRadius: BorderRadius.circular(5)),
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
                                                            color:
                                                                Color.fromARGB(255, 127, 166, 233)),
                                                      ),
                                                      onPressed: () {
                                                        selectImage();
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                      top: MediaQuery.of(context).size.height / 100,
                                                      right:
                                                          MediaQuery.of(context).size.height / 100,
                                                      bottom:
                                                          MediaQuery.of(context).size.height / 100,
                                                    ),
                                                    height: 100,
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      scrollDirection: Axis.horizontal,
                                                      children: selectedFiles
                                                          .map((e) => Stack(
                                                                alignment:
                                                                    AlignmentDirectional.topEnd,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(3.0),
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
                                                                        padding:
                                                                            EdgeInsets.all(.02),
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
                                        ' معلومات اضافية : ',
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
                                    margin: const EdgeInsets.all(15),
                                  ),
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
                                                hintText: 'الأحد والاربعاء 4-8 م ',
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
                                    margin: const EdgeInsets.all(15),
                                  ),

                                  //submit button
                                  SizedBox(
                                    width: 205.0,
                                    height: 70.0,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          getCities();

                                          if (_formKey.currentState!.validate()) {
                                            showAlertDialog(context);
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              Color.fromARGB(255, 127, 166, 233)),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(horizontal: 40, vertical: 5)),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(27),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'إضافة',
                                          style: TextStyle(fontSize: 20, fontFamily: "Tajawal-m"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(20),
                                  ),
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
}
