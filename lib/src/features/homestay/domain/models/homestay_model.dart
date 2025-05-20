class HomestayModel {
  final String id;
  final String hostId;
  final String title;
  final String description;
  final String location;
  final String pricePerNight;
  final List<String> amenities;
  final List<String> images;
  final List<NearByPlace>? nearByPlaces;

  HomestayModel({
    required this.id,
    required this.hostId,
    required this.title,
    required this.description,
    required this.location,
    required this.pricePerNight,
    required this.amenities,
    required this.images,
    this.nearByPlaces,
  });

  factory HomestayModel.fromJson(Map<String, dynamic> json) {
    return HomestayModel(
      id: json['id'] as String,
      hostId: json['hostId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      pricePerNight: json['pricePerNight'] as String,
      amenities: List<String>.from(json['amenities'] as List<dynamic>),
      images: List<String>.from(json['images'] as List<dynamic>),
      nearByPlaces: (json['nearByPlaces'] as List<dynamic>?)
          ?.map((e) => NearByPlace.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hostId': hostId,
      'title': title,
      'description': description,
      'location': location,
      'pricePerNight': pricePerNight,
      'amenities': amenities,
      'images': images,
    };
  }
}

class NearByPlace {
  final String name;
  final String description;
  final String? distance;

  NearByPlace({required this.name, required this.description, this.distance});
  factory NearByPlace.fromJson(Map<String, dynamic> json) {
    return NearByPlace(
      name: json['name'] as String,
      description: json['description'] as String,
      distance: json['distance'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'distance': distance};
  }
}
