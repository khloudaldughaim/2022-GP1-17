import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/pages/navigationbar.dart';
import 'package:nozol_application/pages/villa.dart';
import '../registration/log_in.dart';
import 'apartment.dart';
import 'apartmentdetailes.dart';
import 'building.dart';
import 'buildingdetailes.dart';
import 'filter.dart';
import 'land.dart';
import 'landdetailes.dart';
import 'villadetailes.dart';
import 'mapPage.dart';
import 'filterfunction.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static int indexOfTap = 0;
  static List<dynamic> allData = [];
  static List<dynamic> searchItems = [];
  static List<dynamic> searchItemsForRent = [];
  static List<dynamic> searchItemsForSale = [];
  static List<dynamic> forRent = [];
  static List<dynamic> forSale = [];
  static List<dynamic> FilteredItems = [];
  static List<dynamic> FilterForRent = [];
  static List<dynamic> FilterForSale = [];
  TextEditingController controller = TextEditingController();
  static String name = '';
  static bool FilterValue = false;
  static bool ForRentValue = false;
  bool isMap = false;
  static String? type1;
  static String? propertyUse1;
  static String? in_floor;
  static String? city;
  static String? address;
  static int? number_of_bathrooms;
  static int? number_of_rooms;
  static int? number_of_livingRooms;
  static int? number_of_floors;
  static int? number_of_apartments;
  static bool? pool;
  static bool?  basement;
  static bool?  elevator;
  static bool?  poolAll;
  static bool?  basementAll;
  static bool?  elevatorAll;
  static double? ageRange_start;
  static double? ageRange_end;
  static String? MinSpace;
  static String? MaxSpace;
  static String? MinPrice;
  static String? MaxPrice;
  static bool isDownloadedData = false ;

////////////////////////////////////////////////////////////
 void initState() {
    super.initState();
    // Notifications step 3 
    requestPremission();
    getToken();
     // end of Notifications step 3
  }

late FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String curentId = user!.uid;
 
void requestPremission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
      print("User granted premission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
      print("User granted provisional permission");
    } else {
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
      print("User declined or has not accepted premission");
    }
  }

  String? mtoken = " ";

  void getToken() async {
  
       await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      saveToken(token!);
    });
     
     
  }

  void saveToken(String token) async {
    if (FirebaseAuth.instance.currentUser == null)
    {
      print("this is guset user ;) ");
    }
    else
    {
 await FirebaseFirestore.instance
        .collection("Standard_user")
        .doc(curentId)
        .update({'token': token});
    }
   
  }
///////////////////////////////////////////////////////////////////

  void _handleData(QuerySnapshot<Map<String, dynamic>> data) async {
    try {
      allData.clear();
      forRent.clear();
      forSale.clear();
      data.docs.forEach((element) {
        if (element.data()["type"] == "فيلا") {
          Villa villa = Villa.fromMap(element.data());
          allData.add(villa);
          handleRentAndSaleItems(villa);
          // if (element.data()["classification"] == "للإيجار") {
          //   forSale.add(Villa.fromMap(element.data()));
          // } else {
          //   forRent.add(Villa.fromMap(element.data()));
          // }
        }
        if (element.data()["type"] == "شقة") {
          Apartment apartment = Apartment.fromMap(element.data());
          allData.add(apartment);
          handleRentAndSaleItems(apartment);
          // if (element.data()["classification"] == "للإيجار") {
          //   forSale.add(Apartment.fromMap(element.data()));
          // } else {
          //   forRent.add(Apartment.fromMap(element.data()));
          // }
        }

        if (element.data()["type"] == "عمارة") {
          Building building = Building.fromMap(element.data());
          allData.add(building);
          handleRentAndSaleItems(building);

          // if (element.data()["classification"] == "للإيجار") {
          //   forSale.add(Building.fromMap(element.data()));
          // } else {
          //   forRent.add(Building.fromMap(element.data()));
          // }
        }

        if (element.data()["type"] == "ارض") {
          Land land = Land.fromJson(element.data());
          allData.add(land);
          handleRentAndSaleItems(land);
          // if (element.data()["classification"] == "للإيجار") {
          //   forSale.add(Land.fromJson(element.data()));
          // } else {
          //   forRent.add(Land.fromJson(element.data()));
          // }
        }
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {});
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Widget handleListItems(List<dynamic> listItem) {
    // if (name.isEmpty) {
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
      if (allData.isEmpty || !isDownloadedData) {
        isDownloadedData = true;
        _handleData(snapshot.data!);
      }
      return handleListItems(allData);
    }
    return Container();
  }

  //! NEW FUNCTIONS

  void changeHomeView() {
    setState(() {
      if (isMap) {
        isMap = false;
      } else {
        isMap = true;
      }
    });
  }

  static handleRentAndSaleItems(dynamic item) {
    if (name.isEmpty && FilterValue == false) {
      if (item.properties.classification != "للإيجار") {
        forRent.add(item);
      } else {
        forSale.add(item);
      }
    } else if (name.isEmpty && FilterValue == true) {
      if (item.properties.classification != "للإيجار") {
        FilterForRent.add(item);
      } else {
        FilterForSale.add(item);
      }
    } else if (name.isNotEmpty && FilterValue == true) {
      if (item.properties.classification != "للإيجار") {
        FilterForRent.add(item);
      } else {
        FilterForSale.add(item);
      }
    } else {
      if (item.properties.classification != "للإيجار") {
        searchItemsForRent.add(item);
      } else {
        searchItemsForSale.add(item);
      }
    }
  }

  _handleSearchItems(List<dynamic> listItem) {
    searchItems.clear();
    searchItemsForRent.clear();
    searchItemsForSale.clear();

    listItem.forEach((element) {
      if (element is Villa) {
        final villa = element;
        if (villa.properties.city.toString().toLowerCase().startsWith(name.toLowerCase()) ||
            villa.properties.type.toString().toLowerCase().startsWith(name.toLowerCase()) ||
            villa.properties.neighborhood.toString().toLowerCase().startsWith(name.toLowerCase())) {
          searchItems.add(villa);
          handleRentAndSaleItems(villa);
        }
      }
      if (element is Apartment) {
        final apartment = element;
        if (apartment.properties.city.toLowerCase().startsWith(name.toLowerCase()) ||
            apartment.properties.type.toLowerCase().startsWith(name.toLowerCase()) ||
            apartment.properties.neighborhood
                .toString()
                .toLowerCase()
                .startsWith(name.toLowerCase())) {
          searchItems.add(apartment);
          handleRentAndSaleItems(apartment);
        }
      }
      if (element is Building) {
        final building = element;
        if (building.properties.city.toLowerCase().startsWith(name.toLowerCase()) ||
            building.properties.type.toLowerCase().startsWith(name.toLowerCase()) ||
            building.properties.neighborhood
                .toString()
                .toLowerCase()
                .startsWith(name.toLowerCase())) {
          searchItems.add(building);
          handleRentAndSaleItems(building);
        }
      }

      if (element is Land) {
        final land = element;
        if (land.properties!.city.toString().toLowerCase().startsWith(name.toLowerCase()) ||
            land.properties!.type.toString().toLowerCase().startsWith(name.toLowerCase()) ||
            land.properties!.neighborhood.toString().toLowerCase().startsWith(name.toLowerCase())) {
          searchItems.add(land);
          handleRentAndSaleItems(land);
        }
      }
    });
  }

  Widget _buildSearchItems() {
    // if(name.isNotEmpty && FilterValue == true){
    //   _handleSearchItems(FilteredItems);
    // }else{
    //   _handleSearchItems(allData);
    // }
    // if (searchItems.isEmpty)
    //   return Center(child: Text("لم يتم العثور على نتائج"));
    // return _handleListItems(searchItems);

    _handleSearchItems(allData);
    if (searchItems.isEmpty) return Center(child: Text("لم يتم العثور على نتائج"));
    return handleListItems(searchItems);
  }

  @override
  Widget build(BuildContext context) {
    return isMap
      ? mapPage(
          onPressed: () {
            changeHomeView();
          },
        )
      : SafeArea(
      top: true,
      child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                child: AppBar(
                  backgroundColor: Color.fromARGB(255, 127, 166, 233),
                  leading: IconButton(
                    onPressed: () async {
                      //print(allData);
                      print("type1 $type1");
                      print("propertyUse1 $propertyUse1");
                      print("in_floor $in_floor");
                      print("city $city");
                      print("address $address");
                      print("number_of_bathrooms $number_of_bathrooms");
                      print("number_of_rooms $number_of_rooms"); //
                      print("number_of_livingRooms $number_of_livingRooms");
                      print("number_of_floors $number_of_floors"); //
                      print("number_of_apartments $number_of_apartments"); //
                      print("pool $pool");
                      print("basement $basement"); //
                      print("elevator $elevator");
                      print("ageRange_start $ageRange_start");
                      print("ageRange_end $ageRange_end");

                      if (MinSpace == null) {
                        print('MinSpace empty');
                      } else {
                        print(MinSpace);
                      }

                      if (MaxSpace == null) {
                        print('MaxSpace empty');
                      } else {
                        print(MaxSpace);
                      }

                      if (MinPrice == null) {
                        print('MinPrice empty');
                      } else {
                        print(MinPrice);
                      }

                      if (MaxPrice == null) {
                        print('MaxPrice empty');
                      } else {
                        print(MaxPrice);
                      }
                      //FilterValue = true;
                      final FilterResult = await Navigator.push(
                          context, MaterialPageRoute(builder: (context) => FilterPage()));
                      setState(() {
                        type1 = FilterResult["type1"];
                        propertyUse1 = FilterResult["propertyUse1"];
                        in_floor = FilterResult["in_floor"];
                        city = FilterResult["city"];
                        address = FilterResult["address"];
                        number_of_bathrooms = FilterResult["number_of_bathrooms"];
                        number_of_floors = FilterResult["number_of_floors"];
                        number_of_livingRooms = FilterResult["number_of_livingRooms"];
                        number_of_rooms = FilterResult["number_of_rooms"];
                        number_of_apartments = FilterResult["number_of_apartments"];
                        basement = FilterResult["basement"];
                        basementAll = FilterResult["basementAll"];
                        elevator = FilterResult["elevator"];
                        elevatorAll = FilterResult["elevatorAll"];
                        pool = FilterResult["pool"];
                        poolAll = FilterResult["poolAll"];
                        ageRange_start = FilterResult["ageRange_start"];
                        ageRange_end = FilterResult["ageRange_end"];
                        MinPrice = FilterResult["MinPrice"];
                        MaxPrice = FilterResult["MaxPrice"];
                        MinSpace = FilterResult["MinSpace"];
                        MaxSpace = FilterResult["MaxSpace"];
                        FilterValue = FilterResult["FilterValue"];
                        print(FilterResult);
                      });
                    },
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.right,
                          controller: controller,
                          onChanged: (value) {
                            setState(() {
                              // searchItemsForSale.clear();
                              // searchItemsForRent.clear();
                              name = value;
                            });
                          },
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromARGB(255, 14, 41, 99))),
                            enabledBorder:
                                UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            alignLabelWithHint: true,
                            hintText: 'ابحث عن الحي أو المدينة أو نوع العقار',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(143, 255, 255, 255), fontFamily: "Tajawal-m"),
                          ),
                          cursorColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  bottom: TabBar(
                    labelStyle: TextStyle(
                      fontFamily: "Tajawal-b",
                      fontWeight: FontWeight.w100,
                    ),
                    onTap: (index) {
                      print("Index of tap is : $index");
                      indexOfTap = index;
                    },
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                        text: 'الكل',
                      ),
                      Tab(
                        text: 'للبيع',
                      ),
                      Tab(
                        text: 'للإيجار',
                      ),
                    ],
                  ),
                ),
              ),
              // isMap
              //     ? Expanded(
              //         child: mapPage(
              //           onPressed: () {
              //             changeHomeView();
              //           },
              //         ),
              //       )
              //     : 
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          TabBarView(
                            children: [
                              name.isEmpty && FilterValue == false
                                  ? FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                      future:
                                          FirebaseFirestore.instance.collection('properties').get(),
                                      builder: (
                                        BuildContext context,
                                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                                      ) {
                                        print('1');
                                        return _handleSnapshot(snapshot);
                                      },
                                    )
                                  : name.isEmpty && FilterValue == true
                                      ? FilterFunctionState.buildFilterItems() 
                                      : name.isNotEmpty && FilterValue == true
                                          ? FilterFunctionState.buildFilterItems()
                                          : _buildSearchItems(),
                              name.isEmpty && FilterValue == false
                                  ? handleListItems(forRent)
                                  : name.isEmpty && FilterValue == true
                                      ? FilterForRent.isEmpty
                                          ? Center(child: Text("لم يتم العثور على نتائج"))
                                          : handleListItems(FilterForRent)
                                      : name.isNotEmpty && FilterValue == true
                                          ? FilterForRent.isEmpty
                                              ? Center(child: Text("لم يتم العثور على نتائج"))
                                              : handleListItems(FilterForRent)
                                          : searchItemsForRent.isEmpty
                                              ? Center(child: Text("لم يتم العثور على نتائج"))
                                              : handleListItems(searchItemsForRent),
                              name.isEmpty && FilterValue == false
                                  ? handleListItems(forSale)
                                  : name.isEmpty && FilterValue == true
                                      ? FilterForSale.isEmpty
                                          ? Center(child: Text("لم يتم العثور على نتائج"))
                                          : handleListItems(FilterForSale)
                                      : name.isNotEmpty && FilterValue == true
                                          ? FilterForSale.isEmpty
                                              ? Center(child: Text("لم يتم العثور على نتائج"))
                                              : handleListItems(FilterForSale)
                                          : searchItemsForSale.isEmpty
                                              ? Center(child: Text("لم يتم العثور على نتائج"))
                                              : handleListItems(searchItemsForSale),

                              // name.isEmpty && FilterValue == false
                              //     ? handleListItems(forRent)
                              //     : name.isNotEmpty && FilterValue == false
                              //         ? searchItemsForRent.isEmpty
                              //             ? Center(
                              //                 child: Text(
                              //                     "لم يتم العثور على نتائج"))
                              //             : handleListItems(searchItemsForRent)
                              //         : name.isEmpty && FilterValue == true
                              //             ? FilterForRent.isEmpty
                              //                 ? Center(
                              //                     child: Text(
                              //                         "لم يتم العثور على نتائج"))
                              //                 : handleListItems(FilterForRent)
                              //             : FilterForRent.isEmpty
                              //             ? Center(
                              //                 child: Text(
                              //                     "لم يتم العثور على نتائج"))
                              //             : handleListItems(FilterForRent),
                              // name.isEmpty && FilterValue == false
                              //     ? handleListItems(forSale)
                              //     : name.isNotEmpty && FilterValue == false
                              //         ? searchItemsForSale.isEmpty
                              //             ? Center(
                              //                 child: Text(
                              //                     "لم يتم العثور على نتائج"))
                              //             : handleListItems(searchItemsForSale)
                              //         : name.isEmpty && FilterValue == true
                              //             ? FilterForSale.isEmpty
                              //                 ? Center(
                              //                     child: Text(
                              //                         "لم يتم العثور على نتائج"))
                              //                 : handleListItems(FilterForSale)
                              //             : FilterForSale.isEmpty
                              //             ? Center(
                              //                 child: Text(
                              //                     "لم يتم العثور على نتائج"))
                              //             : handleListItems(FilterForSale),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.all(24),
                            child: CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 225, 231, 255),
                              radius: 30,
                              child: IconButton(
                                icon: Icon(Icons.map, color: Color.fromARGB(255, 127, 166, 233)),
                                onPressed: () {
                                  changeHomeView();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          )),
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
