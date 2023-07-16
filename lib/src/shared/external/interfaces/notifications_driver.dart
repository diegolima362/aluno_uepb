import 'package:result_dart/result_dart.dart';

import '../../data/types/types.dart';

abstract class NotificationsDriver {
  AsyncResult<Unit, AppException> showNotifications(
    String title,
    String body, {
    String? payload,
    DateTime? dateTime,
  });
}
