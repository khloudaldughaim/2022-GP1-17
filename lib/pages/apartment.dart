import 'property.dart';

class Apartment {
  final Property properties;
  final int number_of_bathroom;
  final int number_of_room;
  final String in_floor;
  final int number_of_floor; //CHECK
  final int number_of_livingRooms;
  final bool elevator;
  final num property_age;

  Apartment({
    required this.properties,
    required this.number_of_bathroom,
    required this.number_of_room,
    required this.in_floor,
    required this.number_of_floor,
    required this.number_of_livingRooms,
    required this.elevator,
    required this.property_age,
  });

  Map<String, dynamic> toMap() {
    return {
      'number_of_bathroom': number_of_bathroom,
      'number_of_room': number_of_room,
      'in_floor': in_floor,
      'number_of_floor': number_of_floor,
      'number_of_livingRooms': number_of_livingRooms,
      'elevator': elevator,
      'property_age': property_age,
    };
  }

  factory Apartment.fromMap(Map<String, dynamic> map) {
    return Apartment(
      properties: Property.fromMap(map),
      number_of_bathroom: map['number_of_bathroom']?.toInt() ?? 0,
      number_of_room: map['number_of_room']?.toInt() ?? 0,
      in_floor: map['in_floor'] ?? '',
      number_of_floor: map['number_of_floor']?.toInt() ?? 0,
      number_of_livingRooms: map['number_of_livingRooms']?.toInt() ?? 0,
      elevator: map['elevator'] ?? false,
      property_age: map['property_age']?.toInt() ?? 0,
    );
  }
}
