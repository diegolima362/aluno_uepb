import 'package:aluno_uepb/app/core/domain/extensions/extensions.dart';
import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:aluno_uepb/app/modules/alerts/infra/models/models.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

AlertModel alertFromTable(Alerts alert) {
  return AlertModel(
    id: alert.id,
    course: alert.course,
    title: alert.title,
    time: TimeOfDay.fromDateTime(alert.time),
    days: [],
  );
}

AlertsTableCompanion alertToTable(AlertModel alert, {int? id}) {
  return AlertsTableCompanion.insert(
    id: Value.ofNullable(id),
    course: alert.course,
    title: alert.title,
    time: alert.time.asDateTime,
  );
}

ReminderModel reminderFromTable(Reminders reminder) {
  return ReminderModel(
    id: reminder.id,
    course: reminder.course,
    title: reminder.title,
    subject: reminder.subject,
    body: reminder.body,
    time: reminder.time,
    notify: reminder.notify,
    completed: reminder.completed,
  );
}

RemindersTableCompanion reminderToTable(ReminderModel reminder, {int? id}) {
  return RemindersTableCompanion.insert(
    id: Value.ofNullable(id),
    course: reminder.course,
    title: reminder.title,
    subject: reminder.subject,
    body: reminder.body,
    time: reminder.time,
    notify: reminder.notify,
    completed: reminder.completed,
  );
}
