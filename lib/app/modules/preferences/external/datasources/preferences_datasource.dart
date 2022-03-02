import 'package:drift/drift.dart';

import '../../domain/erros/erros.dart';
import '../../infra/datasources/preferences_datasource.dart';
import 'adapters/drift/drift_database.dart';

class PreferencesDatasource implements IPreferencesDatasource {
  final PrefsDatabase db;

  PreferencesDatasource(this.db);

  @override
  Future<void> storeTheme(int value) async {
    try {
      await db.updatePreferences(id: 0, themeIndex: value);
    } catch (e) {
      throw ErrorStoreThemeMode(
        message: 'PreferencesDatasource: ' + e.toString(),
      );
    }
  }

  @override
  Future<int> get themeMode async {
    try {
      final result = await db.allPreferences;

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
      await db.clearDatabase();
    } catch (e) {
      throw ErrorClearDatabase(
        message: 'PreferencesDatasource: ' + e.toString(),
      );
    }
  }
}
