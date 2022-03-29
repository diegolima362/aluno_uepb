import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:drift/drift.dart';

import '../../../../../infra/models/profile_model.dart';

import 'mappers.dart';

part 'profiles_dao.g.dart';

@DriftAccessor(tables: [ProfilesTable])
class ProfilesDao extends DatabaseAccessor<AppDriftDatabase>
    with _$ProfilesDaoMixin {
  ProfilesDao(AppDriftDatabase db) : super(db);

  Future<int> saveProfile(ProfileModel profile) async {
    return await into(db.profilesTable).insertOnConflictUpdate(
      profileToTable(profile),
    );
  }

  Future<ProfileModel?> get profile async =>
      select(db.profilesTable).map(profileFromTable).getSingleOrNull();
}
