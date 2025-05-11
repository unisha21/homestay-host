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
  const _IncludedAmenities({super.key, required this.amenities});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          _buildIconWithText(context, icon: Icons.wifi, text: 'Free Wi-Fi'),
          _buildIconWithText(context, icon: Icons.kitchen, text: 'Kitchen'),
          _buildIconWithText(context, icon: Icons.tv, text: 'TV'),
          _buildIconWithText(context, icon: Icons.pool, text: 'Swimming Pool'),
        ],
      ),
    );
  }

  Widget _buildIconWithText(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      spacing: 8,
      children: [
        Icon(icon, color: context.theme.colorScheme.primary, size: 16),
        Text(
          text,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
            color: context.theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
