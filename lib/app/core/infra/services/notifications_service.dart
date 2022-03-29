import 'package:fpdart/fpdart.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/services/notifications_service.dart';
import '../../domain/types/types.dart';
import '../drivers/notifications_driver.dart';

class NotificationsService implements INotificationsService {
  final INotificationsDriver driver;

  NotificationsService(this.driver);

  @override
  Future<EitherNotificationUnit> cancelNotifications({int? id}) async {
    await driver.cancelNotifications(id: id);
    return right(unit);
  }

  @override
  Future<EitherNotifications> getNotifications({int? id}) async {
    return right(await driver.getAllNotifications());
  }

  @override
  Future<EitherNotificationUnit> scheduleNotification(
      NotificationEntity notification) async {
    return right(await driver.scheduleAlert(notification));
  }

  @override
  Future<EitherNotificationUnit> scheduleWeeklyNotification(
      NotificationEntity notification) async {
    return right(await driver.scheduleWeeklyAlert(notification));
  }

  @override
  Future<EitherNotificationUnit> showNotification(
      NotificationEntity notification) async {
    return right(await driver.showAlert(notification));
  }
}
