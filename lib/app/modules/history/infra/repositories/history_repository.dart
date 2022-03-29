import 'package:aluno_uepb/app/core/external/drivers/shared_prefs.dart';
import 'package:aluno_uepb/app/modules/history/domain/entities/entities.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/errors/errors.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/types/types.dart';
import '../datasources/history_datasource.dart';

class HistoryRepository implements IHistoryRepository {
  final IHistoryLocalDatasource localDatasource;
  final IHistoryRemoteDatasource remoteDatasource;
  final SharedPrefs prefsStorage;

  HistoryRepository(
      this.localDatasource, this.remoteDatasource, this.prefsStorage);

  final historyCache = <HistoryEntity>[];

  Future<bool> get updated async => DateTime.now()
      .add(const Duration(hours: 1))
      .isAfter(await prefsStorage.getLastHistoryUpdate());

  @override
  Future<EitherHistory> getHistory({bool cached = true}) async {
    final history = <HistoryEntity>[];

    if (cached) {
      if (historyCache.isNotEmpty) {
        return Right(historyCache);
      } else {
        try {
          final result = (await localDatasource.getHistory());
          history.addAll(result);
          historyCache.clear();
          historyCache.addAll(result);
        } on HistoryFailure catch (e) {
          return Left(e);
        }
      }
    }

    if (history.isEmpty || !await updated) {
      try {
        if (history.isEmpty) {
          final result = await remoteDatasource.getHistory();
          await localDatasource.saveHistory(result);
          history.addAll(result);

          historyCache.clear();
          historyCache.addAll(result);
        } else {
          remoteDatasource.getHistory().then(
                (r) async => await localDatasource.saveHistory(r),
              );

          historyCache.clear();
        }

        await prefsStorage.setLastHistoryUpdate(DateTime.now());
      } on HistoryFailure catch (e) {
        return Left(e);
      }
    }

    return Right(history);
  }
}
