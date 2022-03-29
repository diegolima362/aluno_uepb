import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:aluno_uepb/app/modules/alerts/infra/models/models.dart';
import 'package:drift/drift.dart';

import 'mappers.dart';

part 'reminders_dao.g.dart';

@DriftAccessor(tables: [RemindersTable])
class RemindersDao extends DatabaseAccessor<AppDriftDatabase>
    with _$RemindersDaoMixin {
  RemindersDao(AppDriftDatabase db) : super(db);

  Future<int> createReminder(ReminderModel reminder) async {
    return await db.into(db.remindersTable).insert(reminderToTable(reminder));
  }

  Future<List<ReminderModel>> getReminders(
      {int? id, bool? completed, String? course}) async {
    if (course != null) {
      return await (select(db.remindersTable)
            ..where((r) => r.course.equals(course))
            ..orderBy([(t) => OrderingTerm(expression: t.time)]))
          .map(reminderFromTable)
          .get();
    } else {
      return await (select(db.remindersTable)
            ..orderBy([(t) => OrderingTerm(expression: t.time)]))
          .map(reminderFromTable)
          .get();
    }
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    await update(db.remindersTable)
        .replace(reminderToTable(reminder, id: reminder.id));
  }

  Future<void> deleteReminders({
    int? id,
    String? course,
    bool? completed,
  }) async {
    await (delete(db.remindersTable)
          ..where((r) =>
              r.id.equals(id) |
              r.completed.equals(completed) |
              r.course.equals(course)))
        .go();
  }
}
