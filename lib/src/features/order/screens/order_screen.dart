import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_host/src/features/order/data/order_provider.dart';
import 'package:homestay_host/src/features/order/domain/models/order_model.dart';
import 'package:homestay_host/src/features/order/screens/widgets/order_card.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderData = ref.watch(orderProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Orders'),
      ),
      body: orderData.when(
        data: (data) {
          final orderList = data.where((element) {
            return element.status == OrderStatus.pending || element.status == OrderStatus.accepted;
          }).toList();
          return orderList.isEmpty ? Center(
            child: Text(
              'No orders yet',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ) : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ListView.separated(
              padding: EdgeInsets.only(top: 14),
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                return OrderCard(order: orderList[index],);
              },
              separatorBuilder: (context, index) => SizedBox(height: 14,),
            ),
          );
        },
        error: (error, stackTrace) => Center(child: Text('$error'),),
        loading: () => const Center(child: CircularProgressIndicator(),),
      )
    );
  }
}
