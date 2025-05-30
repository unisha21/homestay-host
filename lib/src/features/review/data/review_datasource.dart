import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homestay_host/src/features/review/domain/review_model.dart';

class ReviewDataSource {
  final _reviewDb = FirebaseFirestore.instance.collection('reviews');
  
  /// id is [homeStayId]
  Stream<List<ReviewModel>> getReviewsStream(String id) {
    try {
      final data = _reviewDb.where('homeStayId', isEqualTo: id).snapshots();
      final response = data.asyncMap((event) async {
        final data = Future.wait(
          event.docs.map((e) async {
            final json = e.data();
            return ReviewModel.fromJson({...json, 'reviewId': e.id});
          }).toList(),
        );
        return data;
      });
      return response;
    } on FirebaseException catch (error) {
      throw '$error';
    }
  }
}
