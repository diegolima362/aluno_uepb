import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/daos.dart';

part 'drift_database.g.dart';

@DataClassName("Profiles")
class ProfilesTable extends Table {
  TextColumn get register => text()();
  TextColumn get name => text()();

  TextColumn get program => text()();
  TextColumn get campus => text()();

  TextColumn get cra => text()();
  TextColumn get cumulativeHours => text()();

  @override
  Set<Column> get primaryKey => {register};
}

@DataClassName("Courses")
class CoursesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get professor => text()();

  TextColumn get finalTest => text()();
  TextColumn get und1Grade => text()();
  TextColumn get und2Grade => text()();

  IntColumn get duration => integer()();
  IntColumn get absences => integer()();
  IntColumn get absencesLimit => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName("Schedules")
class SchedulesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get course => text().references(CoursesTable, #id)();
  TextColumn get day => text()();
  TextColumn get time => text()();
  TextColumn get local => text()();
}

@DataClassName("History")
class HistoryTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  TextColumn get semester => text()();
  TextColumn get cumulativeHours => text()();

  TextColumn get grade => text()();
  TextColumn get absences => text()();
  TextColumn get status => text()();

  @override
  Set<Column> get primaryKey => {id};
}

LazyDatabase get _connection => LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(
        p.join(dbFolder.path, 'aluno_uepb', 'database', 'content_db.sqlite'),
      );
      return NativeDatabase(file);
    });

@DriftDatabase(
  tables: [
    ProfilesTable,
    CoursesTable,
    SchedulesTable,
    HistoryTable,
  ],
  daos: [ProfilesDao, CoursesDao, HistoryDao],
)
class ContentDatabase extends _$ContentDatabase {
  ContentDatabase() : super(_connection);

  @override
  int get schemaVersion => 1;
}
