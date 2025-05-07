import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:homestay_host/src/features/homestay/domain/models/homestay_model.dart';
import 'package:homestay_host/src/features/homestay/domain/models/homestay_payload.dart';
import 'package:path/path.dart' as p;

class HomestayDatasource {
  final homestayDb = FirebaseFirestore.instance.collection('homestays');
  final _userDb = FirebaseFirestore.instance.collection('users');
  final _storage = FirebaseStorage.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<String> createHomestay(HomestayPayload payload) async {
    print('Creating homestay with payload: $payload');
    try {
      final userData = await _userDb.doc(uid).get();
      List<String> imageUrls = [];

      // 1. Create a new document reference for the homestay to get its ID
      DocumentReference homestayDocRef = homestayDb.doc();
      String homestayId = homestayDocRef.id;

      if (payload.images != null && payload.images!.isNotEmpty) {
        print('Uploading images...');
        for (int i = 0; i < payload.images!.length; i++) {
          var imageFile = payload.images![i];
          File image = File(imageFile.path);

          // Create a unique file name for the image
          String fileExtension = p.extension(imageFile.path);
          String fileName =
              '${DateTime.now().millisecondsSinceEpoch}_image_$i$fileExtension';

          // Path: homestay_images/userId/homestayId/fileName
          Reference storageRef = _storage.ref().child(
            'homestay_images/$uid/$homestayId/$fileName',
          );

          UploadTask uploadTask = storageRef.putFile(image);

          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          imageUrls.add(downloadUrl);
        }
      }

      print('creating homestay document...');

      await homestayDb.add({
        'id': homestayId,
        'hostId': userData.id,
        'title': payload.name,
        'description': payload.description,
        'location': payload.location,
        'pricePerNight': payload.pricePerNight,
        'amenities': payload.amenities,
        'images': [],
      });
      return 'success';
    } on FirebaseException catch (e) {
      print('Error creating homestay: ${e.message}');
      return e.message ?? "An error occurred";
    }
  }

  Stream<List<HomestayModel>> getHomestays() {
    return _userDb.doc(uid).snapshots().asyncMap((userData) async {
      final userId = userData.id;
      final response =
          await homestayDb.where('hostId', isEqualTo: userId).get();

      final homestayList = await Future.wait(
        response.docs.map((doc) async {
          final data = doc.data();
          return HomestayModel.fromJson(data);
        }),
      );
      return homestayList;
    });
  }

  Future<String> updateHomestay({
    required String homeStayId,
    required HomestayPayload payload,
  }) async {
    try {
      final userData = await _userDb.doc(uid).get();
      await homestayDb.doc(homeStayId).update({
        'hostId': userData.id,
        'title': payload.name,
        'description': payload.description,
        'location': payload.location,
        'pricePerNight': payload.pricePerNight,
        'amenities': payload.amenities,
      });
      return 'Updated';
    } on FirebaseException catch (e) {
      return e.message ?? 'An error occurred';
    }
  }

  Future<String> deleteHomeStay(String homeStayid) async {
    try {
      await homestayDb.doc(homeStayid).delete();
      return 'success';
    } on FirebaseException catch(e) {
      return e.message ?? 'Failed to delete home stay';
    }
  }
}
