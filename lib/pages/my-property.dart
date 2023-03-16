import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/pages/profile.dart';
import 'package:nozol_application/pages/property.dart';
import 'package:nozol_application/pages/userapartmentdetailes.dart';
import 'package:nozol_application/pages/userbuildingdetailes.dart';
import 'package:nozol_application/pages/userlanddetailes.dart';
import 'package:nozol_application/pages/uservilladetailes.dart';
import 'package:nozol_application/pages/villa.dart';
import 'apartment.dart';
import 'building.dart';
import 'homapage.dart';
import 'land.dart';
import 'navigationbar.dart';

class myProperty extends StatefulWidget {
  const myProperty({super.key});

  @override
  State<myProperty> createState() => _myPropertyState();
}

class _myPropertyState extends State<myProperty> {
  List<dynamic> userData = [];

  void _handleData(QuerySnapshot<Map<String, dynamic>> data) async {
    try {
      userData.clear();

      data.docs.forEach((element) {
        if (element.data()["type"] == "فيلا") {
          userData.add(Villa.fromMap(element.data()));
        }

        if (element.data()["type"] == "شقة") {
          userData.add(Apartment.fromMap(element.data()));
        }

        if (element.data()["type"] == "عمارة") {
          userData.add(Building.fromMap(element.data()));
        }

        if (element.data()["type"] == "ارض") {
          userData.add(Land.fromJson(element.data()));
        }
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {});
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget _handleListItems(List<dynamic> listItem) {
    return ListView.separated(
      itemCount: listItem.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10);
      },
      itemBuilder: (BuildContext context, int index) {
        if (listItem[index] is Villa) {
          return _buildVillaItem(listItem[index] as Villa, context);
        }
        if (listItem[index] is Apartment) {
          return _buildApartmentItem(listItem[index] as Apartment, context);
        }
        if (listItem[index] is Building) {
          return _buildBuildingItem(listItem[index] as Building, context);
        }
        if (listItem[index] is Land) {
          return _buildLandItem(listItem[index] as Land, context);
        }
        return Container();
      },
    );
  }

  Widget _handleSnapshot(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Text("حصل خطأً ما");
    }
    if (!snapshot.hasData) {
      return Text("لا يوجد بيانات");
    }
    if (snapshot.hasData) {
      if (userData.isEmpty) {
        _handleData(snapshot.data!);
      }
      return _handleListItems(userData);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    String id = getuser();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 127, 166, 233),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 155),
          child: const Text('عقاراتي',
              style: TextStyle(
                fontSize: 17,
                fontFamily: "Tajawal-b",
              )),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => NavigationBarPage()));
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
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('properties')
            .where('User_id', isEqualTo: id)
            .get(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          print(id);
          return _handleSnapshot(snapshot);
        },
      ),
    );
  }
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
  );
}

String getuser() {
  late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  var cpuid = user!.uid;
  return cpuid;
}


// Stream<List<Property>> readmyPropertys() => FirebaseFirestore.instance
//     .collection('properties')
//     .where('user_id', isEqualTo: nuid)
//     .snapshots()
//     .map((snapshot) =>
//         snapshot.docs.map((doc) => Property.fromJson(doc.data())).toList());
