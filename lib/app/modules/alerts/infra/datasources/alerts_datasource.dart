import 'package:fpdart/fpdart.dart';

import '../models/models.dart';

abstract class IAlertsDatasource {
  // Recurring alerts
  Future<int> createRecurringAlert(AlertModel alert);

  Future<List<AlertModel>> readRecurringAlerts({int? id, String? course});

  Future<Unit> updateRecurringAlert(AlertModel alert);

  Future<Unit> deleteRecurringAlerts({int? id, String? course});

  // Task reminders alerts
  Future<int> createTaskReminder(ReminderModel reminder);

  Future<List<ReminderModel>> readTaskReminders(
      {int? id, bool? completed, String? course});

  Future<Unit> updateReminder(ReminderModel reminder);

  Future<Unit> deleteReminders({int? id, bool? completed, String? course});
}
