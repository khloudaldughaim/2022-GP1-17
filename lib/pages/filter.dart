import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nozol_application/pages/homapage.dart';

import '../Cities/cities.dart';
import '../Cities/neighborhood.dart';

class FilterPage extends StatefulWidget {
  @override
  State<FilterPage> createState() => _FilterPageState();
}

enum propertyUse { residental, commercial }

enum choice { yes, no, all }

class _FilterPageState extends State<FilterPage> {
  final _formKey = GlobalKey<FormState>();
  static int type = 1;
  static String type1 = "فيلا";
  static propertyUse? _pUse = propertyUse.residental;
  static String propertyUse1 = 'سكني';
  static final in_floor = TextEditingController();
  static final MinSpace = TextEditingController();
  static final MaxSpace = TextEditingController();
  static final MinPrice = TextEditingController();
  static final MaxPrice = TextEditingController();
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
  double property_age = 0.0;
  static int number_of_bathrooms = 0;
  static int number_of_rooms = 0;
  static int number_of_livingRooms = 0;
  static int number_of_floors = 0;
  static int number_of_apartments = 0;
  static choice? _poolCH = choice.no;
  static choice? _basementCH = choice.no;
  static choice? _elevatorCH = choice.no;
  static bool pool = false;
  static bool poolAll = false;
  static bool basement = false;
  static bool basementAll = false;
  static bool elevator = false;
  static bool elevatorAll = false;
  static RangeValues _ageRange = const RangeValues(0, 100);
  static bool? FilterValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 127, 166, 233),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 145),
            child: const Text('تصفية عقار',
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
                  Navigator.pop(context, {
                    "type1": type1,
                    "propertyUse1": propertyUse1,
                    "in_floor": in_floor.text,
                    "city": city,
                    "address": address,
                    "number_of_bathrooms": number_of_bathrooms,
                    "number_of_rooms": number_of_rooms,
                    "number_of_livingRooms": number_of_livingRooms,
                    "number_of_floors": number_of_floors,
                    "number_of_apartments": number_of_apartments,
                    "pool": pool,
                    "basement": basement,
                    "elevator": elevator,
                    "ageRange_start": _ageRange.start,
                    "ageRange_end": _ageRange.end,
                    "MinSpace": MinSpace.text,
                    "MaxSpace": MaxSpace.text,
                    "MinPrice": MinPrice.text,
                    "MaxPrice": MaxPrice.text,
                    "FilterValue": FilterValue,
                  });
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'نوع العقار :',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: "Tajawal-b",
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.grey.shade300, width: 1),
                                          ),
                                          height: 55,
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
                                                    color: Color.fromARGB(255, 73, 75, 82),
                                                  ),
                                                ),
                                                value: 1,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(
                                                  "شقة",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontFamily: "Tajawal-m",
                                                    color: Color.fromARGB(255, 73, 75, 82),
                                                  ),
                                                ),
                                                value: 2,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(
                                                  "ارض",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontFamily: "Tajawal-m",
                                                    color: Color.fromARGB(255, 73, 75, 82),
                                                  ),
                                                ),
                                                value: 3,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(
                                                  "عمارة",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontFamily: "Tajawal-m",
                                                    color: Color.fromARGB(255, 73, 75, 82),
                                                  ),
                                                ),
                                                value: 4,
                                              ),
                                            ],
                                            onChanged: (int? value) {
                                              setState(() {
                                                type = value!;
                                                if (type == 1) type1 = 'فيلا';
                                                if (type == 2) type1 = 'شقة';
                                                if (type == 3) type1 = 'ارض';
                                                if (type == 4) type1 = 'عمارة';
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                type == 3
                                    ? Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(' استخدام العقار: ',
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
                                                  ' رقم الدور: ',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: "Tajawal-b",
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Padding(
                                                        padding: EdgeInsets.only(
                                                          left: 165,
                                                          right: 20,
                                                        ),
                                                        child: Directionality(
                                                          textDirection: TextDirection.rtl,
                                                          child: TextFormField(
                                                            controller: in_floor,
                                                            autovalidateMode:
                                                                AutovalidateMode.onUserInteraction,
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
                                                              if (value!.length > 3) {
                                                                return 'الرقم يجب الا يزيد عن 3 خانات';
                                                              }
                                                              if (value.isNotEmpty &&
                                                                  !RegExp(r'[0-9]')
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
                                      ' المساحة: ',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "Tajawal-b",
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: TextFormField(
                                                controller: MinSpace,
                                                autovalidateMode:
                                                    AutovalidateMode.onUserInteraction,
                                                decoration: InputDecoration(
                                                  hintText: ' الحد الأدنى ',
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
                                                  if (value!.length > 6) {
                                                    return 'الرقم يجب الا يزيد عن 6 خانات';
                                                  }
                                                  if (value.isNotEmpty &&
                                                      !RegExp(r'[0-9]').hasMatch(value)) {
                                                    return 'الرجاء إدخال أرقام فقط';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ))),
                                    Text(' - '),
                                    Expanded(
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: TextFormField(
                                                controller: MaxSpace,
                                                autovalidateMode:
                                                    AutovalidateMode.onUserInteraction,
                                                decoration: InputDecoration(
                                                  hintText: 'الحد الأعلى ',
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
                                                  if (value!.isNotEmpty &&
                                                      !RegExp(r'[0-9]').hasMatch(value)) {
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
                                      ' السعر: ',
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
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: TextFormField(
                                                controller: MinPrice,
                                                autovalidateMode:
                                                    AutovalidateMode.onUserInteraction,
                                                decoration: InputDecoration(
                                                  hintText: 'السعر الأدنى ',
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
                                                  if (value!.isNotEmpty &&
                                                      !RegExp(r'[0-9]').hasMatch(value)) {
                                                    return 'الرجاء إدخال أرقام فقط';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ))),
                                    Text(' - '),
                                    Expanded(
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: TextFormField(
                                                controller: MaxPrice,
                                                autovalidateMode:
                                                    AutovalidateMode.onUserInteraction,
                                                decoration: InputDecoration(
                                                  hintText: 'السعر الأعلى ',
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
                                                  if (value!.isNotEmpty &&
                                                      !RegExp(r'[0-9]').hasMatch(value)) {
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
                                //city
                                Container(
                                  child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Text('المدينة : ',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: "Tajawal-b",
                                              ),
                                              textDirection: TextDirection.rtl),
                                          Container(
                                            margin: const EdgeInsets.all(2),
                                          ),
                                          Padding(padding: const EdgeInsets.all(10.0)),
                                          Container(
                                            padding: EdgeInsets.only(right: 7),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey.shade300, width: 1)),
                                            height: 55,
                                            width: 150,
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
                                      margin: const EdgeInsets.all(7),
                                    ),
                                    Padding(padding: const EdgeInsets.all(10.0)),
                                    Container(
                                      padding: EdgeInsets.only(right: 7),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.grey.shade300, width: 1)),
                                      height: 55,
                                      width: 190,
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
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: "Tajawal-m",
                                            color: Color.fromARGB(255, 73, 75, 82)),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(7),
                                        ),
                                      ),
                                    ),
                                  ],
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
                                            "عمر العقار:",
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: "Tajawal-b",
                                            ),
                                            textDirection: TextDirection.rtl,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                          ),
                                          Container(
                                            height: 70,
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
                                                RangeSlider(
                                                  values: _ageRange,
                                                  max: 100,
                                                  divisions: 100,
                                                  labels: RangeLabels(
                                                    _ageRange.start.round().toString(),
                                                    _ageRange.end.round().toString(),
                                                  ),
                                                  onChanged: (RangeValues values) {
                                                    setState(() {
                                                      _ageRange = values;
                                                    });
                                                  },
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
                                                number_of_rooms == 0
                                                    ? Text("الكل",
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontFamily: "Tajawal-b",
                                                            color:
                                                                Color.fromARGB(255, 157, 157, 157)),
                                                        textDirection: TextDirection.rtl)
                                                    : Text("$number_of_rooms",
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
                                                number_of_bathrooms == 0
                                                    ? Text("الكل",
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontFamily: "Tajawal-b",
                                                            color:
                                                                Color.fromARGB(255, 157, 157, 157)),
                                                        textDirection: TextDirection.rtl)
                                                    : Text("$number_of_bathrooms",
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
                                                number_of_livingRooms == 0
                                                    ? Text("الكل",
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontFamily: "Tajawal-b",
                                                            color:
                                                                Color.fromARGB(255, 157, 157, 157)),
                                                        textDirection: TextDirection.rtl)
                                                    : Text("$number_of_livingRooms",
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
                                                number_of_apartments == 0
                                                    ? Text("الكل",
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontFamily: "Tajawal-b",
                                                            color:
                                                                Color.fromARGB(255, 157, 157, 157)),
                                                        textDirection: TextDirection.rtl)
                                                    : Text("$number_of_apartments",
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
                                                number_of_floors == 0
                                                    ? Text("الكل",
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontFamily: "Tajawal-b",
                                                            color:
                                                                Color.fromARGB(255, 157, 157, 157)),
                                                        textDirection: TextDirection.rtl)
                                                    : Text("$number_of_floors",
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
                                          Text('يوجد مسبح : ',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: "Tajawal-b",
                                              ),
                                              textDirection: TextDirection.rtl),
                                          Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width / 3,
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
                                                width: MediaQuery.of(context).size.width / 4,
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
                                              Container(
                                                width: MediaQuery.of(context).size.width / 3,
                                                child: RadioListTile(
                                                  title: const Text(
                                                    'الكل',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontFamily: "Tajawal-m",
                                                        color: Color.fromARGB(255, 73, 75, 82)),
                                                  ),
                                                  value: choice.all,
                                                  groupValue: _poolCH,
                                                  onChanged: (choice? value) {
                                                    setState(() {
                                                      _poolCH = value;
                                                      if (_poolCH == choice.all) poolAll = true;
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
                                        margin: const EdgeInsets.all(10),
                                      ),
                                type == 1
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                                width: MediaQuery.of(context).size.width / 3,
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
                                                width: MediaQuery.of(context).size.width / 4,
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
                                              Container(
                                                width: MediaQuery.of(context).size.width / 3,
                                                child: RadioListTile(
                                                  title: const Text(
                                                    'الكل',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontFamily: "Tajawal-m",
                                                        color: Color.fromARGB(255, 73, 75, 82)),
                                                  ),
                                                  value: choice.all,
                                                  groupValue: _basementCH,
                                                  onChanged: (choice? value) {
                                                    setState(() {
                                                      _basementCH = value;
                                                      if (_basementCH == choice.all)
                                                        basementAll = true;
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
                                        margin: const EdgeInsets.all(10),
                                      ),
                                type == 3
                                    ? Container()
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                                width: MediaQuery.of(context).size.width / 3,
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
                                                width: MediaQuery.of(context).size.width / 4,
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
                                              Container(
                                                width: MediaQuery.of(context).size.width / 3,
                                                child: RadioListTile(
                                                  title: const Text(
                                                    'الكل',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontFamily: "Tajawal-m",
                                                        color: Color.fromARGB(255, 73, 75, 82)),
                                                  ),
                                                  value: choice.all,
                                                  groupValue: _elevatorCH,
                                                  onChanged: (choice? value) {
                                                    setState(() {
                                                      _elevatorCH = value;
                                                      if (_elevatorCH == choice.all)
                                                        elevatorAll = true;
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
                                        margin: const EdgeInsets.all(15),
                                      ),
                                SizedBox(
                                  width: 205.0,
                                  height: 70.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, {
                                          "type1": type1,
                                          "propertyUse1": propertyUse1,
                                          "in_floor": in_floor.text,
                                          "city": city,
                                          "address": address,
                                          "number_of_bathrooms": number_of_bathrooms,
                                          "number_of_rooms": number_of_rooms,
                                          "number_of_livingRooms": number_of_livingRooms,
                                          "number_of_floors": number_of_floors,
                                          "number_of_apartments": number_of_apartments,
                                          "pool": pool,
                                          "poolAll": poolAll,
                                          "basement": basement,
                                          "basementAll": basementAll,
                                          "elevator": elevator,
                                          "elevatorAll": elevatorAll,
                                          "ageRange_start": _ageRange.start,
                                          "ageRange_end": _ageRange.end,
                                          "MinSpace": MinSpace.text,
                                          "MaxSpace": MaxSpace.text,
                                          "MinPrice": MinPrice.text,
                                          "MaxPrice": MaxPrice.text,
                                          "FilterValue": true,
                                        });
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
                                        'إظهار النتائج',
                                        style: TextStyle(fontSize: 20, fontFamily: "Tajawal-m"),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 205.0,
                                  height: 70.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        print(FilterValue);

                                        if (MinSpace != null) {
                                          MinSpace.clear();
                                        }

                                        if (MaxSpace != null) {
                                          MaxSpace.clear();
                                        }

                                        if (MinPrice != null) {
                                          MinPrice.clear();
                                        }

                                        if (MaxPrice != null) {
                                          MaxPrice.clear();
                                        }

                                        if (in_floor != null) {
                                          in_floor.clear();
                                        }

                                        setState(() {
                                          type = 1;
                                          type1 = 'فيلا';
                                          city = 'الرياض';
                                          _ageRange = RangeValues(0, 100);
                                          number_of_bathrooms = 0;
                                          number_of_apartments = 0;
                                          number_of_rooms = 0;
                                          number_of_livingRooms = 0;
                                          number_of_floors = 0;
                                          _poolCH = choice.no;
                                          _basementCH = choice.no;
                                          _elevatorCH = choice.no;
                                          _AddressKey.currentState?.reset();
                                        });

                                        FilterValue = false;
                                        print(FilterValue);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                            Color.fromARGB(255, 255, 255, 255)),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(horizontal: 40, vertical: 5)),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(27),
                                          ),
                                        ),
                                        side: MaterialStateProperty.all(BorderSide(
                                            color: Colors.blue,
                                            width: 1.0,
                                            style: BorderStyle.solid)),
                                      ),
                                      child: const Text(
                                        'إعادة تعيين',
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 127, 166, 233),
                                            fontSize: 20,
                                            fontFamily: "Tajawal-m"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
