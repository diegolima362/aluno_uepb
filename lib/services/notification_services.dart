import 'dart:io';

import 'package:aluno_uepb/models/models.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

abstract class NotificationsService {
  void setListenerForLowerVersions(Function onNotificationInLowerVersions);

  ValueStream<NotificationModel> getNotificationsStream();

  Future<void> setOnNotificationClick(Function onNotificationClick);

  Future<void> showNotification(NotificationModel notification);

  Future<void> showDailyAtTime(NotificationModel notification);

  Future<void> showWeeklyAtDayTime(NotificationModel notification);

  Future<void> scheduleNotification(NotificationModel notification);

  Future<int> getPendingNotificationCount();

  Future<void> cancelNotification(int id);

  Future<void> cancelAllNotification();

  Future<List<PendingNotificationRequest>> getAllNotifications();
}

class LocalNotificationsService implements NotificationsService {
  LocalNotificationsService() {
    _init();
  }

  FlutterLocalNotificationsPlugin _notificationsPlugin;

  InitializationSettings initializationSettings;

  final IOSNotificationDetails _iosChannelSpecifics = IOSNotificationDetails();

  final BehaviorSubject<NotificationModel> didReceivedNotificationSubject =
      BehaviorSubject<NotificationModel>();

  Future<void> _init() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  void initializePlatformSpecifics() {
    final android = AndroidInitializationSettings("app_icon");
    final ios = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        final NotificationModel receivedNotification = NotificationModel(
          id: id,
          title: title,
          body: body,
          payload: payload,
        );
        didReceivedNotificationSubject.add(receivedNotification);
      },
    );

    initializationSettings = InitializationSettings(android, ios);
  }

  void _requestIOSPermission() {
    _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  void setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  Future<void> setOnNotificationClick(Function onNotificationClick) async {
    await _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async => onNotificationClick(payload),
    );
  }

  Future<void> showNotification(NotificationModel notification) async {
    final androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );

    final platformChannelSpecifics = NotificationDetails(
      androidChannelSpecifics,
      _iosChannelSpecifics,
    );

    await _notificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: notification.payload,
    );
  }

  Future<void> showDailyAtTime(NotificationModel notification) async {
    final androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 4',
      'CHANNEL_NAME 4',
      "CHANNEL_DESCRIPTION 4",
      importance: Importance.Max,
      priority: Priority.High,
    );

    final platformChannelSpecifics = NotificationDetails(
      androidChannelSpecifics,
      _iosChannelSpecifics,
    );

    await _notificationsPlugin.showDailyAtTime(
      notification.id,
      notification.title,
      notification.body,
      Time(notification.dateTime.hour, notification.dateTime.minute),
      platformChannelSpecifics,
      payload: notification.payload,
    );
  }

  Future<void> showWeeklyAtDayTime(NotificationModel notification) async {
    final androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 5',
      'CHANNEL_NAME 5',
      "CHANNEL_DESCRIPTION 5",
      importance: Importance.Max,
      priority: Priority.High,
    );

    final platformChannelSpecifics = NotificationDetails(
      androidChannelSpecifics,
      _iosChannelSpecifics,
    );

    await _notificationsPlugin.showWeeklyAtDayAndTime(
      notification.id,
      notification.title,
      notification.body,
      Day((notification.weekDay + 1) % 7),
      Time(notification.dateTime.hour, notification.dateTime.minute),
      platformChannelSpecifics,
      payload: notification.payload,
    );
  }

  Future<void> scheduleNotification(NotificationModel notification) async {
    final androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 1',
      'CHANNEL_NAME 1',
      "CHANNEL_DESCRIPTION 1",
      importance: Importance.Max,
      priority: Priority.High,
    );

    final platformChannelSpecifics = NotificationDetails(
      androidChannelSpecifics,
      _iosChannelSpecifics,
    );
    await _notificationsPlugin.schedule(
      notification.id,
      notification.title,
      notification.body,
      notification.dateTime,
      platformChannelSpecifics,
      payload: notification.payload,
    );
  }

  Future<int> getPendingNotificationCount() async {
    final List<PendingNotificationRequest> p =
        await _notificationsPlugin.pendingNotificationRequests();
    return p.length;
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotification() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getAllNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  @override
  ValueStream<NotificationModel> getNotificationsStream() =>
      didReceivedNotificationSubject.stream;
}
