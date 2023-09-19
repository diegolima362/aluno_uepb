import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/models/app_exception.dart';
import '../interfaces/notifications_driver.dart';

class FlutterLocaltNotificationDriver implements NotificationsDriver {
  final FlutterLocalNotificationsPlugin plugin;

  FlutterLocaltNotificationDriver(this.plugin);

  @override
  AsyncResult<Unit, AppException> showNotifications(
    String title,
    String body, {
    String? payload,
    DateTime? dateTime,
  }) async {
    final androidChannel = AndroidNotificationDetails(
      'singleAlert',
      'Alertas simples',
      channelDescription: 'Alertas simples',
      icon: 'notification_icon',
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
      ),
    );

    final channel = NotificationDetails(android: androidChannel);

    try {
      await plugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        channel,
        payload: payload,
      );
      return const Success(unit);
    } on PlatformException catch (e) {
      return Failure(AppException(e.message ?? 'Erro ao mostrar notificação'));
    }
  }
}
