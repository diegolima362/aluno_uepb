import 'package:isar/isar.dart';
import 'package:result_dart/result_dart.dart';

import '../../../shared/data/types/types.dart';
import '../data/datasources/history_datasource.dart';
import '../models/models.dart';
import 'schema.dart';

class HistoryIsarLocalDataSource implements HistoryLocalDataSource {
  final Isar db;

  HistoryIsarLocalDataSource(this.db);

  @override
  AsyncResult<List<History>, AppException> fetchHistory() async {
    final data = await db //
        .isarHistoryModels
        .where()
        .sortBySemesterDesc()
        .findAll();
    return Success(data.map((e) => e.toDomain()).toList());
  }

  @override
  AsyncResult<List<History>, AppException> save(List<History> data) async {
    final ids = <int>[];

    await db.writeTxn(() async {
      final toSave = data.map(IsarHistoryModel.fromDomain).toList();
      ids.addAll(await db.isarHistoryModels.putAll(toSave));
    });

    final result = (await db.isarHistoryModels.getAll(ids))
        .whereType<IsarHistoryModel>()
        .map((e) => e.toDomain())
        .toList();

    return Success(result);
  }

  @override
  AsyncResult<Unit, AppException> clear() async {
    await db.writeTxn(() async {
      await db.isarHistoryModels.clear();
    });

    return Success.unit();
  }
}
