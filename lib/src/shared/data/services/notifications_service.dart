import 'package:result_dart/result_dart.dart';

import '../../domain/models/app_exception.dart';
import '../../external/interfaces/notifications_driver.dart';

class NotificationsService {
  final NotificationsDriver driver;

  NotificationsService(this.driver);

  AsyncResult<Unit, AppException> showNotifications(
    String title,
    String body, {
    String? payload,
    DateTime? dateTime,
  }) {
    return driver.showNotifications(
      title,
      body,
      payload: payload,
      dateTime: dateTime,
    );
  }
}
