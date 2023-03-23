import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nozol_application/pages/apartment.dart';
import 'package:nozol_application/pages/apartmentdetailes.dart';
import 'package:nozol_application/pages/building.dart';
import 'package:nozol_application/pages/buildingdetailes.dart';
import 'package:nozol_application/pages/homapage.dart';
import 'package:nozol_application/pages/land.dart';
import 'package:nozol_application/pages/landdetailes.dart';
import 'package:nozol_application/pages/navigationbar.dart';
import 'package:nozol_application/pages/property.dart';
import 'package:nozol_application/pages/villa.dart';
import 'package:nozol_application/pages/villadetailes.dart';
import 'package:nozol_application/registration/log_in.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<dynamic> favoriteList = [];
  late String id;

  Future<QuerySnapshot<Map<String, dynamic>>> getFav(String id) {
    Future<QuerySnapshot<Map<String, dynamic>>> snapshot =
        FirebaseFirestore.instance.collection('Standard_user').doc(id).collection('Favorite').get();
    return snapshot;
  }

  void _handleData(QuerySnapshot<Map<String, dynamic>> data) async {
    try {
      favoriteList.clear();

      data.docs.forEach((element) {
        favoriteList.add(element.data()['property_id']);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget _handleListItems(List<dynamic> listItem) {
    return ListView.separated(
        separatorBuilder: (context, index) => SizedBox(width: 20),
        itemCount: favoriteList.length,
        itemBuilder: (context, index) {
          for (int i = 0; i < HomePageState.allData.length; i++) {
            if (HomePageState.allData[i] is Villa) {
              Villa villa = HomePageState.allData[i] as Villa;
              if (villa.properties.property_id == favoriteList[index]) {
                return _buildVillaItem(HomePageState.allData[i] as Villa, context);
              }
            }
            if (HomePageState.allData[i] is Apartment) {
              Apartment apartment = HomePageState.allData[i] as Apartment;
              if (apartment.properties.property_id == favoriteList[index]) {
                return _buildApartmentItem(HomePageState.allData[i] as Apartment, context);
              }
            }
            if (HomePageState.allData[i] is Building) {
              Building building = HomePageState.allData[i] as Building;
              if (building.properties.property_id == favoriteList[index]) {
                return _buildBuildingItem(HomePageState.allData[i] as Building, context);
              }
            }
            if (HomePageState.allData[i] is Land) {
              Land land = HomePageState.allData[i] as Land;
              if (land.properties!.property_id == favoriteList[index]) {
                return _buildLandItem(HomePageState.allData[i] as Land, context);
              }
            }
          }
          return Container();
        });
  }

  Widget _handleSnapshot(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Text("حصل خطأً ما");
    }
    if (!snapshot.hasData) {
      return Center(child: Text("لا يوجد بيانات"));
    }
    if (snapshot.hasData) {
      _handleData(snapshot.data!);
      if (favoriteList.isEmpty) {
        return Center(
            child: Text(
          "لا يوجد عقارات في المفضلة",
          style: TextStyle(fontFamily: "Tajawal-m", fontSize: 17),
        ));
      } else {
        return _handleListItems(favoriteList);
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      id = getuser();
      print(id);
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 127, 166, 233),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 145),
            child: const Text(
              'المفضلة',
              style: TextStyle(
                fontSize: 17,
                fontFamily: "Tajawal-b",
              ),
            ),
          ),
        ),
        body: FirebaseAuth.instance.currentUser == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 85),
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
                      backgroundColor:
                          MaterialStateProperty.all(Color.fromARGB(255, 127, 166, 233)),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                      ),
                    ),
                    child: Text(
                      "تسجيل الدخول",
                      style: TextStyle(fontSize: 20, fontFamily: "Tajawal-m"),
                    ),
                  )
                ],
              )
            : FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: getFav(id),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                ) {
                  print(id);
                  return _handleSnapshot(snapshot);
                },
              ),
      ),
    );
  }

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
            fontWeight: FontWeight.bold,
            fontFamily: "Tajawal-l",
            fontSize: 14,
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
            fontWeight: FontWeight.bold,
            fontFamily: "Tajawal-l",
            fontSize: 14,
          ),
        ),
      ],
    );

    return _buildItem(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VillaDetailes(villa: villa)),
      ).then((_) => setState(() {}));
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
            fontWeight: FontWeight.bold,
            fontSize: 14,
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
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: "Tajawal-l",
          ),
        ),
      ],
    );
    return _buildItem(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ApartmentDetailes(apartment: apartment)),
      ).then((_) => setState(() {}));
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
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: "Tajawal-l",
          ),
        ),
      ],
    );

    return _buildItem(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BuildingDetailes(building: building)),
      ).then((_) => setState(() {}));
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
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: "Tajawal-l",
          ),
        ),
      ],
    );

    return _buildItem(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LandDetailes(land: land)),
      ).then((_) => setState(() {}));
    }, rowItem, land);
  }

  Widget _buildItem(void Function()? onTap, Row rowItem, dynamic type) {
    String id = getuser();
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.fromLTRB(12, 12, 12, 6),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(15),
        )),
        child: Container(
          height: 210,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            icon: (Icon(Icons.favorite)),
                            color: const Color.fromARGB(255, 127, 166, 233),
                            onPressed: () {
                              setState(() {
                                print("favooo");
                                print(type.properties.property_id);
                                FirebaseFirestore.instance
                                    .collection('Standard_user')
                                    .doc(id)
                                    .collection('Favorite')
                                    .doc(type.properties.property_id)
                                    .delete();

                                getFav(id);
                              });
                            }),
                      ),
                    ),
                  ],
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
    );
  }
}

String getuser() {
  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  var cpuid = user!.uid;
  return cpuid;
}
