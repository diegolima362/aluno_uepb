import 'package:isar/isar.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/types/types.dart';
import '../../data/datasources/preferences_local_datasource.dart';
import '../../models/preferences.dart';
import 'schema.dart';

class PreferencesIsarLocalDataSource implements PreferencesLocalDataSource {
  final Isar db;

  PreferencesIsarLocalDataSource(this.db);

  @override
  AsyncResult<Preferences, AppException> load() async {
    var data = await db.isarPreferencesModels.get(1);

    if (data == null) {
      data = IsarPreferencesModel.fromDomain(Preferences.defaultPreferences());
      await db.writeTxn(() async {
        await db.isarPreferencesModels.put(data!);
      });
    }

    return Success(data.toDomain);
  }

  @override
  AsyncResult<Preferences, AppException> save(Preferences data) async {
    await db.writeTxn(() async {
      final toSave = IsarPreferencesModel.fromDomain(data);
      await db.isarPreferencesModels.put(toSave);
    });

    final response = await db.isarPreferencesModels.get(1);
    if (response == null) {
      return Failure(AppException('Preferences not found'));
    }

    return Success(response.toDomain);
  }

  @override
  AsyncResult<Unit, AppException> clear() async {
    await db.writeTxn(() async {
      await db.isarPreferencesModels.clear();
    });

    return Success.unit();
  }
}
