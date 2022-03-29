import 'package:fpdart/fpdart.dart';

import '../../domain/entities/notification_entity.dart';

abstract class INotificationsDriver {
  Future<List<NotificationEntity>> getAllNotifications();

  Future<Unit> showAlert(NotificationEntity notification);

  Future<Unit> scheduleWeeklyAlert(NotificationEntity notification);

  Future<Unit> scheduleAlert(NotificationEntity notification);

  Future<Unit> cancelNotifications({int? id});
}
