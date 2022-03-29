import '../entities/entities.dart';
import '../types/types.dart';

abstract class IAlertsRepository {
  // Recurring alerts
  Future<EitherUnit> createRecurringAlert(RecurringAlertEntity alert);

  Future<EitherRecurring> getRecurringAlerts({int? id, String? course});

  Future<EitherUnit> updateRecurringAlert(RecurringAlertEntity alert);

  Future<EitherUnit> deleteRecurringAlerts({int? id, String? course});

  // Task reminders alerts
  Future<EitherUnit> createTaskReminder(TaskReminderEntity reminder);

  Future<EitherReminders> getTaskReminders(
      {int? id, bool? completed, String? course});

  Future<EitherUnit> updateReminder(TaskReminderEntity reminder);

  Future<EitherUnit> removeReminders(
      {int? id, bool? completed, String? course});
}
