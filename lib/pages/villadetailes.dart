import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nozol_application/Chat/ChatBody.dart';
import 'package:nozol_application/pages/apartment.dart';
import 'package:nozol_application/pages/apartmentdetailes.dart';
import 'package:nozol_application/pages/building.dart';
import 'package:nozol_application/pages/buildingdetailes.dart';
import 'package:nozol_application/pages/complaint.dart';
import 'package:nozol_application/pages/homapage.dart';
import 'package:nozol_application/pages/land.dart';
import 'package:nozol_application/pages/landdetailes.dart';
import 'package:nozol_application/pages/villa.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'bookingPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nozol_application/pages/favorite.dart';

fetchdata(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}

class VillaDetailes extends StatefulWidget {
  final Villa villa;

  VillaDetailes({required this.villa});

  @override
  State<VillaDetailes> createState() => _VillaDetailesState();
}

class _VillaDetailesState extends State<VillaDetailes> {
  GoogleMapController? controller;
  String url = '';
  var data;
  List<dynamic> output = [];
  bool _fav = false;
  late String id;

  void initState() {
    super.initState();
    SimilarPropFunction();
    if (FirebaseAuth.instance.currentUser != null) {
      id = getuser();
      _isFav();
    }
  }

  void SimilarPropFunction() async {
    url =
        'https://recommender-nozol.herokuapp.com/api?query=' + widget.villa.properties.property_id;
    data = await fetchdata(url);
    var decoded = jsonDecode(data);
    output = decoded;
    //output = ["001ac7c1-67b1-4ac3-bbf4-6db8baf2e6cc", "001ac7c1-67b1-4ac3-bbf4-6db8baf2e6cc" ,"001ac7c1-67b1-4ac3-bbf4-6db8baf2e6cc"];
    setState(() {});
  }

  void _toggleFavorite() {
    if (FirebaseAuth.instance.currentUser == null) {
      Fluttertoast.showToast(
        msg: "عذرا لابد من تسجيل الدخول",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Color.fromARGB(255, 127, 166, 233),
        textColor: Color.fromARGB(255, 252, 253, 255),
        fontSize: 18.0,
      );
    } else if (FirebaseAuth.instance.currentUser!.uid == '${widget.villa.properties.User_id}') {
      Fluttertoast.showToast(
        msg: "أنت صاحب العقار بالفعل!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Color.fromARGB(255, 127, 166, 233),
        textColor: Color.fromARGB(255, 252, 253, 255),
        fontSize: 18.0,
      );
    } else if (_fav) {
      _fav = false;
      // FavoritePageState.favoriteList.remove(widget.villa);
      FirebaseFirestore.instance
          .collection('Standard_user')
          .doc(id)
          .collection('Favorite')
          .doc(widget.villa.properties.property_id)
          .delete();
    } else {
      _fav = true;
      // FavoritePageState.favoriteList.add(widget.villa);
      FirebaseFirestore.instance
          .collection('Standard_user')
          .doc(id)
          .collection('Favorite')
          .doc(widget.villa.properties.property_id)
          .set({
        "property_id": widget.villa.properties.property_id,
      });
      // FirebaseFirestore.instance
      // .collection('Standard_user')
      // .doc(cpuid)
      // .update({
      //   "FavoriteList": FieldValue.arrayUnion([widget.villa.properties.property_id])
      // });
    }
    setState(() {});
  }

  void _isFav() async {
    var doc = await FirebaseFirestore.instance
        .collection('Standard_user')
        .doc(id)
        .collection('Favorite')
        .doc(widget.villa.properties.property_id)
        .get();

    if (doc.exists) {
      // doc exits
      print("موجوده ونص");
      _fav = true;
    } else {
      // doc not exits
      print("مش موجوده");
      _fav = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String ThereIsPool;
    bool pool = widget.villa.pool;
    LatLng mapLatLng = LatLng(widget.villa.properties.latitude, widget.villa.properties.longitude);

    if (pool == true) {
      ThereIsPool = 'نعم';
    } else {
      ThereIsPool = 'لا';
    }

    String ThereIsElevator;
    bool elevator = widget.villa.elevator;

    if (elevator == true) {
      ThereIsElevator = 'نعم';
    } else {
      ThereIsElevator = 'لا';
    }

    String ThereIsBasement;
    bool besement = widget.villa.basement;

    if (besement == true) {
      ThereIsBasement = 'نعم';
    } else {
      ThereIsBasement = 'لا';
    }

    String Classification;
    String classification = widget.villa.properties.classification;

    if (classification == 'للإيجار') {
      Classification = 'للإيجار';
    } else {
      Classification = 'للبيع';
    }

    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Hero(
              tag: '${widget.villa.properties.images.length}' == '0'
                  ? 'https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg'
                  : widget.villa.properties.images[0], //'${villa.images[0]}'
              child: Container(
                height: size.height * 0.5,
                decoration: '${widget.villa.properties.images.length}' == '0'
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg'), //'${villa.images[0]}'
                          fit: BoxFit.cover,
                        ),
                      )
                    : BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              '${widget.villa.properties.images[0]}'), //'${villa.images[0]}'
                          fit: BoxFit.cover,
                        ),
                      ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.4, 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: size.height * 0.45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 226, 237, 255),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.flag_outlined,
                                    color: const Color.fromARGB(255, 127, 166, 233),
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    if (FirebaseAuth.instance.currentUser == null) {
                                      Fluttertoast.showToast(
                                        msg: "عذرا لابد من تسجيل الدخول",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Color.fromARGB(255, 127, 166, 233),
                                        textColor: Color.fromARGB(255, 252, 253, 255),
                                        fontSize: 18.0,
                                      );
                                    } else if (FirebaseAuth.instance.currentUser!.uid ==
                                        '${widget.villa.properties.User_id}') {
                                      Fluttertoast.showToast(
                                        msg: "أنت صاحب العقار بالفعل!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Color.fromARGB(255, 127, 166, 233),
                                        textColor: Color.fromARGB(255, 252, 253, 255),
                                        fontSize: 18.0,
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Complaints(
                                                  property_id: widget.villa.properties.property_id,
                                                  user_id: widget.villa.properties.User_id,
                                                  type: widget.villa.properties.type,
                                                  city: widget.villa.properties.city,
                                                  neighborhood:
                                                      widget.villa.properties.neighborhood,
                                                )),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 226, 237, 255),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: IconButton(
                                  alignment: Alignment.center,
                                  icon: (_fav ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
                                  color: const Color.fromARGB(255, 127, 166, 233),
                                  onPressed: _toggleFavorite,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 226, 237, 255),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: const Color.fromARGB(255, 127, 166, 233),
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Container(
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
                      width: 80,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Center(
                        child: Text(
                          '${widget.villa.properties.type} ${Classification}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal-m",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.villa.properties.type}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal-m",
                          ),
                        ),
                        '${widget.villa.properties.classification}' == "للإيجار" ?
                        Text(
                          'ريال شهريا ${widget.villa.properties.price}',
                          style: TextStyle(
                            height: 2,
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal-m",
                          ),
                        ):
                        Text(
                          'ريال ${widget.villa.properties.price}',
                          style: TextStyle(
                            height: 2,
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal-m",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${widget.villa.properties.neighborhood} ، ${widget.villa.properties.city}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Tajawal-m",
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.hotel,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              '${widget.villa.number_of_room}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Tajawal-m",
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.bathtub,
                              color: Colors.white,
                              size: 17,
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Text(
                              '${widget.villa.number_of_bathroom}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Tajawal-m",
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.square_foot,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              '${widget.villa.properties.space} متر ² ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Tajawal-m",
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 127, 166, 233).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: IconButton(
                                        // Here the Massage button
                                        icon: Icon(
                                          Icons.message,
                                          color: Color.fromARGB(255, 127, 166, 233),
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          if (FirebaseAuth.instance.currentUser == null) {
                                            Fluttertoast.showToast(
                                              msg: "عذرا لابد من تسجيل الدخول",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor: Color.fromARGB(255, 127, 166, 233),
                                              textColor: Color.fromARGB(255, 252, 253, 255),
                                              fontSize: 18.0,
                                            );
                                          } else if (FirebaseAuth.instance.currentUser!.uid ==
                                              '${widget.villa.properties.User_id}') {
                                            Fluttertoast.showToast(
                                              msg: "أنت صاحب العقار بالفعل!",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor: Color.fromARGB(255, 127, 166, 233),
                                              textColor: Color.fromARGB(255, 252, 253, 255),
                                              fontSize: 18.0,
                                            );
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ChatBody(
                                                          Freind_id:
                                                              '${widget.villa.properties.User_id}',
                                                        )));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('Standard_user')
                                        .doc('${widget.villa.properties.User_id}')
                                        .get(),
                                    builder: ((context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        Map<String, dynamic> user =
                                            snapshot.data!.data() as Map<String, dynamic>;
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${user['name']}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Tajawal-m",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              '${user['phoneNumber']}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Tajawal-m",
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return Center(child: Text(''));
                                    }),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    height: 65,
                                    width: 65,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://t4.ftcdn.net/jpg/04/10/43/77/360_F_410437733_hdq4Q3QOH9uwh0mcqAhRFzOKfrCR24Ta.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 24, left: 24, bottom: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                PropInfo(
                                    Icons.chair, '${widget.villa.number_of_livingRooms}', 'صالة'),
                                PropInfo(Icons.elevator, '${ThereIsElevator}', 'مصعد'),
                                PropInfo(Icons.pool, '${ThereIsPool}', 'مسبح'),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 265, bottom: 16),
                          child: Text(
                            "تفاصيل أكثر",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Tajawal-m",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, left: 27, bottom: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${widget.villa.property_age} سنة',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Tajawal-l",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    ': عمر العقار',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Tajawal-l",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${ThereIsBasement}',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Tajawal-l",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    ': يوجد قبو',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Tajawal-l",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${widget.villa.number_of_floor}',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Tajawal-l",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    ': عدد الأدوار',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Tajawal-l",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 225, bottom: 16),
                          child: Text(
                            "معلومات إضافية",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Tajawal-m",
                            ),
                          ),
                        ),
                        '${widget.villa.properties.description}' == ''
                            ? Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 20, bottom: 24, right: 20),
                                    child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          'لا يوجد معلومات إضافية !',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Tajawal-l",
                                          ),
                                        ))),
                              )
                            : Container(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 33, left: 5, bottom: 16),
                                  child: Text(
                                    '${widget.villa.properties.description}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Tajawal-l",
                                    ),
                                  ),
                                ),
                              ),
                        Padding(
                          padding: EdgeInsets.only(right: 15, left: 310, bottom: 16),
                          child: Text(
                            "الصور",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Tajawal-m",
                            ),
                          ),
                        ),
                        '${widget.villa.properties.images.length}' == '0'
                            ? Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 20, bottom: 24, right: 20),
                                    child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          'لا يوجد صور متاحة !',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Tajawal-l",
                                          ),
                                        ))),
                              )
                            : Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  height: 200,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20, bottom: 24, right: 20),
                                    child: ListView.separated(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      // shrinkWrap: true,
                                      separatorBuilder: (context, index) => SizedBox(width: 20),
                                      itemCount: widget.villa.properties.images.length,
                                      itemBuilder: (context, index) => InkWell(
                                        onTap: () =>
                                            openGallery(widget.villa.properties.images, context),
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          widget.villa.properties.images[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 25, bottom: 16),
                              child: Text(
                                'الموقع',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Tajawal-m",
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 33, left: 5, bottom: 16),
                              child: Text(
                                '${widget.villa.properties.Location}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Tajawal-l",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 200.0,
                              width: 370,
                              child: Stack(
                                children: [
                                  Padding(
                                    //location
                                    padding: EdgeInsets.only(right: 10),
                                    child: GoogleMap(
                                      onMapCreated: (mapController) {
                                        controller = mapController;
                                      },
                                      myLocationButtonEnabled: true,
                                      myLocationEnabled: true,
                                      initialCameraPosition:
                                          CameraPosition(target: mapLatLng, zoom: 14),
                                      markers: {
                                        Marker(
                                            markerId: const MarkerId("marker1"),
                                            icon: BitmapDescriptor.defaultMarker,
                                            visible: true,
                                            position: mapLatLng)
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30, width: 30),
                            Padding(
                              padding: EdgeInsets.only(right: 20, left: 85, bottom: 16),
                              child: Text(
                                "الوقت المفضل للجولات العقارية",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Tajawal-m",
                                ),
                              ),
                            ),
                            '${widget.villa.properties.TourTime}' == ''
                                ? Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 20, bottom: 24, right: 20),
                                        child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text(
                                              'لا يفضل المالك وقت محدد للجولات العقارية !',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Tajawal-l",
                                              ),
                                            ))),
                                  )
                                : Container(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 33, left: 5, bottom: 16),
                                      child: Text(
                                        '${widget.villa.properties.TourTime}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Tajawal-l",
                                        ),
                                      ),
                                    ),
                                  ),
                            Container(
                              margin: const EdgeInsets.only(left: 90, right: 90, bottom: 25),
                              child: ElevatedButton(
                                child: Center(
                                    child: Text(
                                  "حجز جولة عقارية",
                                  style: TextStyle(fontSize: 18, fontFamily: "Tajawal-m"),
                                )),
                                onPressed: () {
                                  if (FirebaseAuth.instance.currentUser == null) {
                                    Fluttertoast.showToast(
                                      msg: "عذرا لابد من تسجيل الدخول",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: Color.fromARGB(255, 127, 166, 233),
                                      textColor: Color.fromARGB(255, 252, 253, 255),
                                      fontSize: 18.0,
                                    );
                                  } else if (FirebaseAuth.instance.currentUser!.uid ==
                                      '${widget.villa.properties.User_id}') {
                                    Fluttertoast.showToast(
                                      msg: "أنت صاحب العقار بالفعل!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: Color.fromARGB(255, 127, 166, 233),
                                      textColor: Color.fromARGB(255, 252, 253, 255),
                                      fontSize: 18.0,
                                    );
                                  } else if ('${widget.villa.properties.images.length}' == '0') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => boookingPage(
                                                property_id:
                                                    '${widget.villa.properties.property_id}',
                                                user_id: '${widget.villa.properties.User_id}',
                                                Pimge:
                                                    'https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg')));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => boookingPage(
                                                property_id:
                                                    '${widget.villa.properties.property_id}',
                                                user_id: '${widget.villa.properties.User_id}',
                                                Pimge: '${widget.villa.properties.images[0]}')));
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Color.fromARGB(255, 127, 166, 233)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(27))),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 235, bottom: 16),
                          child: Text(
                            "عقارات مشابهة",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Tajawal-m",
                            ),
                          ),
                        ),
                        output.length != 0
                            ? Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  height: 210,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20, bottom: 24, right: 20),
                                    child: ListView.separated(
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        // shrinkWrap: true,
                                        separatorBuilder: (context, index) => SizedBox(width: 20),
                                        itemCount: output.length,
                                        itemBuilder: (context, index) {
                                          for (int i = 0; i < HomePageState.allData.length; i++) {
                                            if (HomePageState.allData[i] is Villa) {
                                              Villa villa = HomePageState.allData[i] as Villa;
                                              if (villa.properties.property_id == output[index]) {
                                                return _buildVillaItem(
                                                    HomePageState.allData[i] as Villa, context);
                                              }
                                            }
                                            if (HomePageState.allData[i] is Apartment) {
                                              Apartment apartment =
                                                  HomePageState.allData[i] as Apartment;
                                              if (apartment.properties.property_id ==
                                                  output[index]) {
                                                return _buildApartmentItem(
                                                    HomePageState.allData[i] as Apartment, context);
                                              }
                                            }
                                            if (HomePageState.allData[i] is Building) {
                                              Building building =
                                                  HomePageState.allData[i] as Building;
                                              if (building.properties.property_id ==
                                                  output[index]) {
                                                return _buildBuildingItem(
                                                    HomePageState.allData[i] as Building, context);
                                              }
                                            }
                                            if (HomePageState.allData[i] is Land) {
                                              Land land = HomePageState.allData[i] as Land;
                                              if (land.properties!.property_id == output[index]) {
                                                return _buildLandItem(
                                                    HomePageState.allData[i] as Land, context);
                                              }
                                            }
                                          }
                                          return Container();
                                        }),
                                  ),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.only(left: 70, bottom: 20),
                                child: Text(
                                  '! لا يوجد لدينا حالياً عقارات مشابهة',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: "Tajawal-b",
                                      color: Color.fromARGB(255, 139, 139, 139)),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget PropInfo(IconData iconData, String text, String label) {
  return Column(
    children: [
      Icon(
        iconData,
        color: Color.fromARGB(255, 127, 166, 233),
        size: 28,
      ),
      SizedBox(
        height: 2,
      ),
      Text(
        label,
        style: TextStyle(
          color: Color.fromARGB(255, 127, 166, 233),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: "Tajawal-l",
        ),
      ),
      SizedBox(
        height: 8,
      ),
      Text(
        text,
        style: TextStyle(
          color: Colors.grey[500],
          fontWeight: FontWeight.bold,
          fontFamily: "Tajawal-l",
          fontSize: 14,
        ),
      ),
    ],
  );
}

openGallery(List images, BuildContext context) => Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => GalleryWidget(
        images: images,
      ),
    ));

class GalleryWidget extends StatefulWidget {
  final List<dynamic> images;

  GalleryWidget({
    required this.images,
  });

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
        body: PhotoViewGallery.builder(
          itemCount: widget.images.length,
          builder: (context, index) {
            final image = widget.images[index];

            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(image),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 4,
            );
          },
        ),
      ),
    );
  }
}

///////////////////////homepagecode//////////////////////
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
    child: Card(
      margin: EdgeInsets.fromLTRB(12, 12, 12, 6),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(15),
      )),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          height: 210,
          width: 260,
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
                        '${type.properties.classification}' == 'للإيجار' ?
                        Text(
                          'ريال شهريا ${type.properties.price}',
                          style: TextStyle(
                            height: 2,
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal-l",
                          ),
                        ):
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
