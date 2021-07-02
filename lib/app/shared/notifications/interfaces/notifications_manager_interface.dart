import 'package:aluno_uepb/app/shared/models/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

abstract class INotificationsManager {
  BehaviorSubject<NotificationModel?> get notificationSubject;

  BehaviorSubject<String?> get selectNotificationSubject;

  Future<NotificationAppLaunchDetails?> get appLaunchDetails;

  Future<void> cancelAllNotifications();

  Future<void> cancelNotification(int id);

  void close();

  Future<List<NotificationModel>> getAllNotifications();

  Future<int> getPendingNotificationCount();

  Future<List<NotificationModel>> pendingNotificationRequests();

  Future<void> scheduleNotification(NotificationModel notification);

  Future<void> scheduleWeeklyNotification(NotificationModel notification);

  void setListenerForLowerVersions(Function onNotificationInLowerVersions);

  Future<void> setOnNotificationClick(Function onNotificationClick);

  Future<void> showDailyAtTime(NotificationModel notification);

  Future<void> showNotification(NotificationModel notification);

  void showSample() {}

  Future<void> showWeeklyAtDayTime(NotificationModel notification);
}
