import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:fpdart/fpdart.dart';

import '../../infra/datasources/profile_datasource.dart';
import '../../infra/models/models.dart';

class ProfileLocalDatasource implements IProfileLocalDatasource {
  final AppDriftDatabase db;

  ProfileLocalDatasource(this.db);

  @override
  Future<Option<ProfileModel>> getProfile() async {
    return Option.fromNullable(await db.profilesDao.profile);
  }

  @override
  Future<Unit> saveProfile(ProfileModel profile) async {
    await db.profilesDao.saveProfile(profile);
    return unit;
  }
}
