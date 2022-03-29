import '../entities/notification_entity.dart';
import '../types/types.dart';

abstract class INotificationsService {
  Future<EitherNotificationUnit> scheduleNotification(
      NotificationEntity notification);

  Future<EitherNotificationUnit> scheduleWeeklyNotification(
      NotificationEntity notification);

  Future<EitherNotificationUnit> cancelNotifications({int? id});

  Future<EitherNotifications> getNotifications({int? id});

  Future<EitherNotificationUnit> showNotification(
      NotificationEntity notification);
}
