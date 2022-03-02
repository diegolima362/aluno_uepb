import 'dart:io';

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

LazyDatabase get _connection => LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(
        p.join(dbFolder.path, 'aluno_uepb', 'database', 'auth_db.sqlite'),
      );
      return NativeDatabase(file);
    });

@DriftDatabase(tables: [UsersTable])
class AuthDatabase extends _$AuthDatabase {
  AuthDatabase() : super(_connection);

  @override
  int get schemaVersion => 1;

  Future<User?> get currentUser => select(usersTable).getSingleOrNull();

  Future<int> saveUser(UsersTableCompanion user) async {
    await delete(usersTable).go();
    return into(usersTable).insertOnConflictUpdate(user);
  }

  Future<void> clearDatabase() async {
    await Future.wait([
      delete(usersTable).go(),
    ]);
  }
}
