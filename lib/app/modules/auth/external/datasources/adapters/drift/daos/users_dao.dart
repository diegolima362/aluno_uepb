import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:drift/drift.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [UsersTable])
class UsersDao extends DatabaseAccessor<AppDriftDatabase> with _$UsersDaoMixin {
  UsersDao(AppDriftDatabase db) : super(db);

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
