import 'package:flutter/material.dart';
import 'package:homestay_host/src/features/order/domain/models/order_model.dart';
import 'package:homestay_host/src/features/order/screens/order_detail_screen.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});

  String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.rejected:
        return 'Rejected';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _statusToColor(BuildContext context, OrderStatus status) {
    final colors = Theme.of(context).colorScheme;
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.accepted:
        return Colors.green;
      case OrderStatus.rejected:
      case OrderStatus.cancelled:
        return colors.error;
      case OrderStatus.completed:
        return Colors.blue;
    }
  }

  // Simplified detail row or direct text widgets will be used
  Widget _buildEssentialDetail(
    BuildContext context,
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
    DateTime parsedOrderDate;
    try {
      parsedOrderDate = DateTime.parse(order.orderDetail.orderDate);
    } catch (e) {
      parsedOrderDate = DateTime.now(); // Fallback
    }

    final double pricePerNight = double.tryParse(order.price) ?? 0.0;
    final double totalPrice = pricePerNight * order.orderDetail.numberOfGuests;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailScreen(orderId: order.orderId),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12.0), // Reduced padding slightly
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2), // Slight shadow for depth
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // To make card height fit content
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    order.orderDetail.homeStayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusToColor(
                      context,
                      order.status,
                    ).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusToString(order.status),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _statusToColor(context, order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildEssentialDetail(
              context,
              Icons.person_outline,
              order.orderDetail.customerName,
            ),
            const SizedBox(height: 4),
            _buildEssentialDetail(
              context,
              Icons.calendar_today_outlined,
              dateFormat.format(parsedOrderDate),
            ),
            const SizedBox(height: 4),
            _buildEssentialDetail(
              context,
              Icons.people_outline,
              '${order.orderDetail.numberOfGuests} Guests',
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: ${NumberFormat.currency(
                  locale: 'en_np',
                  symbol: 'NPR ',
                  decimalDigits: 0, // No decimal for total in summary
                ).format(totalPrice)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            if (order.orderDetail.notes != null &&
                order.orderDetail.notes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.notes_outlined,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Has notes",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
