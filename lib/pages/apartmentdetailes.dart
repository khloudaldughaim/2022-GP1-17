import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/pages/apartment.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ApartmentDetailes extends StatelessWidget {
  final Apartment apartment;

  ApartmentDetailes({required this.apartment});

  @override
  Widget build(BuildContext context) {

    String ThereIsElevator;
    bool elevator = apartment.elevator;

    if (elevator == true) {
      ThereIsElevator = 'نعم';
    } else {
      ThereIsElevator = 'لا';
    }

    String Classification;
    String classification = apartment.properties.classification;

    if (classification == 'rent') {
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
              tag: '${apartment.properties.images.length}' == '0' ? 'https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg' : apartment.properties.images[0], //'${apartment.images[0]}'
              child: Container(
                height: size.height * 0.5,
                decoration: '${apartment.properties.images.length}' == '0' ? BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg'), //'${villa.images[0]}'
                    fit: BoxFit.cover,
                  ),
                ) : BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('${apartment.properties.images[0]}'), //'${villa.images[0]}'
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
              height: size.height * 0.35,
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
                            Icon(
                              Icons.flag_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.favorite_outline,
                              color: Colors.white,
                              size: 28,
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
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 24,
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
                          '${apartment.properties.type} ${Classification}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
                          '${apartment.properties.type}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          'ريال ${apartment.properties.price}',
                          style: TextStyle(
                            height: 2,
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
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
                              '${apartment.properties.neighborhood} ، ${apartment.properties.city}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                              '${apartment.number_of_room}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                              '${apartment.number_of_bathroom}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                              '${apartment.properties.space} متر ² ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 127, 166, 233).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.whatsapp,
                                        color: Color.fromARGB(255, 127, 166, 233),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 127, 166, 233).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.message,
                                        color: Color.fromARGB(255, 127, 166, 233),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance.collection('Standard_user').doc('${apartment.properties.User_id}').get(),
                                    builder: ((context, snapshot) {
                                      if(snapshot.connectionState == ConnectionState.done){
                                        Map<String, dynamic> user = snapshot.data!.data() as Map<String, dynamic> ;
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${user['name']}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
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
                                            'https://blaonline.org.za/wp-content/uploads/2021/05/2750635_gray-circle-login-user-icon-png-transparent-png.jpg'),
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
                                    PropInfo(Icons.chair, '${apartment.number_of_livingRooms}', 'صالة'),
                                    PropInfo(Icons.elevator, '${ThereIsElevator}', 'مصعد'),
                                  ],
                                )),
                        // Padding(
                        //   padding: EdgeInsets.only(left: 315, bottom: 16),
                        //   child: Text(
                        //     "الوصف",
                        //     style: TextStyle(
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(right: 24, left: 24, bottom: 16),
                        //   child: Text(
                        //     '${apartment.properties.description}',
                        //     textAlign: TextAlign.right,
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       color: Colors.grey[500],
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(left: 275, bottom: 16),
                          child: Text(
                            "تفاصيل أكثر",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 27, left: 27, bottom: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${apartment.property_age} سنة',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
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
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${apartment.in_floor}',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    ': رقم الدور',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${apartment.number_of_floor}',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
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
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: 320, bottom: 16),
                          child: Text(
                            "الصور",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        '${apartment.properties.images.length}' == '0' ?
                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, bottom: 24, right: 20),
                            child:  Directionality(
                              textDirection: TextDirection.rtl, 
                              child: Text('لا يوجد صور متاحة !',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                ),
                              )
                            )
                          ),
                        ) : 
                        Container(
                          height: 200,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, bottom: 24, right: 20),
                            child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              // shrinkWrap: true,
                              separatorBuilder: (context, index) => SizedBox(width: 20),
                              itemCount: apartment.properties.images.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () => openGallery(apartment.properties.images, context),
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  apartment.properties.images[index],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 315, bottom: 16),
                          child: Text(
                            "الموقع",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
        ),
      ),
      SizedBox(
        height: 8,
      ),
      Text(
        text,
        style: TextStyle(
          color: Colors.grey[500],
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
          actions:[
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