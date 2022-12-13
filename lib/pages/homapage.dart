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
  List<dynamic> FilteredItems = [];
  List<dynamic> FilterForRent = [];
  List<dynamic> FilterForSale = [];
  TextEditingController controller = TextEditingController();
  String name = '';
  bool FilterValue = false;
  bool isMap = false;
  String? type1;
  String? propertyUse1;
  String? in_floor;
  String? city;
  String? address;
  int? number_of_bathrooms;
  int? number_of_rooms;
  int? number_of_livingRooms;
  int? number_of_floors;
  int? number_of_apartments;
  bool? pool;
  bool? basement;
  bool? elevator;
  double? ageRange_start;
  double? ageRange_end;
  String? MinSpace;
  String? MaxSpace;
  String? MinPrice;
  String? MaxPrice;

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

  void changeHomeView() {
    setState(() {
      if (isMap) {
        isMap = false;
      } else {
        isMap = true;
      }
    });
  }

  _handleRentAndSaleItems(dynamic item) {
    if (name.isEmpty) {
      if (item.properties.classification != "للإيجار") {
        forRent.add(item);
      } else {
        forSale.add(item);
      }
    } else if (FilterValue == true) {
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

  _handleFilterItems(List<dynamic> listItem) {
    FilteredItems.clear();
    FilterForRent.clear();
    FilterForSale.clear();

    listItem.forEach((element) {
      // if (element is Villa) {
      //   final villa = element;
      //   if (double.parse(villa.properties.space) <
      //           double.parse('${widget.MaxSpace}') &&
      //       double.parse(villa.properties.space) >
      //           double.parse('${widget.MinSpace}') &&
      //       double.parse(villa.properties.price) <
      //           double.parse('${widget.MaxPrice}') &&
      //       double.parse(villa.properties.price) >
      //           double.parse('${widget.MinPrice}') &&
      //       villa.properties.city == '${widget.city}' &&
      //       villa.properties.neighborhood == '${widget.address}' &&
      //       villa.property_age <= widget.ageRange_end! &&
      //       villa.property_age >= widget.ageRange_start! &&
      //       villa.number_of_room == widget.number_of_rooms &&
      //       villa.number_of_bathroom == widget.number_of_bathrooms &&
      //       villa.number_of_livingRooms == widget.number_of_livingRooms &&
      //       villa.number_of_floor == widget.number_of_floors &&
      //       villa.pool == widget.pool &&
      //       villa.basement == widget.basement &&
      //       villa.elevator == widget.elevator) {
      //     FilteredItems.add(villa);
      //     _handleRentAndSaleItems(villa);
      //     print("فيلا مطابقه");
      //   }
      // }
      // if (element is Apartment) {
      //   final apartment = element;
      //   if (apartment.in_floor == '${widget.in_floor}' &&
      //       double.parse(apartment.properties.space) <
      //           double.parse('${widget.MaxSpace}') &&
      //       double.parse(apartment.properties.space) >
      //           double.parse('${widget.MinSpace}') &&
      //       double.parse(apartment.properties.price) <
      //           double.parse('${widget.MaxPrice}') &&
      //       double.parse(apartment.properties.price) >
      //           double.parse('${widget.MinPrice}') &&
      //       apartment.properties.city == '${widget.city}' &&
      //       apartment.properties.neighborhood == '${widget.address}' &&
      //       apartment.property_age <= widget.ageRange_end! &&
      //       apartment.property_age >= widget.ageRange_start! &&
      //       apartment.number_of_room == widget.number_of_rooms &&
      //       apartment.number_of_bathroom == widget.number_of_bathrooms &&
      //       apartment.number_of_livingRooms == widget.number_of_livingRooms &&
      //       apartment.number_of_floor == widget.number_of_floors &&
      //       apartment.elevator == widget.elevator) {
      //     FilteredItems.add(apartment);
      //     _handleRentAndSaleItems(apartment);
      //     print("شقه مطابقه");
      //   }
      // }
      // if (element is Building) {
      //   final building = element;
      //   if (double.parse(building.properties.space) <
      //           double.parse('${widget.MaxSpace}') &&
      //       double.parse(building.properties.space) >
      //           double.parse('${widget.MinSpace}') &&
      //       double.parse(building.properties.price) <
      //           double.parse('${widget.MaxPrice}') &&
      //       double.parse(building.properties.price) >
      //           double.parse('${widget.MinPrice}') &&
      //       building.properties.city == '${widget.city}' &&
      //       building.properties.neighborhood == '${widget.address}' &&
      //       building.property_age <= widget.ageRange_end! &&
      //       building.property_age >= widget.ageRange_start! &&
      //       building.number_of_apartment == widget.number_of_apartments &&
      //       building.number_of_floor == widget.number_of_floors &&
      //       building.pool == widget.pool &&
      //       building.elevator == widget.elevator) {
      //     FilteredItems.add(building);
      //     _handleRentAndSaleItems(building);
      //     print("عمارة مطابقه");
      //   }
      // }

      //((MaxPrice == null)) && (double.parse(land.properties!.price) <= double.parse(MaxPrice!))

      if (element is Land) {
        final land = element;
        print("================= Min Space =================");
        print(MinSpace == null);
        print(MinSpace?.isEmpty);
        print(MinSpace.runtimeType);
        print("================= Space of building =================");
        print(land.properties?.space);
        print(land.properties?.space.runtimeType);
        bool flag = true ;
        do {
          if (land.properties!.purpose == propertyUse1) {
            if ((MaxSpace!.isNotEmpty)) {
              if ((int.parse(land.properties!.space) <= int.parse(MaxSpace!))) {
                if ((MinSpace!.isNotEmpty)) {
                  if ((int.parse(land.properties!.space) >= int.parse(MinSpace!)) && (int.parse(land.properties!.space) <= int.parse(MaxSpace!))) {
                    if ((MinPrice!.isNotEmpty)) {
                      if ((int.parse(land.properties!.price) >= int.parse(MinPrice!))) {
                        if (((MaxPrice!.isNotEmpty))) {
                          if ((int.parse(land.properties!.price) <= int.parse(MaxPrice!)) && (int.parse(land.properties!.price) >= int.parse(MinPrice!))) {
                            if (address!.isNotEmpty) {
                              if (land.properties!.neighborhood == address) {
                                if (land.properties!.city == city) {
                                  FilteredItems.add(land);
                                  _handleRentAndSaleItems(land);
                                  print("1ارض  مطابقه");
                                }
                                break;
                              }
                              break;
                            } else if (land.properties!.city == city) {
                                FilteredItems.add(land);
                                _handleRentAndSaleItems(land);
                                print("1ارض  مطابقه");
                              }
                            break;
                          }
                          break;
                        } else if (address!.isNotEmpty) {
                          if (land.properties!.neighborhood == address) {
                            if (land.properties!.city == city) {
                              FilteredItems.add(land);
                              _handleRentAndSaleItems(land);
                              print("1ارض  مطابقه");
                            }
                            break;
                          }
                          break;
                        }
                        break;
                      }
                      break;
                    } else if (((MaxPrice!.isNotEmpty))) {
                      if ((int.parse(land.properties!.price) <= int.parse(MaxPrice!)) && (int.parse(land.properties!.price) >= int.parse(MinPrice!))) {
                        if (address!.isNotEmpty) {
                          if (land.properties!.neighborhood == address) {
                            if (land.properties!.city == city) {
                              FilteredItems.add(land);
                              _handleRentAndSaleItems(land);
                              print("1ارض  مطابقه");
                            }
                            break;
                          }
                          break;
                        }
                        break;
                      }
                      break;
                    } else if (address!.isNotEmpty) {
                      if (land.properties!.neighborhood == address) {
                        if (land.properties!.city == city) {
                          FilteredItems.add(land);
                          _handleRentAndSaleItems(land);
                          print("1ارض  مطابقه");
                        }
                        break;
                      }
                      break;
                    }
                    break;
                  }
                  break;
                } else if ((MinPrice!.isNotEmpty)) {
                  if ((int.parse(land.properties!.price) >= int.parse(MinPrice!))) {
                    if (((MaxPrice!.isNotEmpty))) {
                      if ((int.parse(land.properties!.price) <= int.parse(MaxPrice!)) && (int.parse(land.properties!.price) >= int.parse(MinPrice!))) {
                        if (address!.isNotEmpty) {
                          if (land.properties!.neighborhood == address) {
                            if (land.properties!.city == city) {
                              FilteredItems.add(land);
                              _handleRentAndSaleItems(land);
                              print("1ارض  مطابقه");
                            }
                            break;
                          }
                          break;
                        }
                        break;
                      }
                      break;
                    } else if (address!.isNotEmpty) {
                      if (land.properties!.neighborhood == address) {
                        if (land.properties!.city == city) {
                          FilteredItems.add(land);
                          _handleRentAndSaleItems(land);
                          print("1ارض  مطابقه");
                        }
                        break;
                      }
                      break;
                    }
                    break;
                  }
                  break;
                } else if (((MaxPrice!.isNotEmpty))) {
                  if ((int.parse(land.properties!.price) <= int.parse(MaxPrice!)) && (int.parse(land.properties!.price) >= int.parse(MinPrice!))) {
                    if (address!.isNotEmpty) {
                      if (land.properties!.neighborhood == address) {
                        if (land.properties!.city == city) {
                          FilteredItems.add(land);
                          _handleRentAndSaleItems(land);
                          print("1ارض  مطابقه");
                        }
                        break;
                      }
                      break;
                    }
                    break;
                  }
                  break;
                } else if (address!.isNotEmpty) {
                  if (land.properties!.neighborhood == address) {
                    if (land.properties!.city == city) {
                      FilteredItems.add(land);
                      _handleRentAndSaleItems(land);
                      print("1ارض  مطابقه");
                    }
                    break;
                  }
                  break;
                }
                break;
              }
              break;
            } else if ((MinSpace!.isNotEmpty)) {
              if ((int.parse(land.properties!.space) >= int.parse(MinSpace!)) && (int.parse(land.properties!.space) <= int.parse(MaxSpace!))) {
                if ((MinPrice!.isNotEmpty)) {
                  if ((int.parse(land.properties!.price) >= int.parse(MinPrice!))) {
                    if (((MaxPrice!.isNotEmpty))) {
                      if ((int.parse(land.properties!.price) <= int.parse(MaxPrice!)) && (int.parse(land.properties!.price) >= int.parse(MinPrice!))) {
                        if (address!.isNotEmpty) {
                          if (land.properties!.neighborhood == address) {
                            if (land.properties!.city == city) {
                              FilteredItems.add(land);
                              _handleRentAndSaleItems(land);
                              print("1ارض  مطابقه");
                            }
                            break;
                          }
                          break;
                        }
                        break;
                      }
                      break;
                    } else if (address!.isNotEmpty) {
                      if (land.properties!.neighborhood == address) {
                        if (land.properties!.city == city) {
                          FilteredItems.add(land);
                          _handleRentAndSaleItems(land);
                          print("1ارض  مطابقه");
                        }
                        break;
                      }
                      break;
                    }
                    break;
                  }
                  break;
                } else if (((MaxPrice!.isNotEmpty))) {
                  if ((int.parse(land.properties!.price) <= int.parse(MaxPrice!)) && (int.parse(land.properties!.price) >= int.parse(MinPrice!))) {
                    if (address!.isNotEmpty) {
                      if (land.properties!.neighborhood == address) {
                        if (land.properties!.city == city) {
                          FilteredItems.add(land);
                          _handleRentAndSaleItems(land);
                          print("1ارض  مطابقه");
                        }
                        break;
                      }
                      break;
                    }
                    break;
                  }
                  break;
                } else if (address!.isNotEmpty) {
                  if (land.properties!.neighborhood == address) {
                    if (land.properties!.city == city) {
                      FilteredItems.add(land);
                      _handleRentAndSaleItems(land);
                      print("1ارض  مطابقه");
                    }
                    break;
                  }
                  break;
                }
                break;
              }
              break;
            } else if ((MinPrice!.isNotEmpty)) {
              if ((int.parse(land.properties!.price) >= int.parse(MinPrice!))) {
                if (((MaxPrice!.isNotEmpty))) {
                  if ((int.parse(land.properties!.price) <= int.parse(MaxPrice!)) && (int.parse(land.properties!.price) >= int.parse(MinPrice!))) {
                    if (address!.isNotEmpty) {
                      if (land.properties!.neighborhood == address) {
                        if (land.properties!.city == city) {
                          FilteredItems.add(land);
                          _handleRentAndSaleItems(land);
                          print("1ارض  مطابقه");
                        }
                        break;
                      }
                      break;
                    }
                    break;
                  }
                  break;
                } else if (address!.isNotEmpty) {
                  if (land.properties!.neighborhood == address) {
                    if (land.properties!.city == city) {
                      FilteredItems.add(land);
                      _handleRentAndSaleItems(land);
                      print("1ارض  مطابقه");
                    }
                    break;
                  }
                  break;
                }
                break;
              }
              break;
            } else if (((MaxPrice!.isNotEmpty))) {
              if ((int.parse(land.properties!.price) <= int.parse(MaxPrice!)) && (int.parse(land.properties!.price) >= int.parse(MinPrice!))) {
                if (address!.isNotEmpty) {
                  if (land.properties!.neighborhood == address) {
                    if (land.properties!.city == city) {
                      FilteredItems.add(land);
                      _handleRentAndSaleItems(land);
                      print("1ارض  مطابقه");
                    }
                    break;
                  }
                  break;
                }
                break;
              }
              break;
            } else if (address!.isNotEmpty) {
              if (land.properties!.neighborhood == address) {
                if (land.properties!.city == city) {
                  FilteredItems.add(land);
                  _handleRentAndSaleItems(land);
                  print("1ارض  مطابقه");
                }
                break;
              }
              break;
            } else if (land.properties!.city == city) {
                FilteredItems.add(land);
                _handleRentAndSaleItems(land);
                print("1ارض  مطابقه");
            }
            break; /////////////////////////////////////////////////////////////////////////////////////END PROPERTY USE////////////////////////////////////////
          }
          flag = false;
        } while(flag) ;
      }
    });
  }

  Widget _buildFilterItems() {
    _handleFilterItems(allData);
    if (FilteredItems.isEmpty)
      return Center(child: Text("لم يتم العثور على نتائج"));
    return _handleListItems(FilteredItems);
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
                            print("a $type1");
                            print("b $propertyUse1");
                            print("c $in_floor");
                            print("d $city");
                            print("e $address");
                            print("f $number_of_bathrooms");
                            print("g $number_of_rooms");//
                            print("h $number_of_livingRooms");
                            print("i $number_of_floors");//
                            print("j $number_of_apartments");//
                            print("k $pool");
                            print("l $basement");//
                            print("m $elevator");
                            print("n $ageRange_start");
                            print("o $ageRange_end");
                            
                            if(MinSpace == null){
                              print('MinSpace empty');
                            }else{
                              print(MinSpace);
                            }
                            
                            if(MaxSpace == null){
                              print('MaxSpace empty');
                            }else{
                              print(MaxSpace);
                            }
                            
                            if(MinPrice == null){
                              print('MinPrice empty');
                            }else{
                              print(MinPrice);
                            }
                            
                            if(MaxPrice == null){
                              print('MaxPrice empty');
                            }else{
                              print(MaxPrice);
                            }
                                  FilterValue = true;
                                  final FilterResult = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FilterPage(FilterValue: FilterValue)));
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
                                        elevator = FilterResult["elevator"];
                                        pool = FilterResult["pool"];
                                        ageRange_start = FilterResult["ageRange_start"];
                                        ageRange_end = FilterResult["ageRange_end"];
                                        MinPrice = FilterResult["MinPrice"];
                                        MaxPrice = FilterResult["MaxPrice"];
                                        MinSpace = FilterResult["MinSpace"];
                                        MaxSpace = FilterResult["MaxSpace"];
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
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 14, 41, 99))),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  alignLabelWithHint: true,
                                  hintText:
                                      'ابحث عن الحي أو المدينة أو نوع العقار',
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
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          TabBarView(
                            children: [
                              name.isEmpty
                                  ? FutureBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                      future: FirebaseFirestore.instance
                                          .collection('properties')
                                          .get(),
                                      builder: (
                                        BuildContext context,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot,
                                      ) {
                                        return _handleSnapshot(snapshot);
                                      },
                                    )
                                  : _buildFilterItems(), //_buildSearchItems(),
                              name.isEmpty
                                  ? _handleListItems(forRent)
                                  : searchItemsForRent.isEmpty
                                      ? Center(
                                          child:
                                              Text("لم يتم العثور على نتائج"))
                                      : _handleListItems(searchItemsForRent),
                              name.isEmpty
                                  ? _handleListItems(forSale)
                                  : searchItemsForSale.isEmpty
                                      ? Center(
                                          child:
                                              Text("لم يتم العثور على نتائج"))
                                      : _handleListItems(searchItemsForSale),
                              // Center(child: Text("For sale")),
                              // Center(child: Text("For rent")),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.all(24),
                            child: CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 225, 231, 255),
                              radius: 30,
                              child: IconButton(
                                icon: Icon(Icons.map,
                                    color: Color.fromARGB(255, 127, 166, 233)),
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
