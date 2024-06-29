import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../../interactor/datasources/academic_datasource.dart';
import '../../interactor/models/history.dart';
import '../../interactor/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final AppLocalDataSource _localDataSource;
  final AppRemoteDataSource _remoteDataSource;

  HistoryRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  AsyncResult<List<HistoryEntry>, AppException> fetchHistory() async {
    try {
      final history = await _localDataSource.fetchHistory();
      if (history.isEmpty) {
        return refreshHistory();
      }
      return Success(history);
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  AsyncResult<List<HistoryEntry>, AppException> refreshHistory() async {
    try {
      final history = await _remoteDataSource.fetchHistory();
      await _localDataSource.cacheHistory(history);
      return Success(history);
    } on AppException catch (e) {
      return Failure(e);
    }
  }
}
