import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nozol_application/pages/building.dart';
import 'package:nozol_application/pages/updatebuilding.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'my-property.dart';

class BuildingDetailes extends StatelessWidget {
  final Building building;

  BuildingDetailes({required this.building});

  @override
  Widget build(BuildContext context) {
    String ThereIsPool;
    bool pool = building.pool;

    if (pool == true) {
      ThereIsPool = 'نعم';
    } else {
      ThereIsPool = 'لا';
    }

    String ThereIsElevator;
    bool elevator = building.elevator;

    if (elevator == true) {
      ThereIsElevator = 'نعم';
    } else {
      ThereIsElevator = 'لا';
    }

    String Classification;
    String classification = building.properties.classification;

    if (classification == 'للإيجار') {
      Classification = 'للإيجار';
    } else {
      Classification = 'للبيع';
    }

    Size size = MediaQuery.of(context).size;

    void deleteproperty(String pId) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("هل أنت متأكد من حذف العقار"),
              actions: <Widget>[
                TextButton(
                  child: Text("لا"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("نعم"),
                  onPressed: () {
                    try {
                      FirebaseFirestore.instance.collection('properties').doc(pId).delete();
                      FirebaseFirestore.instance
                          .collection('bookings')
                          .where("property_id", isEqualTo: pId)
                          .get()
                          .then((Snapshot) async {
                        Snapshot.docs.forEach((element) {
                          FirebaseFirestore.instance
                              .collection('bookings')
                              .doc(element['book_id'])
                              .update({
                            "status": "deleted",
                            "isExpired": true,
                          });
                        });
                      });
                      // for (int i = 0; i < bookid.length; i++) {
                      //   FirebaseFirestore.instance.collection('bookings').doc(bookid[i]).update({
                      //     "status": "deleted",
                      //   });
                      // }

                      Fluttertoast.showToast(
                        msg: "تم الحذف بنجاح",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Color.fromARGB(255, 127, 166, 233),
                        textColor: Color.fromARGB(255, 248, 249, 250),
                        fontSize: 18.0,
                      );
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => myProperty()));
                    } catch (e, stack) {
                      Fluttertoast.showToast(
                        msg: "هناك خطأ ما",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Color.fromARGB(255, 127, 166, 233),
                        textColor: Color.fromARGB(255, 252, 253, 255),
                        fontSize: 18.0,
                      );
                    }
                    ;
                  },
                ),
              ],
            );
          });
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Hero(
              tag: '${building.properties.images.length}' == '0'
                  ? 'https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg'
                  : building.properties.images[0], //'${building.images[0]}'
              child: Container(
                height: size.height * 0.5,
                decoration: '${building.properties.images.length}' == '0'
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
                              '${building.properties.images[0]}'), //'${villa.images[0]}'
                          fit: BoxFit.cover,
                        ),
                      ),
                child: Container(
                  decoration: '${building.properties.images.length}' == '0'
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
                                '${building.properties.images[0]}'), //'${villa.images[0]}'
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
                            //delete
                            GestureDetector(
                              onTap: () {
                                deleteproperty('${building.properties.property_id}');
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
                                    Icons.delete,
                                    color: const Color.fromARGB(255, 127, 166, 233),
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateBuilding(building: building)),
                                );
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
                                    Icons.edit,
                                    color: const Color.fromARGB(255, 127, 166, 233),
                                    size: 28,
                                  ),
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
                          '${building.properties.type} ${Classification}',
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
                          '${building.properties.type}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal-m",
                          ),
                        ),
                        Text(
                          'ريال ${building.properties.price}',
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
                              '${building.properties.neighborhood} ، ${building.properties.city}',
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
                              Icons.square_foot,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              '${building.properties.space} متر ² ',
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
                                    width: 16,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('Standard_user')
                                        .doc('${building.properties.User_id}')
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
                                PropInfo(Icons.elevator, '${ThereIsElevator}', 'مصعد'),
                                PropInfo(Icons.pool, '${ThereIsPool}', 'مسبح'),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 275, bottom: 16),
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
                          padding: const EdgeInsets.only(right: 27, left: 27, bottom: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${building.property_age} سنة',
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
                                    '${building.number_of_apartment}',
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
                                    ': عدد الشقق',
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
                                    '${building.number_of_floor}',
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
                          padding: EdgeInsets.only(left: 232, bottom: 16),
                          child: Text(
                            "معلومات إضافية",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Tajawal-m",
                            ),
                          ),
                        ),
                        '${building.properties.description}' == ''
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
                                  padding: EdgeInsets.only(right: 24, left: 5, bottom: 16),
                                  child: Text(
                                    '${building.properties.description}',
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
                          padding: EdgeInsets.only(left: 102, bottom: 16),
                          child: Text(
                            "الوقت المفضل للجولات العقارية",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Tajawal-m",
                            ),
                          ),
                        ),
                        '${building.properties.TourTime}' == ''
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
                                  padding: EdgeInsets.only(right: 25, left: 5, bottom: 16),
                                  child: Text(
                                    '${building.properties.TourTime}',
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
                          padding: EdgeInsets.only(left: 320, bottom: 16),
                          child: Text(
                            "الصور",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Tajawal-m",
                            ),
                          ),
                        ),
                        '${building.properties.images.length}' == '0'
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
                                      itemCount: building.properties.images.length,
                                      itemBuilder: (context, index) => InkWell(
                                        onTap: () =>
                                            openGallery(building.properties.images, context),
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          building.properties.images[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 25, left: 25, bottom: 16),
                              child: Text(
                                'الموقع',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Tajawal-m",
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 25, left: 5, bottom: 16),
                              child: Text(
                                '${building.properties.Location}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Tajawal-l",
                                ),
                              ),
                            ),
                          ],
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
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: "Tajawal-l",
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
