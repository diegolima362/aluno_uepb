import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:drift/drift.dart';

part 'prefs_dao.g.dart';

@DriftAccessor(tables: [PreferencesTable])
class PrefsDao extends DatabaseAccessor<AppDriftDatabase> with _$PrefsDaoMixin {
  PrefsDao(AppDriftDatabase db) : super(db);
  Future<Preferences?> get allPreferences =>
      (select(preferencesTable)).getSingleOrNull();

  Future<int> updatePreferences({
    required int id,
    int? themeIndex,
    bool? allowNotifications,
    bool? allowAutoDownload,
    int? seedColor,
  }) {
    return (update(preferencesTable)..where((p) => p.id.equals(id))).write(
      PreferencesTableCompanion(
        id: Value(id),
        themeIndex: Value.ofNullable(themeIndex),
        allowNotifications: Value.ofNullable(allowNotifications),
        allowAutoDownload: Value.ofNullable(allowAutoDownload),
        seedColor: Value.ofNullable(seedColor),
      ),
    );
  }

  Future<void> clearDatabase() async {
    await Future.wait([
      delete(preferencesTable).go(),
    ]);
  }
}
