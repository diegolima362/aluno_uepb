import 'package:aluno_uepb/app/modules/courses/infra/models/models.dart';
import 'package:drift/drift.dart';

import '../drift_database.dart';
import 'mappers.dart';

part 'profiles_dao.g.dart';

@DriftAccessor(tables: [ProfilesTable])
class ProfilesDao extends DatabaseAccessor<ContentDatabase>
    with _$ProfilesDaoMixin {
  ProfilesDao(ContentDatabase db) : super(db);

  Future<int> saveProfile(ProfileModel profile) async {
    return await into(db.profilesTable).insert(profileToTable(profile));
  }

  Future<ProfileModel?> get profile async =>
      select(db.profilesTable).map(profileFromTable).getSingleOrNull();
}
