// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nozol_application/pages/apartmentdetailes.dart';
import 'package:nozol_application/pages/buildingdetailes.dart';
import 'package:nozol_application/pages/landdetailes.dart';
import 'package:nozol_application/pages/villa.dart';
import 'package:nozol_application/pages/villadetailes.dart';

import '../Cities/cities.dart';
import '../Cities/neighborhood.dart';
import 'apartment.dart';
import 'building.dart';
import 'homapage.dart';
import 'land.dart';

class affordCalcPage extends StatefulWidget {
  const affordCalcPage({Key? key}) : super(key: key);

  @override
  State<affordCalcPage> createState() => _affordCalcPageState();
}

class _affordCalcPageState extends State<affordCalcPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 127, 166, 233),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 125),
          child: Text("حاسبة التكاليف",
              style: TextStyle(
                fontSize: 17,
                fontFamily: "Tajawal-m",
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
        toolbarHeight: 60,
      ),
      body: const afforCalcForm(),
    );
  }
}

class afforCalcForm extends StatefulWidget {
  const afforCalcForm({super.key});

  @override
  afforCalcFormState createState() {
    return afforCalcFormState();
  }
}

class afforCalcFormState extends State<afforCalcForm> {
  final _formKey = GlobalKey<FormState>();
  final income = TextEditingController();
  final spendings = TextEditingController();
  final loans = TextEditingController();
  double result = 0;
  bool showInRange = false;
  List<dynamic> inRangeProp = [];

  int type = 1;
  String type1 = 'فيلا';

  static String? city = "الرياض";
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
  static final GlobalKey<FormFieldState> _AddressKey = GlobalKey<FormFieldState>();
  static String? address;

  void dispose() {
    income.dispose();
    spendings.dispose();
    loans.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tempArea = areas.where((element) =>  (element['city_id'] == 3 ));
    areasList.addAll(tempArea);

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
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 6.0),
                                        child: Text(
                                          'حاسبة التكاليف تحسب مقدار الإيجار المناسب لميزانيتك',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontFamily: "Tajawal-b",
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(255, 139, 139, 139)),
                                        ),
                                      )),
                                  Container(
                                    margin: const EdgeInsets.all(12),
                                  ),
                                  Container(
                                      //calculator
                                      height: 550,
                                      width: 350,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 202, 216, 227),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 230),
                                                  child: Text(
                                                    'المدينة : ',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontFamily: "Tajawal-b",
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(right: 7),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 1)),
                                                height: 45,
                                                width: 320,
                                                child: DropdownButtonFormField(
                                              menuMaxHeight: 400,
                                              value: city,
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
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: "Tajawal-m",
                                                  color: Color.fromARGB(255, 73, 75, 82)),
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.all(7),
                                                hintText: 'الرياض',
                                              ),
                                            ),
                                              ),
                                              SizedBox(
                                                height: 14,
                                              ),
                                              //type
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 215),
                                                  child: Text(
                                                    'نوع العقار :',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontFamily: "Tajawal-b",
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 1)),
                                                height: 45,
                                                width: 320,
                                                child: DropdownButtonFormField(
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.all(7),
                                                    ),
                                                    value: type,
                                                    items: [
                                                      DropdownMenuItem(
                                                        child: Text(
                                                          "فيلا",
                                                          style: TextStyle(
                                                              fontSize: 17.0,
                                                              fontFamily:
                                                                  "Tajawal-m",
                                                              color: Color
                                                                  .fromARGB(
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
                                                              fontSize: 17.0,
                                                              fontFamily:
                                                                  "Tajawal-m",
                                                              color: Color
                                                                  .fromARGB(
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
                                                              fontSize: 17.0,
                                                              fontFamily:
                                                                  "Tajawal-m",
                                                              color: Color
                                                                  .fromARGB(
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
                                                              fontSize: 17.0,
                                                              fontFamily:
                                                                  "Tajawal-m",
                                                              color: Color
                                                                  .fromARGB(
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
                                                        type = value!;
                                                        if (type == 1)
                                                          type1 = 'فيلا';
                                                        if (type == 2)
                                                          type1 = 'شقة';
                                                        if (type == 3)
                                                          type1 = 'ارض';
                                                        if (type == 4)
                                                          type1 = 'عمارة';
                                                      });
                                                    }),
                                              ),
                                              SizedBox(
                                                height: 14,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 170),
                                                  child: Text(
                                                    'الدخل الشهري :',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontFamily: "Tajawal-b",
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: TextFormField(
                                                          controller: income,
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'الراتب وأي مصادر دخل أخرى',
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    6),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0.0,
                                                              ),
                                                            ),
                                                          ),
                                                          validator: (value) {
                                                            if (!RegExp(
                                                                    r'[0-9]')
                                                                .hasMatch(
                                                                    value!)) {
                                                              return 'الرجاء إدخال أرقام فقط';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ))),
                                              SizedBox(
                                                height: 7,
                                              ), //spendings
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 145),
                                                  child: Text(
                                                    ' الإلتزامات الشهرية :',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontFamily: "Tajawal-b",
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: TextFormField(
                                                          controller: spendings,
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                ' فواتير ماء، كهرب، نفقة...',
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    6),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0.0,
                                                              ),
                                                            ),
                                                          ),
                                                          validator: (value) {
                                                            if (!RegExp(
                                                                    r'[0-9]')
                                                                .hasMatch(
                                                                    value!)) {
                                                              return 'الرجاء إدخال أرقام فقط';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ))),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              //loan
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 155),
                                                  child: Text(
                                                    ' القروض الشهرية :',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontFamily: "Tajawal-b",
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: TextFormField(
                                                          controller: loans,
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'قرض منزل، سيارة...',
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    6),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0.0,
                                                              ),
                                                            ),
                                                          ),
                                                          validator: (value) {
                                                            if (!RegExp(
                                                                    r'[0-9]')
                                                                .hasMatch(
                                                                    value!)) {
                                                              return 'الرجاء إدخال أرقام فقط';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ))),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              //submit button
                                              SizedBox(
                                                width: 205.0,
                                                height: 70.0,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      print(city);
                                                      print(address);
                                                      print(city);
                                                      //calculate functionality
                                                      if (_formKey.currentState!.validate()) {
                                                        setState(() {
                                                        int income1 = int.parse(income.text);
                                                        int spendings1 = int.parse(spendings.text);
                                                        int loans1 = int.parse(loans.text);
                                                        result = (income1 - spendings1 - loans1) * 0.25;
                                                        inRangeProp.clear();
                                                        showInRange = false;
                                                        address='';
                                                        

                                                        HomePageState.allData.forEach((element) {
                                                          if (element is Villa) {
                                                            final villa = element;
                                                            if (villa.properties.type == type1 && villa.properties.classification == 'للإيجار' && villa.properties.city == city && int.parse(villa.properties.price) <= result) {
                                                              inRangeProp.add(villa.properties.property_id);
                                                            }
                                                          }
                                                          if (element is Apartment) {
                                                            final apartment = element;
                                                            if (apartment.properties.type == type1 && apartment.properties.classification == 'للإيجار' && apartment.properties.city == city && int.parse(apartment.properties.price) <= result) {
                                                              inRangeProp.add(apartment.properties.property_id);
                                                            }
                                                          }
                                                          if (element is Building) {
                                                            final building = element;
                                                            if (building.properties.type == type1 && building.properties.classification == 'للإيجار' && building.properties.city == city && int.parse(building.properties.price) <= result) {
                                                              inRangeProp.add(building.properties.property_id);
                                                            }
                                                          }
                                                          if (element is Land) {
                                                            final land = element;
                                                            if (land.properties!.type == type1 && land.properties!.classification == 'للإيجار' && land.properties!.city == city && int.parse(land.properties!.price) <= result) {
                                                              inRangeProp.add(land.properties!.property_id);
                                                            }
                                                          }
                                                        });

                                                        if(inRangeProp.isNotEmpty){
                                                          showInRange = true;
                                                        }

                                                        });
                                                      }
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Color
                                                                  .fromARGB(
                                                                      255,
                                                                      127,
                                                                      166,
                                                                      233)),
                                                      padding:
                                                          MaterialStateProperty
                                                              .all(EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          40,
                                                                      vertical:
                                                                          5)),
                                                      shape:
                                                          MaterialStateProperty
                                                              .all(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(27),
                                                        ),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'إحسب',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily:
                                                              "Tajawal-m"),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ))),    
                                  Container(
                                    margin: const EdgeInsets.all(13),
                                  ),
                                  showInRange == true
                                      ? Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5, right: 7),
                                              child: Column(
                                                children: [
                                                  Container(
                                                      child: Column(
                                                    children: [
                                                      Container(
                                                          height: 160,
                                                          width: 180,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 25,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              10)),
                                                              border: Border.all(
                                                                  width: 3.5,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          134,
                                                                          206,
                                                                          137))),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                  'أقصى حد للإيجار',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            134,
                                                                            206,
                                                                            137),
                                                                    fontSize:
                                                                        19.0,
                                                                    fontFamily:
                                                                        "Tajawal-b",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  textDirection:
                                                                      TextDirection
                                                                          .rtl),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(7),
                                                              ),
                                                              Text(
                                                                '$result',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          134,
                                                                          206,
                                                                          137),
                                                                  fontSize:
                                                                      39.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      "Tajawal-b",
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(2),
                                                              ),
                                                              Text(
                                                                '  ر.س ',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          134,
                                                                          206,
                                                                          137),
                                                                  fontSize:
                                                                      19.0,
                                                                  fontFamily:
                                                                      "Tajawal-b",
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(25),
                                            ),
                                            //recommended properties
                                            Container(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 90),
                                                    child: Text(
                                                      'عقارات مناسبة لميزانيتك :',
                                                      style: TextStyle(
                                                        fontSize: 22.0,
                                                        fontFamily: "Tajawal-b",
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 180,
                                                        top: 13,
                                                        bottom: 10),
                                                    padding: EdgeInsets.only(
                                                        right: 7, top: 3 ),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300,
                                                            width: 1)),
                                                    height: 40,
                                                    width: 160,
                                                    child:
                                                        DropdownButtonFormField(
                                                      isExpanded: true,
                                                      key: _AddressKey,
                                                      items: areasList
                                                          .map((value) {
                                                        return DropdownMenuItem(
                                                          value: value,
                                                          child: Text(
                                                              value['name_ar']),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (dynamic value) {
                                                        setState(() {
                                                          address = value['name_ar'];

                                                          inRangeProp.clear();
                                                        
                                                          HomePageState.allData.forEach((element) {
                                                            if (element is Villa) {
                                                              final villa = element;
                                                              if (villa.properties.neighborhood == address && villa.properties.type == type1 && villa.properties.classification == 'للإيجار' && villa.properties.city == city && int.parse(villa.properties.price) <= result) {
                                                                inRangeProp.add(villa.properties.property_id);
                                                              }
                                                            }
                                                            if (element is Apartment) {
                                                              final apartment = element;
                                                              if (apartment.properties.neighborhood == address && apartment.properties.type == type1 && apartment.properties.classification == 'للإيجار' && apartment.properties.city == city && int.parse(apartment.properties.price) <= result) {
                                                                inRangeProp.add(apartment.properties.property_id);
                                                              }
                                                            }
                                                            if (element is Building) {
                                                              final building = element;
                                                              if (building.properties.neighborhood == address && building.properties.type == type1 && building.properties.classification == 'للإيجار' && building.properties.city == city && int.parse(building.properties.price) <= result) {
                                                                inRangeProp.add(building.properties.property_id);
                                                              }
                                                            }
                                                            if (element is Land) {
                                                              final land = element;
                                                              if (land.properties?.neighborhood == address && land.properties!.type == type1 && land.properties!.classification == 'للإيجار' && land.properties!.city == city && int.parse(land.properties!.price) <= result) {
                                                                inRangeProp.add(land.properties!.property_id);
                                                              }
                                                            }
                                                          });
                                                        });
                                                      },
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontFamily:
                                                              "Tajawal-m",
                                                          color: Color.fromARGB(
                                                              255, 73, 75, 82)),
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        border:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.only(bottom: 8),
                                                        hintText: 'تصفية الحي',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 210,
                                                    child: Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 24,
                                                                right: 20),
                                                        child:
                                                            ListView.separated(
                                                                physics:
                                                                    BouncingScrollPhysics(),
                                                                scrollDirection: Axis
                                                                    .horizontal,
                                                                // shrinkWrap: true,
                                                                separatorBuilder: (context,
                                                                        index) =>
                                                                    SizedBox(
                                                                        width:
                                                                            20),
                                                                itemCount:
                                                                    inRangeProp
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          HomePageState
                                                                              .allData
                                                                              .length;
                                                                      i++) {
                                                                    if (HomePageState
                                                                            .allData[i]
                                                                        is Villa) {
                                                                      Villa
                                                                          villa =
                                                                          HomePageState.allData[i]
                                                                              as Villa;
                                                                      if (villa
                                                                              .properties
                                                                              .property_id ==
                                                                          inRangeProp[
                                                                              index]) {
                                                                        return _buildVillaItem(
                                                                            HomePageState.allData[i]
                                                                                as Villa,
                                                                            context);
                                                                      }
                                                                    }
                                                                    if (HomePageState
                                                                            .allData[i]
                                                                        is Apartment) {
                                                                      Apartment
                                                                          apartment =
                                                                          HomePageState.allData[i]
                                                                              as Apartment;
                                                                      if (apartment
                                                                              .properties
                                                                              .property_id ==
                                                                          inRangeProp[
                                                                              index]) {
                                                                        return _buildApartmentItem(
                                                                            HomePageState.allData[i]
                                                                                as Apartment,
                                                                            context);
                                                                      }
                                                                    }
                                                                    if (HomePageState
                                                                            .allData[i]
                                                                        is Building) {
                                                                      Building
                                                                          building =
                                                                          HomePageState.allData[i]
                                                                              as Building;
                                                                      if (building
                                                                              .properties
                                                                              .property_id ==
                                                                          inRangeProp[
                                                                              index]) {
                                                                        return _buildBuildingItem(
                                                                            HomePageState.allData[i]
                                                                                as Building,
                                                                            context);
                                                                      }
                                                                    }
                                                                    if (HomePageState
                                                                            .allData[i]
                                                                        is Land) {
                                                                      Land
                                                                          land =
                                                                          HomePageState.allData[i]
                                                                              as Land;
                                                                      if (land.properties!
                                                                              .property_id ==
                                                                          inRangeProp[
                                                                              index]) {
                                                                        return _buildLandItem(
                                                                            HomePageState.allData[i]
                                                                                as Land,
                                                                            context);
                                                                      }
                                                                    }
                                                                  }
                                                                  return Container();
                                                                }),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(
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
}

/////////////////////////////////////////////////////////////////////
Widget _buildVillaItem(Villa villa, BuildContext context) {
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
          fontSize: 14,
          fontWeight: FontWeight.bold,
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
        '${villa.properties.space} متر ² ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: "Tajawal-l",
        ),
      ),
    ],
  );

  return _buildItem(() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VillaDetailes(villa: villa)),
    );
  }, rowItem, villa);
}

Widget _buildApartmentItem(Apartment apartment, BuildContext context) {
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
          fontSize: 14,
          fontWeight: FontWeight.bold,
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
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: "Tajawal-l",
        ),
      ),
    ],
  );
  return _buildItem(() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ApartmentDetailes(apartment: apartment)),
    );
  }, rowItem, apartment);
}

Widget _buildBuildingItem(Building building, BuildContext context) {
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
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: "Tajawal-l",
        ),
      ),
    ],
  );

  return _buildItem(() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BuildingDetailes(building: building)),
    );
  }, rowItem, building);
}

Widget _buildLandItem(Land land, BuildContext context) {
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
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: "Tajawal-l",
        ),
      ),
    ],
  );

  return _buildItem(() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LandDetailes(land: land)),
    );
  }, rowItem, land);
}

Widget _buildItem(void Function()? onTap, Row rowItem, dynamic type) {
  return GestureDetector(
    onTap: onTap,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Card(
        margin: EdgeInsets.fromLTRB(12, 12, 12, 6),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(15),
        )),
        child: Container(
          height: 210,
          width: 250,
          decoration: '${type.properties.images.length}' == '0'
              ? BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg'),
                      fit: BoxFit.cover),
                )
              : BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage('${type.properties.images[0]}'), fit: BoxFit.cover),
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
                      child: '${type.properties.classification}' == 'للإيجار'
                          ? Text(
                              '${type.properties.type} للإيجار',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Tajawal-m",
                              ),
                            )
                          : Text(
                              '${type.properties.type} للبيع',
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
                          '${type.properties.type}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal-l",
                          ),
                        ),
                        Text(
                          'ريال ${type.properties.price}',
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
                              '${type.properties.city}',
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
    ),
  );
}