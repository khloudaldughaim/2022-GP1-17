// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          title: const Text(appTitle),
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
  classification? _class = classification.rent;
  String classification1 = '';
  choice? _poolCH = choice.no;
  choice? _basementCH = choice.no;
  choice? _elevatorCH = choice.no;
  int type = 1;
  String type1 = 'villa';
  String age = '';
  String city = '';
  String address = '';
  String location = '';
  String price = '';
  String space = '';
  String bathNo = '';
  String roomNo = '';
  bool pool = false;
  bool basement = false;
  bool elevator = false;

  @override
  Widget build(BuildContext context) {
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(' عقارك: ',
                                            style: TextStyle(fontSize: 20.0),
                                            textDirection: TextDirection.rtl),
                                        RadioListTile(
                                          title: const Text('للبيع'),
                                          value: classification.sale,
                                          groupValue: _class,
                                          onChanged: (classification? value) {
                                            setState(() {
                                              _class = value;
                                              if (_class == classification.sale)
                                                classification1 = 'sale';
                                            });
                                          },
                                        ),
                                        RadioListTile(
                                          title: const Text('لللايجار'),
                                          value: classification.rent,
                                          groupValue: _class,
                                          onChanged: (classification? value) {
                                            setState(() {
                                              _class = value;
                                              if (_class == classification.rent)
                                                classification1 = 'rent';
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Text('نوع عقارك: ',
                                                style:
                                                    TextStyle(fontSize: 20.0),
                                                textDirection:
                                                    TextDirection.rtl),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0)),
                                            Container(
                                              child: DropdownButton(
                                                  value: type,
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Text("فيلا"),
                                                      value: 1,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text("شقة"),
                                                      value: 2,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text("ارض"),
                                                      value: 3,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text("عمارة"),
                                                      value: 4,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text("استراحة"),
                                                      value: 5,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text("مزرعة"),
                                                      value: 6,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text("مكتب"),
                                                      value: 7,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text("محل تجاري"),
                                                      value: 8,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text("مستودع"),
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
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: '5 سنوات',
                                      labelText: 'عمر العقار',
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
                                    margin: const EdgeInsets.all(15),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'الرياض',
                                      labelText: 'المدينة',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء عدم ترك الخانة فارغة!';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      city = val!;
                                    },
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(15),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'القيروان',
                                      labelText: 'الحي',
                                    ),
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
                                      icon: const Icon(Icons.location_on),
                                      hintText: 'العنوان',
                                      labelText: 'الموقع',
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
                                    margin: const EdgeInsets.all(15),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      icon: const Icon(
                                          Icons.price_change_rounded),
                                      hintText: '1000 ر.س',
                                      labelText: 'السعر',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء عدم ترك الخانة فارغة!';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      price = val!;
                                    },
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(15),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      icon: const Icon(Icons.square_foot),
                                      hintText: '500 م2',
                                      labelText: 'المساحة',
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
                                    margin: const EdgeInsets.all(15),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      icon: const Icon(Icons.bathroom),
                                      hintText: '0',
                                      labelText: 'عدد دورات المياه',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء عدم ترك الخانة فارغة!';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      bathNo = val!;
                                    },
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(15),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      icon: const Icon(Icons.bedroom_parent),
                                      hintText: '0',
                                      labelText: 'عدد الغرف',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء عدم ترك الخانة فارغة!';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      roomNo = val!;
                                    },
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(20),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('يوجد مسبح : ',
                                          style: TextStyle(fontSize: 17.0),
                                          textDirection: TextDirection.rtl),
                                      RadioListTile(
                                        title: const Text('نعم'),
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
                                      RadioListTile(
                                        title: const Text('لا'),
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
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('يوجد قبو : ',
                                          style: TextStyle(fontSize: 17.0),
                                          textDirection: TextDirection.rtl),
                                      RadioListTile(
                                        title: const Text('نعم'),
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
                                      RadioListTile(
                                        title: const Text('لا'),
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
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('يوجد مصعد : ',
                                          style: TextStyle(fontSize: 17.0),
                                          textDirection: TextDirection.rtl),
                                      RadioListTile(
                                        title: const Text('نعم'),
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
                                      RadioListTile(
                                        title: const Text('لا'),
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
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          print(
                                              "classification: $classification1 , type: $type1 , age: $age , city: $city , address: $address , location: $location , price: $price , space: $space , bathNo: $bathNo , roomNo: $roomNo , pool: $pool , basement: $basement , elevator: $elevator  ");
                                          FirebaseFirestore.instance
                                              .collection('properties')
                                              .add({
                                            'classification': classification1,
                                            'type': type1,
                                            'age': age,
                                            'city': city,
                                            'address': address,
                                            'location': location,
                                            'price': price,
                                            'space': space,
                                            'bathNo': bathNo,
                                            'roomNo': roomNo,
                                            'pool': pool,
                                            'basement': basement,
                                            'elevator': elevator
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Processing Data')),
                                          );
                                        }
                                      },
                                      child: const Text('Submit'),
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
