class Property{
  
  final String user_id ;
  final String property_id ;
  final List available_time ;
  final String classification ;
  final String location ;
  final num price ;
  final num space ;
  final int number_of_bathroom ;
  final int number_of_room ;
  final bool pool ;
  final bool basement ;
  final bool elevator ;
  final num property_age ;
  final String type;
  final String city ;
  final String neighborhood ;
  final List images ;

  Property(
  {
    required this.user_id,
    required this.property_id,
    required this.available_time,
    required this.classification,
    required this.location,
    required this.price,
    required this.space,
    required this.number_of_bathroom,
    required this.number_of_room,
    required this.pool,
    required this.basement,
    required this.elevator,
    required this.property_age,
    required this.type,
    required this.city,
    required this.neighborhood,
    required this.images
  }
);

Map<String, dynamic> toJson() => {
  'user_id' : user_id,
  'property_id' : property_id,
  'available_time' : available_time,
  'classification' : classification,
  'location' : location,
  'price' : price,
  'space' : space,
  'number_of_bathroom' : number_of_bathroom,
  'number_of_room' : number_of_room,
  'pool' : pool,
  'basement' : basement,
  'elevator' : elevator,
  'property_age' : property_age,
  'type' : type,
  'city' : city,
  'neighborhood' : neighborhood,
  'images' : images,
};

static Property fromJson(Map<String, dynamic> json) => Property(
  user_id: json['user_id'],
  property_id: json['property_id'],
  available_time: json['available_time'],
  classification: json['classification'],
  location: json['location'],
  price: json['price'],
  space: json['space'],
  number_of_bathroom: json['number_of_bathroom'],
  number_of_room: json['number_of_room'],
  pool: json['pool'],
  basement: json['basement'],
  elevator: json['elevator'],
  property_age: json['property_age'],
  type: json['type'],
  city: json['city'],
  neighborhood: json['neighborhood'],
  images: json['image'],
);

}