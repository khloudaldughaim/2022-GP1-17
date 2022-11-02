import 'property.dart';

class Building {
  final Property properties;
  final bool elevator;
  final int property_age;
  final int number_of_apartment;
  final int number_of_floor;
  final bool pool;
  
  Building({
    required this.properties,
    required this.elevator,
    required this.property_age,
    required this.number_of_apartment,
    required this.number_of_floor,
    required this.pool,
  });

  Map<String, dynamic> toMap() {
    return {
      'elevator': elevator,
      'property_age': property_age,
      'number_of_apartment': number_of_apartment,
      'number_of_floor': number_of_floor,
      'pool': pool,
    };
  }

  factory Building.fromMap(Map<String, dynamic> map) {
    return Building(
      properties: Property.fromMap(map),
      elevator: map['elevator'] ?? false,
      pool: map['pool'] ?? false,
      property_age: map['property_age']?.toInt() ?? 0,
      number_of_apartment: map['number_of_apartment']?.toInt() ?? 0,
      number_of_floor: map['number_of_floors']?.toInt() ?? 0,
    );
  }
}