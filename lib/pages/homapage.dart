import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/pages/property.dart';
import 'package:nozol_application/pages/propertydetailes.dart';
// ignore_for_file: prefer_const_constructors

class HomePage extends StatefulWidget {
   const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//        return MaterialApp(
//       home: DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           appBar: AppBar(
//            // bottom: const 
//             title: Center(child: const Text('NOZOL')),
//             toolbarHeight: 60,
//             backgroundColor:  Color.fromARGB(255, 127, 166, 233),
            
//           ),
//           body: Column(
//             children: [
//               SizedBox(height: 15,),
//               TabBar(
//                 labelColor: Color.fromARGB(255, 57, 64, 141),
//                   tabs: [
//                     Tab(text:'ALL',),
//                     Tab(text: 'FOR RENT',),
//                     Tab(text: 'For SALE',),
//                   ],
//                 ),
//             ],
//           ),
//           // body: const TabBarView(
//           //   children: [
//           //     Icon(Icons.directions_car),
//           //     Icon(Icons.directions_transit),
//           //     Icon(Icons.directions_bike),
//           //   ],
//           // ),
//         ),
//       ),
//     );
   
//   }
// }

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  SafeArea(
        child: DefaultTabController(
          length: 3,
            child: Scaffold(  
               appBar: AppBar(
                backgroundColor:Color.fromARGB(255, 127, 166, 233),
                title: const Text('نزل'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'الكل',),
                Tab(text: 'للبيع',),
                Tab(text: 'للإيجار', ),
              ],
            ),  
               ),   
              body: TabBarView(
                children: [
                  StreamBuilder<List<Property>>(
                      stream: readPropertys(),
                      builder: ((context, snapshot){
                        if(snapshot.hasError){
                          return Text('Something went wrong! ${snapshot.error}');
                        }else if(snapshot.hasData){
                          final properties = snapshot.data!;
                    
                          return ListView(
                            children: List.generate(properties.length,(index){
                              return buildProperty(properties[index], context);
                            })
                          );
                        } else{
                          return Center(child: CircularProgressIndicator(),);
                        }
                      }),
                    ),

                StreamBuilder<List<Property>>(
                      stream: readPropertys2(),
                      builder: ((context, snapshot){
                        if(snapshot.hasError){
                          return Text('Something went wrong! ${snapshot.error}');
                        }else if(snapshot.hasData){
                          final properties = snapshot.data!;
                    
                          return ListView(
                            children: List.generate(properties.length,(index){
                              return buildProperty(properties[index], context);
                            })
                          );
                        } else{
                          return Center(child: CircularProgressIndicator(),);
                        }
                      }),
                    ),
                StreamBuilder<List<Property>>(
                      stream: readPropertys3(),
                      builder: ((context, snapshot){
                        if(snapshot.hasError){
                          return Text('Something went wrong! ${snapshot.error}');
                        }else if(snapshot.hasData){
                          final properties = snapshot.data!;
                    
                          return ListView(
                            children: List.generate(properties.length,(index){
                              return buildProperty(properties[index], context);
                            })
                          );
                        } else{
                          return Center(child: CircularProgressIndicator(),);
                        }
                      }),
                    ),

                ],
              ),
              ),
          ),
      ),
      );
  }
}

Widget buildProperty(Property property , BuildContext context) =>  GestureDetector(
  
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PropertyDetailes(property: property)),
      );
    },
    child: Card(
      margin: EdgeInsets.fromLTRB(12,12,12,6),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        )
      ),
      child: Container(
        height: 210,
        //color: Colors.teal,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('${property.images[0]}'),
            fit: BoxFit.cover
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin:  Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5,1.0],
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
                width: 80,
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Center(
                  child: Text(
                    '${property.classification}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                        '${property.type}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        'ريال ${property.price}',
                        style: TextStyle(
                          height: 2,
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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
                            '${property.city}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),                                           

                        ],
                      ),

                      Row(
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
                            '${property.number_of_room}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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
                            '${property.number_of_bathroom}',
                            style: TextStyle(
                              color: Colors.white,
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
                            '${property.space}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),                                                
                          ),                       
                        ],
                      ),

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

Stream<List<Property>> readPropertys() => FirebaseFirestore.instance
.collection('properties')
.snapshots()
.map((snapshot) =>
snapshot.docs.map((doc) => Property.fromJson(doc.data())).toList());    


Stream<List<Property>> readPropertys2() => FirebaseFirestore.instance
.collection('properties').where('classification', isEqualTo: 'عقار للبيع')
.snapshots()
.map((snapshot) =>
snapshot.docs.map((doc) => Property.fromJson(doc.data())).toList());    


Stream<List<Property>> readPropertys3() => FirebaseFirestore.instance
.collection('properties').where('classification', isEqualTo: 'عقار للإيجار')
.snapshots()
.map((snapshot) =>
snapshot.docs.map((doc) => Property.fromJson(doc.data())).toList());    