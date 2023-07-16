import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/datasources/remote_datasource.dart';
import '../../../../shared/data/types/types.dart';
import '../../models/models.dart';
import '../datasources/history_datasource.dart';

class HistoryRepository {
  final AcademicRemoteDataSource _remote;
  final HistoryLocalDataSource _local;

  HistoryRepository(this._remote, this._local);

  AsyncResult<List<History>, AppException> fetchHistory([
    bool refresh = false,
  ]) async {
    final local = (await _local.fetchHistory()).getOrDefault([]);

    if (local.isNotEmpty && !refresh) {
      return Success(local);
    }

    final remote = await _remote.fetchHistory();
    return remote.fold(
      (data) async {
        final merged = mergeEntries(local, data);
        await _local.save(merged);

        return Success(merged);
      },
      (failure) => Failure(failure),
    );
  }

  List<History> mergeEntries(List<History> local, List<History> remote) {
    final cache = <String, History>{};

    for (final entry in local) {
      cache[entry.code] = entry;
    }

    for (final entry in remote) {
      final cached = cache[entry.code];

      cache[entry.code] = entry.copyWith(
        id: cached?.id ?? entry.code.hashCode,
      );
    }

    return cache.values.toList();
  }

  AsyncResult<Unit, AppException> clear() async {
    _local.clear();

    return Success.unit();
  }
}
