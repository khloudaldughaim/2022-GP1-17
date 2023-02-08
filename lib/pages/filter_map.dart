// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, camel_case_types, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'mapPage.dart';

class filterMap extends StatefulWidget {
  @override
  State<filterMap> createState() => _filterMapState();
}

class _filterMapState extends State<filterMap> {
  static String filter_val = " ";
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(15),
                right: Radius.circular(15),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 310),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, {"filter_val": filter_val});
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
                          Icons.close,
                          color: const Color.fromARGB(255, 127, 166, 233),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "خصائص الخريطة",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Tajawal-b",
                      color: Color.fromARGB(255, 127, 166, 233)),
                ),
                SizedBox(
                  height: 15,
                ),
                //                 Directionality(
                // textDirection: TextDirection.rtl,
                Padding(
                    padding: EdgeInsets.only(left: 230),
                    child: Text(
                      ": ألوان الخريطة تحدد",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Tajawal-m",
                          color: Color.fromARGB(255, 91, 94, 98)),
                    )),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 180.0,
                      height: 50.0,
                      child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ElevatedButton(
                            onPressed: () {
                              if (filter_val == "type") {
                                setState(() {
                                  filter_val = " ";
                                  print("no");
                                });
                              } else {
                                setState(() {
                                  filter_val = "type";
                                  print("stttt");
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Color.fromARGB(255, 135, 136, 138)),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                backgroundColor: filter_val == "type"
                                    ? Color.fromARGB(255, 135, 165, 203)
                                    : Color.fromARGB(194, 180, 183, 187)),
                            child: Center(
                                child: Text(
                              "نوع العقار",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "Tajawal-m",
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            )),
                          )),
                    ),
                    SizedBox(
                      width: 180.0,
                      height: 50.0,
                      child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ElevatedButton(
                            onPressed: () {
                              if (filter_val == "price") {
                                setState(() {
                                  filter_val = " ";
                                  print("no");
                                });
                              } else {
                                setState(() {
                                  filter_val = "price";
                                  print("stttt");
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Color.fromARGB(255, 135, 136, 138)),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                backgroundColor: filter_val == "price"
                                    ? Color.fromARGB(255, 135, 165, 203)
                                    : Color.fromARGB(194, 180, 183, 187)),
                            child: Center(
                                child: Text(
                              "سعر العقار",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "Tajawal-m",
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            )),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 180.0,
                  height: 50.0,
                  child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          if (filter_val == "space") {
                            setState(() {
                              filter_val = " ";
                              print("no");
                            });
                          } else {
                            setState(() {
                              filter_val = "space";
                              print("stttt");
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Color.fromARGB(255, 135, 136, 138)),
                            elevation: 3,
                            shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            backgroundColor: filter_val == "space"
                                ? Color.fromARGB(255, 135, 165, 203)
                                : Color.fromARGB(194, 180, 183, 187)),
                        child: Center(
                            child: Text(
                          "المساحة",
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: "Tajawal-m",
                              color: Color.fromARGB(255, 255, 255, 255)),
                        )),
                      )),
                ),
                SizedBox(
                  height: 25,
                ),
                if (filter_val == "type")
                  Container(
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("فيلا",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 166, 212, 243),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("عمارة",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 243, 166, 240),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("شقة",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 243, 204, 166),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 270),
                            child: Container(
                              width: 110,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(68, 178, 178, 178),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("أرض",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Tajawal-m",
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.circle,
                                    color: Color.fromARGB(255, 166, 243, 220),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                if (filter_val == "space")
                  Container(
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("400-599",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 243, 204, 166),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("200-399",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 243, 166, 240),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("0-199",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 166, 212, 243),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("1000-1199",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 166, 240, 243),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("800-999",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 243, 166, 166),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("600-799",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 180, 166, 243),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("1600-1799",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 115, 107, 99),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("1400-1599",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 119, 52, 76),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("1200-1399",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 119, 124, 118),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(">2200",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 152, 124, 69),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("2000-2200",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 201, 58, 82),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("1800-1999",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 72, 107, 131),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                      ],
                    ),
                  ),
                if (filter_val == "price")
                  Container(
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("50K - 99.9K",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 243, 204, 166),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 3,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("10K - 49.9K",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 243, 166, 240),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 3,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("0 - 9.99K",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 166, 212, 243),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("1M - 1.99M",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 166, 240, 243),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 3,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("500K - 999K",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 243, 166, 166),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 3,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("100K - 499K",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 180, 166, 243),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("4M - 4.99M",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 115, 107, 99),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 3,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("3M - 3.99M",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 119, 52, 107),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 3,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("2M - 2.99M",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 119, 124, 118),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(">6,99M",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 211, 175, 103),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 3,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("6M - 6.99M",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 223, 65, 57),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 3,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 110,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromARGB(68, 178, 178, 178),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("5M - 5.99M",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Tajawal-m",
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(255, 72, 107, 131),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                      ],
                    ),
                  ),
              ]),
            ));
      },
    );
    ;
  }
}
