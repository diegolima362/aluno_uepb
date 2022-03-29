import 'dart:io';

import 'package:aluno_uepb/app/modules/alerts/external/datasources/adapters/drift/daos/daos.dart';
import 'package:aluno_uepb/app/modules/auth/external/datasources/adapters/drift/daos/users_dao.dart';
import 'package:aluno_uepb/app/modules/courses/external/datasouces/adapters/drift/daos/daos.dart';
import 'package:aluno_uepb/app/modules/history/external/datasouces/adapters/drift/daos/daos.dart';
import 'package:aluno_uepb/app/modules/preferences/external/datasources/adapters/drift/daos/prefs_dao.dart';
import 'package:aluno_uepb/app/modules/profile/external/datasouces/adapters/drift/daos/profiles_dao.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

@DataClassName("User")
class UsersTable extends Table {
  TextColumn get id => text()();
  TextColumn get credentials => text()();

  @override
  Set<Column> get primaryKey => {id};
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
  IntColumn get id => integer().autoIncrement()();

  TextColumn get idDisciplina => text()();
  TextColumn get name => text()();

  TextColumn get semester => text()();
  TextColumn get cumulativeHours => text()();

  TextColumn get grade => text()();
  TextColumn get absences => text()();
  TextColumn get status => text()();
}

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

@DataClassName("Alerts")
class AlertsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get course => text()();
  TextColumn get title => text()();
  DateTimeColumn get time => dateTime()();
}

@DataClassName("AlertsDay")
class AlertsDayTable extends Table {
  IntColumn get alert => integer().references(AlertsTable, #id)();
  IntColumn get day => integer()();
  IntColumn get notification => integer()();

  @override
  Set<Column> get primaryKey => {alert, day};
}

@DataClassName("Reminders")
class RemindersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get course => text()();

  TextColumn get title => text()();
  TextColumn get subject => text()();
  TextColumn get body => text()();

  DateTimeColumn get time => dateTime()();
  BoolColumn get notify => boolean()();
  BoolColumn get completed => boolean()();
}

@DataClassName("Preferences")
class PreferencesTable extends Table {
  IntColumn get id => integer()();
  IntColumn get themeIndex => integer()();
  IntColumn get seedColor => integer()();
  BoolColumn get allowNotifications =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get allowAutoDownload =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

LazyDatabase get _connection => LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(
        p.join(dbFolder.path, 'aluno_uepb', 'database', 'app_db.sqlite'),
      );
      return NativeDatabase(file);
    });

@DriftDatabase(
  tables: [
    UsersTable,
    PreferencesTable,
    CoursesTable,
    SchedulesTable,
    ProfilesTable,
    HistoryTable,
    AlertsTable,
    AlertsDayTable,
    RemindersTable,
  ],
  daos: [
    UsersDao,
    PrefsDao,
    ProfilesDao,
    CoursesDao,
    HistoryDao,
    AlertsDao,
    RemindersDao,
  ],
)
class AppDriftDatabase extends _$AppDriftDatabase {
  AppDriftDatabase() : super(_connection);

  AppDriftDatabase.connect(DatabaseConnection connection)
      : super.connect(connection);

  @override
  int get schemaVersion => 1;

  Future<void> clearDatabase() async {
    await transaction(() async {
      await customStatement('PRAGMA foreign_keys = OFF');
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}
