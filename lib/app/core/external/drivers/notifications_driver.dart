import 'dart:convert';

import 'package:aluno_uepb/app/core/domain/entities/notification_entity.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fpdart/fpdart.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../infra/drivers/notifications_driver.dart';

class NotificationsDriver implements INotificationsDriver {
  final FlutterLocalNotificationsPlugin plugin;

  NotificationsDriver(this.plugin);

  @override
  Future<List<NotificationEntity>> getAllNotifications() async {
    final notifications = await plugin.pendingNotificationRequests();

    return notifications.map(
      (n) {
        var date = _extractDate(n);

        return NotificationEntity(
          id: n.id,
          title: n.title ?? 'Sem Título',
          body: n.body ?? '',
          payload: n.payload ?? '',
          dateTime: date,
        );
      },
    ).toList();
  }

  DateTime _extractDate(PendingNotificationRequest n) {
    var date = DateTime.now();

    final payload = n.payload;

    if (payload != null && payload.isNotEmpty) {
      final strDate = jsonDecode(payload) as Map;

      if (strDate.containsKey('date')) {
        date = DateTime.fromMillisecondsSinceEpoch(strDate['date']);
      }
    }

    return date;
  }

  @override
  Future<Unit> showAlert(NotificationEntity notification) async {
    final androidChannel = AndroidNotificationDetails(
      'singleAlert',
      'Alertas simples',
      channelDescription: 'Alertas simples',
      priority: Priority.max,
      importance: Importance.max,
      icon: 'notification_icon',
      ongoing: true,
      styleInformation: BigTextStyleInformation(
        notification.body,
        contentTitle: notification.title,
      ),
    );

    final channel = NotificationDetails(android: androidChannel);

    await plugin.show(
      notification.id,
      notification.title,
      notification.body,
      channel,
      payload: notification.payload,
    );

    return unit;
  }

  @override
  Future<Unit> scheduleWeeklyAlert(NotificationEntity notification) async {
    const androidChannel = AndroidNotificationDetails(
      'recurringAlerts',
      'Alertas recorrentes',
      channelDescription: 'Alertas recorrentes',
    );

    const channel = NotificationDetails(android: androidChannel);

    final date = tz.TZDateTime.from(notification.dateTime, tz.local);

    await plugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      date,
      channel,
      payload: notification.payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );

    return unit;
  }

  @override
  Future<Unit> scheduleAlert(NotificationEntity notification) async {
    const androidChannel = AndroidNotificationDetails(
      'scheduledAlert',
      'Alertas agendados',
      channelDescription: 'Alertas agendados',
    );

    const channel = NotificationDetails(android: androidChannel);

    final date = tz.TZDateTime.from(notification.dateTime, tz.local);

    await plugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      date,
      channel,
      payload: notification.payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    return unit;
  }

  @override
  Future<Unit> cancelNotifications({int? id}) async {
    if (id != null) {
      await plugin.cancel(id);
    } else {
      await plugin.cancelAll();
    }

    return unit;
  }
}
