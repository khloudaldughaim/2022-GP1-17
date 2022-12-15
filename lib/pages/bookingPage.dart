
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:booking_calendar/booking_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:date_time_picker/date_time_picker.dart';



class boookingPage extends StatefulWidget {

  final String property_id;

  boookingPage({required this.property_id});

  //const boookingPage({Key? key, required Apartment Apartment}) : super(key: key);
  @override
  State<boookingPage> createState() => _BookingPagestate();

}

class _BookingPagestate extends State<boookingPage> {
//'${widget.User_id}' to call User_id from up 

late FirebaseAuth auth = FirebaseAuth.instance;
late User? user = auth.currentUser;
late String curentId = user!.uid;

  final now = DateTime.now();
  DateTime Reseve = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(child: Column(
                children: [
                      Text(
                        '${now.day} / ${now.month}'
                      ),
  ElevatedButton(onPressed: () async {
DateTime? ReservedDate= await showDatePicker(context: context, 
initialDate: now, 
firstDate: now, 
lastDate: DateTime(2024));
 
 if(ReservedDate == null)
 return;

// setState(() {
//   Reseve = ReservedDate ; 
// });

TimeOfDay? ReservedTime = await showTimePicker(
context: context, 
initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
);

 if(ReservedTime == null)
 return;


final NewReseration = DateTime(
ReservedDate.year,
ReservedDate.month,
ReservedDate.day,
ReservedTime.hour,
ReservedTime.minute,
); 

FirebaseFirestore.instance.collection('properties').doc('${widget.property_id}')
        .collection('bookings')
        .add({
"Date" : NewReseration,
"property_id" : '${widget.property_id}', 
"buyer_id" : curentId,
        })
        .then((value) => print("Booking Added"))
        .catchError((error) => print("Failed to add booking: $error"));

  } ,

child: Text("")),

// Text( '${Reseve.day} / ${Reseve.month}')

                ],


        )),
      
               
          
      )
    );
      
  }
}



































// OLD CODE 
late BookingService mockBookingService;

//   @override
//   void initState() {
//    initializeDateFormatting();

//     super.initState();
//     // DateTime.now().startOfDay
//     // DateTime.now().endOfDay
//     mockBookingService = BookingService(
//         serviceName: 'Mock Service',
//         serviceDuration: 30,
//         bookingEnd: DateTime(now.year, now.month, now.day, 18, 0),
//         bookingStart: DateTime(now.year, now.month, now.day, 8, 0));
//   }

//   Stream<dynamic>? getBookingStreamMock(
//       {required DateTime end, required DateTime start}) {
//     return Stream.value([]);
//   }


//   Future<dynamic> uploadBookingMock( // here when user click on book button 
//       {required BookingService newBooking}) async {
//     Timestamp.fromDate(newBooking.bookingStart ?? DateTime.now());
//     Timestamp.fromDate(newBooking.bookingEnd ?? DateTime.now());

//     await FirebaseFirestore.instance.collection('properties').doc('${widget.User_id}')
//         .collection('bookings')
//         .add(newBooking.toJson())
//         .then((value) => print("Booking Added"))
//         .catchError((error) => print("Failed to add booking: $error"));

//   }

 
  

//  static Timestamp dateTimeToTimeStamp(DateTime? dateTime) {
//       return Timestamp.fromDate(dateTime ?? DateTime.now()); //To TimeStamp
//   }


//   List<DateTimeRange> converted = [];

//   List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
//     // /here you can parse the streamresult and convert to [List<DateTimeRange>]
//     // /take care this is only mock, so if you add today as disabledDays it will still be visible on the first load
//     // /disabledDays will properly work with real data
//     DateTime first = now;
//     DateTime second = now.add(const Duration(minutes: 55));
//     DateTime third = now.subtract(const Duration(minutes: 240));
//     DateTime fourth = now.subtract(const Duration(minutes: 500));
//     converted.add(
//         DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
//     converted.add(DateTimeRange(
//         start: second, end: second.add(const Duration(minutes: 23))));
//     converted.add(DateTimeRange(
//         start: third, end: third.add(const Duration(minutes: 15))));
//     converted.add(DateTimeRange(
//         start: fourth, end: fourth.add(const Duration(minutes: 50))));
//     return converted;
//   }

//   List<DateTimeRange> generatePauseSlots() {
//     return [
//       DateTimeRange(
//           start: DateTime(now.year, now.month, now.day, 12, 0),
//           end: DateTime(now.year, now.month, now.day, 13, 0))
//     ];
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SafeArea(
//         child: 
      
//                 Column(
//                   children: [
//                     Expanded(
//                       child: BookingCalendar(
//                        bookingService: mockBookingService,
//                        convertStreamResultToDateTimeRanges: convertStreamResultMock,
//                        getBookingStream: getBookingStreamMock,
//                        uploadBooking: uploadBookingMock,
//                         pauseSlots: generatePauseSlots(),
//                         pauseSlotText: 'LUNCH',
//                         hideBreakTime: false,
//                         loadingWidget: const Text('Fetching data...'),
//                         uploadingWidget: const CircularProgressIndicator(),
//                         locale: 'hu_HU',
//                         startingDayOfWeek: StartingDayOfWeek.tuesday,
//                         disabledDays: const [6, 7], 
//                     bookingButtonColor: Color.fromARGB(255, 140, 179, 211),
//                             bookingButtonText: "حجز",
//                       ),
//                     ),
                     
//                   ],
//                 ),
          
            
          
//       ),
//     );
//   }