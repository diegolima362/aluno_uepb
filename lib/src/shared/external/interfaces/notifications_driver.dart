import 'package:result_dart/result_dart.dart';

import '../../domain/models/app_exception.dart';

abstract class NotificationsDriver {
  AsyncResult<Unit, AppException> showNotifications(
    String title,
    String body, {
    String? payload,
    DateTime? dateTime,
  });
}
