import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:drift/drift.dart';

import '../../../../../infra/models/models.dart';

import 'mappers.dart';

part 'history_dao.g.dart';

@DriftAccessor(tables: [HistoryTable])
class HistoryDao extends DatabaseAccessor<AppDriftDatabase>
    with _$HistoryDaoMixin {
  HistoryDao(AppDriftDatabase db) : super(db);

  Future<void> saveHistory(List<HistoryModel> history) async {
    await db.delete(db.historyTable).go();

    await batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.historyTable,
        history.map(historyToTable),
      );
    });
  }

  Future<List<HistoryModel>> get fullHistory async =>
      await select(db.historyTable).map(historyFromTable).get();
}
