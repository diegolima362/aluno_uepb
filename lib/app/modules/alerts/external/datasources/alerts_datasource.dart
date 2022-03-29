import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:aluno_uepb/app/modules/alerts/infra/models/recurring_alert_model.dart';
import 'package:aluno_uepb/app/modules/alerts/infra/models/task_reminder_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../infra/datasources/alerts_datasource.dart';

class AlertsDatasource implements IAlertsDatasource {
  final AppDriftDatabase db;

  AlertsDatasource(this.db);

  @override
  Future<int> createRecurringAlert(AlertModel alert) async {
    return await db.alertsDao.createAlert(alert);
  }

  @override
  Future<int> createTaskReminder(ReminderModel reminder) async {
    return await db.remindersDao.createReminder(reminder);
  }

  @override
  Future<Unit> deleteRecurringAlerts({int? id, String? course}) async {
    await db.alertsDao.deleteAlerts(id: id, course: course);
    return unit;
  }

  @override
  Future<Unit> deleteReminders(
      {int? id, bool? completed, String? course}) async {
    await db.remindersDao.deleteReminders(
      id: id,
      completed: completed,
      course: course,
    );
    return unit;
  }

  @override
  Future<List<AlertModel>> readRecurringAlerts({int? id, String? course}) {
    return db.alertsDao.getAlerts(id: id, course: course);
  }

  @override
  Future<List<ReminderModel>> readTaskReminders(
      {int? id, bool? completed, String? course}) async {
    return await db.remindersDao.getReminders(
      id: id,
      course: course,
      completed: completed,
    );
  }

  @override
  Future<Unit> updateRecurringAlert(AlertModel alert) async {
    await db.alertsDao.updateAlert(alert);
    return unit;
  }

  @override
  Future<Unit> updateReminder(ReminderModel reminder) async {
    await db.remindersDao.updateReminder(reminder);
    return unit;
  }
}
