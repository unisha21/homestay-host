import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_host/src/features/homestay/data/datasource/homestay_datasource.dart';
import 'package:homestay_host/src/features/homestay/domain/models/homestay_model.dart';

final homeStayProvider = StreamProvider.autoDispose<List<HomestayModel>>(
  (ref) => HomestayDatasource().getHomestays(),
);
