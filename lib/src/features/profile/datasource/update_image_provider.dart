import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_host/src/features/profile/datasource/profile_datasource.dart';
import 'package:image_picker/image_picker.dart';

final updateImageProvider = FutureProvider.family(
  (ref, XFile image) => ProfileDataSource().uploadImage(image: image),
);
