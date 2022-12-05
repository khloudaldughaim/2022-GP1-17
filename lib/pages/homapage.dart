import 'package:cloud_firestore/cloud_firestore.dart';
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

class HomePage extends StatefulWidget {
  final String? type1;
  final String? propertyUse1;
  final String? in_floor;
  final String? city;
  final String? address;
  final int? number_of_bathrooms;
  final int? number_of_rooms;
  final int? number_of_livingRooms;
  final int? number_of_floors;
  final int? number_of_apartments;
  final bool? pool;
  final bool? basement;
  final bool? elevator;
  final double? ageRange_start;
  final double? ageRange_end;
  final String? MinSpace;
  final String? MaxSpace;
  final String? MinPrice;
  final String? MaxPrice;

  HomePage({
    this.type1,
    this.propertyUse1,
    this.in_floor,
    this.city,
    this.address,
    this.number_of_bathrooms,
    this.number_of_floors,
    this.number_of_livingRooms,
    this.number_of_rooms,
    this.number_of_apartments,
    this.basement,
    this.elevator,
    this.pool,
    this.ageRange_start,
    this.ageRange_end,
    this.MinPrice,
    this.MaxPrice,
    this.MinSpace,
    this.MaxSpace,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> allData = [];
  List<dynamic> searchItems = [];
  List<dynamic> searchItemsForRent = [];
  List<dynamic> searchItemsForSale = [];
  List<dynamic> forRent = [];
  List<dynamic> forSale = [];
  TextEditingController controller = TextEditingController();
  String name = '';
  bool FilterValue = false;
  //'${widget.type1}'

  void _handleData(QuerySnapshot<Map<String, dynamic>> data) async {
    try {
      allData.clear();
      forRent.clear();
      forSale.clear();
      data.docs.forEach((element) {
        if (element.data()["type"] == "فيلا") {
          Villa villa = Villa.fromMap(element.data());
          allData.add(villa);
          _handleRentAndSaleItems(villa);
          // if (element.data()["classification"] == "للإيجار") {
          //   forSale.add(Villa.fromMap(element.data()));
          // } else {
          //   forRent.add(Villa.fromMap(element.data()));
          // }
        }
        if (element.data()["type"] == "شقة") {
          Apartment apartment = Apartment.fromMap(element.data());
          allData.add(apartment);
          _handleRentAndSaleItems(apartment);
          // if (element.data()["classification"] == "للإيجار") {
          //   forSale.add(Apartment.fromMap(element.data()));
          // } else {
          //   forRent.add(Apartment.fromMap(element.data()));
          // }
        }

        if (element.data()["type"] == "عمارة") {
          Building building = Building.fromMap(element.data());
          allData.add(building);
          _handleRentAndSaleItems(building);

          // if (element.data()["classification"] == "للإيجار") {
          //   forSale.add(Building.fromMap(element.data()));
          // } else {
          //   forRent.add(Building.fromMap(element.data()));
          // }
        }

        if (element.data()["type"] == "ارض") {
          Land land = Land.fromJson(element.data());
          allData.add(land);
          _handleRentAndSaleItems(land);
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

  Widget _handleListItems(List<dynamic> listItem) {
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

  Widget _handleSnapshot(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
      if (allData.isEmpty) {
        _handleData(snapshot.data!);
      }
      return _handleListItems(allData);
    }
    return Container();
  }

  //! NEW FUNCTIONS

  _handleRentAndSaleItems(dynamic item) {
    if (name.isEmpty) {
      if (item.properties.classification != "للإيجار") {
        forRent.add(item);
      } else {
        forSale.add(item);
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
        if (villa.properties.city
                .toString()
                .toLowerCase()
                .startsWith(name.toLowerCase()) ||
            villa.properties.type
                .toString()
                .toLowerCase()
                .startsWith(name.toLowerCase()) ||
            villa.properties.neighborhood
                .toString()
                .toLowerCase()
                .startsWith(name.toLowerCase())) {
          searchItems.add(villa);
          _handleRentAndSaleItems(villa);
        }
      }
      if (element is Apartment) {
        final apartment = element;
        if (apartment.properties.city
                .toLowerCase()
                .startsWith(name.toLowerCase()) ||
            apartment.properties.type
                .toLowerCase()
                .startsWith(name.toLowerCase()) ||
            apartment.properties.neighborhood
                .toString()
                .toLowerCase()
                .startsWith(name.toLowerCase())) {
          searchItems.add(apartment);
          _handleRentAndSaleItems(apartment);
        }
      }
      if (element is Building) {
        final building = element;
        if (building.properties.city
                .toLowerCase()
                .startsWith(name.toLowerCase()) ||
            building.properties.type
                .toLowerCase()
                .startsWith(name.toLowerCase()) ||
            building.properties.neighborhood
                .toString()
                .toLowerCase()
                .startsWith(name.toLowerCase())) {
          searchItems.add(building);
          _handleRentAndSaleItems(building);
        }
      }

      if (element is Land) {
        final land = element;
        if (land.properties!.city
                .toString()
                .toLowerCase()
                .startsWith(name.toLowerCase()) ||
            land.properties!.type
                .toString()
                .toLowerCase()
                .startsWith(name.toLowerCase()) ||
            land.properties!.neighborhood
                .toString()
                .toLowerCase()
                .startsWith(name.toLowerCase())) {
          searchItems.add(land);
          _handleRentAndSaleItems(land);
        }
      }
    });
  }

  Widget _buildSearchItems() {
    _handleSearchItems(allData);
    if (searchItems.isEmpty)
      return Center(child: Text("لم يتم العثور على نتائج"));
    return _handleListItems(searchItems);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        top: true,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 127, 166, 233),
              leading: IconButton(
                onPressed: () {
            print('${widget.type1}');
            print('${widget.propertyUse1}');
            print('${widget.in_floor}');
            print('${widget.city}');
            print('${widget.address}');
            print('${widget.number_of_bathrooms}');
            print('${widget.number_of_rooms}');//
            print('${widget.number_of_livingRooms}');
            print('${widget.number_of_floors}');//
            print('${widget.number_of_apartments}');//
            print('${widget.pool}');
            print('${widget.basement}');//
            print('${widget.elevator}');
            print('${widget.ageRange_start}');
            print('${widget.ageRange_end}');
            print('${widget.MinSpace}');
            print('${widget.MaxSpace}');
            print('${widget.MinPrice}');
            print('${widget.MaxPrice}');
                  FilterValue = true;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FilterPage(FilterValue: FilterValue)));
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
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 14, 41, 99))),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        alignLabelWithHint: true,
                        hintText: 'ابحث عن الحي أو المدينة أو نوع العقار',
                        hintStyle: TextStyle(
                            color: Color.fromARGB(143, 255, 255, 255),
                            fontFamily: "Tajawal-m"),
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
              bottom: const TabBar(
                labelStyle: TextStyle(
                  fontFamily: "Tajawal-b",
                  fontWeight: FontWeight.w100,
                ),
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
            body: TabBarView(
              children: [
                name.isEmpty
                    ? FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('properties')
                            .get(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot,
                        ) {
                          return _handleSnapshot(snapshot);
                        },
                      )
                    : _buildSearchItems(),
                name.isEmpty
                    ? _handleListItems(forRent)
                    : searchItemsForRent.isEmpty
                        ? Center(child: Text("لم يتم العثور على نتائج"))
                        : _handleListItems(searchItemsForRent),
                name.isEmpty
                    ? _handleListItems(forSale)
                    : searchItemsForSale.isEmpty
                        ? Center(child: Text("لم يتم العثور على نتائج"))
                        : _handleListItems(searchItemsForSale),
                // Center(child: Text("For sale")),
                // Center(child: Text("For rent")),
              ],
            ),

            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,

            floatingActionButton: SizedBox(
              width: 75,
              height: 75,
              child: FloatingActionButton(
                child: Icon(
                  Icons.map,
                  size: 35,
                ), //Text("View map", style: TextStyle(fontSize: 15, fontFamily: "Tajawal-b", ), textAlign: TextAlign.center, ),
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                foregroundColor: Color.fromARGB(255, 93, 119, 185),
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => mapPage()))
                },
              ),
            ),
          ),
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
      MaterialPageRoute(
          builder: (context) => ApartmentDetailes(apartment: apartment)),
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
      MaterialPageRoute(
          builder: (context) => BuildingDetailes(building: building)),
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
                    image: NetworkImage('${type.properties.images[0]}'),
                    fit: BoxFit.cover),
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
