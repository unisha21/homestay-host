import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_host/src/features/notification/data/notification_datasource.dart';

final notificationListProvider = StreamProvider((ref) => NotificationDataSource().getNotifications());
final notificationDataSourceProvider = Provider((ref) => NotificationDataSource());