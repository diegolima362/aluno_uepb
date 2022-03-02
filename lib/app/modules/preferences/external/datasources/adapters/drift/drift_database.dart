import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

@DataClassName("Preference")
class PreferencesTable extends Table {
  IntColumn get id => integer()();
  IntColumn get themeIndex => integer()();
  BoolColumn get allowNotifications =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get allowAutoDownload =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(
      p.join(dbFolder.path, 'aluno_uepb', 'database', 'prefs_db.sqlite'),
    );
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [PreferencesTable])
class PrefsDatabase extends _$PrefsDatabase {
  PrefsDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<Preference?> get allPreferences =>
      (select(preferencesTable)).getSingleOrNull();

  Future<int> updatePreferences({
    required int id,
    int? themeIndex,
    bool? allowNotifications,
    bool? allowAutoDownload,
  }) {
    return (update(preferencesTable)..where((p) => p.id.equals(id))).write(
      PreferencesTableCompanion(
        id: Value(id),
        themeIndex: Value.ofNullable(themeIndex),
        allowNotifications: Value.ofNullable(allowNotifications),
        allowAutoDownload: Value.ofNullable(allowAutoDownload),
      ),
    );
  }

  Future<void> clearDatabase() async {
    await Future.wait([
      delete(preferencesTable).go(),
    ]);
  }
}
