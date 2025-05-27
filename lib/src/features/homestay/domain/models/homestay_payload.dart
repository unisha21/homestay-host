import 'package:homestay_host/src/features/homestay/domain/models/homestay_model.dart';
import 'package:image_picker/image_picker.dart';

class HomestayPayload {
  final String name;
  final String description;
  final String location;
  final String pricePerNight;
  final List<String> amenities;
  List<XFile>? images;
  final List<NearByPlace>? nearByPlaces;

  HomestayPayload({
    required this.name,
    required this.description,
    required this.location,
    required this.pricePerNight,
    required this.amenities,
    this.images,
    this.nearByPlaces,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'location': location,
      'pricePerNight': pricePerNight,
      'amenities': amenities,
      'images': images,
      'nearByPlaces': nearByPlaces?.map((e) => e.toJson()).toList(),
    };
  }
}