class HomestayModel {
  final String id;
  final String hostId;
  final String title;
  final String description;
  final String location;
  final double pricePerNight;
  final List<String> amenities;
  final List<String> images;

  HomestayModel({
    required this.id,
    required this.hostId,
    required this.title,
    required this.description,
    required this.location,
    required this.pricePerNight,
    required this.amenities,
    required this.images,
  });

  factory HomestayModel.fromJson(Map<String, dynamic> json) {
    return HomestayModel(
      id: json['id'] as String,
      hostId: json['hostId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      amenities: List<String>.from(json['amenities'] as List<dynamic>),
      images: List<String>.from(json['images'] as List<dynamic>),
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