import 'package:aluno_uepb/app/modules/courses/infra/models/models.dart';
import 'package:drift/drift.dart';

import '../drift_database.dart';
import 'mappers.dart';
part 'history_dao.g.dart';

@DriftAccessor(tables: [HistoryTable])
class HistoryDao extends DatabaseAccessor<ContentDatabase>
    with _$HistoryDaoMixin {
  HistoryDao(ContentDatabase db) : super(db);

  Future<void> saveHistory(List<HistoryModel> history) async {
    return await batch((batch) {
      batch.insertAll(db.historyTable, history.map(historyToTable));
    });
  }

  Future<List<HistoryModel>> get fullHistory async =>
      select(db.historyTable).map(historyFromTable).get();
}
