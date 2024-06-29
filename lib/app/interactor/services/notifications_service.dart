import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';

abstract class NotificationsService {
  AsyncResult<Unit, AppException> showNotifications(
    String title,
    String body, {
    String? payload,
    DateTime? dateTime,
  });
}
