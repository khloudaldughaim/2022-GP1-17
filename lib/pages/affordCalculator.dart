// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

import 'homapage.dart';

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

  int type = 1;
  String type1 = 'فيلا';
  //double property_age = 0.0;
  String? city = "الرياض";

  var citiesList = [
    "الرياض",
    "جدة",
    "مكة",
    "المدينة",
    "الدمام",
    "الاحساء",
    "الخبر",
    "القطيف",
    "الخفجي",
    "الهفوف",
    "الطائف",
    "تبوك",
    "بريدة",
    "خميس مشيط",
    "الجبيل",
    "نجران",
    "المبرز",
    "حايل",
    "ابها",
    "ينبع",
    "عرعر",
    "عنيزة",
    "سكاكا",
    "جازان",
    "القريات",
    "الباحة",
    "بيشة",
    "الرس",
    "البكيرية",
    "الشفا",
    "العلا",
    "القنفذة",
    "رنية",
    "رابغ",
    "النماص",
    "سراة عبيدة",
    "رجال المع",
    "ضباء",
    "املج",
    "بقعاء",
    "رفحاء",
    "صبيا",
    "شرورة",
    "بلجرشي",
    "دومة الجندل"
  ];

  void dispose() {
    income.dispose();
    spendings.dispose();
    loans.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    calculate() {}

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
                                    margin: const EdgeInsets.all(20),
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 6.0),
                                        child: Text(
                                          'حاسبة التكاليف تحسب مقدار الإيجار المناسب لميزانيتك',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              fontFamily: "Tajawal-b",
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 163, 163, 163)),
                                        ),
                                      )),
                                  Container(
                                    margin: const EdgeInsets.all(15),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          //calculator
                                          alignment: Alignment.topRight,
                                          height: 400,
                                          width: 230,
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 202, 216, 227),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Padding(
                                              padding: EdgeInsets.all(20.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'الدخل الشهري ',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontFamily: "Tajawal-b",
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.all(0),
                                                          child: Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  income,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    'الراتب وأي مصادر دخل أخرى',
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(6),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 0.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (!RegExp(
                                                                        r'[0-9]')
                                                                    .hasMatch(
                                                                        value!)) {
                                                                  return 'الرجاء إدخال أرقام فقط';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ))), //spendings
                                                  Text(
                                                    ' الإلتزامات الشهرية ',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontFamily: "Tajawal-b",
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.all(0),
                                                          child: Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  spendings,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    'نفقة، فواتير ماء، كهرب...',
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(6),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 0.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (!RegExp(
                                                                        r'[0-9]')
                                                                    .hasMatch(
                                                                        value!)) {
                                                                  return 'الرجاء إدخال أرقام فقط';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ))), //loan
                                                  Text(
                                                    ' القروض الشهرية',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontFamily: "Tajawal-b",
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.all(0),
                                                          child: Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            child:
                                                                TextFormField(
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
                                                                    Colors
                                                                        .white,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(6),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 0.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              validator:
                                                                  (value) {
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
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            calculate();
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
                                                          padding: MaterialStateProperty
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
                                                                      .circular(
                                                                          27),
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
                                        margin: const EdgeInsets.only(
                                            top: 5, right: 7),
                                        child: Column(
                                          children: [
                                            //city
                                            Container(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          'المدينة                ',
                                                          style: TextStyle(
                                                            fontSize: 19.0,
                                                            fontFamily:
                                                                "Tajawal-b",
                                                          ),
                                                          textDirection:
                                                              TextDirection
                                                                  .rtl),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0)),
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
                                                        child:
                                                            DropdownButtonFormField(
                                                          menuMaxHeight: 400,
                                                          value: city,
                                                          items: citiesList
                                                              .map((value) {
                                                            return DropdownMenuItem(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            );
                                                          }).toList(),
                                                          onChanged:
                                                              (_selectedValue) {
                                                            setState(() {
                                                              city =
                                                                  _selectedValue
                                                                      .toString();
                                                            });
                                                          },
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontFamily:
                                                                  "Tajawal-m",
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      73,
                                                                      75,
                                                                      82)),
                                                          decoration:
                                                              InputDecoration(
                                                            isDense: true,
                                                            border: InputBorder
                                                                .none,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    7),
                                                            hintText: 'الرياض',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(13),
                                            ),
                                            //type
                                            Container(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          'نوع العقار           ',
                                                          style: TextStyle(
                                                            fontSize: 19.0,
                                                            fontFamily:
                                                                "Tajawal-b",
                                                          ),
                                                          textDirection:
                                                              TextDirection
                                                                  .rtl),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0)),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8),
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
                                                        child:
                                                            DropdownButtonFormField(
                                                                decoration:
                                                                    InputDecoration(
                                                                  isDense: true,
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              7),
                                                                ),
                                                                value: type,
                                                                items: [
                                                                  DropdownMenuItem(
                                                                    child: Text(
                                                                      "فيلا",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17.0,
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
                                                                              17.0,
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
                                                                              17.0,
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
                                                                              17.0,
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
                                                                onChanged: (int?
                                                                    value) {
                                                                  setState(() {
                                                                    type =
                                                                        value!;
                                                                    if (type ==
                                                                        1)
                                                                      type1 =
                                                                          'فيلا';
                                                                    if (type ==
                                                                        2)
                                                                      type1 =
                                                                          'شقة';
                                                                    if (type ==
                                                                        3)
                                                                      type1 =
                                                                          'ارض';
                                                                    if (type ==
                                                                        4)
                                                                      type1 =
                                                                          'عمارة';
                                                                  });
                                                                }),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(13),
                                            ),
                                            Container(
                                                child: Column(
                                              children: [
                                                Text('الإيجار المناسب:',
                                                    style: TextStyle(
                                                        fontSize: 21.0,
                                                        fontFamily: "Tajawal-b",
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textDirection:
                                                        TextDirection.rtl),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                ),
                                                Container(
                                                    height: 140,
                                                    width: 140,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 40),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 4,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    134,
                                                                    206,
                                                                    137))),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          ' 5000 ',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    134,
                                                                    206,
                                                                    137),
                                                            fontSize: 45.0,
                                                            fontFamily:
                                                                "Tajawal-b",
                                                          ),
                                                        ),
                                                        Text(
                                                          ' ر.س ',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    134,
                                                                    206,
                                                                    137),
                                                            fontSize: 20.0,
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
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(20),
                                  ),
                                  //recommended properties
                                  Container(
                                    padding: const EdgeInsets.only(left: 120),
                                    child: Text(
                                      'عقارات مناسبة لميزانيتك:',
                                      style: TextStyle(
                                        fontSize: 23.0,
                                        fontFamily: "Tajawal-b",
                                      ),
                                    ),
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
