import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_host/src/common/widgets/build_button.dart';
import 'package:homestay_host/src/common/widgets/build_text_field.dart';
import 'package:homestay_host/src/features/auth/screens/widgets/build_dialogs.dart';
import 'package:homestay_host/src/features/homestay/data/datasource/homestay_datasource.dart';
import 'package:homestay_host/src/features/homestay/data/home_stay_provider/home_stay_provider.dart';
import 'package:homestay_host/src/features/homestay/domain/models/homestay_model.dart';
import 'package:homestay_host/src/features/homestay/domain/models/homestay_payload.dart';
import 'package:homestay_host/src/features/homestay/screens/widgets/input_chip_field.dart';
import 'package:homestay_host/src/themes/extensions.dart';
import 'package:image_picker/image_picker.dart';

class UpdateHomestayScreen extends ConsumerStatefulWidget {
  final HomestayModel homestay;

  const UpdateHomestayScreen({super.key, required this.homestay});

  @override
  ConsumerState<UpdateHomestayScreen> createState() =>
      _UpdateHomestayScreenState();
}

class _UpdateHomestayScreenState extends ConsumerState<UpdateHomestayScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<XFile> images = [];
  List<String> existingImages = [];
  List<NearByPlace> nearByPlaces = []; // Added

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  // final _amenitiesController = TextEditingController(); // Removed

  List<String> amenities = <String>[];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Prefill the form with existing data
    _titleController.text = widget.homestay.title;
    _descriptionController.text = widget.homestay.description;
    _priceController.text = widget.homestay.pricePerNight.toStringAsFixed(
      0,
    ); // Ensure correct formatting
    _locationController.text = widget.homestay.location;
    amenities = List<String>.from(
      widget.homestay.amenities,
    ); // Ensure mutable list
    existingImages = List<String>.from(
      widget.homestay.images,
    ); // Ensure mutable list
    // Initialize nearByPlaces, ensuring it's a new mutable list
    nearByPlaces =
        widget.homestay.nearByPlaces
            ?.map(
              (place) => NearByPlace(
                name: place.name,
                description: place.description,
                distance: place.distance,
              ),
            )
            .toList() ??
        [];
  }

  Future<void> _pickImage() async {
    if (images.length + existingImages.length >= 6) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You can select a maximum of 6 images.'),
          ),
        );
      }
      return;
    }

    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 50,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          int availableSlots = 6 - (images.length + existingImages.length);
          int filesToAddCount =
              pickedFiles.length > availableSlots
                  ? availableSlots
                  : pickedFiles.length;

          images.addAll(pickedFiles.take(filesToAddCount));

          if (pickedFiles.length > filesToAddCount && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Maximum 6 images allowed. Only ${filesToAddCount > 0 ? "$filesToAddCount more images were" : "no more images could be"} added.',
                ),
              ),
            );
          }
        });
      }
    } catch (e) {
      print('Error picking images: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking images: $e')));
      }
    }
  }

  void _removeImage(int index, {bool isExisting = false}) {
    setState(() {
      if (isExisting) {
        existingImages.removeAt(index);
      } else {
        images.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Listing'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Update your listing details.',
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      BuildTextFormField(
                        controller: _titleController,
                        labelText: 'Title',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      BuildTextFormField(
                        controller: _locationController,
                        labelText: 'Address',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      BuildTextFormField(
                        controller: _priceController,
                        labelText: 'Price per head',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter price';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      EditableChipField(
                        initialValues: amenities,
                        onChanged: (List<String> items) {
                          setState(() {
                            amenities = items;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildNearbyPlacesSection(), // Added
                      const SizedBox(height: 16),
                      BuildTextField(
                        maxLine: 4,
                        controller: _descriptionController,
                        textInputType: TextInputType.text,
                        labelText: 'Description',
                        hintText:
                            'Example: This is a beautiful homestay with nature and peace.',
                        alignLabelToTop: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please tell us about your homestay';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Upload media',
                        style: context.theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          ...existingImages.asMap().entries.map((entry) {
                            int idx = entry.key;
                            String imageUrl = entry.value;
                            return Stack(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: InkWell(
                                    onTap:
                                        () =>
                                            _removeImage(idx, isExisting: true),
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          ...images.asMap().entries.map((entry) {
                            int idx = entry.key;
                            XFile imageFile = entry.value;
                            return Stack(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: FileImage(File(imageFile.path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: InkWell(
                                    onTap: () => _removeImage(idx),
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          if (images.length + existingImages.length < 6)
                            InkWell(
                              onTap: _pickImage,
                              borderRadius: BorderRadius.circular(10),
                              child: Ink(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                boxShadow: [
                  const BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: BuildButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  if (_formKey.currentState!.validate()) {
                    if (images.length + existingImages.length < 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least 4 images.'),
                        ),
                      );
                      return;
                    }

                    final payload = HomestayPayload(
                      name: _titleController.text,
                      description: _descriptionController.text,
                      location: _locationController.text,
                      pricePerNight: _priceController.text.trim(),
                      amenities: amenities,
                      images: images,
                      nearByPlaces: nearByPlaces, // Added
                    );

                    buildLoadingDialog(context, "Updating your property...");
                    final response = await HomestayDatasource().updateHomestay(
                      homeStayId: widget.homestay.id,
                      payload: payload,
                    );
                    navigator.pop(); // Close the loading dialog
                    if (response != 'Updated') {
                      if (!context.mounted) return;
                      buildErrorDialog(context, response);
                    } else {
                      if (!context.mounted) return;
                      ref.invalidate(homeStayProvider);
                      ref.read(homeStayProvider);
                      buildSuccessDialog(context, response, () {
                        navigator.pop(); // Close the success dialog
                        navigator.pop(); // Close the update screen
                      });
                    }
                  }
                },
                buttonWidget: const Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Added: _buildNearbyPlacesSection method (similar to CreateListingScreen)
  Widget _buildNearbyPlacesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nearby Places',
              style: context.theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _addOrEditNearbyPlace(),
            ),
          ],
        ),
        if (nearByPlaces.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'No nearby places added yet. Click the + icon to add one.',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: nearByPlaces.length,
            itemBuilder: (context, index) {
              final place = nearByPlaces[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  title: Text(place.name),
                  subtitle: Text(
                    '${place.description}${place.distance != null && place.distance!.isNotEmpty ? " - ${place.distance} away" : ""}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () => _addOrEditNearbyPlace(index: index),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            nearByPlaces.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  // Added: _addOrEditNearbyPlace method (using plain Dialog, similar to CreateListingScreen)
  void _addOrEditNearbyPlace({int? index}) {
    final placeNameController = TextEditingController(
      text: index != null ? nearByPlaces[index].name : '',
    );
    final placeDescriptionController = TextEditingController(
      text: index != null ? nearByPlaces[index].description : '',
    );
    final distanceController = TextEditingController(
      text: index != null ? nearByPlaces[index].distance : '',
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          title: Text(index == null ? 'Add Nearby Place' : 'Edit Nearby Place'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BuildTextFormField(
                  controller: placeNameController,
                  labelText: 'Place Name',
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Please enter place name' : null,
                ),
                const SizedBox(height: 16),
                BuildTextField(
                  controller: placeDescriptionController,
                  labelText: 'Description',
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Please enter description' : null,
                  maxLine: 4,
                ),
                const SizedBox(height: 16),
                BuildTextFormField(
                  controller: distanceController,
                  labelText: 'Distance (e.g., 500m, 1km)',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(index == null ? 'Add' : 'Save'),
              onPressed: () {
                if (placeNameController.text.isEmpty ||
                    placeDescriptionController.text.isEmpty) {
                  return;
                }
                final newPlace = NearByPlace(
                  name: placeNameController.text,
                  description: placeDescriptionController.text,
                  distance: distanceController.text,
                );
                setState(() {
                  if (index != null) {
                    nearByPlaces[index] = newPlace;
                  } else {
                    nearByPlaces.add(newPlace);
                  }
                });
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
