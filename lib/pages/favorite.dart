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

class FavoritePage extends StatefulWidget {
   const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {

  // static List<dynamic> favoriteList = HomePageState.allData ;
  static List<dynamic> favoriteList = [] ;

  void initState() {
    super.initState();
    getFav();
  }

  void getFav() async {

    favoriteList.clear();

    var snapshot = await FirebaseFirestore.instance
    .collection('Standard_user')
    .doc(cpuid)
    .collection('Favorite')
    .get();

    if (snapshot.docs.isNotEmpty) {
      // Collection exits
      print("فيه كولكشن فيفورت");
      snapshot.docs.forEach((element) {
        favoriteList.add(element.data()['property_id']);
      });
    }
    else{
      print("ما فيه كولكشن فيفورت");
    }
    setState(() {});
  }

  // Widget DisplayFavorite(List<dynamic> listItem){
  //   return ListView.separated(
  //     itemCount: listItem.length,
  //     separatorBuilder: (BuildContext context, int index) {
  //       return SizedBox(height: 10);
  //     },
  //     itemBuilder: (BuildContext context, int index) {
  //       if (listItem[index] is Villa) {
  //         return _buildVillaItem(listItem[index] as Villa, context);
  //       }
  //       if (listItem[index] is Apartment) {
  //         return _buildApartmentItem(listItem[index] as Apartment, context);
  //       }
  //       if (listItem[index] is Building) {
  //         return _buildBuildingItem(listItem[index] as Building, context);
  //       }
  //       if (listItem[index] is Land) {
  //         return _buildLandItem(listItem[index] as Land, context);
  //       }
  //       return Container();
  //     },
  //   );
  // }

  // void _handleData(QuerySnapshot<Map<String, dynamic>> data) async {
  //   try {
  //     favoriteList.clear();

  //     data.docs.forEach((element) {
  //       if (element.data()["type"] == "فيلا") {
  //         favoriteList.add(Villa.fromMap(element.data()));
  //       }

  //       if (element.data()["type"] == "شقة") {
  //         favoriteList.add(Apartment.fromMap(element.data()));
  //       }

  //       if (element.data()["type"] == "عمارة") {
  //         favoriteList.add(Building.fromMap(element.data()));
  //       }

  //       if (element.data()["type"] == "ارض") {
  //         favoriteList.add(Land.fromJson(element.data()));
  //       }
  //     });
  //     Future.delayed(Duration(seconds: 1), () {
  //       setState(() {});
  //     });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  // Widget _handleSnapshot(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
  //   if (snapshot.connectionState == ConnectionState.waiting) {
  //     return Center(child: CircularProgressIndicator());
  //   }
  //   if (snapshot.hasError) {
  //     return Text("حصل خطأً ما");
  //   }
  //   if (!snapshot.hasData) {
  //     return Text("لا يوجد بيانات");
  //   }
  //   if (snapshot.hasData) {
  //     if (favoriteList.isEmpty) {
  //       _handleData(snapshot.data!);
  //     }
  //     return DisplayFavorite(favoriteList);
  //   }
  //   return Container();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar : AppBar(
          backgroundColor: Color.fromARGB(255, 127, 166, 233),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 155),
          child: const Text('المفضلة',
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Tajawal-b",
              )),
        ),
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: 20.0),
        //     child: GestureDetector(
        //       onTap: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => NavigationBarPage()));
        //       },
        //       child: Icon(
        //         Icons.arrow_forward_ios,
        //         color: Colors.white,
        //         size: 28,
        //       ),
        //     ),
        //   ),
        // ],
        ),
        body: favoriteList.length > 0 ?
        ListView.separated(
          separatorBuilder: (context, index) => SizedBox(width: 20),
          itemCount: favoriteList.length,
          itemBuilder: (context, index) {
            for (int i = 0; i < HomePageState.allData.length; i++) {
              if (HomePageState.allData[i] is Villa) {
                Villa villa = HomePageState.allData[i] as Villa;
                if (villa.properties.property_id == favoriteList[index]) {
                  return _buildVillaItem(
                      HomePageState.allData[i] as Villa, context);
                }
              }
              if (HomePageState.allData[i] is Apartment) {
                Apartment apartment = HomePageState.allData[i] as Apartment;
                if (apartment.properties.property_id == favoriteList[index]) {
                  return _buildApartmentItem(
                      HomePageState.allData[i] as Apartment, context);
                }
              }
              if (HomePageState.allData[i] is Building) {
                Building building = HomePageState.allData[i] as Building;
                if (building.properties.property_id == favoriteList[index]) {
                  return _buildBuildingItem(
                      HomePageState.allData[i] as Building, context);
                }
              }
              if (HomePageState.allData[i] is Land) {
                Land land = HomePageState.allData[i] as Land;
                if (land.properties!.property_id == favoriteList[index]) {
                  return _buildLandItem(
                      HomePageState.allData[i] as Land, context);
                }
              }
            }
            return Container();
          }) :
        Center(
          child:  Text("لا يوجد عقارات في المفضلة"),
        ),
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

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final cpuid = user!.uid;
