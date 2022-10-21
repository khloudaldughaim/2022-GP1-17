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


enum SingingCharacter { lafayette, jefferson }

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
  bool isChecked = false;
  bool isChecked2 = false;
  SingingCharacter? _character = SingingCharacter.lafayette;
  String author = '';
  int selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(' عقارك: ',
                                            style: TextStyle(fontSize: 20.0),
                                            textDirection: TextDirection.rtl),
                                        RadioListTile(
                                          title: const Text('للبيع'),
                                          value: SingingCharacter.lafayette,
                                          groupValue: _character,
                                          onChanged: (SingingCharacter? value) {
                                            setState(() {
                                              _character = value;
                                            });
                                          },
                                        ),
                                        RadioListTile(
                                          title: const Text('لللايجار'),
                                          value: SingingCharacter.jefferson,
                                          groupValue: _character,
                                          onChanged: (SingingCharacter? value) {
                                            setState(() {
                                              _character = value;
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
                                                  value: selectedValue,
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
                                                      selectedValue = value!;
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
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      author = val!;
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
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      author = val!;
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
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      author = val!;
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
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      author = val!;
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
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      author = val!;
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
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      author = val!;
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
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      author = val!;
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
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      author = val!;
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
                                        value: SingingCharacter.lafayette,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                      ),
                                      RadioListTile(
                                        title: const Text('لا'),
                                        value: SingingCharacter.jefferson,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
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
                                        value: SingingCharacter.lafayette,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                      ),
                                      RadioListTile(
                                        title: const Text('لا'),
                                        value: SingingCharacter.jefferson,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
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
                                        value: SingingCharacter.lafayette,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                      ),
                                      RadioListTile(
                                        title: const Text('لا'),
                                        value: SingingCharacter.jefferson,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
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
                                          print("Author $author");
                                          FirebaseFirestore.instance
                                              .collection('properties')
                                              .add({'text': author});
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
