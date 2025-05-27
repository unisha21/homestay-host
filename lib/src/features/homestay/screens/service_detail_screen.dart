import 'package:flutter/material.dart';
import 'package:homestay_host/src/features/homestay/domain/models/homestay_model.dart';
import 'package:homestay_host/src/features/homestay/screens/widgets/carousel_image.dart';
import 'package:homestay_host/src/themes/extensions.dart';

class ServiceDetailScreen extends StatefulWidget {
  final HomestayModel _homestay;
  const ServiceDetailScreen(this._homestay, {super.key});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: 16,
        children: [
          AspectRatio(
            aspectRatio: 16 / 11,
            child: Stack(
              children: [
                CarouselImage(imageUrls: widget._homestay.images),
                Positioned(
                  top: 50,
                  left: 12,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.surface.withAlpha(200),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget._homestay.title,
                          style: context.theme.textTheme.titleLarge,
                        ),
                        Text(
                          '4.2 ⭐',
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.pin_drop_outlined,
                        color: context.theme.colorScheme.primary,
                        size: 16,
                      ),
                      Text(
                        widget._homestay.location,
                        style: context.theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Text(
                    widget._homestay.description,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: context.theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'What\'s included',
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _IncludedAmenities(amenities: widget._homestay.amenities),
                  const SizedBox(height: 4),
                  NearByPlaces(nearByPlaces: widget._homestay.nearByPlaces ?? []),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IncludedAmenities extends StatelessWidget {
  final List<String> amenities;
  const _IncludedAmenities({required this.amenities});

  Map<String, dynamic> get amenitiesMap {
    return {
      'WiFi': Icons.wifi,
      'Parking': Icons.local_parking,
      'Breakfast': Icons.free_breakfast,
      'Air Conditioning': Icons.ac_unit,
      'Swimming Pool': Icons.pool,
      'TV': Icons.tv,
      'Kitchen': Icons.kitchen,
      'Washer': Icons.local_laundry_service,
      'Pet Friendly': Icons.pets,
      'Gym': Icons.fitness_center,
      'Elevator': Icons.elevator,
      'Fireplace': Icons.fireplace,
      'Balcony': Icons.balcony,
      'Smoke Detector': Icons.smoke_free,
      // Add more mappings as needed
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: List.generate(amenities.length, (index) {
          return Text(
            "- ${amenities[index]}",
            style: context.theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
          );
        }),
      ),
    );
  }
}


class NearByPlaces extends StatelessWidget {
  final List<NearByPlace> nearByPlaces;
  const NearByPlaces({super.key, required this.nearByPlaces});

  @override
  Widget build(BuildContext context) {
    if(nearByPlaces.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          'Nearby Places',
          style: context.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        ...nearByPlaces.map(
          (place) => Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  place.name,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  place.description,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (place.distance != null)
                  Text(
                    'Distance: ${place.distance}',
                    style: context.theme.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
        
      ],
    );
  }
}