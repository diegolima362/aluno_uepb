import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:fpdart/fpdart.dart';

import '../../infra/datasources/history_datasource.dart';
import '../../infra/models/models.dart';

class HistoryLocalDatasource implements IHistoryLocalDatasource {
  final AppDriftDatabase db;

  HistoryLocalDatasource(this.db);

  @override
  Future<List<HistoryModel>> getHistory() async {
    final result = await db.historyDao.fullHistory;

    return result;
  }

  @override
  Future<Unit> saveHistory(List<HistoryModel> history) async {
    await db.historyDao.saveHistory(history);
    return unit;
  }
}
