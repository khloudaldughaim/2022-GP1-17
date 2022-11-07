import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nozol_application/pages/land.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class LandDetailes extends StatelessWidget {
  final Land land;

  LandDetailes({required this.land});

  @override
  Widget build(BuildContext context) {
    String Classification;
    String classification = land.properties?.classification ?? "";

    if (classification == 'للإيجار') {
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
              tag: '${land.properties!.images.length}' == '0'
                  ? 'https://www.guardanthealthamea.com/wp-content/uploads/2019/09/no-image.jpg'
                  : land.properties!.images[0], //'${land.images[0]}'
              child: Container(
                height: size.height * 0.5,
                decoration: '${land.properties!.images.length}' == '0'
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
                              '${land.properties!.images[0]}'), //'${villa.images[0]}'
                          fit: BoxFit.cover,
                        ),
                      ),
                child: Container(
                  decoration: '${land.properties!.images.length}' == '0'
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
                                '${land.properties!.images[0]}'), //'${villa.images[0]}'
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
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 127, 166, 233)
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.flag_outlined,
                                  color:
                                      const Color.fromARGB(255, 127, 166, 233),
                                  size: 28,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 127, 166, 233)
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.favorite_outline,
                                  color:
                                      const Color.fromARGB(255, 127, 166, 233),
                                  size: 28,
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
                              color: const Color.fromARGB(255, 127, 166, 233)
                                  .withOpacity(0.1),
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
                          '${land.properties!.type} ${Classification}',
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
                          '${land.properties!.type}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal-m",
                          ),
                        ),
                        Text(
                          'ريال ${land.properties!.price}',
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
                    padding: EdgeInsets.only(
                        left: 24, right: 24, top: 8, bottom: 16),
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
                              '${land.properties!.neighborhood} ، ${land.properties!.city}',
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
                              '${land.properties!.space} متر ² ',
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
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 127, 166, 233)
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.whatsapp,
                                        color:
                                            Color.fromARGB(255, 127, 166, 233),
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
                                      color: Color.fromARGB(255, 127, 166, 233)
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.message,
                                        color:
                                            Color.fromARGB(255, 127, 166, 233),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('Standard_user')
                                        .doc('${land.properties!.User_id}')
                                        .get(),
                                    builder: ((context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        Map<String, dynamic> user =
                                            snapshot.data!.data()
                                                as Map<String, dynamic>;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
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
                            padding: EdgeInsets.only(
                                right: 24, left: 24, bottom: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [],
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
                          padding: const EdgeInsets.only(
                              right: 27, left: 27, bottom: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${land.properties!.purpose}',
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
                                    ': الغرض',
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
                        '${land.properties!.description}' == ''
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 232, bottom: 16),
                                    child: Text(
                                      "معلومات إضافية",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Tajawal-m",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 5, left: 5, bottom: 16),
                                    child: Text(
                                      '${land.properties!.description}',
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
                        '${land.properties!.images.length}' == '0'
                            ? Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, bottom: 24, right: 20),
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
                            : Container(
                                height: 200,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, bottom: 24, right: 20),
                                  child: ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    // shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(width: 20),
                                    itemCount: land.properties!.images.length,
                                    itemBuilder: (context, index) => InkWell(
                                      onTap: () => openGallery(
                                          land.properties!.images, context),
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        land.properties!.images[index],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 315, bottom: 16),
                              child: Text(
                                'الموقع',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Tajawal-m",
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 16),
                              child: Text(
                                '${land.properties!.Location}',
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

openGallery(List images, BuildContext context) =>
    Navigator.of(context).push(MaterialPageRoute(
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
