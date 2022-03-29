import 'package:aluno_uepb/app/core/domain/entities/notification_entity.dart';
import 'package:aluno_uepb/app/core/domain/errors/erros.dart';
import 'package:aluno_uepb/app/core/domain/services/notifications_service.dart';
import 'package:aluno_uepb/app/modules/courses/infra/datasources/courses_datasource.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/entities.dart';
import '../../domain/errors/erros.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../../domain/types/types.dart';
import '../datasources/alerts_datasource.dart';
import '../models/models.dart';

class AlertsRepository implements IAlertsRepository {
  final IAlertsDatasource local;
  final ICoursesDatasource coursesDatasource;
  final INotificationsService notificationsService;

  AlertsRepository(
    this.local,
    this.coursesDatasource,
    this.notificationsService,
  );

  Future<Unit> createAlertNotification(AlertModel alert) async {
    final now = DateTime.now();
    final course = await coursesDatasource.getCourses(id: alert.course);

    for (final day in alert.days) {
      final notificationId = _createAlertId(alert, day);

      final notification = NotificationEntity(
        id: notificationId,
        title: alert.title.trim().isEmpty ? 'Alerta 📣' : alert.title,
        body: course.isNotEmpty ? course.first.name : 'Alerta recorrente',
        payload: alert.toJson(),
        dateTime: DateTime(
          now.year,
          now.month,
          day,
          alert.time.hour,
          alert.time.minute,
        ),
      );

      await notificationsService.scheduleWeeklyNotification(notification);
    }

    return unit;
  }

  Future<Unit> createReminderNotification(ReminderModel alert) async {
    final course = await coursesDatasource.getCourses(id: alert.course);

    final body =
        course.isNotEmpty ? course.first.name : 'Alerta de atividade 📚';

    final notification = NotificationEntity(
      id: alert.id,
      title: alert.title.trim().isEmpty ? '📢 Atividade 📓' : alert.title,
      body: body,
      payload: alert.toJson(),
      dateTime: alert.time,
    );

    await notificationsService.scheduleNotification(notification);

    return unit;
  }

  Future<Unit> cancelNotifications(int? id) async {
    await notificationsService.cancelNotifications(id: id);
    return unit;
  }

  int _createAlertId(AlertModel alert, int day) =>
      '${alert.id}-$day-${alert.time.hour}:${alert.time.minute}'.hashCode;

  // Recurring alerts

  @override
  Future<EitherUnit> createRecurringAlert(RecurringAlertEntity alert) async {
    try {
      final _alert = AlertModel.fromEntity(alert);

      final id = await local.createRecurringAlert(_alert);

      await createAlertNotification(_alert.copyWith(id: id));

      return const Right(unit);
    } on AlertFailure catch (e) {
      return Left(e);
    } on NotificationFailure catch (e) {
      return Left(CreateAlertError(message: e.message));
    }
  }

  @override
  Future<EitherRecurring> getRecurringAlerts({int? id, String? course}) async {
    try {
      final result = await local.readRecurringAlerts(
        id: id,
        course: course,
      );

      return Right(result);
    } on AlertFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> updateRecurringAlert(RecurringAlertEntity alert) async {
    final model = AlertModel.fromEntity(alert);

    try {
      final alerts = await local.readRecurringAlerts(id: alert.id);

      if (alerts.isNotEmpty) {
        final alert = alerts.first;

        for (final day in alert.days) {
          await cancelNotifications(_createAlertId(alert, day));
        }
      }
      await createAlertNotification(model);

      await local.updateRecurringAlert(model);

      return const Right(unit);
    } on AlertFailure catch (e) {
      return Left(e);
    } on NotificationFailure catch (e) {
      return Left(UpdateAlertError(message: e.message));
    }
  }

  @override
  Future<EitherUnit> deleteRecurringAlerts({int? id, String? course}) async {
    try {
      if (id != null) {
        final alerts = await local.readRecurringAlerts(id: id);

        if (alerts.isNotEmpty) {
          final alert = alerts.first;

          for (final day in alert.days) {
            await cancelNotifications(_createAlertId(alert, day));
          }
        }
      }

      if (id == null && course == null) {
        await cancelNotifications(id);
      }

      await local.deleteRecurringAlerts(id: id, course: course);

      return const Right(unit);
    } on AlertFailure catch (e) {
      return Left(e);
    } on NotificationFailure catch (e) {
      return Left(RemoveAlertError(message: e.message));
    }
  }

  // Reminders

  @override
  Future<EitherUnit> createTaskReminder(TaskReminderEntity reminder) async {
    try {
      final _reminder = ReminderModel.fromEntity(reminder);

      final id = await local.createTaskReminder(_reminder);

      if (reminder.notify) {
        await createReminderNotification(_reminder.copyWith(id: id));
      }

      return const Right(unit);
    } on AlertFailure catch (e) {
      return Left(e);
    } on NotificationFailure catch (e) {
      return Left(CreateAlertError(message: e.message));
    }
  }

  @override
  Future<EitherReminders> getTaskReminders({
    int? id,
    bool? completed,
    String? course,
  }) async {
    try {
      final result = await local.readTaskReminders(
        id: id,
        course: course,
        completed: completed,
      );

      return Right(result);
    } on AlertFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> updateReminder(TaskReminderEntity reminder) async {
    final model = ReminderModel.fromEntity(reminder);

    try {
      final result = await local.readTaskReminders(id: reminder.id);

      if (result.isNotEmpty) {
        final old = result.first;

        if (!old.notify) {
          if (reminder.notify) {
            await createReminderNotification(model);
          }
        } else {
          if (!reminder.notify) {
            await cancelNotifications(reminder.id);
          } else if (reminder.time != old.time) {
            await cancelNotifications(reminder.id);
            await createReminderNotification(model);
          }
        }
      }

      await local.updateReminder(model);

      return const Right(unit);
    } on AlertFailure catch (e) {
      return Left(e);
    } on NotificationFailure catch (e) {
      return Left(UpdateAlertError(message: e.message));
    }
  }

  @override
  Future<EitherUnit> removeReminders(
      {int? id, bool? completed, String? course}) async {
    try {
      await cancelNotifications(id);

      await local.deleteReminders(
        id: id,
        course: course,
        completed: completed,
      );

      return const Right(unit);
    } on AlertFailure catch (e) {
      return Left(e);
    } on NotificationFailure catch (e) {
      return Left(RemoveAlertError(message: e.message));
    }
  }
}
