import 'property.dart';

class Villa {
  final int number_of_bathroom;
  final int number_of_room;
  final bool pool;
  final bool basement;
  final bool elevator;
  final int number_of_floor;
  final int number_of_livingRooms;
  final int property_age;
  final Property properties;
  
  Villa({
    required this.number_of_bathroom,
    required this.number_of_room,
    required this.pool,
    required this.basement,
    required this.elevator,
    required this.number_of_floor,
    required this.number_of_livingRooms,
    required this.property_age,
    required this.properties,
  });

  Map<String, dynamic> toMap() {
    return {
      'number_of_bathroom': number_of_bathroom,
      'number_of_room': number_of_room,
      'pool': pool,
      'basement': basement,
      'elevator': elevator,
      'number_of_floor': number_of_floor,
      'number_of_livingRooms': number_of_livingRooms,
      'property_age': property_age,
      'properties': properties.toMap(),
    };
  }

  factory Villa.fromMap(Map<String, dynamic> map) {
    return Villa(
      number_of_bathroom: map['number_of_bathroom']?.toInt() ?? 0,
      number_of_room: map['number_of_room']?.toInt() ?? 0,
      pool: map['pool'] ?? false,
      basement: map['basement'] ?? false,
      elevator: map['elevator'] ?? false,
      number_of_floor: map['number_of_floors']?.toInt() ?? 0,
      number_of_livingRooms: map['number_of_livingRooms']?.toInt() ?? 0,
      property_age: map['property_age']?.toInt() ?? 0,
      properties: Property.fromMap(map),
    );
  }
}