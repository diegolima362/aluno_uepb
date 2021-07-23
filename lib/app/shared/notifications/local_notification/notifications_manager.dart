import 'package:aluno_uepb/app/shared/models/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

import '../interfaces/notifications_manager_interface.dart';

class NotificationsManager implements INotificationsManager {
  final _selectNotificationSubject = BehaviorSubject<String>();

  final _notificationSubject = BehaviorSubject<NotificationModel>();

  final _pluginManager = FlutterLocalNotificationsPlugin();

  late final InitializationSettings _initializationSettings;

  static final NotificationsManager _singleton =
      NotificationsManager._internal();

  factory NotificationsManager() {
    return _singleton;
  }

  NotificationsManager._internal() {
    _init();
  }

  @override
  BehaviorSubject<NotificationModel> get notificationSubject =>
      _notificationSubject;

  @override
  BehaviorSubject<String> get selectNotificationSubject =>
      _selectNotificationSubject;

  Future<void> cancelAllNotifications() async {
    final total = await getPendingNotificationCount();
    print('> NotificationManager: cancel all ($total) notifications');
    await _pluginManager.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    print('> NotificationManager: cancel notification');
    await _pluginManager.cancel(id);
  }

  @override
  void close() {
    _notificationSubject.close();
    _selectNotificationSubject.close();
  }
 
  Future<List<NotificationModel>> getAllNotifications() async {
    return (await _pluginManager.pendingNotificationRequests())
        .map((e) => NotificationModel.fromPendingNotification({
              'id': e.id,
              'title': e.title,
              'body': e.body,
              'payload': e.payload,
            }))
        .toList();
  }

  Future<int> getPendingNotificationCount() async {
    final List<PendingNotificationRequest> p =
        await _pluginManager.pendingNotificationRequests();
    return p.length;
  }

  Future<List<NotificationModel>> pendingNotificationRequests() async {
    final pending = await _pluginManager.pendingNotificationRequests();

    return pending.map(_modelFromRequest).toList();
  }

  Future<void> scheduleNotification(NotificationModel notification) async {
    print('> NotificationManager: schedule notification= $notification');
    await _pluginManager.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tz.TZDateTime.from(notification.dateTime!, await _location()),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '001',
          'Scheduled Notifications Channel',
          'Scheduled Notifications Channel',
          importance: Importance.high,
        ),
      ),
      payload: notification.payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int h, int m) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, h, m);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfDayAndTime(NotificationModel notification) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(
      notification.dateTime!.hour,
      notification.dateTime!.minute,
    );
    while (scheduledDate.weekday != notification.weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  @override
  Future<void> scheduleWeeklyNotification(
      NotificationModel notification) async {
    final date = _nextInstanceOfDayAndTime(notification);
    print(
        '> NotificationManager: schedule notification= $notification at $date');

    await _pluginManager.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      date,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '002',
          'Weekly Scheduled Notifications Channel',
          'Weekly Scheduled Notifications Channel',
        ),
      ),
      androidAllowWhileIdle: true,
      payload: notification.payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  void setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    _notificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  Future<void> setOnNotificationClick(Function onNotificationClick) async {
    await _pluginManager.initialize(
      _initializationSettings,
      onSelectNotification: (payload) async => onNotificationClick(payload),
    );
  }

  Future<void> showDailyAtTime(NotificationModel notification) async {}

  Future<void> showNotification(NotificationModel notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '003',
      'Alert Notifications Channel',
      'Alert Notifications Channel',
      icon: 'notification_icon',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _pluginManager.show(
      notification.id,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: notification.payload,
    );
  }

  @override
  Future<void> showSample() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'notification_icon',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _pluginManager.show(
      0,
      'plain title',
      'plain body',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> showWeeklyAtDayTime(NotificationModel notification) async {}

  Future<void> _init() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    _initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _pluginManager.initialize(
      _initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          _selectNotificationSubject.add(payload);
        }
      },
    );
  }

  Future<tz.Location> _location() async {
    tz.Location location;
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    try {
      location = tz.getLocation(timeZoneName);
    } catch (e) {
      const String fallback = 'America/Recife';
      location = tz.getLocation(fallback);
    }

    return location;
  }

  NotificationModel _modelFromRequest(PendingNotificationRequest n) =>
      NotificationModel(
        id: n.id,
        title: n.title ?? '',
        body: n.body ?? '',
        payload: n.payload ?? '',
      );

  @override
  Future<NotificationAppLaunchDetails?> get appLaunchDetails async {
    return await _pluginManager.getNotificationAppLaunchDetails();
  }
}
