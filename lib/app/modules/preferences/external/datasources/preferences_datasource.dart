import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:aluno_uepb/app/modules/preferences/infra/models/preferences_model.dart';
import 'package:drift/drift.dart';

import '../../domain/erros/erros.dart';
import '../../infra/datasources/preferences_datasource.dart';

const defaultColor = 0xff0a84ff;

class PreferencesDatasource implements IPreferencesDatasource {
  final AppDriftDatabase db;

  PreferencesDatasource(this.db);

  @override
  Future<void> storeTheme(int value) async {
    await db.prefsDao.updatePreferences(id: 0, themeIndex: value);
  }

  @override
  Future<void> updatePreferences(PreferencesModel preferences) async {
    await db.prefsDao.updatePreferences(
      id: 0,
      themeIndex: preferences.themeIndex,
      allowAutoDownload: preferences.allowAutoDownload,
      allowNotifications: preferences.allowNotifications,
      seedColor: preferences.seedColor,
    );
  }

  @override
  Future<PreferencesModel> get preferences async {
    final result = await db.prefsDao.allPreferences;

    if (result == null) {
      await db.into(db.preferencesTable).insert(const PreferencesTableCompanion(
            id: Value(0),
            themeIndex: Value(0),
            allowAutoDownload: Value(false),
            allowNotifications: Value(false),
            seedColor: Value(defaultColor),
          ));

      return PreferencesModel(
        themeIndex: 0,
        allowNotifications: false,
        allowAutoDownload: false,
        seedColor: defaultColor,
      );
    } else {
      return PreferencesModel(
        themeIndex: result.themeIndex,
        allowNotifications: result.allowNotifications,
        allowAutoDownload: result.allowAutoDownload,
        seedColor: result.seedColor,
      );
    }
  }

  @override
  Future<int> get themeMode async {
    try {
      final result = await db.prefsDao.allPreferences;

      if (result == null) {
        await db
            .into(db.preferencesTable)
            .insert(const PreferencesTableCompanion(
              id: Value(0),
              themeIndex: Value(0),
              allowAutoDownload: Value(false),
              allowNotifications: Value(false),
            ));
        return 0;
      } else {
        return result.themeIndex;
      }
    } catch (e) {
      throw ErrorGetThemeMode(
        message: 'PreferencesDatasource: ' + e.toString(),
      );
    }
  }

  @override
  Future<void> clearDatabase() async {
    try {
      await db.prefsDao.clearDatabase();
    } catch (e) {
      throw ErrorClearDatabase(
        message: 'PreferencesDatasource: ' + e.toString(),
      );
    }
  }
}
