import 'property.dart';

class Land {
  Property? properties;

  Land({
    this.properties,
  });

  factory Land.fromJson(Map<String, dynamic> json) => Land(
        properties: Property.fromMap(json),
      );
}