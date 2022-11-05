import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nozol_application/pages/building.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nozol_application/pages/land.dart';
import 'package:nozol_application/pages/my-property.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';

class UpdateLand extends StatefulWidget {
  final Land land;

  UpdateLand({required this.land});

  @override
  State<UpdateLand> createState() => _UpdateLandState();
}

enum classification { rent, sale }

enum propertyUse { residental, commercial }

enum choice { yes, no }

LatLng mapLatLng = LatLng(23.88, 45.0792);

class _UpdateLandState extends State<UpdateLand> {
  late String type;
  final _formKey = GlobalKey<FormState>();
  late String property_id;
  classification? _class = classification.rent;
  late String classification1;
  late String city;
  late String? address;
  late String purpose;
  propertyUse? _pUse = propertyUse.residental;

  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedFiles = [];
  List<String> arrImage = [];

  GoogleMapController? googleMapController;
  late TextEditingController spaceController;
  late TextEditingController priceController;
  late TextEditingController neighborhoodController;
  late TextEditingController location;
  late TextEditingController description;

  @override
  void initState() {
    spaceController =
        TextEditingController(text: widget.land.properties!.space);
    priceController =
        TextEditingController(text: widget.land.properties!.price);
    neighborhoodController =
        TextEditingController(text: widget.land.properties!.neighborhood);
    location = TextEditingController(text: widget.land.properties!.Location);
    description =
        TextEditingController(text: widget.land.properties!.description);

    type = '${widget.land.properties!.type}';
    property_id = '${widget.land.properties!.property_id}';
    classification1 = '${widget.land.properties!.classification}';
    city = '${widget.land.properties!.city}';
    address = "";
    purpose = '${widget.land.properties!.purpose}';

    super.initState();
  }

  @override
  void dispose() {
    spaceController.dispose();
    priceController.dispose();
    neighborhoodController.dispose();
    googleMapController?.dispose();
    description.dispose();
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
    Reference reference =
        imageRef.ref().child("propertyImages/$userId/${_image.name}");
    File file = File(_image.path);
    await reference.putFile(file);
    String downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    updateData(List<XFile> fileImages) async {
      for (int i = 0; i < fileImages.length; i++) {
        var imageUrl =
            await uploadFile(fileImages[i], widget.land.properties!.User_id);
        arrImage.add(imageUrl.toString());
      }

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
            'images': arrImage,
            'Location': location.text,
            'description': description.text
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => myProperty()));
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
                      Container(
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
                                          color:
                                              Color.fromARGB(255, 73, 75, 82)),
                                      textAlign: TextAlign.start,
                                    ),
                                    value: propertyUse.residental,
                                    groupValue: _pUse,
                                    onChanged: (propertyUse? value) {
                                      setState(() {
                                        _pUse = value;
                                        if (_pUse == propertyUse.residental)
                                          purpose = 'سكني';
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  child: RadioListTile(
                                    title: const Text(
                                      'تجاري',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: "Tajawal-m",
                                          color:
                                              Color.fromARGB(255, 73, 75, 82)),
                                      textAlign: TextAlign.start,
                                    ),
                                    value: propertyUse.commercial,
                                    groupValue: _pUse,
                                    onChanged: (propertyUse? value) {
                                      setState(() {
                                        _pUse = value;
                                        if (_pUse == propertyUse.commercial)
                                          purpose = 'تجاري';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

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
                              },
                            ),
                          ),
                        ],
                      ),

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
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 60),
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 167, 166, 166),
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
                        height: 10,
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
                          ]),
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
                            ":الصور التي تم رفعها",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF374F67),
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        child: Text(
                                          "لم يتم رفع أي صور",
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              40,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              70,
                                        ),
                                        height: 100,
                                        child: ListView(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          children: arrImage
                                              .map((e) => Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topEnd,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
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
                                                              arrImage
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
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
                        padding: EdgeInsets.symmetric(horizontal: 90),
                        child: ElevatedButton(
                          onPressed: () async {
                            updateData(selectedFiles);
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
                            style: TextStyle(
                                fontSize: 18, fontFamily: "Tajawal-m"),
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
