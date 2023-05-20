// import 'package:flutter/material.dart';
// import 'package:nozol_application/pages/property.dart';

// class PropertyDetailes extends StatelessWidget {
  
//   final Property property ;
  
//   PropertyDetailes({required this.property});

//   @override
//   Widget build(BuildContext context) {

//     Size size = MediaQuery.of(context).size;

//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Hero(
//               tag: property.images[0],
//               child: Container(
//                 height: size.height * 0.5,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage('${property.images[0]}'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       stops: [0.4, 1.0],
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.7),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: size.height * 0.35,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Icon(
//                               Icons.flag_outlined,
//                               color: Colors.white,
//                               size: 28,
//                             ),

//                             SizedBox(
//                               width: 20,
//                             ),

//                             Icon(
//                               Icons.favorite_outline,
//                               color: Colors.white,
//                               size: 28,
//                             ),
//                           ],
//                         ),

//                         SizedBox(
//                           width: 10,
//                         ),

//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Icon(
//                             Icons.arrow_forward_ios,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 24,
//                       vertical: 8,
//                     ),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(5),
//                         ),
//                         border: Border.all(
//                           width: 1.5,
//                           color: Color.fromARGB(255, 127, 166, 233),
//                         ),
//                       ),
//                       width: 80,
//                       padding: EdgeInsets.symmetric(vertical: 4),
//                       child: Center(
//                         child: Text(
//                           '${property.classification}',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 24,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '${property.type}',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         // Container(
//                         //   height: 50,
//                         //   width: 50,
//                         //   decoration: BoxDecoration(
//                         //     color: Colors.white,
//                         //     shape: BoxShape.circle,
//                         //   ),
//                         //   child: Center(
//                         //     child: Icon(
//                         //       Icons.favorite,
//                         //       color: Color.fromARGB(255, 127, 166, 233),
//                         //       size: 20,
//                         //     ),
//                         //   ),
//                         // ),

//                         Text(
//                           'ريال ${property.price}',
//                           style: TextStyle(
//                             height: 2,
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.location_city,
//                               color: Colors.white,
//                               size: 18,
//                             ),
//                             SizedBox(
//                               width: 4,
//                             ),
//                             Text(
//                               '${property.neighborhood} ، ${property.city}',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.hotel,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                             SizedBox(
//                               width: 3,
//                             ),
//                             Text(
//                               '${property.number_of_room}',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Icon(
//                               Icons.bathtub,
//                               color: Colors.white,
//                               size: 17,
//                             ),
//                             SizedBox(
//                               width: 1,
//                             ),
//                             Text(
//                               '${property.number_of_bathroom}',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Icon(
//                               Icons.square_foot,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                             Text(
//                               '${property.space}',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: size.height * 0.50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Center(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.all(24),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   Container(
//                                     height: 50,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       color: Color.fromARGB(255, 127, 166, 233).withOpacity(0.1),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Center(
//                                       child: Icon(
//                                         Icons.whatsapp,
//                                         color: Color.fromARGB(255, 127, 166, 233),
//                                         size: 20,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 16,
//                                   ),
//                                   Container(
//                                     height: 50,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       color: Color.fromARGB(255, 127, 166, 233).withOpacity(0.1),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Center(
//                                       child: Icon(
//                                         Icons.message,
//                                         color: Color.fromARGB(255, 127, 166, 233),
//                                         size: 20,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),

//                               Row(
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       Text(
//                                         "محمد عبدالله",
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 4,
//                                       ),
//                                       Text(
//                                         "05********",
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           color: Colors.grey[500],
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                   SizedBox(
//                                     width: 16,
//                                   ),

//                                   Container(
//                                     height: 65,
//                                     width: 65,
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         image: NetworkImage(
//                                             'https://t4.ftcdn.net/jpg/04/10/43/77/360_F_410437733_hdq4Q3QOH9uwh0mcqAhRFzOKfrCR24Ta.jpg'),
//                                         fit: BoxFit.cover,
//                                       ),
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(right: 24, left: 24, bottom: 24),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               PropInfo(Icons.kitchen, ""),
//                               PropInfo(Icons.local_parking, ""),                              
//                               PropInfo(Icons.elevator, '${property.elevator}'),
//                               PropInfo(Icons.pool, '${property.pool}'),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: 315, bottom: 16),
//                           child: Text(
//                             "الوصف",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),

//                         Padding(
//                           padding: EdgeInsets.only(right: 24, left: 24, bottom: 16),
//                           child: Text(
//                             'لوريم ايبسوم دولار سيت أميت ,كونسيكتيتور أدايبا يسكينج أليايتا . ',
//                             textAlign: TextAlign.right,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey[500],
//                             ),
//                           ),
//                         ),

//                         Padding(
//                           padding: EdgeInsets.only(left: 275, bottom: 16),
//                           child: Text(
//                             "تفاصيل أكثر",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),

//                         Column(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(left: 290, bottom: 16),
//                               child: Text(
//                                 'عمر العقار : ${property.property_age}',
//                                 textAlign: TextAlign.right,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[500],
//                                 ),
//                               ),
//                             ),

//                             Padding(
//                               padding: EdgeInsets.only(left: 278, bottom: 16),
//                               child: Text(
//                                 'يوجد قبو : نعم',
//                                 textAlign: TextAlign.right,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[500],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         Padding(
//                           padding: EdgeInsets.only(left: 320, bottom: 16),
//                           child: Text(
//                             "الصور",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),

//                         Container(
//                           height: 200,
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 20, bottom: 24, right: 20),
//                             child: ListView.separated(
//                               physics: BouncingScrollPhysics(),
//                               scrollDirection: Axis.horizontal,
//                               // shrinkWrap: true,
//                               separatorBuilder: (context, index) => SizedBox(width: 20),
//                               itemCount: property.images.length,
//                               itemBuilder: (context, index) => ClipRRect(
//                                 borderRadius: BorderRadius.circular(15),
//                                 child: Image.network(
//                                   property.images[index],
//                                 ),
//                               ),
//                               // children: listImages(property.images),
//                             ),
//                           ),
//                         ),

//                         Padding(
//                           padding: EdgeInsets.only(left: 315, bottom: 16),
//                           child: Text(
//                             "الموقع",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget PropInfo(IconData iconData, String text) {
//   return Column(
//     children: [
//       Icon(
//         iconData,
//         color: Color.fromARGB(255, 127, 166, 233),
//         size: 28,
//       ),
//       SizedBox(
//         height: 8,
//       ),
//       Text(
//         text,
//         style: TextStyle(
//           color: Colors.grey[500],
//           fontSize: 14,
//         ),
//       ),
//     ],
//   );
// }

// List<Widget> listImages(List images) {
//   List<Widget> list = [];
//   list.add(SizedBox(
//     width: 24,
//   ));
//   for (var i = 0; i < images.length; i++) {
//     list.add(listImage(images[i]));
//   }
//   return list;
// }

// Widget listImage(String url) {
//   return AspectRatio(
//     aspectRatio: 3 / 2,
//     child: Container(
//       margin: EdgeInsets.only(right: 24),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(
//           Radius.circular(2),
//         ),
//         image: DecorationImage(
//           image: NetworkImage(url),
//           fit: BoxFit.cover,
//         ),
//       ),
//     ),
//   );
// }