class Property {
  String property_id;
  String User_id;
  String classification;
  double latitude;
  double longitude;
  String price;
  String space;
  String city;
  String neighborhood;
  List<String> images;
  String description;
  String Location;
  String type;
  String purpose;
  
  Property({
    required this.property_id,
    required this.User_id,
    required this.classification,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.space,
    required this.city,
    required this.neighborhood,
    required this.images,
    required this.description,
    required this.Location,
    required this.type,
    required this.purpose,
  });

  Map<String, dynamic> toMap() {
    return {
      'property_id': property_id,
      'User_id': User_id,
      'classification': classification,
      'latitude': latitude,
      'longitude': longitude,
      'price': price,
      'space': space,
      'city': city,
      'neighborhood': neighborhood,
      'images': images,
      'Location': Location,
      'description': description,
      'type': type,
      'purpose': purpose,
    };
  }

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      property_id: map['property_id'] ?? '',
      User_id: map['User_id'] ?? '',
      classification: map['classification'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      price: map['price'] ?? '',
      space: map['space'] ?? '',
      city: map['city'] ?? '',
      neighborhood: map['neighborhood'] ?? '',
      images: List.from(map['images']),
      Location: map['Location'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? '',
      purpose: map['propertyUse'] ?? '',
    );
  }
}