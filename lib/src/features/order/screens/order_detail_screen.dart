import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_host/src/common/widgets/build_button.dart';
import 'package:homestay_host/src/features/auth/screens/widgets/build_dialogs.dart';
import 'package:homestay_host/src/features/order/data/order_datasource.dart';
import 'package:homestay_host/src/features/order/data/order_provider.dart';
import 'package:homestay_host/src/features/order/domain/models/order_model.dart'; // Ensure this path is correct
import 'package:intl/intl.dart';

// Assuming these are defined elsewhere, or you might need to define them.
// import 'package:homestay_host/src/themes/app_colors.dart'; // For AppColor.primaryRed
// import 'package:homestay_host/src/common_widgets/build_text_field.dart'; // For BuildTextField
// import 'package:homestay_host/src/common_widgets/build_button.dart'; // For BuildButton
// import 'package:homestay_host/src/features/chat/screens/chat_screen.dart'; // For ChatScreen
// import 'package:homestay_host/src/features/chat/data/chat_provider.dart'; // For roomProvider
// import 'package:homestay_host/src/features/notification/data/notification_datasource.dart'; // For NotificationDataSource

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  final _formKey = GlobalKey<FormState>(); // Changed from formKey to _formKey
  final _textController = TextEditingController();
  final _reasonController = TextEditingController();
  // late String formattedDate; // Will be formatted directly in build

  @override
  void initState() {
    super.initState();
    // Fetch initial data or set up listeners if needed
  }

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

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
    TextStyle? valueStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: valueStyle ?? Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderDetailAsyncValue = ref.watch(
      orderDetailProvider(widget.orderId),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Order Details'),
        elevation: 1,
        actions: [
          orderDetailAsyncValue.when(
            data:
                (data) =>
                    data.status == OrderStatus.accepted ||
                            data.status ==
                                OrderStatus
                                    .pending // Condition for showing complete
                        ? PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'complete') {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Confirm Completion'),
                                      content: const Text(
                                        'Are you sure you want to mark this order as completed?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: const Text('Complete'),
                                        ),
                                      ],
                                    ),
                              );
                              if (confirmed == true) {
                                buildLoadingDialog(
                                  context,
                                  "Completing order...",
                                );
                                final response = await OrderDataSource()
                                    .completeOrder(orderId: widget.orderId);
                                if (!context.mounted) return;
                                Navigator.pop(context); // pop loading dialog
                                buildSuccessDialog(context, response, () {
                                  Navigator.pop(context); // pop success dialog
                                  Navigator.pop(
                                    context,
                                  ); // pop order detail screen
                                });
                              }
                            }
                          },
                          itemBuilder:
                              (
                                BuildContext context,
                              ) => <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'complete',
                                  child: ListTile(
                                    leading: Icon(Icons.check_circle_outline),
                                    title: Text('Mark as Completed'),
                                  ),
                                ),
                              ],
                        )
                        : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: orderDetailAsyncValue.when(
        data: (data) {
          _textController.text = data.orderDetail.notes ?? '';
          DateTime parsedOrderDate;
          try {
            parsedOrderDate = DateTime.parse(data.orderDetail.orderDate);
          } catch (e) {
            parsedOrderDate = DateTime.now(); // Fallback
          }
          final formattedDate = DateFormat(
            'MMMM dd, yyyy (EEE)',
          ).format(parsedOrderDate);
          final double pricePerNight = double.tryParse(data.price) ?? 0.0;
          final double advancePayment =
              double.tryParse(data.advancePayment) ?? 0.0;
          final double totalPrice =
              pricePerNight * data.orderDetail.numberOfGuests;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Header
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                data.orderDetail.homeStayName,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: _statusToColor(
                                  context,
                                  data.status,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _statusToString(data.status),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: _statusToColor(context, data.status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Order ID: ${data.orderId}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Customer Details
                _buildSectionTitle(context, 'Customer Details'),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          context,
                          'Name:',
                          data.orderDetail.customerName,
                          icon: Icons.person_outline,
                        ),
                        _buildDetailRow(
                          context,
                          'Phone:',
                          data.orderDetail.customerPhone,
                          icon: Icons.phone_outlined,
                        ),
                        // _buildDetailRow(context, 'Address:', data.orderDetail.customerAddress ?? 'N/A', icon: Icons.location_on_outlined), // Assuming customerAddress exists
                      ],
                    ),
                  ),
                ),

                // Booking Details
                _buildSectionTitle(context, 'Booking Details'),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          context,
                          'Date:',
                          formattedDate,
                          icon: Icons.calendar_today_outlined,
                        ),
                        _buildDetailRow(
                          context,
                          'Nights:',
                          data.orderDetail.numberOfNights.toString(),
                          icon: Icons.nights_stay_outlined,
                        ),
                        _buildDetailRow(
                          context,
                          'Guests:',
                          data.orderDetail.numberOfGuests.toString(),
                          icon: Icons.people_alt_outlined,
                        ),
                      ],
                    ),
                  ),
                ),

                // Pricing Details
                _buildSectionTitle(context, 'Payment Details'),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          context,
                          'Price/Night:',
                          NumberFormat.currency(
                            locale: 'en_IN',
                            symbol: 'NPR ',
                            decimalDigits: 2,
                          ).format(pricePerNight),
                        ),
                        _buildDetailRow(
                          context,
                          'Total Amount:',
                          NumberFormat.currency(
                            locale: 'en_IN',
                            symbol: 'NPR ',
                            decimalDigits: 2,
                          ).format(totalPrice),
                          valueStyle: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        _buildDetailRow(
                          context,
                          'Advance Paid:',
                          NumberFormat.currency(
                            locale: 'en_IN',
                            symbol: 'NPR ',
                            decimalDigits: 2,
                          ).format(advancePayment),
                          valueStyle: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Notes
                if (data.orderDetail.notes != null &&
                    data.orderDetail.notes!.isNotEmpty) ...[
                  _buildSectionTitle(context, 'Notes from Customer'),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        data.orderDetail.notes!,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                // Action Buttons
                displayButton(context, data.status, data),
                const SizedBox(height: 20), // For bottom padding
              ],
            ),
          );
        },
        error:
            (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Failed to load order details: $error',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget displayButton(
    BuildContext context,
    OrderStatus status,
    OrderModel data,
  ) {
    if (status == OrderStatus.accepted) {
      return BuildButton(
        onPressed: () async {
          // final navigator = Navigator.of(context);
          // final currentUser = FirebaseAuth.instance.currentUser!.uid;
          // final scaffoldMessage = ScaffoldMessenger.of(context);
          // final response = await ref.read(roomProvider).createRoom(data.user); // Assuming roomProvider is available
          // final otherUser = response?.users.firstWhere(
          //   (element) => element.id != currentUser,
          //   orElse: () => data.user, // Fallback, ensure data.user is compatible
          // );
          // if (response != null && otherUser != null) {
          //   navigator.push(
          //     MaterialPageRoute(
          //       builder: (_) =>
          //           ChatScreen(room: response, name: otherUser.firstName ?? 'Customer'), // Assuming ChatScreen is available
          //     ),
          //   );
          // } else {
          //   scaffoldMessage.showSnackBar(
          //     const SnackBar(
          //       duration: Duration(milliseconds: 1500),
          //       content: Text("Could not initiate chat."),
          //     ),
          //   );
          // }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Message Customer: Placeholder")),
          );
        },
        buttonWidget: Text('Message Customer'),
      );
    } else if (status == OrderStatus.completed ||
        status == OrderStatus.rejected ||
        status == OrderStatus.cancelled) {
      return const SizedBox.shrink(); // No actions for these statuses
    } else if (status == OrderStatus.pending) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _buildRejectModal(context, data);
              },
              child: Text('Decline'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: BuildButton(
              onPressed: () async {
                buildLoadingDialog(context, 'Accepting Order...');
                await Future.delayed(const Duration(seconds: 1));
                final response = await OrderDataSource().acceptOrder(
                  orderId: widget.orderId,
                );

                if (!context.mounted) return;
                Navigator.pop(context);

                if (response == "Order accepted") {
                  ref.invalidate(
                    orderDetailProvider(widget.orderId),
                  ); // Refresh data
                  ref.invalidate(orderProvider); // Refresh list if any
                  // Potentially send notification
                } else {
                  buildErrorDialog(context, "Failed to accept order.");
                }
              },
              buttonWidget: Text('Accept'),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink(); // Default fallback
  }

  Future<dynamic> _buildRejectModal(
    BuildContext context,
    OrderModel orderData,
  ) {
    // Renamed from buildRejectModal to _buildRejectModal
    _reasonController.clear();
    return showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        // Changed context to modalContext to avoid conflict
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(
                  modalContext,
                ).viewInsets.bottom, // Use modalContext
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reason for Rejection',
                  style: Theme.of(modalContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  maxLines: 5,
                  autofocus: true,
                  controller: _reasonController,
                  decoration: InputDecoration(
                    hintText: 'Enter reason for rejection',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason for rejection.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // final navigator = Navigator.of(modalContext); // Use modalContext's navigator
                        // buildLoadingDialog(modalContext, 'Rejecting Order...');

                        // // final response = await ref.read(
                        // //   rejectOrderProvider(orderData.orderId).future,
                        // // ); // This seems to be a Riverpod specific call
                        // // Placeholder for actual rejection logic:
                        // final response = await OrderDataSource().updateOrderStatus(orderId: orderData.orderId, status: OrderStatus.rejected.index, reason: _reasonController.text.trim());

                        // if (!mounted) return; // Check if the main widget is still mounted
                        // Navigator.pop(modalContext); // Pop loading dialog

                        // if (response == 'Status Updated') { // Assuming this is the success string
                        //   // await NotificationDataSource().sendNotification(
                        //   //   token: orderData.user.metadata?['deviceToken'],
                        //   //   title: 'Order Rejected',
                        //   //   message: 'Your order for ${orderData.orderDetail.homeStayName} has been rejected. Reason: ${_reasonController.text.trim()}',
                        //   //   notificationData: {
                        //   //     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                        //   //     'type': 'order',
                        //   //     'route': 'notification', // Or specific order detail route for user
                        //   //   },
                        //   // );
                        //   // await OrderDataSource().rejectNotification( // This seems like a custom method
                        //   //   orderModel: orderData,
                        //   //   reason: _reasonController.text.trim(),
                        //   // );
                        //    ref.invalidate(orderDetailProvider(widget.orderId)); // Refresh data
                        //    ref.invalidate(orderProvider); // Refresh list if any

                        //   navigator.pop(); // Pop modal bottom sheet
                        //   if (mounted && Navigator.canPop(context)) {
                        //      // Navigator.pop(context); // Pop order detail screen if needed, or just refresh
                        //   }
                        //    ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text('Order rejected successfully.'), backgroundColor: Colors.green),
                        //   );
                        // } else {
                        //    buildErrorDialog(context, "Failed to reject order. ${response}");
                        // }
                      }
                    },
                    child: const Text('Submit Rejection'),
                  ),
                ),
                const SizedBox(height: 40), // Padding for keyboard
              ],
            ),
          ),
        );
      },
    );
  }
}
