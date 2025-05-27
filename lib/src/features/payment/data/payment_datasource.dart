import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homestay_host/src/features/payment/domain/payment_model.dart';

class PaymentDataSource{
  final _paymentDb = FirebaseFirestore.instance.collection('payments');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<PaymentDetailModel>> getPaymentHistory() async {
    try {
      final snapshot = await _paymentDb.where('hostId', isEqualTo: userId).get();
      final data = snapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data();
        return PaymentDetailModel.fromJson(data);
      }).toList();
      return data;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    }
  }

}