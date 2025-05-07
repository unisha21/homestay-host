import 'package:image_picker/image_picker.dart';

class HomestayPayload {
  final String name;
  final String description;
  final String location;
  final String pricePerNight;
  final List<String> amenities;
  List<XFile>? images;

  HomestayPayload({
    required this.name,
    required this.description,
    required this.location,
    required this.pricePerNight,
    required this.amenities,
    this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'location': location,
      'pricePerNight': pricePerNight,
      'amenities': amenities,
      'images': images,
    };
  }
}