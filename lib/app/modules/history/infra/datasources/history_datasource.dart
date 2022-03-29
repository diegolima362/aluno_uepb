import 'package:fpdart/fpdart.dart';

import '../models/models.dart';

abstract class IHistoryDatasource {
  Future<List<HistoryModel>> getHistory();
}

abstract class IHistoryLocalDatasource extends IHistoryDatasource {
  Future<Unit> saveHistory(List<HistoryModel> history);
}

abstract class IHistoryRemoteDatasource extends IHistoryDatasource {}
