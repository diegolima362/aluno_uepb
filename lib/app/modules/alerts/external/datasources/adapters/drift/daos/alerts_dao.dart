import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:aluno_uepb/app/modules/alerts/infra/models/models.dart';
import 'package:drift/drift.dart';

import 'mappers.dart';

part 'alerts_dao.g.dart';

@DriftAccessor(tables: [Alerts])
class AlertsDao extends DatabaseAccessor<AppDriftDatabase>
    with _$AlertsDaoMixin {
  AlertsDao(AppDriftDatabase db) : super(db);

  Future<int> createAlert(AlertModel alert) async {
    final id = await db.into(db.alertsTable).insert(alertToTable(alert));

    await createAlertDays(alert, id);

    return id;
  }

  Future<void> createAlertDays(AlertModel alert, int id) async {
    for (final day in alert.days) {
      final notification =
          '$id-$day-${alert.time.hour}:${alert.time.minute}'.hashCode;

      await db.into(db.alertsDayTable).insert(
            AlertsDayTableCompanion.insert(
              alert: id,
              day: day,
              notification: notification,
            ),
          );
    }
  }

  Future<List<AlertModel>> getAlerts({int? id, String? course}) async {
    final alerts = <AlertModel>[];

    if (course != null) {
      alerts.addAll(await ((select(db.alertsTable)
            ..where((alert) => alert.course.equals(course))
            ..orderBy([(t) => OrderingTerm(expression: t.time)]))
          .map(alertFromTable)
          .get()));
    } else {
      alerts.addAll(await ((select(db.alertsTable)
            ..orderBy([(t) => OrderingTerm(expression: t.time)]))
          .map(alertFromTable)
          .get()));
    }

    for (final alert in alerts) {
      final result = await ((select(db.alertsDayTable)
            ..where((e) => e.alert.equals(alert.id)))
          .map((i) => i.day)
          .get());

      alert.days.addAll(result);
    }

    return alerts;
  }

  Future<void> updateAlert(AlertModel alert) async {
    await (delete(db.alertsDayTable)
          ..where((day) => day.alert.equals(alert.id)))
        .go();

    await createAlertDays(alert, alert.id);

    await update(db.alertsTable).replace(alertToTable(alert, id: alert.id));
  }

  Future<void> deleteAlerts({int? id, String? course}) async {
    if (id != null) {
      await (delete(db.alertsDayTable)..where((a) => a.alert.equals(id))).go();
      await (delete(db.alertsTable)..where((alert) => alert.id.equals(id)))
          .go();
    }

    if (id == null && course == null) {
      await (delete(db.alertsDayTable)).go();

      await (delete(db.alertsTable)).go();
    }
  }
}
